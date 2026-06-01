---
sidebar_position: 2
title: Business Analyst
---

# Business Analyst Agent

**File:** `.github/agents/tsh-business-analyst.agent.md`

The Business Analyst agent orchestrates discovery workshop materials (transcripts, Figma designs, codebase context) into structured, Jira-ready epics and user stories. It can also explore ambiguous workshop inputs before extraction and import existing Jira backlogs for local iteration.

## Responsibilities

- Exploring workshop context before commitment when the source material is still ambiguous.
- Processing raw workshop transcripts and related reference materials into business-facing backlog context.
- Drafting an `intent-brief.md` for Gate 0 approval before extraction begins.
- Extracting epics and user stories with source traceability and concise GIVEN/WHEN/THEN acceptance scenarios.
- Running Lite or Full quality-review passes and presenting suggestions at Gate 1.5.
- Formatting tasks for Jira, verifying Jira after sync, and refreshing the project baseline for continuity.
- Importing existing Jira backlogs for local iteration and improvement.

## What It Produces

A set of markdown files placed in `specifications/<workshop-name>/`:

- **`cleaned-transcript.md`** — Cleaned and structured transcript with discussion topics, key decisions, action items, and open questions.
- **`workshop-context-summary.md`** — Optional exploration summary with likely epics, overlap, ambiguities, and readiness.
- **`intent-brief.md`** — Scope brief that must be approved before extraction.
- **`extracted-tasks.md`** — Extracted epics and user stories with acceptance criteria and dependencies.
- **`quality-review.md`** — Quality review report with all suggestions and dispositions.
- **`jira-tasks.md`** — Final Jira-ready tasks formatted per the benchmark template.
- **`specifications/projects/<project-name>/task-baseline.md`** — Optional project backlog baseline refreshed after verified Jira sync.

## What It Does NOT Do

- Does not produce technical specifications or architecture decisions (use the [Architect](./architect) for that).
- Does not produce detailed requirement research or gap analysis (use the [Context Engineer](./context-engineer) for that).
- Does not create implementation plans, test plans, or deployment plans.
- Does not estimate story points (provides sizing guidance only).

## Four-Gate Review Process

The Business Analyst enforces a strict review process — no data is pushed to Jira without explicit user approval:

| Gate | When | What |
|---|---|---|
| **Gate 0** | After intent brief drafting | User reviews scope, intent, and candidate epics before extraction |
| **Gate 1** | After task extraction | User reviews the epic/story breakdown |
| **Gate 1.5** | After quality review | User accepts or rejects individual improvement suggestions |
| **Gate 2** | After Jira formatting | User reviews final formatted tasks before Jira push |

## Tool Access

| Tool | Usage |
|---|---|
| **Atlassian** | Create/update Jira issues, fetch existing backlogs, link stories to epics, and verify synced issues |
| **Figma** | Analyze workshop designs, wireframes, and FigJam boards for functional requirements |
| **PDF Reader** | Read and extract content from PDF workshop materials |
| **Sequential Thinking** | Analyze complex discussions, resolve conflicts between materials, plan task structure |
| **File Read/Edit/Search** | Read, modify, and search workspace files |
| **Sub-agents** | Delegate subtasks to specialized agents |
| **Todo** | Track task progress with structured checklists |

## Skills Loaded

- `tsh-task-analysing` — Explore workshop context, ambiguity, and baseline overlap before extraction.
- `tsh-transcript-processing` — Clean raw transcripts, structure by topics, extract decisions and action items.
- `tsh-task-extracting` — Identify epics and user stories from all processed materials.
- `tsh-task-quality-reviewing` — Run analysis passes to find gaps, edge cases, and improvements.
- `tsh-jira-task-formatting` — Format tasks for Jira, manage review gates, handle import mode, support verification and baseline refresh.
- `tsh-codebase-analysing` — Understand existing system context when relevant to task scope.

## Internal BA Workers

The Business Analyst stays user-facing, but routes focused phases to internal workers:

- **Transcript worker** — Cleans and structures raw transcript material.
- **Analysis worker** — Synthesizes workshop context, baseline overlap, and ambiguities.
- **Extraction worker** — Drafts the intent brief and extracts epics and stories.
- **Quality worker** — Runs Lite or Full quality-review passes.
- **Formatting worker** — Prepares Jira-ready output, post-push verification support, and baseline refresh content.

## Handoffs

After completing workshop analysis, the Business Analyst can hand off to:

- **Engineering Manager** → `/tsh-implement` (the Engineering Manager will automatically delegate to Context Engineer for research and Architect for planning)
