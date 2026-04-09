---
sidebar_position: 10
title: /tsh-plan
---

# /tsh-plan

:::info
Not invoked directly by users. To trigger implementation planning, use [`/tsh-implement`](../public/implement) — the [Engineering Manager](../../agents/engineering-manager) will automatically delegate to the [Architect](../../agents/architect) when a plan is needed.
:::

**Agent:** Architect  
**File:** `.github/internal-prompts/tsh-plan.prompt.md`

Creates a detailed, phased implementation plan from the research context.

## How It's Triggered

```text
/tsh-implement <JIRA_ID or task description>
```

The Engineering Manager identifies that no implementation plan exists and delegates planning to the Architect automatically.

## What It Does

1. **Analyzes context** — Reviews the `.research.md` file and cross-checks with best practices.
2. **Analyzes tech stack** — Identifies domain-specific best practices.
3. **Verifies current implementation** — Searches the codebase for existing components, functions, and utilities related to the feature.
4. **Understands project standards** — Reviews `*.instructions.md` files.
5. **Prepares implementation plan** — Creates detailed phases with code changes.
6. **Defines tasks** — Each task has a clear title, description, action type (`[CREATE]`/`[MODIFY]`/`[REUSE]`), and definition of done checklist.
7. **Addresses security** — Includes security considerations.
8. **Defines testing** — Guidelines for validation.
9. **Controls scope** — Only plans changes for THIS task; documents improvements separately.

## Skills Loaded

- `tsh-architecture-designing` — Architecture design process and plan template.
- `tsh-codebase-analysing` — Analyze existing codebase.
- `tsh-implementation-gap-analysing` — Verify what exists vs what needs to be built.
- `tsh-technical-context-discovering` — Understand project conventions and patterns.
- `tsh-sql-and-database-understanding` — When the feature involves database changes.

## Output

A `.plan.md` file placed in `specifications/<task-name>/`:

```text
specifications/
  user-authentication/
    user-authentication.research.md
    user-authentication.plan.md    ← new
```

The plan includes checklist-style phases, tasks with `[CREATE]`/`[MODIFY]`/`[REUSE]` action types, acceptance criteria, security considerations, and testing guidelines.

:::tip
Review the plan thoroughly. Confirm scope, phases, and acceptance criteria before starting implementation.
:::
