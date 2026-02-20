---
sidebar_position: 7
title: E2E Engineer
---

# E2E Engineer Agent

**File:** `.github/agents/tsh-e2e-engineer.agent.md`

The E2E Engineer agent creates, maintains, and debugs end-to-end tests using Playwright. It produces reliable, maintainable, and meaningful test suites.

## Responsibilities

- Analyzing the application and designing test scenarios.
- Implementing Page Objects with accessibility-first locators.
- Writing comprehensive test files with proper structure.
- Verifying tests pass consistently (3+ consecutive passes) in headless mode.
- Debugging flaky tests and ensuring CI readiness.
- Reporting bugs discovered during testing.

## Testing Standards

| Standard | Approach |
|---|---|
| **Locators** | Use `getByRole`, `getByLabel`, `getByText`. Avoid CSS selectors. `getByTestId` only as fallback. |
| **Synchronization** | Built-in auto-waiting assertions. No `waitForTimeout()`. No `networkidle`. |
| **Test Data** | Dynamic data with timestamps/UUIDs. No state dependency between tests. |
| **Security** | Never hardcode credentials. Use environment variables. |
| **Naming** | `should [behavior] when [condition]` pattern. |
| **Isolation** | Tests must not depend on state left by previous tests. |

## Key Behaviors

- **Non-interactive** — Makes reasonable decisions and documents them.
- **Strictly follows the plan** — Does not deviate unless explicitly instructed.
- **No dead code** — Does not create unused test helpers or future-only tests.
- **3+ consecutive passes** — Required before tests are considered stable.

## Tool Access

| Tool | Usage |
|---|---|
| **Playwright MCP** | Inspect actual page state, discover locators, understand UI structure |
| **Context7** | Search Playwright API docs (library ID: `/microsoft/playwright.dev`) |
| **Figma** | Understand expected UI behavior, extract labels for locator strategies |
| **Sequential Thinking** | Analyze complex test scenarios, debug flaky tests, plan mocking strategies |

## Skills Loaded

- `task-analysis` — Determine context sources and gather requirements.
- `e2e-testing` — Test structure patterns, Page Object conventions, mocking strategies, verification loop.
- `technical-context-discovery` — Project conventions and test patterns.

## Handoffs

After discovering critical bugs, the E2E Engineer can hand off to:

- **Software Engineer** → `/implement` (fix the bug discovered during E2E testing)
