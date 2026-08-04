---
name: tsh-implement-ui
description: "Implement UI features according to research and plan context while orchestrating iterative Figma verification."
user-invocable: false
---
<routing>Designated agent: `tsh-ui-engineer`; private workflow skill: `tsh-implement-ui`.</routing>

Orchestrate UI implementation and verification: identify Figma references, obtain a pinned full dev-server URL, delegate implementation, capture fresh artifacts, delegate `tsh-review-ui`, and iterate fixes up to the defined budget.

<required-skills>`tsh-implementing-frontend`, `tsh-ensuring-accessibility`, `tsh-ui-verifying`, `tsh-orchestrating-implementation`</required-skills>
<workflow>Review plan and research; confirm URL; delegate `tsh-implement-ui-common-task`; run capture then `tsh-review-ui`; treat VERIFICATION NOT RUN as a blocker; fix all FAIL findings and re-capture; proceed to `tsh-review` only after PASS or explicit escalation.</workflow>
<constraints>Never self-execute UI verification, use stale artifacts, guess a Figma URL, or substitute code review for the Figma gate.</constraints>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-implement-ui:v1 -->
