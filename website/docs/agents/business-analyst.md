---
sidebar_position: 2
title: Business Analyst
---

# Business Analyst Agent

**File:** `.github/agents/tsh-business-analyst.agent.md`

The Business Analyst agent specializes in converting discovery workshop materials (transcripts, Figma designs, codebase context) into structured, Jira-ready epics and user stories. It can also import and iterate on existing Jira backlogs.

## Responsibilities

- Processing raw workshop transcripts — cleaning, structuring, and extracting key decisions.
- Analyzing Figma/FigJam designs for functional requirements and user flows.
- Extracting epics and user stories from all processed materials.
- Running quality review passes to identify gaps and missing edge cases.
- Formatting tasks for Jira using a benchmark template.
- Managing a three-gate review process before pushing to Jira.
- Importing existing Jira backlogs for local iteration and improvement.

## What It Produces

A set of markdown files placed in `specifications/<workshop-name>/`:

- **`cleaned-transcript.md`** — Cleaned and structured transcript with discussion topics, key decisions, action items, and open questions.
- **`extracted-tasks.md`** — Extracted epics and user stories with acceptance criteria and dependencies.
- **`quality-review.md`** — Quality review report with all suggestions and dispositions.
- **`jira-tasks.md`** — Final Jira-ready tasks formatted per the benchmark template.

## What It Does NOT Do

- Does not produce technical specifications or architecture decisions (use the [Architect](./architect) for that).
- Does not produce detailed requirement research or gap analysis (use the [Context Engineer](./context-engineer) for that).
- Does not create implementation plans, test plans, or deployment plans.
- Does not estimate story points (provides sizing guidance only).

## Three-Gate Review Process

The Business Analyst enforces a strict review process — no data is pushed to Jira without explicit user approval:

| Gate | When | What |
|---|---|---|
| **Gate 1** | After task extraction | User reviews the epic/story breakdown |
| **Gate 1.5** | After quality review | User accepts or rejects individual improvement suggestions |
| **Gate 2** | After Jira formatting | User reviews final formatted tasks before Jira push |

## Tool Access

| Tool | Usage |
|---|---|
| **Atlassian** | Create/update Jira issues, fetch existing backlogs, link stories to epics |
| **Figma** | Analyze workshop designs, wireframes, and FigJam boards for functional requirements |
| **PDF Reader** | Read and extract content from PDF workshop materials |
| **Sequential Thinking** | Analyze complex discussions, resolve conflicts between materials, plan task structure |
| **File Read/Edit/Search** | Read, modify, and search workspace files |
| **Sub-agents** | Delegate subtasks to specialized agents |
| **Todo** | Track task progress with structured checklists |

## Skills Loaded

- `tsh-transcript-processing` — Clean raw transcripts, structure by topics, extract decisions and action items.
- `tsh-task-extracting` — Identify epics and user stories from all processed materials.
- `tsh-task-quality-reviewing` — Run analysis passes to find gaps, edge cases, and improvements.
- `tsh-jira-task-formatting` — Format tasks for Jira, manage review gates, handle import mode.
- `tsh-codebase-analysing` — Understand existing system context when relevant to task scope.

## Handoffs

After completing workshop analysis, the Business Analyst can hand off to:

- **Engineering Manager** → `/tsh-implement` (the Engineering Manager will automatically delegate to Context Engineer for research and Architect for planning)
