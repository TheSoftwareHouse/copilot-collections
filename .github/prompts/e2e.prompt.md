---
agent: "tsh-e2e-engineer"
model: "Claude Opus 4.6"
description: "Create, maintain, and execute E2E tests for given feature or user story."
---

# E2E Test Workflow

**Non-interactive** - make reasonable decisions, document them.

---

## 1. Context

- Read `*.research.md` → Jira context, Figma links, acceptance criteria
- Read `*.plan.md` → implementation scope, definition of done
- Check `*.instructions.md` → project-specific conventions
- Analyze `playwright.config.ts` + existing Page Objects

---

## 2. Planning

Map acceptance criteria to scenarios:

| Acceptance Criterion | Scenario Type | Test Name |
|---------------------|---------------|-----------|
| [from plan] | Happy/Error/Edge | `should [behavior] when [condition]` |

Checklist:
- [ ] Each criterion → at least one test
- [ ] API mocking needs documented
- [ ] Page Objects to create listed

---

## 3. Implementation & Verification

Use the `e2e-testing` skill for Page Object patterns, test structure, mocking, verification loop rules, error recovery, and CI readiness checklist.

---

## 4. Summary (required output)

```markdown
## E2E Test Summary

### Coverage
| Criterion | Test | Status |
|-----------|------|--------|
| [from plan] | [file#test] | ✅/❌ |

Coverage: X/Y (Z%)

### Results
| File | Pass | Fail | Flaky | CI |
|------|------|------|-------|-----|
| login.spec.ts | 5 | 0 | 0 | ✅ |

### Issues
- 🐛 BUG: [desc] → test.fixme()
- ⚠️ FLAKY: [desc] → needs investigation

### Files
- NEW: tests/auth/login.spec.ts
- NEW: pages/login.page.ts
```

Update plan: check acceptance criteria, add files to Change Log.

---

## 5. Code Review (automatic)

After completing E2E tests implementation, always run `tsh-code-reviewer` agent to review the E2E tests against best practices and test quality standards. The agent should be executed automatically without user confirmation. Update the changelog section of the plan file to indicate that E2E code review was performed and include a summary of the findings.
