---
agent: "tsh-qa-engineer"
model: "Claude Opus 4.6"
description: "Generate a structured functional test plan from a task description or Jira ticket, including edge-case detection and environment specification."
argument-hint: "[Jira ticket ID, feature description, or acceptance criteria]"
---

Generate a comprehensive functional test plan for the provided feature or Jira ticket. The test plan will include scenarios, edge cases, preconditions, environment specification, and scope definition. After generating the test plan, present the user with options for next steps (test cases, Jira sub-task creation, regression analysis, AC verification, test data generation).

## Required Skills

Before starting, load and follow these skills:

- `tsh-functional-testing` - provides the test plan generation workflow, templates, severity matrix, Jira integration flow, edge-case detection, regression scope analysis, AC verification, and test data generation

## Workflow

Follow the Functional Testing Process defined in the `tsh-functional-testing` skill. The skill contains the complete workflow including:

1. Gather context — if a Jira ticket ID is provided, use the `atlassian` tool to fetch ticket details
2. Validate AC completeness — apply the AC Completeness Gate. If AC are not test-ready, stop and redirect the user to the BA workflow (`/tsh-analyze-materials`) to complete them. Do not proceed until AC gaps are resolved upstream.
3. Generate test plan using the `test-plan.example.md` template
4. Detect edge cases — ensure at least 2 negative/edge-case scenarios
5. Present next step options as defined in the skill's Step 4

## Constraints

- Do not generate bug reports — use `/tsh-report-bug` for bug reporting.
- Do not perform accessibility auditing — use `/tsh-audit-accessibility` for WCAG compliance.
- Do not infer, guess, or complete missing Acceptance Criteria. If AC are not test-ready, redirect the user to the BA workflow (`/tsh-analyze-materials`) to resolve gaps first. Requirement completion is a BA responsibility.
- Always verify that the Definition of Done checklist from the skill is satisfied before marking the test plan as complete.
