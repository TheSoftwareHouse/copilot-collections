---
agent: "tsh-qa-engineer"
model: Claude Opus 4.6
description: "Generate a structured functional test plan from a task description or Jira ticket, including edge-case detection and environment specification."
argument-hint: "[Jira ticket ID, feature description, or acceptance criteria]"
---

<goal>
Generate a comprehensive functional test plan for the provided feature or Jira ticket. The test plan will include scenarios, edge cases, preconditions, environment specification, and scope definition. After generating the test plan, present the user with options for next steps (test cases, bug report template, test results template, Jira sub-task creation).
</goal>

<required-skills>
## Required Skills

Before starting, load and follow these skills:
- `tsh-functional-testing` - provides the test plan generation workflow, templates, severity matrix, Jira integration flow, and edge-case detection process
</required-skills>

<workflow>
## Workflow

1. **Gather context**: If a Jira ticket ID is provided, use the `atlassian` tool to fetch the ticket details. Otherwise, extract requirements from the provided task description.
2. **Load skill**: Load the `tsh-functional-testing` skill and follow its Functional Testing Process step by step.
3. **Generate test plan**: Create the test plan using the test-plan.example.md template from the skill. Ensure it includes at least 2 edge-case scenarios.
4. **Present options**: After delivering the test plan, present the user with next step options as defined in the skill's Step 4.
</workflow>

<constraints>
## Constraints

- Do not generate test results or bug reports unless explicitly requested after the test plan is delivered.
- Do not perform accessibility auditing — use `/tsh-audit-accessibility` for WCAG compliance.
- Always verify that the Definition of Done checklist from the skill is satisfied before marking the test plan as complete.
</constraints>
