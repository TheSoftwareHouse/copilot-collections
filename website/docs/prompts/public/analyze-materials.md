---
sidebar_position: 11
title: /tsh-analyze-materials
---

# /tsh-analyze-materials

**Agent:** Business Analyst  
**File:** `.github/prompts/tsh-analyze-materials.prompt.md`

Processes discovery workshop materials and converts them into structured, Jira-ready epics and user stories. Can also import an existing Jira backlog for local iteration and improvement.

## Usage

```text
/tsh-analyze-materials <workshop materials or Jira project key>
```

## What It Does

### Standard Workflow (workshop materials provided)

1. **Process transcript** — Cleans raw transcript using the `tsh-transcript-processing` skill. Removes small talk, structures content by topics, extracts decisions and action items.
2. **Analyze additional materials and baseline** — Reviews Figma designs, existing codebase, reference documents, and any existing `task-baseline.md` continuity context.
3. **Draft intent brief** — Synthesizes `intent-brief.md` capturing scope, exclusions, likely epics, overlap, and open questions.
4. **Gate 0 — Intent Brief Review** — Presents the intent brief for user approval before extraction begins.
5. **Extract tasks** — Identifies epics and user stories from all processed materials using the `tsh-task-extracting` skill.
6. **Gate 1 — Task Review** — Presents extracted tasks for user validation. Iterates until approved.
7. **Quality review** — Runs Lite or Full analysis passes against the approved task list to find gaps, missing edge cases, and improvements.
8. **Gate 1.5 — Suggestion Review** — Presents quality review suggestions individually for accept/reject and applies accepted changes.
9. **Format for Jira** — Applies the benchmark template to all tasks using the `tsh-jira-task-formatting` skill.
10. **Gate 2 — Push Approval** — Presents final formatted tasks for user review before Jira push.
11. **Push to Jira** — Creates or updates Jira issues with proper linking and reports synced issue keys.
12. **Post-push verification** — Reads issues back from Jira and verifies key fields against the approved output.
13. **Archive and baseline refresh** — Refreshes continuity artifacts after a verified sync.

### Import Mode (Jira project key provided)

When the user provides existing Jira issue keys or a project key instead of workshop materials, the agent imports existing tasks from Jira into the local format, then proceeds through quality review, formatting, approval, and verified sync.

## Skills Loaded

- `tsh-task-analysing` — Explore business context, ambiguity, and baseline overlap.
- `tsh-transcript-processing` — Clean and structure raw transcripts.
- `tsh-task-extracting` — Identify epics and user stories from materials.
- `tsh-task-quality-reviewing` — Analyze tasks for gaps and improvements.
- `tsh-jira-task-formatting` — Format tasks for Jira, manage push, and support verification/baseline refresh.
- `tsh-codebase-analysing` — Understand existing codebase when relevant.

## Output

A set of markdown files placed in `specifications/<workshop-name>/`:

```text
specifications/
  user-onboarding/
    cleaned-transcript.md       ← structured transcript
    intent-brief.md             ← approved scope brief
    extracted-tasks.md          ← epics and stories (updated after quality review)
    quality-review.md           ← quality review report
    jira-tasks.md               ← final Jira-ready tasks

Optional exploration mode produces:

specifications/
  user-onboarding/
    workshop-context-summary.md ← pre-extraction context synthesis
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
Gate 0, Gate 1, Gate 1.5, and Gate 2 are mandatory. No data is pushed to Jira without your explicit approval at each gate. Review each output carefully — the agent produces business-oriented tasks that stakeholders should be able to understand without technical knowledge.
:::
