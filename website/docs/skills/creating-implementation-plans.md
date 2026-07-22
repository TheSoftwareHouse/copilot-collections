---
sidebar_position: 3
title: Creating Implementation Plans
---

# Creating Implementation Plans

**Folder:** `.github/skills/tsh-creating-implementation-plans/`  
**Used by:** Architect via [`tsh-plan.prompt.md`](../prompts/internal/plan.md); consulted by Architect Reviewer via [`tsh-review-plan.prompt.md`](../prompts/internal/review-plan.md)

Turns a designed solution into a phased, verifiable implementation plan.

## Human Approval

Every plan must include a `## Human Approval` table immediately after `## Open Questions` and before `## Technical Context`:

| Field | Value |
| --- | --- |
| Plan Revision | Integer, starting at `1` |
| Human Decision | `PENDING`, `APPROVED`, `CHANGES_REQUESTED`, or `STOPPED` |
| Approved Revision | Integer matching Plan Revision when approved, otherwise `—` |
| Decision Timestamp | ISO 8601 UTC ending in `Z`, or `—` |
| Note | Optional concise note |

Human approval applies to the exact current plan revision and is valid only when `Human Decision=APPROVED`, `Approved Revision=current Plan Revision`, and `Decision Timestamp` is a valid ISO 8601 UTC timestamp ending in `Z`. A material plan change at any point before implementation completion increments Plan Revision, resets Human Decision to `PENDING`, clears Approved Revision, and records the reason in the plan Changelog. If the plan was previously human-approved, the change immediately stops subsequent file-changing delegation and requires mandatory automated Reviewer re-review with no low-risk exemption before renewed Human approval. The low-risk automated-review exemption applies only during initial preparation before any Human approval has ever been recorded. Routine task checkbox, progress, status, and execution- or review-recording metadata updates are non-material and do not invalidate approval.

The Architect owns revision changes and records only the user's explicit response; Human approval is never stored in `.plan-review.md` or inferred from Reviewer approval. This is an instruction-level, auditable protocol: it is not cryptographic and is not mechanically enforced by the platform, so the revision convention must be followed by the workflow. The `Human Decision`/`Approved Revision`/`Decision Timestamp` predicate itself is otherwise mechanically checkable, but no mechanism can detect a material edit that skipped the revision-increment convention — that gap is an instruction-level, auditable limitation, not a mechanical guarantee.

## Process

### Step 1: Confirm Inputs

Start from a designed solution, usually produced by `tsh-architecture-designing`, plus task research and any supporting context. Do not redesign the solution here.

### Step 2: Define the Wildly Important Goal

State one explicit Wildly Important Goal for the whole plan as a single sentence, plus an explicit Success Measure and a Do NOT touch / do NOT add list of non-goals to curb scope creep. Add a short description of the overall approach.

### Step 3: Break the Work into Phases

Divide the work into small phases. Each phase needs a Goal, a Description, a `**Verification:**` field listing the exact fast-running commands to run after the phase completes, and tasks with checkboxes. Keep phase verification reviewer-verifiable and limited to fast checks such as unit tests, integration tests, static analysis, linters, formatting, and builds.

### Step 4: Define Each Task

Give every task a Description, a `**Files:**` field, a Definition of Done checklist, and optional Clues such as file paths, line ranges, reference patterns, or gotchas. The `**Files:**` field names every file the task touches and labels each one `create`, `modify`, or `reuse`. When a file was produced or last touched by an earlier task in the same plan, add an inline back-reference such as `(modify — created in Task 1.1)`.

### Step 5: Add Mandatory Cross-Cutting Tasks

Include the required shared tasks for code review, UI verification, and prompt engineering when those domains apply.

### Step 6: Save the Plan Using the Template

Write the plan as a document that follows `plan.example.md` exactly. Do not add or remove sections from the template.

## Key Rules

| Area                          | Rule                                                                                                                                                                                                                                                                                                                                                                             |
| ----------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Goal hierarchy                | Every plan has one explicit Wildly Important Goal stated as one sentence, with a Success Measure and a Do NOT touch / do NOT add list. Every phase has a Goal that advances it, a Description, and a `**Verification:**` field. Every task has a Description, a `**Files:**` field, a Definition of Done checklist, and optional Clues.                                          |
| Definition of Done            | Each task's DoD must include at least one runnable command a reviewer can verify during review. DoD items must not include deployment steps, manual QA, or anything a code reviewer cannot verify during review.                                                                                                                                                                 |
| UI Verification Status        | Figma-based plans must track per-component `UI Verification Status` separately from code review, including the component name, iteration count, Figma URL, and a final status of `PASSED`, `ESCALATED`, or `VERIFICATION NOT RUN`.                                                                                                                                               |
| No real code                  | Do not include production implementation code or full function bodies. Task-boundary seam artifacts (type definitions, function signatures, DTOs, interfaces, API shapes) are allowed when they clarify the contract without supplying implementation bodies. Use pseudo-code only when a complicated algorithm truly needs it; diagrams and explanatory context are encouraged. |
| Open-questions gate           | A plan must not be dispatched to an implementor while any `## Open Questions` row has Status `❓ Open`. Unresolved questions route back to `tsh-architect` before execution.                                                                                                                                                                                                     |
| Mandatory cross-cutting tasks | End with a code review phase handled by `tsh-code-reviewer`. Add `[REUSE]` UI verification tasks for Figma-based UI via `tsh-ui-reviewer`, and `[REUSE]` prompt engineering tasks for LLM prompts via `tsh-prompt-engineer`. Do not add deployment plans.                                                                                                                        |

## Connected Skills

- `tsh-architecture-designing` — designs the solution this skill turns into a plan
- `tsh-implementation-gap-analysing` — verifies what was already implemented before planning new work
- `tsh-technical-context-discovering` — populates the plan's Technical Context section
