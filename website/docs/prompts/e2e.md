---
sidebar_position: 8
title: /e2e
---

# /e2e

**Agent:** E2E Engineer  
**File:** `.github/prompts/e2e.prompt.md`

Creates, maintains, and debugs end-to-end tests using Playwright.

## Usage

```text
/e2e <JIRA_ID or task description>
```

## What It Does

### 1. Context Gathering

- Determines input source (research/plan files, Jira ID, or prompt message).
- Checks `*.instructions.md` for project-specific conventions.
- Analyzes `playwright.config.ts` and existing Page Objects.
- Discovers existing test patterns and locator strategies.

### 2. Planning

Maps acceptance criteria to test scenarios:

| Acceptance Criterion | Scenario Type | Test Name |
|---|---|---|
| User can log in | Happy path | `should navigate to dashboard when login succeeds` |
| Invalid password shows error | Error | `should display error when login fails` |

### 3. Implementation & Verification

- Creates Page Objects with accessibility-first locators.
- Writes test files following `should [behavior] when [condition]` naming.
- Uses Playwright MCP for real-time browser interaction.
- Verifies tests pass 3+ consecutive times in headless mode.
- Follows the `e2e-testing` skill for patterns, mocking, and CI readiness.

### 4. Automatic Code Review

Runs `tsh-code-reviewer` agent automatically at the end to review E2E test quality.

## Skills Loaded

- `task-analysis` — Determine input source and gather requirements.
- `e2e-testing` — Page Object patterns, test structure, mocking strategies, verification loop.
- `technical-context-discovery` — Project conventions and test patterns.

## Output

```markdown
## E2E Test Summary

### Coverage
| Criterion | Test | Status |

### Results
| File | Pass | Fail | Flaky | CI |

### Issues
- BUG: [desc] → test.fixme()
- FLAKY: [desc] → needs investigation

### Files
- NEW: tests/auth/login.spec.ts
- NEW: pages/login.page.ts
```
