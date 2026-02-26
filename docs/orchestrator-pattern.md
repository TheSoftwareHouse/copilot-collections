# The Orchestrator Pattern

This document explains the orchestrator + specialized workers pattern — an alternative approach to the monolithic `tsh-copilot-engineer` for complex Copilot engineering tasks. It covers why the pattern exists, how it works, how its sub-agents are designed, and when to use it instead of working with `tsh-copilot-engineer` directly.

---

## The Problem: Context Rot

When `tsh-copilot-engineer` handles complex, multi-step tasks, the conversation accumulates 35–50+ tool calls of intermediate context: file reads, web fetches, analysis steps, design reasoning, and creation attempts. Each phase generates substantial context that stays in the conversation window:

1. **Research phase**: reading existing agents, skills, instructions, prompts (10–20 file reads)
2. **Documentation phase**: fetching VS Code docs, MCP server docs, best practice references (5–10 web fetches)
3. **Analysis phase**: reasoning steps, back-and-forth with the user (5–10 tool calls)
4. **Creation phase**: creating or editing files based on findings (5–10 tool calls)
5. **Validation phase**: re-reading created files, checking for errors, cross-referencing (5–10 tool calls)

By the time the agent reaches the creation phase — the only phase that produces the actual deliverable — earlier research results are diluting attention, consuming token budget, and degrading output quality. The model's attention is spread across thousands of tokens of intermediate content that is no longer directly relevant. The signal-to-noise ratio in the context window progressively deteriorates.

This is **context rot**: the progressive degradation of output quality as a conversation grows longer, not because the model lacks capability, but because accumulated noise crowds out signal.

The result: `tsh-copilot-engineer` produces good results on simple tasks (fix a typo, add a tool to an agent), but hits a **quality ceiling** on complex, multi-artifact tasks (design a new agent system, review all customization files, create an agent from scratch with research and validation).

### Monolithic vs. Orchestrated: The Core Difference

```
MONOLITHIC (tsh-copilot-engineer)
─────────────────────────────────────────────────────────────────
[User] → [tsh-copilot-engineer]
           │
           ├─ research (10-20 file reads)          ─┐
           ├─ documentation (5-10 web fetches)      │ ALL in one
           ├─ analysis (5-10 reasoning steps)       │ context window
           ├─ creation (5-10 file edits)            │ (35-50+ tool calls)
           └─ validation (5-10 re-reads)           ─┘
           │
           └─ final output (context window is saturated)


ORCHESTRATED (tsh-copilot-orchestrator)
─────────────────────────────────────────────────────────────────
[User] → [tsh-copilot-orchestrator]
           │
           ├─→ [Researcher]  → ~500-token summary    (isolated context)
           │   (done, context discarded)
           │
           ├─  design decisions (in clean main context)
           │
           ├─→ [Creator]     → file created           (isolated context)
           │   (done, context discarded)
           │
           └─→ [Reviewer]    → structured findings    (isolated context)
               (done, context discarded)
           │
           └─ final output (main context contains only summaries)
```

The orchestrator's context window after a full create-from-scratch workflow contains roughly 8 interactions (user question, clarification, design decision, 3 worker summaries, final presentation). The monolithic agent's context contains 40+ interactions of raw intermediate output.

---

## Architecture Overview

The orchestrator is a **separate agent** that coexists alongside an unchanged `tsh-copilot-engineer`. This is deliberate:

1. **Zero regression risk** — `tsh-copilot-engineer` is untouched. If the experiment fails, delete 4 files and nothing is lost.
2. **A/B comparison** — the same complex task can be given to both agents for direct quality comparison.
3. **No dual-mode complexity** — each agent has exactly one behavioral mode. No conditional logic about when to delegate vs. act directly.

The orchestrator delegates to three specialized workers, grouped by function (not by artifact type):

- **Researcher** — gathers information, returns summaries
- **Creator** — creates and modifies files based on specifications
- **Reviewer** — evaluates artifacts, returns findings

The orchestrator can also delegate to `tsh-copilot-engineer` itself as a "full-stack subagent" for medium-complexity tasks that don't decompose cleanly.

Workers are **invisible to users** (`user-invokable: false`). Only the orchestrator spawns them. The orchestrator **cannot edit files** — this is a deliberate constraint that forces all modifications through the creator worker, keeping the orchestrator focused on coordination and design decisions.

```
┌─────────────────────────────────────────────────┐
│                     User                         │
└─────────────┬───────────────────────┬───────────┘
              │                       │
              ▼                       ▼
┌─────────────────────┐  ┌─────────────────────────┐
│ tsh-copilot-engineer│  │ tsh-copilot-orchestrator │
│    (monolithic)     │  │     (coordinator)        │
│                     │  │                          │
│ Does everything     │  │ Delegates & synthesizes  │
│ in one context      │  │ Clean context window     │
└─────────────────────┘  └────┬──────┬──────┬──────┘
                              │      │      │
                    ┌─────────┘      │      └──────────┐
                    ▼                ▼                  ▼
            ┌──────────────┐ ┌──────────────┐  ┌──────────────┐
            │  Researcher  │ │   Creator    │  │   Reviewer   │
            │              │ │              │  │              │
            │ read, search │ │ read, search │  │ read, search │
            │ web/fetch    │ │ edit, todo   │  │              │
            │ context7     │ │ ──────────── │  │              │
            │              │ │ + skills     │  │              │
            │              │ │              │  │              │
            │ READ-ONLY    │ │ WRITE ACCESS │  │ READ-ONLY    │
            └──────────────┘ └──────────────┘  └──────────────┘
```

---

## The Workers

### Copilot Researcher (`copilot-researcher`)

**Purpose**: Gathers information from the codebase, documentation, and external sources. Returns structured, concise summaries — never raw file contents.

**Why it exists separately**: Research is the biggest contributor to context rot. A single research phase can involve 10–20 file reads and multiple web fetches, generating thousands of tokens of intermediate content. By isolating research in a sub-agent, the orchestrator receives a ~500-token structured summary instead of ~20,000 tokens of raw file contents. This is the single highest-leverage isolation in the pattern.

**Tools**: `read`, `search`, `web/fetch`, `context7/*` — all read-only. No `edit` tools.

**Key constraints**:
- Cannot create or modify files
- Cannot make design decisions or propose implementations
- Must return structured summaries organized by topic, with file paths for traceability
- Notes ambiguity in findings rather than making assumptions

### Copilot Artifact Creator (`copilot-artifact-creator`)

**Purpose**: Creates and modifies Copilot customization artifacts (`.agent.md`, `SKILL.md`, `.prompt.md`, `.instructions.md`) based on detailed specifications provided by the orchestrator.

**Why it exists separately**: Creation happens in a fresh context window — no accumulated research noise. The separation also enforces a clean authority boundary: the orchestrator decides what to create and how, the creator executes. This prevents the "architect who also writes all the code" anti-pattern where design decisions get muddled with implementation details.

**Tools**: `read`, `search`, `edit`, `todo` — the **only worker with write access**. No `web/fetch` or `context7/*` (research happens before creation, not during).

**Skills**: Autonomously loads `agent-creation`, `creating-skills`, or `prompt-creation` based on the artifact type being created. The orchestrator's delegation prompt specifies WHAT to create; the skill provides HOW.

**Key constraints**:
- Must follow the orchestrator's specification exactly
- Does not make design decisions beyond what the specification provides
- If the specification is ambiguous, notes the gap in its response rather than filling it autonomously
- Validates created files before returning (valid frontmatter, required sections present, consistent formatting)

### Copilot Artifact Reviewer (`copilot-artifact-reviewer`)

**Purpose**: Reviews artifacts against best practices, workspace consistency, structural correctness, and separation of concerns.

**Why it exists separately**: Review and fixing are deliberately decoupled. The reviewer reports findings; the orchestrator decides whether and how to act on them. This prevents the common failure mode where a "review and fix" agent silently papers over issues without the user knowing what was changed or why.

**Tools**: `read`, `search` — the **most restricted** tool set. No `edit` tools (produces findings, not fixes).

**Output format**: Severity-categorized findings, each with:
- **What**: concise description of the issue
- **Where**: file path and section
- **Why it matters**: impact explanation
- **Recommended action**: specific, actionable fix

Severity levels:
- **Must-fix** — structural errors, separation of concerns violations, missing required sections
- **Should-fix** — inconsistencies with workspace patterns, token efficiency issues
- **Consider** — minor style suggestions, optional improvements

---

## Three Core Principles

### 1. Context Is Precious

The orchestrator's conversation context should contain **only** user interactions, design decisions, and synthesized worker summaries. Never raw research output, never intermediate file contents, never documentation dumps.

For a research subtask involving 20 file reads, the main context receives a ~500-token summary instead of ~20,000 tokens of file contents. This is an order-of-magnitude improvement in token efficiency — and more importantly, it means the orchestrator's attention is focused on high-value content (user requirements, design decisions, worker results) rather than diluted across thousands of tokens of intermediate noise.

This is the fundamental principle motivating the entire pattern.

### 2. Delegate Execution, Retain Judgment

The orchestrator makes design decisions. Workers execute. The orchestrator validates worker output and may reject it or request revisions. It is the architect; workers are the builders.

This prevents the "just do it myself" temptation that would undermine the pattern. The orchestrator intentionally lacks `edit` tools — it physically cannot bypass delegation. For the same reason, it lacks `web/fetch` and `context7/*` — research must go through the researcher worker.

The orchestrator does have light `read` and `search` capabilities for quick validation (checking that a file was created at the expected path, verifying a reference points to a real target), but deep analysis is always delegated.

### 3. Prompt Is the Interface

Workers receive **only** the delegation prompt. They have no conversation history, no knowledge of previous worker outputs, no awareness of the broader task. Every delegation must be self-contained:

- **Task statement**: what to do, stated specifically
- **Expected output format**: how to structure the response
- **Relevant context**: design decisions, user requirements, findings from previous workers
- **File references**: specific files to read or create
- **Constraints**: what the worker should NOT do

The quality of the orchestrator's output depends heavily on the quality of its delegation prompts. A vague delegation produces vague results. A precise delegation with clear context, format requirements, and constraints produces focused, useful output.

---

## Standard Workflow

Here is the typical end-to-end workflow for a "create a new agent" task:

```
 1. User → Orchestrator: "Create a new agent for X"

 2. Orchestrator: Clarifies requirements with the user (askQuestions)

 3. Orchestrator → Researcher: "Analyze existing agents in .github/agents/.
    Summarize: naming conventions, tool patterns, structural patterns,
    skills-usage patterns."

 4. Researcher returns ~500-token structured summary

 5. Orchestrator: Makes design decisions based on research + user
    requirements (this happens in the clean main context — it's the
    high-value work)

 6. Orchestrator → Creator: Detailed specification including exact file
    path, structure, content requirements, patterns to follow, and
    workspace conventions

 7. Creator creates the file, returns confirmation + brief summary

 8. Orchestrator → Reviewer: "Review the newly created file against the
    agent-creation skill checklist, consistency with existing agents,
    and separation of concerns principles"

 9. Reviewer returns severity-categorized findings

10. Orchestrator: Addresses must-fix issues (delegates fixes to Creator),
    presents result to user with any remaining recommendations
```

### Delegation Decision Logic

- **Researcher**: when the task needs information gathering, pattern analysis, or external documentation lookup
- **Creator**: when a file needs to be created or modified — only after design decisions are made and the specification is fully detailed
- **Reviewer**: when an artifact needs quality validation — standard flow is always create then review
- **tsh-copilot-engineer** (as sub-agent): for medium-complexity fixes that don't decompose cleanly into research/create/review — for example, fixing a specific issue flagged by the reviewer that requires reading context and editing in one pass

Independent subtasks with no data dependencies (e.g., multiple research queries, parallel reviews of separate files) can be delegated to workers simultaneously rather than sequentially. In the initial implementation, the three worker agents (TR-1 through TR-3) were built in parallel because they had no interdependencies.

---

## Orchestrator vs. Monolithic: When to Use Which

| Dimension | `tsh-copilot-engineer` | `tsh-copilot-orchestrator` |
|---|---|---|
| **Best for** | Simple–medium tasks, single file edits, quick fixes | Complex multi-step tasks, new creation from scratch, audits |
| **Context management** | Single window; all tool calls accumulate | Isolated windows per subtask; orchestrator stays clean |
| **Quality on complex tasks** | Hits ceiling — context rot degrades later steps | Workers execute in fresh contexts |
| **Token efficiency** | All intermediate context competes for space | ~500-token summaries vs ~20,000 tokens raw |
| **Speed** | Fast for simple tasks | Overhead from prompt crafting + worker spawning; independent tasks can run in parallel |
| **User experience** | Direct, transparent | Collapsed sub-agent calls; needs progress updates |

### Quick Decision Guide

**Use `tsh-copilot-engineer` when:**
- Editing a single file
- Making a quick fix or adding a tool to an existing agent
- Iterating on an existing artifact with known changes
- The task is well-understood and doesn't require research

**Use `tsh-copilot-orchestrator` when:**
- Creating something from scratch (new agent, new skill, new prompt)
- The task involves research + creation + review phases
- Working across multiple files or artifact types
- Designing something new that requires analyzing existing patterns first
- Running an audit or consistency review across all customization artifacts

During the experiment phase, the same complex task can be given to both agents for direct comparison — this is one of the key reasons the orchestrator exists as a separate agent rather than being merged into `tsh-copilot-engineer`.

---

## Experimental Status

The orchestrator is a **parallel experiment**, not a replacement for `tsh-copilot-engineer`.

**What this means in practice:**

- `tsh-copilot-engineer` remains completely unchanged. It continues to be the team's primary monolithic Copilot engineering agent, and it continues to be available as a sub-agent for other agents.
- The orchestrator and its three workers are **additive** — 4 new files in `.github/agents/`. If the experiment fails, delete them. Zero cost, zero cleanup, zero impact on existing workflows.
- The VS Code `agents` frontmatter property used for sub-agent delegation is still marked as **Experimental** by Microsoft. The rollback path is straightforward.

**The experiment plan:**

The team plans to run identical complex tasks (creating agents from scratch, auditing all customization artifacts, designing multi-agent improvements) with both `tsh-copilot-engineer` and `tsh-copilot-orchestrator`, comparing output quality, consistency, token usage, and completion time.

The consolidation decision is deliberately deferred until empirical results are available:

- **If the orchestrator wins clearly**: merge orchestration capabilities into `tsh-copilot-engineer`, retire the separate orchestrator, keep the workers
- **If results are mixed**: keep both agents — they serve different use cases
- **If no significant difference**: retire the orchestrator and workers, document lessons learned

---

## Known Risks

**Prompt engineering burden** (HIGH): The orchestrator's effectiveness depends heavily on the quality of delegation prompts it crafts. A vague delegation produces vague results. This is the critical success factor — the orchestrator must provide clear task statements, expected output formats, relevant context, and constraints in every delegation.

**Skill loading in sub-agent context**: Whether skills load correctly when a worker runs as a sub-agent is an open question that needs practical validation. The creator worker references skills like `agent-creation` and `creating-skills` — confirming these activate properly in the sub-agent context is an early validation priority.

**Worker model selection**: Workers could potentially use faster or cheaper models for straightforward tasks (e.g., a lighter model for research summarization). Whether this maintains quality is deferred to experimentation.

**Observability**: Sub-agent calls appear collapsed in the VS Code UI. Users cannot see what's happening inside worker contexts. The orchestrator must provide explicit progress updates between worker invocations to keep users informed (e.g., "Research complete. Found 8 agents with consistent patterns. Now designing the new agent...").

**Domain knowledge calibration**: The orchestrator needs enough Copilot engineering expertise to make good design decisions and craft effective delegation prompts, but not so much that it duplicates `tsh-copilot-engineer`. Getting this balance right requires iteration.
