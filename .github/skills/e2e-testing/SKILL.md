---
name: e2e-testing
description: 'E2E testing patterns, verification procedures, and CI readiness checklists using Playwright. Use for writing, debugging, or reviewing end-to-end tests, fixing flaky tests, creating Page Objects, mocking external APIs.'
---

# E2E Testing Patterns & Practices

## When to Use

- Writing or modifying E2E tests
- Debugging test failures or flaky tests
- Reviewing E2E test code quality
- Setting up CI pipelines for E2E tests

## Page Object Pattern

```typescript
export class FeaturePage {
  constructor(readonly page: Page) {}
  get submitBtn() {
    return this.page.getByRole('button', { name: 'Submit' });
  }
  async navigate() { await this.page.goto('/feature'); }
}
```

## Test Structure

```typescript
test('should [behavior] when [condition]', async ({ page }) => {
  const id = `test-${Date.now()}-${test.info().parallelIndex}`;
  // Arrange → Act → Assert
});
```

## Mocking (external APIs only)

```typescript
await page.route('**/api/external/**', route => route.fulfill({ status: 200, body: '{}' }));
```

## Verification Loop

```
RUN → FAIL? → DEBUG (browser_snapshot) → FIX → REPEAT
```

| Rule | Limit |
|------|-------|
| Max per test | 5 iterations → `test.fixme()` |
| Max per suite | 15 iterations → stop |
| Flaky detection | 3 pass/fail mix → investigate |
| Stability | 3+ consecutive passes required |
| App bug | Mark `test.fixme('BUG: desc')` |

### Error Recovery

| Error | Action |
|-------|--------|
| Timeout | Increase once → check selector → check if element renders |
| Element not found | Alternative locator → check DOM → verify page loaded |
| Network | Retry → consider mock → verify backend |
| Flaky | Explicit waits → check race conditions → run 5x |
| App bug | Mark `test.fixme('BUG: desc')` - test is skipped; CI usually still passes unless skipped tests fail the build |

## CI Readiness Checklist

- [ ] Passes headless: `npx playwright test --headed=false`
- [ ] Uses `process.env.BASE_URL`
- [ ] No hardcoded credentials
- [ ] Explicit viewport

## Quick Reference

**Always**: accessible locators, unique test data, 3+ passes, mock external APIs
**Never**: `waitForTimeout()`, CSS selectors, test interdependencies, hardcoded creds
