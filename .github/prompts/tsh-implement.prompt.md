---
agent: "tsh-engineering-manager"
model: "Claude Sonnet 5"
description: "Implement feature according to the plan."
---

<goal>
Start implementation delivery for a feature based on a task description, Jira item, or implementation plan. This prompt is a thin trigger that routes execution through the canonical orchestration workflow rather than defining that workflow inline.
</goal>

<required-skills>
<skill name="tsh-orchestrating-implementation">
Required because it contains the canonical implementation-orchestration workflow, including Step 0 flow selection and the delivery process that this prompt must trigger without duplicating.
</skill>
</required-skills>

<input-requirements>
Provide at least one of the following: a task description, a Jira ID, or a `*.plan.md` implementation plan. Related context such as a `*.research.md` file may also be included when available.
</input-requirements>

<workflow>
Load `tsh-orchestrating-implementation`, start at Step 0, and follow the canonical workflow defined there for the rest of the implementation delivery.
</workflow>

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-implement:v2 -->
