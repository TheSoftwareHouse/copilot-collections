---
agent: "tsh-qa-engineer"
model: "Claude Opus 4.6"
description: "Plan manual regression testing using Jira tasks, bugs, acceptance criteria, and Confluence documentation. Produces a prioritized manual regression checklist with risk analysis."
argument-hint: "[Jira project key, ticket ID, feature area, or description of recent changes]"
---

Plan manual regression testing for the provided feature area, Jira project, or recent changes. Uses Jira tickets (user stories, bugs, acceptance criteria) and Confluence documentation (feature specs, regression checklists, release notes) to build a prioritized manual regression checklist focused on the highest-risk areas. Optionally includes a quality health report analysis to identify quality trends.

## Required Skills

Before starting, load and follow these skills:

- `tsh-functional-testing` - provides the Regression Scope Analysis workflow, manual regression checklist template, and risk classification framework
- `tsh-analyzing-bugs` - provides the Quality Health Report Analysis workflow for optional quality trend analysis

## Workflow

Follow the Regression Scope Analysis section from the `tsh-functional-testing` skill:

1. **Ask for data sources**: Before any analysis, use `vscode/askQuestions` to ask the user which data sources to use for building the regression plan:
   - **Jira** — Provide Jira project key, ticket IDs, or epic key to pull user stories, bugs, AC, and linked issues.
   - **Confluence** — Provide Confluence space key and/or page title to pull feature specs, regression checklists, release notes, or QA documentation.
   - **Both** — Pull from both Jira and Confluence for the richest context.
   - **Neither** — Work from the user-provided description only (note that richer context would improve the plan).
   
   Based on the answer, ask follow-up questions for the specific identifiers needed (project key, space key, page title, ticket IDs, etc.).
2. Gather context from the selected data sources — use the `atlassian` tool to fetch the relevant tickets, bugs, Confluence pages, etc.
3. If code changes are available (diff, PR, or changed files), use `get_changed_files` to identify affected areas. If no code changes are provided, work from the gathered context to identify the scope.
3. Map changes and Jira context to functional areas. Classify regression risk using the skill's risk table (High/Medium/Low), incorporating bug history and defect density.
4. Produce a Regression Scope Table and a Manual Regression Checklist as defined in the skill — prioritized by risk level with justification from Jira/Confluence findings.
5. If performance or security areas are impacted, include focused risk notes (2-3 highest risks, not exhaustive checklists).
6. Present results and offer next steps:
   - Generate regression test cases (full E2E paths + critical area cases, positive and negative) using the skill's Regression Test Cases section
   - Hand off regression scenarios to `tsh-e2e-engineer` for Playwright automation (presents a handoff brief, does NOT generate scripts)
   - Publish regression checklist to Confluence (create or update a living page)
   - Sync to Confluence and create a Jira task as the regression execution report
   - Generate a quality health report analysis
   - Create a Jira sub-task with the regression plan

## Constraints

- Do not generate E2E automation scripts — this prompt produces manual regression plans and test cases only. For Playwright automation, hand off to the `tsh-e2e-engineer` agent via the handoff brief workflow.
- Do not generate API test scenarios without first confirming with the user that API testing is relevant for the project.
- Focus on manual testing scenarios — manual regression flows, exploratory testing areas, and full E2E user journeys. Not automation-ready scripts.
- Do not infer or complete missing acceptance criteria. If AC are needed and incomplete, redirect to `/tsh-analyze-materials`.
- If no Jira/Confluence context is available, work from the user-provided description but note that richer context would improve the regression plan.
- When publishing to Confluence, always append to the change log — never overwrite previous entries.
