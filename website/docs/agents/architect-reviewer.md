---
sidebar_position: 7
title: Architect Reviewer
---

# Architect Reviewer Agent

**File:** `.github/agents/tsh-architect-reviewer.agent.md`

The Architect Reviewer is an internal sub-agent that validates implementation plans before code is written. It reviews the architect's plan for correctness, feasibility, simplicity, and pattern consistency, catching phantom references, over-engineering, missing requirements, and incompatible assumptions.

## Responsibilities

- Verifying that the plan covers every requirement from the research context.
- Checking that referenced files, functions, classes, and patterns actually exist in the codebase.
- Spotting over-engineering, speculative abstractions, and unnecessary phases.
- Ensuring the plan is feasible, ordered well, and testable.
- Producing a structured approval or revision report for the Engineering Manager.

## What It Produces

- A structured review report with verdict, findings, requirements coverage, codebase verification, simplicity assessment, and pattern consistency sections.
- The report is saved as `{task-name}.plan-review.md` alongside the plan in `specifications/<task-name>/`.

## Tool Access

| Tool | Usage |
|---|---|
| Context7 | Verify framework or library assumptions when the plan references them |
| Sequential Thinking | Evaluate trade-offs, phase ordering, and over-engineering risk |
| File Read/Search | Inspect the plan, research file, instructions, and referenced code |
| Todo | Track review checklist progress |

## Skills Loaded

- `tsh-architecture-designing` — Evaluate architectural shape, phase coherence, and trade-offs.
- `tsh-codebase-analysing` — Verify plan references against the actual codebase.
- `tsh-technical-context-discovering` — Check project conventions and existing patterns.
- `tsh-implementation-gap-analysing` — Compare what exists with what the plan proposes.
- `tsh-sql-and-database-understanding` — When the plan includes database schema, migration, or query changes.

## How It Is Used

- It is not invoked directly by users.
- The Engineering Manager runs it through the internal `/tsh-review-plan` prompt after the Architect produces or updates a plan.
- If the reviewer returns revisions, the plan goes back to the Architect and is re-reviewed until approved or escalated.
