# E2E Test Workflow

**Non-interactive** - make reasonable decisions, document them.

## Required Skills

Before starting, load and follow these skills:
- `tsh-task-analysing` - to determine the input source and gather task requirements
- `tsh-technical-context-discovering` - to establish test conventions, existing patterns, and project configuration
- `tsh-e2e-testing` - for Page Object patterns, test structure, mocking strategies, verification loop rules, error recovery, and CI readiness checklist

---

## 1. Context

Follow the `tsh-task-analysing` skill's **Step 0 (Determine input source)** to identify whether context comes from research/plan files, a Jira ID, or directly from the prompt message.

Additionally, always:
- **Read the "Technical Context" section from the plan file** (`*.plan.md`) if it exists — it contains project conventions, test patterns, and commands already discovered during planning. Use it as your primary source and skip re-discovery for aspects already covered.
- Check `*.instructions.md` only for aspects **not covered** by the plan's Technical Context
- Analyze `playwright.config.ts` + existing Page Objects
- Discover existing test patterns and locator strategies in the codebase

---

## 2. Planning

Map acceptance criteria to scenarios:

| Acceptance Criterion | Scenario Type | Test Name |
|---------------------|---------------|-----------|
| [from plan/prompt] | Happy/Error/Edge | `should [behavior] when [condition]` |

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
| [from plan/prompt] | [file#test] | ✅/❌ |

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

Update plan (if plan file exists): check acceptance criteria, add files to Change Log.

---

## 5. Completion Handoff

After completing E2E tests implementation and the section 4 suite/reporting responsibilities, return completion and the E2E summary to `tsh-engineering-manager`. E2E tests are reviewable implementation artifacts and are reviewed once at the manager's final gate per `## Implementation Code-Review Eligibility` in `tsh-orchestrating-implementation`; this prompt must not invoke `tsh-code-reviewer` itself. The E2E summary and any plan Changelog entry recording delivered test files are bookkeeping.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-implement-e2e:v2 -->
