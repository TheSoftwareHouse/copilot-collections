---
sidebar_position: 4
title: E2E Testing Flow
---

# E2E Testing Flow

For features that need end-to-end test coverage, use the E2E testing workflow. This creates comprehensive, reliable Playwright test suites for critical user journeys.

## Command Sequence

```text
1️⃣ /research <JIRA_ID or task description>
   ↳ 📖 Review research doc – understand feature scope and user journeys
   ↳ ✅ Identify critical paths that need E2E coverage

2️⃣ /plan <JIRA_ID or task description>
   ↳ 📖 Review plan – confirm test scenarios and acceptance criteria
   ↳ ✅ Ensure E2E testing is included in the plan

3️⃣ /e2e <JIRA_ID or task description>
   ↳ 📖 Implements Page Objects, test files, and fixtures
   ↳ ✅ Run tests locally, verify they pass
   ↳ 🔄 Iterate on flaky or failing tests
```

## What `/e2e` Does

- **Agent:** E2E Engineer
- Analyzes the application, designs test scenarios, and implements Page Objects.
- Uses **Playwright MCP** for real-time browser interaction and test verification.
- Follows BDD-style scenarios with proper Arrange-Act-Assert structure.
- Maps acceptance criteria to test scenarios.
- Verifies tests pass consistently **(3+ consecutive passes)** in headless mode before committing.

## What It Produces

- **Page Objects** — Reusable page abstractions with accessibility-first locators.
- **Test files** — Comprehensive test suites following the `should [behavior] when [condition]` naming pattern.
- **Fixtures** — Test data and setup utilities.
- **Execution report** — Summary of coverage, results, and any issues found.

## Testing Standards

The E2E Engineer agent enforces these standards:

| Standard | Approach |
|---|---|
| **Locators** | Use `getByRole`, `getByLabel`, `getByText`. Avoid CSS selectors. Use `getByTestId` only as fallback. |
| **Synchronization** | Built-in auto-waiting assertions. No `waitForTimeout()`. No `waitForLoadState('networkidle')`. |
| **Test data** | Dynamic data for every run (timestamps/UUIDs). Tests must not depend on state from other tests. |
| **Security** | Never hardcode credentials. Use environment variables. |
| **Naming** | `should [behavior] when [condition]` pattern. |

:::warning Important
The `/e2e` command generates tests using Playwright MCP for real-time browser interaction. Always run the generated tests locally, review test scenarios for completeness, and verify they cover the critical user journeys identified during research.
:::
