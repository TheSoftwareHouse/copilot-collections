---
sidebar_position: 5
title: E2E Testing
---

# E2E Testing

**Folder:** `.github/skills/e2e-testing/`  
**Used by:** E2E Engineer

Provides Playwright-specific E2E testing patterns, Page Object conventions, mocking strategies, error recovery, and CI readiness checklists.

## Page Object Pattern

```typescript
export class LoginPage {
  constructor(private page: Page) {}

  async navigateTo() {
    await this.page.goto('/login');
  }

  async fillCredentials(email: string, password: string) {
    await this.page.getByLabel('Email').fill(email);
    await this.page.getByLabel('Password').fill(password);
  }

  async submit() {
    await this.page.getByRole('button', { name: 'Sign in' }).click();
  }
}
```

## Test Structure

Tests follow the **Arrange → Act → Assert** pattern with `should [behavior] when [condition]` naming.

## Verification Loop

| Limit | Value |
|---|---|
| Max iterations per test | 5 |
| Max iterations per suite | 15 |
| Consecutive passes required | 3 |

## Error Recovery

| Error Type | Recovery Strategy |
|---|---|
| **Timeout** | Increase timeout, check for lazy loading |
| **Element not found** | Verify locator, check if element is conditional |
| **Network** | Check dev server, verify API mocking |
| **Flaky** | Add explicit waits for UI elements, not timers |
| **App bug** | Mark `test.fixme()`, report to SE |

## Mocking Rules

- Mock **external APIs only** — never mock the application under test.
- Use Playwright's `page.route()` for API interception.

## CI Readiness Checklist

- All tests pass in headless mode.
- `BASE_URL` configured via environment variable.
- No hardcoded credentials.
- Explicit viewport size set.

## Quick Reference

| Always | Never |
|---|---|
| Use `getByRole`, `getByLabel`, `getByText` | Use CSS class selectors |
| Wait for specific UI elements | Use `waitForTimeout()` |
| Generate unique test data | Depend on state from other tests |
| Use environment variables for credentials | Hardcode passwords |
