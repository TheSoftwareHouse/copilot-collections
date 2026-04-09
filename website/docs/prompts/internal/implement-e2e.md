---
sidebar_position: 8
title: /tsh-implement-e2e
---

# /tsh-implement-e2e

:::info
Not invoked directly by users. To trigger E2E test implementation, use [`/tsh-implement`](../public/implement) — the [Engineering Manager](../../agents/engineering-manager) will automatically delegate to the [E2E Engineer](../../agents/e2e-engineer).
:::

**Agent:** E2E Engineer  
**File:** `.github/internal-prompts/tsh-implement-e2e.prompt.md`

Creates comprehensive end-to-end tests for a feature using Playwright.

## How It’s Triggered

```text
/tsh-implement <JIRA_ID or task description>
```

The Engineering Manager identifies E2E test tasks in the plan and delegates them to the E2E Engineer automatically.

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
- Follows the `tsh-e2e-testing` skill for patterns, mocking, and CI readiness.

### 4. Automatic Code Review

Runs `tsh-code-reviewer` agent automatically at the end to review E2E test quality.

## Skills Loaded

- `tsh-task-analysing` — Determine input source and gather requirements.
- `tsh-e2e-testing` — Page Object patterns, test structure, mocking strategies, verification loop.
- `tsh-technical-context-discovering` — Project conventions and test patterns.

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
