<!-- .github/skills/tsh-creating-implementation-plans/plan-light.example.md -->
# <task-name> - Implementation Plan (Light)

## Task Details

| Field       | Value              |
| ----------- | ------------------ |
| Jira ID     | <jira-id-or-none>  |
| Title       | <task-title>       |
| Description | <task-description> |
| Plan Tier   | LIGHT              |

## Goal

**Goal**: <one-sentence-statement-of-the-outcome-this-change-must-achieve>

**Do NOT touch / do NOT add**: <compact-list-of-out-of-scope-items>

## Tier Justification

This plan uses the light tier and the low-risk automated-review exemption. Each condition below is asserted true for this change; any `No` disqualifies the light tier and requires the full template.

| # | Condition | Holds |
| --- | --- | --- |
| 1 | Single phase with very few tasks | Yes |
| 2 | No irreversible or high-cost decisions (engine, framework, vendor, data-model shape) | Yes |
| 3 | No schema changes, migrations, or backfills | Yes |
| 4 | No security, authentication, or privacy behavior changes | Yes |
| 5 | No new external dependency and no new architectural pattern | Yes |
| 6 | No deviation from research or the established direction | Yes |
| 7 | Confined to one component or concern | Yes |

No `*.plan-review.md` exists for this plan; this recorded exemption is the documented reviewer-readiness basis. It is never Human approval.

## Human Approval

| Field | Value |
| --- | --- |
| Plan Revision | 1 |
| Human Decision | PENDING |
| Approved Revision | — |
| Decision Timestamp | — |
| Note | <optional concise note> |

<human-approval-protocol>
The plan's `## Human Approval` record is the canonical, auditable record of approval for the exact current plan revision. Its schema has exactly these fields: `Plan Revision` (integer), `Human Decision`, `Approved Revision`, `Decision Timestamp` (ISO 8601 UTC with a trailing `Z`), and `Note` (optional). `Human Decision` has exactly these values: `PENDING`, `APPROVED`, `CHANGES_REQUESTED`, and `STOPPED`. The Architect owns material plan revision changes and records only literal explicit human responses. Persisted approval is valid if and only if `Human Decision=APPROVED`, `Approved Revision=current Plan Revision`, and `Decision Timestamp` is valid ISO 8601 UTC ending in `Z`. Material changes before implementation completion increment `Plan Revision`, set `Human Decision=PENDING`, clear `Approved Revision`, and explain the change in Changelog. A material change that fails any Tier Justification condition additionally disqualifies the light tier: the plan must be re-authored on the full template before renewed Human approval. On the light tier no plan-authoring gate runs; the Engineering Manager's execution-authorization gate is the only user-facing gate.
</human-approval-protocol>

## Technical Context

### Tech Stack / Testing Patterns

Verbatim runnable commands for this change's app stack, used by task Definitions of Done:

- <command> — <what it verifies>

## Tasks

### Task 1 - [CREATE/MODIFY/REUSE] <task-name>

- [ ] <task-checkbox>

**Description**: <near-imperative description naming the files and the behavior to change>

**Files:**

- `<file-path>` — <create/modify/reuse>

**Definition of Done:**

- [ ] <objectively reviewer-verifiable check>
- [ ] <runnable command taken verbatim from Technical Context above>

### Task 2 - [REUSE] Code review by `tsh-code-reviewer` agent

- [ ] Code review completed

**Description**: Use this task only when the delivered change contains reviewable implementation artifacts under `## Implementation Code-Review Eligibility` in `tsh-orchestrating-implementation`. Delegate review of the implemented change to `tsh-code-reviewer` using `tsh-review.prompt.md`, against this plan and the change's Definition of Done. A light-tier doc-only, config-only-without-code, or plan-only change omits this task entirely or records `NOT APPLICABLE — no reviewable implementation artifacts delivered`.

**Definition of Done:**

- [ ] `tsh-code-reviewer` review completed with findings dispositioned

## Changelog

- <ISO-8601-UTC-timestamp> — Plan created (light tier).
