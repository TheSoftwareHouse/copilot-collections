---
sidebar_position: 6
title: /tsh-implement-common-task
---

# /tsh-implement-common-task

:::info
Not invoked directly by users. To trigger implementation, use [`/tsh-implement`](../public/implement) — the [Engineering Manager](../../agents/engineering-manager) will automatically delegate to the [Software Engineer](../../agents/software-engineer).
:::

**Agent:** Software Engineer
**File:** `.github/internal-prompts/tsh-implement-common-task.prompt.md`

The standard delegation prompt for general implementation tasks — backend logic, APIs, database changes, and non-UI frontend work.

## How It's Triggered

```text
/tsh-implement <JIRA_ID or task description>
```

The Engineering Manager identifies application code tasks in the plan and delegates them to the Software Engineer automatically.

## What It Does

### 1. Context Discovery

- Reviews the implementation plan and feature context.
- Checks `*.instructions.md` for project-specific conventions and coding standards.
- Loads the `tsh-technical-context-discovering` and `tsh-implementation-gap-analysing` skills.
- Gathers build, test, and lint commands for the project.

### 2. Implementation

- Follows the plan step by step — no deviations without explicit approval.
- Runs tests and linters before starting and after each phase.
- Loads `tsh-sql-and-database-understanding` when working with database schemas, migrations, or ORM-based data access.
- Updates plan checkboxes after completing each task step.

### 3. Verification

- Ensures all tasks in the plan are completed.
- Validates acceptance criteria before handing over to review.
- Documents any changes to the original plan in the Changelog section with timestamps.

## Skills Loaded

- `tsh-technical-context-discovering` — Establishes project conventions before implementing.
- `tsh-implementation-gap-analysing` — Verifies current state before making changes.
- `tsh-sql-and-database-understanding` — When working with databases, migrations, queries, or ORMs.
