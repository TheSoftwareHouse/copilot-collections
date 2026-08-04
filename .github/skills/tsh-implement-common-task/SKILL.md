---
name: tsh-implement-common-task
description: "Implement a feature according to the provided implementation plan and feature context."
user-invocable: false
---
<routing>Designated agents: `tsh-plan-implementor` for default actionable plan seams and `tsh-software-engineer` for complex non-UI work; private workflow skill: `tsh-implement-common-task`.</routing>

Implement only the approved plan and feature context. Read persisted Technical Context first, require the exact Human approval predicate, follow tasks in order, validate before and after changes, and update only delegated progress.

<required-skills>`tsh-technical-context-discovering`, `tsh-implementation-gap-analysing`, `tsh-implementing-backend` when backend work applies, `tsh-sql-and-database-understanding` when database work applies</required-skills>
<workflow>Review plan and context; gather applicable checks; implement only planned work; verify each task and acceptance criterion; escalate material deviations before changing scope; hand off to `tsh-review`.</workflow>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-implement-common-task:v1 -->
