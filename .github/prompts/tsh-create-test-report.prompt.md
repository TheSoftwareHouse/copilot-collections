---
agent: "tsh-qa-engineer"
model: "Claude Opus 4.6"
description: "Generate a test execution report with pass/fail summary, Go/No-Go verdict, failed case details, and blockers from test case results."
argument-hint: "[Test cases with results, Jira ticket ID, or describe what was tested]"
---

Generate a test execution report summarizing test results into a Go/No-Go verdict. Takes executed test cases (with pass/fail outcomes) and produces a structured report with summary metrics, detailed results, failed case analysis, blockers, and recommendations. Can be used as a follow-up to `/tsh-create-test-cases` after manual execution.

## Required Skills

Before starting, load and follow these skills:

- `tsh-functional-testing` - provides the test report template and severity context

## Workflow

1. **Ask delivery destination** — use `vscode/askQuestions` to ask where the test report should be delivered:
   - **Chat only** — display the report in the conversation (default)
   - **Add to Jira ticket** — post as a comment on an existing Jira ticket. If chosen, ask for the target ticket ID.
   - **Create Jira sub-task** — create a "Test Report" sub-task under the source ticket with the report as description.
   Store the choice and apply it in step 5.
2. **Gather results** — collect test execution data from the user:
   - If test cases with results are provided in the conversation (e.g., from a previous `/tsh-create-test-cases` run with manual annotations), use those directly.
   - If a Jira ticket ID is provided, use the `atlassian` tool to fetch the ticket and any QA sub-tasks with test results.
   - If neither, ask the user to provide the test cases with their pass/fail results.
3. **Generate the test report** using the template at `tsh-functional-testing/test-report.example.md`. Follow the template's structure exactly:
   - Summary table with total/passed/failed/blocked/skipped counts
   - Verdict: 🟢 Go (all critical pass, no blockers), 🔴 No-Go (critical failures or blockers), 🟡 Conditional (non-critical failures, can proceed with known issues)
   - Test results grouped by functional area mirroring the test case grouping
   - Failed test cases detail table with expected vs actual and bug ticket references
   - Blockers & risks section
   - Recommendations section with actionable next steps
4. **Link failed cases to bugs** — for each failed test case, check if a bug ticket already exists. If not, note it as "To be filed" and offer to create one via `/tsh-report-bug`.
5. **Deliver the report** — based on the destination chosen in step 1:
   - **Chat only**: present in the conversation.
   - **Add to Jira ticket**: post as a comment using the `atlassian` tool, confirm with link.
   - **Create Jira sub-task**: create a sub-task titled "Test Report" using the `atlassian` tool, confirm with link.
6. **Present next steps**:
   - File bug reports for failed cases (`/tsh-report-bug`)
   - Plan regression for affected areas (`/tsh-plan-regression`)
   - Re-run test cases after fixes (`/tsh-create-test-cases`)

## Constraints

- Do not generate test cases — use `/tsh-create-test-cases` for that. This prompt summarizes execution results only.
- Do not fabricate test results. If the user has not provided pass/fail outcomes, ask for them before generating the report.
- The verdict must be justified — explain which failures or blockers drove the Go/No-Go decision.
- Do not generate bug reports inline — reference `/tsh-report-bug` for each failed case that needs a ticket.
