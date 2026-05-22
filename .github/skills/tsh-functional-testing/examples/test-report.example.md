# Test Report Example

Use this template when generating test execution reports. Follow this exact structure for every test report.

---

# Test Report — [Feature / Scenario Name]

**Source:** [Jira ticket ID or test plan reference]
**Date:** [Current date]
**Tester:** [Name]
**Environment:** [Device, OS, browser, app version]

---

## Summary

| Metric | Count |
|--------|-------|
| Total test cases | [N] |
| Passed | [N] |
| Failed | [N] |
| Blocked | [N] |
| Skipped | [N] |

**Verdict:** 🟢 Go / 🔴 No-Go / 🟡 Conditional

---

## Test Results

### [Functional Area / Scenario Group 1]

| # | Test Case | Result | Notes |
|---|-----------|--------|-------|
| TC-001 | [Short descriptive name] | ✅ Pass | |
| TC-002 | [Short descriptive name] | ❌ Fail | [Brief description of failure] |
| TC-003 | [Negative case — short name] | ✅ Pass | |

### [Functional Area / Scenario Group 2]

| # | Test Case | Result | Notes |
|---|-----------|--------|-------|
| TC-004 | [Short descriptive name] | ⛔ Blocked | [What is blocking execution] |
| TC-005 | [Edge case — short name] | ⏭️ Skipped | [Reason for skipping] |

---

## Failed Test Cases

| # | Test Case | Expected Result | Actual Result | Bug Ticket |
|---|-----------|-----------------|---------------|------------|
| TC-002 | [Short descriptive name] | [What should have happened] | [What actually happened] | [Jira ID or "To be filed"] |

---

## Blockers & Risks

- [Blocker or risk description — e.g., "Environment X unavailable, 3 test cases could not run"]
- [Any open issues that affect the verdict]

---

## Recommendations

- [Action item — e.g., "Fix TC-002 failure before release"]
- [Action item — e.g., "Retest blocked cases once environment is restored"]
- [Action item — e.g., "Consider adding regression coverage for area X"]

---

## Formatting Rules

- **Result column**: Use `✅ Pass`, `❌ Fail`, `⛔ Blocked`, `⏭️ Skipped`.
- **Notes column**: Leave blank for passing cases. For failures, provide a one-line description. For blocked/skipped, state the reason.
- **Failed Test Cases section**: Only include test cases with `❌ Fail` result. Link to a bug ticket if one was filed.
- **Verdict**: `🟢 Go` = all critical cases pass, no blockers. `🔴 No-Go` = critical failures or blockers present. `🟡 Conditional` = non-critical failures, can proceed with known issues.
- **Grouping**: Mirror the same grouping used in the test cases document.
