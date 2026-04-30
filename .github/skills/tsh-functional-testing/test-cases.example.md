# Test Cases Example

Use this template when generating test cases. Follow this exact structure for every test case set.

---

# Test Cases — [Feature / Scenario Name]

**Source:** [Jira ticket ID, test plan reference, or feature description]
**Date:** [Current date]
**Preconditions:** [Global preconditions that apply to all test cases below]

---

## [Functional Area / Scenario Group 1]

| # | Test Case | Steps | Expected Result | Status |
|---|-----------|-------|-----------------|--------|
| TC-001 | [Short descriptive name] | 1. [Action step] · 2. [Action step] · 3. [Action step] | [Specific, verifiable outcome] | |
| TC-002 | [Short descriptive name] | 1. [Action step] · 2. [Action step] | [Specific, verifiable outcome] | |
| TC-003 | [Negative case — short name] | 1. [Action step triggering failure] · 2. [Observe behavior] | [Expected error handling or graceful degradation] | |

## [Functional Area / Scenario Group 2]

| # | Test Case | Steps | Expected Result | Status |
|---|-----------|-------|-----------------|--------|
| TC-004 | [Short descriptive name] | 1. [Action step] · 2. [Action step] | [Specific, verifiable outcome] | |
| TC-005 | [Edge case — short name] | 1. [Action step at boundary] · 2. [Observe behavior] | [Expected behavior at boundary] | |

## Edge Cases & Negative Scenarios

| # | Test Case | Steps | Expected Result | Status |
|---|-----------|-------|-----------------|--------|
| TC-N01 | [Empty input / missing data] | 1. [Leave field empty or omit required data] · 2. [Submit / trigger action] | [Validation message or graceful handling] | |
| TC-N02 | [Invalid input / boundary overflow] | 1. [Enter invalid or over-limit data] · 2. [Submit / trigger action] | [Rejection with clear error message] | |
| TC-N03 | [Network failure / timeout] | 1. [Disconnect network or simulate timeout] · 2. [Trigger action] | [Graceful error state, no data loss] | |
| TC-N04 | [Unauthorized access attempt] | 1. [Attempt restricted action] | [Access denied, redirect, or appropriate error] | |

---

## Formatting Rules

- **# column**: Use `TC-001`, `TC-002` for positive cases; `TC-N01`, `TC-N02` for negative/edge cases.
- **Steps**: Number each step. Use ` · ` (space-dot-space) as separator within the table cell. For complex flows, consider splitting into multiple test cases instead of listing 10+ steps.
- **Expected Result**: Must be specific and verifiable — never "works correctly" or "behaves as expected." State exactly what the user should see, what state changes, or what data appears.
- **Status**: Leave blank — filled during manual execution (Pass / Fail / Blocked / Skipped).
- **Grouping**: Group test cases by functional area or scenario. Each group gets its own table with a `##` heading. Always include an "Edge Cases & Negative Scenarios" group at the end.
- **Coverage**: Every AC must map to at least one test case. Include at least 2 negative/edge-case test cases per scenario group.
