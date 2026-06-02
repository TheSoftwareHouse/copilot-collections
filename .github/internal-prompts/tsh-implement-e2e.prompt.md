# E2E Test Workflow

**Non-interactive** - make reasonable decisions, document them.

## Required Skills

Before starting, load and follow these skills:
- `tsh-task-analysing` - to determine the input source for the delegated task block
- `tsh-technical-context-discovering` - to establish test conventions, existing patterns, and project configuration
- `tsh-e2e-testing` - for Page Object patterns, test structure, mocking strategies, verification loop rules, error recovery, and CI readiness checklist

---

## 1. Context

Follow the `tsh-task-analysing` skill's **Step 0 (Determine input source)** only to locate the delegated task block, then use that task block and its `Read First` items as the primary source of truth for scope, fixtures, browser state, route details, and other UI-specific facts.

Additionally, always:
- **Read the delegated task block first** — Read only the files/resources named in its `Read First` list.
- Check `*.instructions.md` only for aspects **not covered** by the task block or its named reading
- Analyze `playwright.config.ts` + existing Page Objects
- Discover existing test patterns and locator strategies in the codebase

Treat labeled pseudocode, tables, diagrams, and contracts in the task block as illustrative guidance only. They must not be copied as production test code without translating them into the repository's actual patterns.

---

## 2. Planning

Map acceptance criteria to scenarios:

| Acceptance Criterion | Scenario Type | Test Name |
|---------------------|---------------|-----------|
| [from task block] | Happy/Error/Edge | `should [behavior] when [condition]` |

Checklist:
- [ ] Each criterion → at least one test
- [ ] API mocking needs documented
- [ ] Page Objects to create listed

---

## 3. Implementation & Verification

Follow the `tsh-e2e-testing` skill for:
- Page Object patterns and test structure
- Mocking strategies (external APIs only)
- Verification loop rules and iteration limits
- Error recovery procedures
- CI readiness checklist

---

## 4. Summary (required output)

```markdown
## E2E Test Summary

### Coverage
| Criterion | Test | Status |
|-----------|------|--------|
| [from task block] | [file#test] | ✅/❌ |

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

Update task status (if a status list exists): check acceptance criteria and mark verified QA items complete.

---

## 5. Code Review (automatic)

After completing E2E tests implementation, always run `tsh-code-reviewer` agent to review the E2E tests against best practices and test quality standards. The agent should be executed automatically without user confirmation. Update task status or verified QA items to indicate that E2E code review was performed and include a summary of the findings.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-implement-e2e:v2 -->
