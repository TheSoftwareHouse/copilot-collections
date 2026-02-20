---
sidebar_position: 4
title: /implement
---

# /implement

**Agent:** Software Engineer  
**File:** `.github/prompts/implement.prompt.md`

Executes the implementation plan created by the Architect.

## Usage

```text
/implement <JIRA_ID or task description>
```

## What It Does

1. Reviews the implementation plan and feature context thoroughly.
2. Reviews project coding standards (`*.instructions.md`) and codebase architecture.
3. Gathers build/test/lint commands; runs tests and linters **before** starting.
4. Implements the plan step by step — follows each task without deviating.
5. Updates the plan checkboxes after completing each task.
6. After each phase: reviews implementation against plan, runs tests.
7. Asks for confirmation before making any changes to the original solution.
8. Documents all changes in the plan's Changelog section.
9. Ensures all tasks are complete before handoff.
10. Runs tests and linters **after** each phase.
11. **Automatically runs `tsh-code-reviewer`** at the end — no user confirmation needed.

## Skills Loaded

- `technical-context-discovery` — Project conventions and existing patterns.
- `implementation-gap-analysis` — Verify current state before making changes.
- `sql-and-database` — When implementing database-related features.

## Key Behaviors

- **Strictly follows the plan** — No deviations unless explicitly approved.
- **Does not implement improvements** from the plan's improvements section unless instructed.
- **Updates plan checkboxes** after each completed task step.
- **Runs automatic code review** at the end of implementation.

## Output

- Code changes as specified in the implementation plan.
- Updated plan checkboxes showing completion status.
- Changelog entries for any modifications.
- Code review findings from the automatic `tsh-code-reviewer` run.
