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
2. **Ask delivery destination** — always use `vscode/askQuestions` to ask where the regression plan should be delivered. Do not assume a destination; the user must choose:
   - **Chat only** — display the plan in the conversation
   - **Publish to Confluence** — create or update a Confluence page with the regression checklist. If chosen, ask for the Confluence space key and optionally a parent page title.
   - **Create Jira sub-task** — create a regression plan sub-task under the source ticket. If chosen, ask for the parent ticket ID.
   - **Confluence + Jira** — publish to Confluence and create a Jira task linking to the page.
   Store the choice and apply it in step 8. If the user selects a destination but cannot provide the required identifiers (space key, ticket ID, etc.), ask them to provide the missing information before proceeding — do not fall back silently to chat.
3. Gather context from the selected data sources — use the `atlassian` tool to fetch the relevant tickets, bugs, Confluence pages, etc.
4. If code changes are available (diff, PR, or changed files), use `get_changed_files` to identify affected areas. If no code changes are provided, work from the gathered context to identify the scope.
5. Map changes and Jira context to functional areas. Classify regression risk using the skill's risk table (High/Medium/Low), incorporating bug history and defect density. When analyzing bugs, distinguish between **Story Bugs** (tied to specific user stories — indicating feature-level instability) and **Bugs** (standalone defects — indicating systemic issues). Areas with high Story Bug density signal incomplete feature implementation and warrant focused regression on the affected stories.
6. Produce a Regression Scope Table and a Manual Regression Checklist as defined in the skill — prioritized by risk level with justification from Jira/Confluence findings.
7. If performance or security areas are impacted, include focused risk notes (2-3 highest risks, not exhaustive checklists).
8. **Deliver the regression plan** — based on the destination chosen in step 2:
   - **Chat only**: present in the conversation.
   - **Publish to Confluence**: create or update a page titled "Regression Plan — [feature/area] — [date]" in the specified space using the `atlassian` tool. When updating an existing page, append to the change log — never overwrite previous entries. Confirm with link.
   - **Create Jira sub-task**: create a sub-task titled "Regression Plan" using the `atlassian` tool, confirm with link.
   - **Confluence + Jira**: publish to Confluence first, then create a Jira task linking to the Confluence page. Confirm both with links.
   If delivery fails (e.g., invalid space key, permission error), inform the user of the error and ask them to provide a valid destination before retrying.
9. Present results and offer next steps:
   - Generate regression test cases (full E2E paths + critical area cases, positive and negative) using the skill's Regression Test Cases section
   - Hand off regression scenarios to `tsh-e2e-engineer` for Playwright automation (presents a handoff brief, does NOT generate scripts)
   - Generate a quality health report analysis
   - Re-deliver to a different destination if needed

## Constraints

- Do not generate E2E automation scripts — this prompt produces manual regression plans and test cases only. For Playwright automation, hand off to the `tsh-e2e-engineer` agent via the handoff brief workflow.
- Do not generate API test scenarios without first confirming with the user that API testing is relevant for the project.
- Focus on manual testing scenarios — manual regression flows, exploratory testing areas, and full E2E user journeys. Not automation-ready scripts.
- Do not infer or complete missing acceptance criteria. If AC are needed and incomplete, redirect to `/tsh-analyze-materials`.
- If no Jira/Confluence context is available, work from the user-provided description but note that richer context would improve the regression plan.
- When publishing to Confluence, always append to the change log — never overwrite previous entries.
- If delivery to the chosen destination fails, do not silently fall back to chat — inform the user of the error and ask for a valid destination.
