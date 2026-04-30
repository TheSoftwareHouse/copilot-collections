---
sidebar_position: 13
title: /tsh-plan-testing
---

# /tsh-plan-testing

**Agent:** QA Engineer  
**File:** `.github/prompts/tsh-plan-testing.prompt.md`

Generates a structured functional test plan from a task description or Jira ticket, including edge-case detection and environment specification.

## Usage

```text
/tsh-plan-testing <Jira ticket ID or feature description>
```

## What It Does

1. **Gathers context** — If a Jira ticket ID is provided, fetches ticket details via Atlassian. Otherwise extracts requirements from the task description.
2. **Validates Acceptance Criteria** — Applies the AC Completeness Gate. If AC are incomplete or ambiguous, stops and instructs the user to complete them via the BA workflow before proceeding.
3. **Generates test plan** — Creates a structured test plan with scenarios, edge cases (minimum 2), preconditions, environment, and scope. Every AC item is mapped to at least one test scenario.
4. **Presents next steps** — Offers options: generate test cases, focus on edge cases, create Jira QA sub-task, extend environment matrix, run regression analysis, verify AC, or generate test data.

## Skills Loaded

- `tsh-functional-testing` — Provides the test plan workflow, templates, severity matrix, Jira integration, edge-case detection, regression scope analysis, AC verification, and test data generation.

## Output

- Structured test plan following the standard template.
- After approval, optionally creates a Jira QA sub-task with the test plan as description.

## Next Steps After Test Plan

| Option | What It Does |
|---|---|
| Generate test cases | Creates detailed test case tables in Markdown |
| Edge cases only | Focuses on negative/boundary scenarios |
| Jira QA sub-task | Creates a sub-task under the original ticket |
| Desktop environment | Extends with desktop browser matrix |
| Regression analysis | Analyses code changes for regression scope |
| Verify AC | Compares implementation against Acceptance Criteria |
| Test data | Generates complex test data sets |
