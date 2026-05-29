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
- **Read the plan's execution-support package** from the plan file (`*.plan.md`) if it exists — `Glossary / Ubiquitous Language`, `Technical Context`, `Traps and Warnings`, and the relevant phase preamble(s). These sections contain project conventions, test patterns, constraints, terminology, and commands already discovered during planning. Use them as your primary source and skip re-discovery for aspects already covered.
- Check `*.instructions.md` only for aspects **not covered** by the plan's Technical Context
- Analyze `playwright.config.ts` + existing Page Objects
- Discover existing test patterns and locator strategies in the codebase

Treat labeled pseudocode, tables, diagrams, and contracts in the plan as illustrative guidance only. They must not be copied as production test code without translating them into the repository's actual patterns.

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

## 5. Code Review (automatic)

After completing E2E tests implementation, always run `tsh-code-reviewer` agent to review the E2E tests against best practices and test quality standards. The agent should be executed automatically without user confirmation. Update the changelog section of the plan file to indicate that E2E code review was performed and include a summary of the findings.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-implement-e2e:v2 -->
