---
name: tsh-review-plan
description: "Stress-test an implementation plan for failure modes, hidden assumptions, execution risk, and expensive rework."
user-invocable: false
---
<routing>Designated agent: `tsh-plan-reviewer`; private workflow skill: `tsh-review-plan`.</routing>

Review a plan against research and codebase reality with a failure-oriented approach. Save the full structured report beside the plan as `.plan-review.md` and return an APPROVED or REVISIONS NEEDED verdict.

<required-skills>`tsh-architecture-designing`, `tsh-creating-implementation-plans`, `tsh-codebase-analysing`, `tsh-technical-context-discovering`, `tsh-implementation-gap-analysing`, `tsh-sql-and-database-understanding` when applicable</required-skills>
<workflow>Read research and plan; challenge consequential decisions; verify critical references; inspect hidden assumptions and sequencing; maintain compact Decision and Revision History; report blockers, warnings, suggestions, questions, and binary verdict.</workflow>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-review-plan:v3 -->
