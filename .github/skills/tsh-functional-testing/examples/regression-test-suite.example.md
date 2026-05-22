# Regression Test Suite Example

Use this template when generating the regression test suite. Follow this exact structure. This is the **execution artifact** — a structured table of test cases ready for manual testing.

---

# Regression Test Suite — [Release / Phase Name]

**Last updated:** [date]
**Scope:** [Brief description of what this regression covers — e.g., "All changes from Phase 2 (Jan–Apr 2026)"]
**Platforms:** [e.g., iOS, Android / Web (Chrome, Firefox, Safari) / Desktop (Windows, macOS)]
**Status legend:** P = Pass, F = Fail, B = Blocked, N/A = Not applicable

---

## 1. [Functional Area Name]

| # | Test Case | Steps | Expected Result | Status |
|---|-----------|-------|-----------------|--------|
| R-001 | [Short descriptive name] ([TICKET-ID]) | 1. [Step] · 2. [Step] · 3. [Step] | [Specific verifiable outcome] | |
| R-002 | [Short descriptive name] | 1. [Step] · 2. [Step] | [Specific verifiable outcome] | |

---

## 2. [Functional Area Name]

| # | Test Case | Steps | Expected Result | Status |
|---|-----------|-------|-----------------|--------|
| R-003 | [Short descriptive name] ([TICKET-ID]) | 1. [Step] · 2. [Step] | [Specific verifiable outcome] | |
| R-004 | [Negative case — short name] | 1. [Step triggering failure] · 2. [Observe behavior] | [Expected error handling] | |

---

## N. Cross-Cutting Concerns

| # | Test Case | Steps | Expected Result | Status |
|---|-----------|-------|-----------------|--------|
| R-NNN | [App launch / startup check] | 1. [Step] · 2. [Step] | [No crashes, correct initial state] | |

---

## Summary

| Risk Level | Sections | Test Cases |
|---|---|---|
| 🔴 Critical | [N] | [count] |
| 🟡 Important | [N] | [count] |
| 🟢 Low Risk | [N] | [count] |
| **Total** | **[N]** | **[count]** |

---

## Formatting Rules

- **# column**: Sequential `R-001`, `R-002`, ... across the entire document. Numbering does NOT reset per section.
- **Test Case**: Short descriptive name. Include Jira ticket reference inline when applicable: `Login with MFA (PROJ-189)`.
- **Steps**: Numbered inline with ` · ` (space-dot-space) separator. Keep concise — split complex flows into separate test cases rather than listing 10+ steps.
- **Expected Result**: Specific and verifiable — never "works correctly." State exactly what the tester should observe.
- **Status**: Leave blank — filled during execution. Use `P` (Pass), `F` (Fail), `B` (Blocked), `N/A`, or emoji (✅ / ❌ / ❓).
- **Sections**: Group by functional area. Number sections sequentially: `## 1.`, `## 2.`, etc. Separate with `---`.
- **Section ordering**: Order sections by risk — 🔴 High risk sections first, 🟢 Low risk last. Always end with a "Cross-Cutting Concerns" section.
- **Jira references**: Inline in the Test Case column, not in a separate column.
- **Platform columns**: When the project tests across specific platforms (e.g., iOS + Android, or multiple browsers), replace the single `Status` column with one column per platform. Otherwise keep a single `Status` column.
