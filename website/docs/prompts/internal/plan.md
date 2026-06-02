---
sidebar_position: 10
title: /tsh-plan
---

## /tsh-plan

:::info
Not invoked directly by users. To trigger implementation planning, use [`/tsh-implement`](../public/implement) — the [Engineering Manager](../../agents/engineering-manager) will automatically delegate to the [Architect](../../agents/architect) when a plan is needed.
:::

**Agent:** Architect  
**File:** `.github/internal-prompts/tsh-plan.prompt.md`

Creates a lean, self-contained implementation plan from the research context.

## How It's Triggered

```text
/tsh-implement <JIRA_ID or task description>
```

The Engineering Manager identifies that no implementation plan exists and delegates planning to the Architect automatically.

## What It Does

1. **Reviews the available context** — Uses the research notes, relevant codebase facts, and project instructions needed to frame the plan.
2. **Scopes the work tightly** — Produces one task per file with exact file scope only.
3. **Keeps tasks self-contained** — Packs each task block with the facts needed to execute it, so implementors do not need to reopen research or spec docs during execution.
4. **Uses the lean plan shape** — Follows the canonical phase preamble and the task field set defined in `plan.example.md`.
5. **Stays guidance-only** — Writes prose, tables, contracts, and clearly labeled non-executable pseudocode only; no production code.
6. **Captures verification and guardrails** — Adds security, verification, and scope notes where the task needs them.
7. **Supports review** — Sends the finished plan to the Architect Reviewer via the internal `/tsh-review-plan` prompt before implementation begins.

## Skills Loaded

- `tsh-architecture-designing` — Architecture design process and plan template.
- `tsh-codebase-analysing` — Analyze existing codebase.
- `tsh-implementation-gap-analysing` — Verify what exists vs what needs to be built.
- `tsh-technical-context-discovering` — Understand project conventions and patterns.
- `tsh-sql-and-database-understanding` — When the feature involves database changes.

## Output

A `.plan.md` file placed in `specifications/<task-name>/` with the canonical top-level shape: `Task Details`, `Implementation Plan`, and `Quality Assurance`.

The implementation section uses checklist-style phases with the reusable `Purpose` / `State Before` / `State After` / `Dependencies / Risks` preamble. Each task stays scoped to one file and uses only the lean fields from `plan.example.md`: `Files in Scope`, `Read First`, `Preconditions / Dependencies`, `Changes Required`, `Expected Artifacts`, `Definition of Done`, `Verification`, and `Out of Scope / Do NOT`.

Plans remain guidance artifacts only. Keep them code-free and use prose, tables, contracts, or clearly labeled non-executable pseudocode when detail is needed.

:::tip
Review the plan thoroughly. Confirm scope, phases, and acceptance criteria before starting implementation.
:::
