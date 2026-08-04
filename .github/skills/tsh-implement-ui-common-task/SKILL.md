---
name: tsh-implement-ui-common-task
description: "Implement a Figma-backed UI feature according to research context and the implementation plan."
user-invocable: false
---
<routing>Designated agent: `tsh-ui-engineer`; private workflow skill: `tsh-implement-ui-common-task`.</routing>

Implement UI features from research and plan with Figma as the visual source of truth. This procedure extends `tsh-implement-common-task` and adds frontend and accessibility requirements; UI verification is owned by `tsh-ui-reviewer` through `tsh-review-ui`.

<required-skills>`tsh-implement-common-task`, `tsh-implementing-frontend`, `tsh-ensuring-accessibility`</required-skills>
<workflow>Read research and plan design references; inspect the exact Figma node before UI edits; implement components using project patterns and accessibility standards; report implementation without self-running the verification loop.</workflow>
<constraints>Stop when a required Figma reference is missing. Do not substitute code review or compile checks for delegated UI verification.</constraints>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-implement-ui-common-task:v1 -->
