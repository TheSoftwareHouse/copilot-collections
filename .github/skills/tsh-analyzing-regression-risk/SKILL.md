---
name: tsh-analyzing-regression-risk
description: "Regression scope analysis from code changes, Jira context, and documentation. Produces risk-classified regression checklists and structured test suites. Use when analyzing regression scope, planning manual regression testing, or generating regression test cases."
---

# Analyzing Regression Risk

Analyzes code changes, Jira context, and documentation to determine which existing features may be affected and require manual regression testing.

## Workflow

**When triggered**: `/regression`, `analyze regression scope`, or `/regression-plan`.

**Steps**:
1. Identify the changed files and their scope (use `get_changed_files` tool or accept a diff/PR description from the user)
2. **Fetch Jira context**: Search for related Jira tickets — user stories, bugs, sub-tasks, and linked issues that touch the same feature area. Look at acceptance criteria, recent bugs, and reopened issues.

   **Pagination & completeness (MANDATORY):**
   - Set `maxResults: 100` for all JQL queries.
   - After each query, compare the returned count to `totalCount`. If `totalCount` exceeds the returned results, paginate using `AND key < "{lastKeyFromPreviousPage}" ORDER BY key DESC` until all results are fetched.
   - Do NOT proceed with partial data — analysis must be based on the complete dataset.
   - Include ALL defect-related issue types: use `type in (Bug, "Story bug")` (or equivalent project-specific types). Check `getJiraProjectIssueTypesMetadata` if unsure which types exist.

3. **Fetch Confluence context** (if available): Search for relevant Confluence pages — feature specifications, regression checklists, release notes, QA documentation, or architecture docs that describe the affected area.
4. Map changed code to functional areas:
   - Which user-facing features depend on the changed modules?
   - Which API endpoints or data flows are affected?
   - Are there shared utilities or components that propagate risk?
5. Classify regression risk per area:

| Risk Level | Criteria |
|------------|----------|
| 🔴 **High** | Direct dependency on changed code; critical user flow; area with history of bugs |
| 🟡 **Medium** | Indirect dependency; shared component or utility changed; area with moderate defect history |
| 🟢 **Low** | No dependency detected; change is isolated; area historically stable |

6. Produce a **Regression Scope Table**:

| Functional Area | Risk Level | Reason | Suggested Manual Scenarios |
|----------------|-----------|--------|---------------------------|
| [Area] | 🔴/🟡/🟢 | [Why this area is affected] | [Key manual scenarios to retest] |

7. Produce a **Manual Regression Checklist**:

**🔴 Critical — Must Retest**
- [ ] [Scenario]: [Brief description] — [Why it's critical]

**🟡 Important — Should Retest**
- [ ] [Scenario]: [Brief description] — [Why it matters]

**🟢 Low Risk — Retest If Time Permits**
- [ ] [Scenario]: [Brief description]

**Areas Impacted by Recent Changes**
- [Area]: [What changed and why retesting is needed]

**Risks Based on Existing Bugs**
- [Bug ID/Title]: [How this bug relates to the current change and why regression is likely]

8. If performance or security areas are impacted, include focused risk notes (just the 2-3 highest risks specific to this change).

9. **Produce a Regression Test Suite** using the template at `./examples/regression-test-suite.example.md`. Convert each scenario from the risk analysis into a structured test case row with `#`, `Test Case`, `Steps`, `Expected Result`, and `Status` columns. Group by functional area, ordered by risk level (🔴 first). Use sequential `R-001`, `R-002` numbering across the entire suite. Include a brief summary table at the end with risk level counts.

**Output**: Two artifacts:
1. **Regression scope analysis** — risk table + bug cross-reference (the planning view)
2. **Regression test suite** — structured test case tables per `./examples/regression-test-suite.example.md` (the execution view)

## Regression Test Cases

**When triggered**: User selects "Generate regression test cases" from next steps.

Before generating, use `vscode/askQuestions` to ask:
1. **Scope** — Full E2E paths, critical area cases only, or both?
2. **Depth** — Top N high-risk scenarios only (specify N), or comprehensive coverage?

Convert the selected regression scenarios into structured test cases using `./examples/test-cases.example.md`. Focus on:

- **Full E2E paths** — complete user journeys covering the critical flow end-to-end
- **Critical area cases** — targeted test cases for high-risk areas
- **Positive and negative paths** — every regression scenario must have at least one happy-path case and one failure/edge-case

Use the `TC-R001`, `TC-R002` numbering convention for regression cases (R prefix distinguishes them from feature test cases).

These regression test cases serve dual purpose:
1. **Immediate** — manual regression execution by the QA team
2. **Future** — input for E2E automation

## Trigger Phrases

| Trigger | Action |
|---------|--------|
| `/regression` | Analyze regression scope from code changes or diff |
| `/regression-plan` | Plan manual regression testing with Jira/Confluence context |

## Connected Skills

- `tsh-planning-tests` — for test plan generation that may precede regression analysis
- `tsh-analyzing-bugs` — for quality health reports that feed into regression priorities
- `tsh-task-analysing` — for gathering broader Jira/Confluence context
