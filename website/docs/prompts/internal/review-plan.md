---
sidebar_position: 10
title: /tsh-review-plan
---

:::info
Not invoked directly by users. To trigger plan validation, use [`/tsh-implement`](../public/implement) — the Engineering Manager automatically delegates to the Architect Reviewer after the Architect produces or updates a plan.
:::

**Agent:** Architect Reviewer  
**File:** `.github/internal-prompts/tsh-review-plan.prompt.md`

Stress-tests architect implementation plans before implementation begins and persists the review report alongside the plan.

## How It's Triggered

```text
/tsh-implement <JIRA_ID or task description>
```

The Engineering Manager uses this internal prompt after the Architect creates or updates a `.plan.md` file. If the plan is already approved and unchanged since the last review, the validation step is skipped.

## What It Does

1. Reads the research file first so the review is grounded in the original requirements.
2. Reads the plan file and checks every task, phase, and definition of done.
3. Runs failure-mode, assumption, codebase-reality, and sequencing-and-feasibility passes.
4. Tries to surface 5-10 substantive risks when the plan is broad or uncertain, while allowing unusually robust plans to produce fewer findings.
5. Produces a failure-oriented review report with a binary verdict and the highest-risk issues, assumptions, rework triggers, and blocking gaps.
6. Saves the report as `{task-name}.plan-review.md` in the same `specifications/<task-name>/` directory as the plan.
7. If the verdict is `REVISIONS NEEDED`, the Engineering Manager sends the findings back to the Architect and reruns the review until the plan is approved or the escalation limit is reached.

## Skills Loaded

- `tsh-architecture-designing` — Evaluate architectural shape, phase coherence, and trade-offs.
- `tsh-codebase-analysing` — Verify the plan's references against actual codebase state.
- `tsh-technical-context-discovering` — Check pattern consistency against established conventions.
- `tsh-implementation-gap-analysing` — Validate what exists vs. what the plan proposes to build.
- `tsh-sql-and-database-understanding` — When the plan includes database schema, migration, indexing, or query changes.

## Output

A `.plan-review.md` file placed in `specifications/<task-name>/` alongside the plan, containing the failure-oriented review report and binary verdict.
