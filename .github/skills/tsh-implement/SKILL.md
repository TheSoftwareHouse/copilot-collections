---
name: tsh-implement
description: "Implement feature according to the plan."
user-invocable: true
---
<routing>Run this workflow through the designated agent: `tsh-engineering-manager`.</routing>

Start implementation delivery from a task description, Jira item, research file, or implementation plan through the canonical orchestration workflow.

<required-skills>
- `tsh-orchestrating-implementation` - canonical flow selection, approval gates, routing, validation, and review.
</required-skills>

<workflow>
1. Load `tsh-orchestrating-implementation` and start at its todo-controlled flow-start step.
2. Require research, plan readiness, and the exact Human approval predicate before file-changing delegation.
3. Route every task to the designated agent and exact private skill, then run the required quality gates.
4. Delegate final code review through `tsh-code-reviewer` with `tsh-review`.
</workflow>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-implement:v3 -->
