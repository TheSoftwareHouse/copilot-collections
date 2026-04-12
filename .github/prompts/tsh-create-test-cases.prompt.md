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

1. Gather context — if a Jira ticket ID is provided, use the `atlassian` tool to fetch ticket details. If a test plan was already generated (e.g., via `/tsh-plan-testing`), use its scenarios as input.
2. Validate AC completeness — apply the AC Completeness Gate from `tsh-functional-testing`. If AC are not test-ready, redirect the user to the BA workflow (`/tsh-analyze-materials`) to complete them first.
3. Generate test cases as Markdown tables with these columns: **#**, **Test Case**, **Preconditions**, **Steps**, **Expected Result**, **Priority** (High/Medium/Low), **Status** (blank — for manual fill).
4. Cover every acceptance criterion with at least one test case. Include at least 2 negative/edge-case test cases per scenario.
5. Group test cases by scenario or functional area. Present the full set for review.

## Constraints

- Do not generate a full test plan — use `/tsh-plan-testing` for that. This prompt produces granular test cases only.
- Do not infer, guess, or complete missing Acceptance Criteria. If AC are not test-ready, redirect to `/tsh-analyze-materials`.
- Every test case must have explicit steps (numbered) and a specific expected result — no vague assertions like "it works correctly."
- Do not generate bug reports — use `/tsh-report-bug` for that.
