---
sidebar_position: 4
title: Engineering Manager
---

**File:** `.github/agents/tsh-engineering-manager.agent.md`

The Engineering Manager is the orchestration seat for implementation delivery. It defines **WHO** does the work — persona, delegation boundaries, ambiguity handling, and tool discipline — and never writes product code itself. The actual workflow mechanics (planning readiness, execution routing, and quality gates) live in the `tsh-orchestrating-implementation` skill, not in the agent.

The agent declares a shared model array of **GPT-5.6 Luna** and **Claude Sonnet 5**. High-leverage decisions are escalated to the **Architect**.

The Engineering Manager owns the user-facing execution-authorization recovery gate. A valid current-revision `APPROVED` record is the authorization basis regardless of which gate recorded it, including the Architect's plan-authoring gate; automated Reviewer approval is not permission to implement. The Manager first validates the persisted `## Human Approval` record and silently reuses a valid record. Only when no valid record exists does it present exactly `Approve current plan`, `Request changes`, or `Stop` as fail-closed recovery, never as a second normal authorization. The Architect may record the literal response in the plan, but may not infer, paraphrase, or manufacture consent. A material revision after Human approval halts delegation and requires renewed Human approval, with no automatic reviewer invocation; a new review event happens only through an explicitly user-directed new review event.

The manager presents Human Approval at the gate but never writes the record itself — it has no direct document-editing tools, so recording the user's literal response is always a narrowly scoped delegation to the Architect. Execution owners separately validate the persisted record from disk before any edit. A delegated owner's recovery question can offer handing work back to the manager, but that hand-back is not the only recovery path.

When the Architect records plan-authoring Human approval, that authoring discussion ends before delivery. The manager reports the exact plan path, current revision, persisted timestamp, and review path when available, names implementation as the next step in a new discussion, and stops before file-changing delegation; the unchanged persisted record is reused there without a duplicate approval gate.

## How to Use

The Engineering Manager works from two entry points:

- **Directly** — invoke the agent in chat with a task description, Jira ID, standalone `*.research.md` file, or `*.plan.md` implementation plan.
- **Via [`/tsh-implement`](../prompts/public/implement)** — the public prompt routes to the agent using the same shared model array.

For any request whose intent is to deliver implementation changes, the agent loads the `tsh-orchestrating-implementation` skill and starts at **Step 0** (creating flow-start todos). Information-only, advisory-only, and standalone review- or research-only requests do not trigger the workflow.

## Workflow Skill

All workflow mechanics are owned by a single canonical skill:

- `tsh-orchestrating-implementation` — flow-start todos (Step 0), Full Flow establishment and planning readiness (Step 1), todo protocol, upfront execution plan, delegated execution routing, and review/UI-verification gates.

### Step 0 — Start with Todos

The skill begins by creating the Full Flow todos: one todo per plan task, review loop, `[REUSE]` UI verification item, and final gate.

### Step 1 — Establish Full Flow and Assess Planning Readiness

Full Flow is the only implementation-orchestration route. Planning readiness covers research, plan, open questions, Technical Context, reviewer readiness, and Human approval state. Any Figma or UI-verification involvement runs through the Full Flow UI-verification gate.

## Architect Consultation

The agent escalates to the **Architect** when:

- Requirements, constraints, or acceptance criteria are ambiguous or internally inconsistent.
- The plan leaves material technical decisions unresolved.
- Task ownership spans architecture, platform, backend, frontend, or prompt concerns.
- An unexpected issue, tradeoff, or design conflict surfaces.
- It is unclear whether a shortcut is acceptable, or one reasoning pass is not enough to defend the next step.

## Delegation Roster

| Agent | Delegate when |
| --- | --- |
| **Plan Implementor** | DEFAULT owner for actionable, low-risk plan seams in a Human-approved app-code task |
| **Software Engineer** | EXCEPTION owner for complex non-UI application code — API, database, or business logic work the plan flags as needing deeper reasoning |
| **UI Engineer** | Figma-backed UI and frontend implementation, including the capture-and-review verification loop |
| **E2E Engineer** | End-to-end test design, mocking strategy, or CI-ready test suites |
| **DevOps Engineer** | Infrastructure, Terraform, Kubernetes, CI/CD pipelines, or observability |
| **Architect** | Architectural guidance, codebase analysis, or a missing/incomplete plan |
| **Architect (deep band)** | Planning work with a deep-band signal — irreversible or high-cost decisions, schema migrations or backfills, security or authentication boundary design, cross-component architecture, competing viable designs, or an explicit user request |
| **Architect (fast band)** | Planning work that on its face satisfies the light-tier predicate; returns a tier mismatch instead of switching to the full template |
| **Code Reviewer** | Reviewing implemented changes against the plan, tests, and acceptance criteria |
| **UI Reviewer** | Verifying implemented UI against Figma, including `[REUSE]` UI verification tasks |
| **Context Engineer** | Gathering requirements and context before the Architect can plan |
| **Prompt Engineer** | Designing, optimizing, or auditing LLM application prompts |
| **Technical Writer** | Repository documentation — README, CHANGELOG, in-repo `/docs`, or the published documentation site |

## Tool Access

| Tool | Usage |
| --- | --- |
| **Read / Search** | Locate plans, research, and files needed to route work correctly |
| **Atlassian** | Gather context from Jira/Confluence — only when issue keys or page IDs are provided |
| **Sequential Thinking** | Resolve non-obvious ownership and assess whether ambiguity needs Architect consultation |
| **Terminal (execute)** | Run validation, inspection, and quality-gate commands only — never as an editing workaround |
| **Sub-agents** | Delegate research, planning, implementation, review, and verification |
| **Todo** | Track multi-step delivery work as the progress-control surface |
| **VS Code Commands** | Support inspection or validation during orchestration |
| **Ask Questions** | Resolve real blocking ambiguity — used conditionally, not as a ritual gate |

The agent has **no direct document-editing tools**. Any file, plan, prompt, or product-code change is delegated to the appropriate specialist.

## Key Behaviors

- **Never writes product code** — always delegates implementation to a specialist.
- **Orchestrates through the skill** — execution mechanics come from `tsh-orchestrating-implementation`, not the agent page.
- **Routes by ownership** — application code, infrastructure, tests, and prompts each go to their owning specialist.
- **Escalates ambiguity** — consults the Architect rather than guessing when the next step is not defensible.
- **Confirms conditionally** — asks the user only when a real blocker remains, not at every transition.
