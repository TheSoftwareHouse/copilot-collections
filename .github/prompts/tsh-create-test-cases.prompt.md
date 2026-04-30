---
agent: "tsh-qa-engineer"
model: "Claude Opus 4.6"
description: "Generate detailed, executable test cases from a test plan, acceptance criteria, or feature description, formatted as Markdown tables."
argument-hint: "[Test plan, acceptance criteria, Jira ticket ID, or feature description]"
---

Generate detailed test cases with step-by-step actions, expected results, test data, and preconditions. Output is formatted as Markdown tables ready for manual test execution or Jira import. Can be used standalone or as a follow-up to `/tsh-plan-testing`.

## Required Skills

Before starting, load and follow these skills:

- `tsh-functional-testing` - provides the AC Completeness Gate, severity matrix, and test plan context

## Workflow

1. **Ask delivery destination** — use `vscode/askQuestions` to ask where the test cases should be delivered:
   - **Chat only** — display in the conversation (default)
   - **Add to Jira ticket** — post as a comment on an existing Jira ticket. If chosen, ask for the target ticket ID.
   - **Create Jira sub-task** — create a "QA Test Cases" sub-task under the source ticket with the test cases as description.
   Store the choice and apply it in step 6.
2. Gather context — if a Jira ticket ID is provided, use the `atlassian` tool to fetch ticket details. If a test plan was already generated (e.g., via `/tsh-plan-testing`), use its scenarios as input.
3. Validate AC completeness — apply the AC Completeness Gate from `tsh-functional-testing`. If AC are not test-ready, redirect the user to the BA workflow (`/tsh-analyze-materials`) to complete them first.
4. Generate test cases using the template at `tsh-functional-testing/test-cases.example.md`. Follow the template's structure, formatting rules, and numbering conventions exactly. Columns: **#**, **Test Case**, **Steps**, **Expected Result**, **Status** (blank — for manual fill).
5. Cover every acceptance criterion with at least one test case. Include at least 2 negative/edge-case test cases per scenario. Group test cases by scenario or functional area. Always include an "Edge Cases & Negative Scenarios" group at the end.
6. **Deliver the test cases** — based on the destination chosen in step 1:
   - **Chat only**: present in the conversation as-is.
   - **Add to Jira ticket**: post as a comment using the `atlassian` tool, confirm with link.
   - **Create Jira sub-task**: create a sub-task titled "QA Test Cases" using the `atlassian` tool, confirm with link.
7. **Present next steps**:
   - Generate a test execution report after running the cases (`/tsh-create-test-report`)
   - Generate complex test data for the scenarios (`/tsh-plan-testing` → test data option)
   - Report a bug found during case review (`/tsh-report-bug`)
   - Plan regression for related areas (`/tsh-plan-regression`)

## Constraints

- Do not generate a full test plan — use `/tsh-plan-testing` for that. This prompt produces granular test cases only.
- Do not infer, guess, or complete missing Acceptance Criteria. If AC are not test-ready, redirect to `/tsh-analyze-materials`.
- Every test case must have explicit steps (numbered) and a specific expected result — no vague assertions like "it works correctly."
- Do not generate bug reports — use `/tsh-report-bug` for that.
