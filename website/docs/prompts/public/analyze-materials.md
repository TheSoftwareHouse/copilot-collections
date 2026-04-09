---
sidebar_position: 10
title: /tsh-analyze-materials
---

# /tsh-analyze-materials

**Agent:** Business Analyst  
**File:** `.github/prompts/tsh-analyze-materials.prompt.md`

Processes discovery workshop materials and converts them into structured, Jira-ready epics and user stories. Can also import an existing Jira backlog for local iteration.

## Usage

```text
/tsh-analyze-materials <workshop materials or Jira project key>
```

## What It Does

### Standard Workflow (workshop materials provided)

1. **Process transcript** — Cleans raw transcript using the `tsh-transcript-processing` skill. Removes small talk, structures content by topics, extracts decisions and action items.
2. **Analyze additional materials** — Reviews Figma designs (via Figma MCP), existing codebase (via `tsh-codebase-analysing`), and other reference documents.
3. **Extract tasks** — Identifies epics and user stories from all processed materials using the `tsh-task-extracting` skill.
4. **Gate 1 — Task Review** — Presents extracted tasks for user validation. Iterates until approved.
5. **Quality review** — Runs analysis passes against the approved task list to find gaps, missing edge cases, and improvements.
6. **Gate 1.5 — Suggestion Review** — Presents quality review suggestions individually for accept/reject.
7. **Format for Jira** — Applies the benchmark template to all tasks using the `tsh-jira-task-formatting` skill.
8. **Gate 2 — Push Approval** — Presents final formatted tasks for user review before Jira push.
9. **Push to Jira** — Creates epics and stories in Jira with proper linking. Reports created issue keys.

### Import Mode (Jira project key provided)

When the user provides existing Jira issue keys or a project key instead of workshop materials, the agent skips transcript processing and task extraction. It fetches existing tasks from Jira, converts them into the local format, then proceeds to quality review and formatting.

## Skills Loaded

- `tsh-transcript-processing` — Clean and structure raw transcripts.
- `tsh-task-extracting` — Identify epics and user stories from materials.
- `tsh-task-quality-reviewing` — Analyze tasks for gaps and improvements.
- `tsh-jira-task-formatting` — Format tasks for Jira and manage push.
- `tsh-codebase-analysing` — Understand existing codebase when relevant.

## Output

A set of markdown files placed in `specifications/<workshop-name>/`:

```text
specifications/
  user-onboarding/
    cleaned-transcript.md       ← structured transcript
    extracted-tasks.md          ← epics and stories (updated after quality review)
    quality-review.md           ← quality review report
    jira-tasks.md               ← final Jira-ready tasks
```

## Input Flexibility

The command accepts various input types:

| Input | Behavior |
|---|---|
| Raw transcript text | Runs full workflow starting from transcript processing |
| Structured notes | Skips transcript processing, starts from task extraction |
| Figma links | Analyzes designs for functional requirements |
| Jira project key | Imports existing backlog for local iteration |
| Combination | Processes all available materials together |

:::tip
The three review gates are mandatory. No data is pushed to Jira without your explicit approval at each gate. Review each output carefully — the agent produces business-oriented tasks that stakeholders should be able to understand without technical knowledge.
:::
