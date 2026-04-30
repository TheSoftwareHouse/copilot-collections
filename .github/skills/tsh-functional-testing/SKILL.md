---
name: tsh-functional-testing
description: "Quality engineering workflows: test plan generation, edge-case detection, regression scope analysis, regression planning with Jira/Confluence context, AC verification, complex test data generation, environment matrix, quality health report analysis, and Jira QA sub-task creation. Use when creating test plans, detecting edge cases, analysing regression scope, planning manual regression testing, verifying implementation against AC, generating test data, analysing bug trends, or performing Jira-integrated QA workflows."
---

# Functional Testing

Strategic quality engineering skill focused on test planning, edge-case detection, regression analysis, and AC verification for manual QA workflows.

<principles>

<always-challenge>
Never state "this looks fine" without suggesting at least one potential edge case or failure point. Every feature has hidden assumptions worth questioning.
</always-challenge>

<test-before-automate>
Manual test plans establish the ground truth. Validate scenarios manually first — automated tests codify what manual testing already proved correct.
</test-before-automate>

<ac-is-the-contract>
Acceptance Criteria are the contract between product and QA. QA consumes AC — it does not create, complete, or normalize them. If AC are incomplete, QA must send the work back upstream to the BA workflow (`/tsh-analyze-materials`) before testing begins. QA's job is to validate what was specified, not to invent what wasn't.
</ac-is-the-contract>

<api-relevance-gate>
Not all projects test the backend directly. Before generating API test scenarios, always confirm with the user whether API testing is relevant for the current project, feature, or task. If API testing is not applicable, skip API scenarios entirely — generating irrelevant test cases wastes time and reduces trust in the output.
</api-relevance-gate>

</principles>

## Responsibility Boundary

This skill is a **pure QA skill**. It consumes test-ready acceptance criteria as input and produces testing outputs (test plans, edge cases, regression scope, test data, bug reports). It does NOT:

- Complete or normalize incomplete acceptance criteria
- Infer scope or requirements from partial descriptions
- Extract testable requirements from raw materials
- Resolve requirement ambiguities by making assumptions

These are BA responsibilities handled by `tsh-task-analysing` and the `/tsh-analyze-materials` workflow. If the input is not test-ready, redirect the user upstream before proceeding.

## Functional Testing Process

Use the checklist below and track your progress:

```
Progress:
- [ ] Step 1: Gather task context and validate AC
- [ ] Step 2: Generate test plan
- [ ] Step 3: Detect edge cases
- [ ] Step 4: Present next steps
```

**Step 1: Gather task context and validate AC**

Determine the source of the task and validate that Acceptance Criteria are complete:
- If a **Jira ticket ID** is provided, use the `atlassian` tool to fetch the ticket's summary, description, and acceptance criteria.
- If a **task description** is provided directly, use the stated acceptance criteria as input.

**AC Completeness Gate:**
Before generating any test plan, verify that the Acceptance Criteria are sufficient for testing. AC are considered **test-ready** when they define:
- At least one clear expected outcome per user-facing behavior
- Identifiable preconditions (user state, data state)
- Boundaries or constraints (e.g., max length, allowed roles, supported formats)

If the AC are **incomplete or ambiguous**:
1. List the specific gaps found (e.g., "No expected behavior defined for empty input", "Role-based access not specified").
2. Redirect the user: _"The Acceptance Criteria for this task are not test-ready. Please complete them via the BA workflow (`/tsh-analyze-materials`) before proceeding with test planning. Gaps found: [list gaps]."_
3. **Stop** — do not generate a test plan, do not attempt to fill the gaps, do not infer missing requirements. Requirement completion is a BA responsibility, not a QA responsibility.

> **Boundary rule**: QA validates AC — it does not supplement, rewrite, or expand them. If AC are missing details, the correct action is always to redirect upstream, never to compensate inline.

If **navigation paths** or **environment/browser details** are missing, infer them using standard QA defaults (these are operational details, not business requirements — QA can handle them).

**Step 2: Generate test plan**

Generate a test plan using the template at `./test-plan.example.md`. Follow these rules:
- Use bolded text, numbered lists, and bullet points for the general structure — do **not** use tables for the overall plan layout
- Include at least 2 negative/edge-case scenarios
- Specify preconditions and environment
- Explicitly list out-of-scope items
- Each scenario must have clear action steps and specific verification criteria
- Map every AC item to at least one test scenario
- **API Testing Gate**: If the feature involves backend interaction, ask the user whether API test scenarios should be included before generating them. Use `vscode/askQuestions` to confirm. If confirmed, include API scenarios in the test plan. If declined or not applicable, skip entirely.
- **Performance Considerations**: Include a "Performance Considerations" section in the test plan when the feature involves data loading, large datasets, heavy operations, or user-facing latency. Keep it focused — list only the 3-5 highest-risk performance items specific to the feature. Use the template section from `./test-plan.example.md`.
- **Security Considerations**: Include a "Security Considerations" section when the feature involves authentication, authorization, user data, role-based access, or input handling. Keep it focused — list only the 3-5 highest-risk security items specific to the feature. Use the template section from `./test-plan.example.md`.

Present **only** the test plan first. Do not generate test cases or additional content yet.

**Step 3: Detect edge cases**

Brainstorm negative testing scenarios for every task, including:
- Loss of connectivity / network failures
- Invalid character inputs and boundary conditions
- Concurrent sessions and race conditions
- Empty states and maximum data limits
- Permission/authorization edge cases
- Device-specific and browser-specific behaviors
- Performance-related risks: slow-loading pages, large data sets, long-running requests, actions triggering multiple backend calls
- Security-related risks: unauthorized access attempts, role escalation, sensitive data exposure in UI, input injection

**Step 4: Present next steps**

After generating the test plan, present the user with options:
1. Generate specific test cases (using the template at `./test-cases.example.md`)
2. Focus on edge cases only
3. Create a Jira QA sub-task with the test plan
4. Extend with desktop environment matrix
5. Run regression scope analysis
6. Verify implementation against AC
7. Generate complex test data
8. Plan manual regression testing with Jira/Confluence context
9. Generate a quality health report analysis (delegates to `tsh-analyzing-bugs`)

Wait for the user's choice before generating additional content.

## Jira Integration Flow

**When triggered**: User provides a Jira ticket ID.

**Steps**:
1. Fetch the ticket details using the `atlassian` tool
2. Validate the AC Completeness Gate (Step 1) — stop if AC are incomplete
3. Generate a Test Plan based on the ticket's summary, description, and acceptance criteria
4. Present the test plan to the user for approval
5. Once approved, create a Sub-task under the original ticket titled **"QA Task"** with the test plan as the description

**Output**: Jira sub-task with test plan as description.

## Regression Scope Analysis

**When triggered**: `/regression` or `analyze regression scope`.

Analyze code changes, Jira context, and Confluence documentation to determine which existing features may be affected and require manual regression testing.

**Steps**:
1. Identify the changed files and their scope (use `get_changed_files` tool or accept a diff/PR description from the user)
2. **Fetch Jira context**: Search for related Jira tickets — user stories, bugs, sub-tasks, and linked issues that touch the same feature area. Look at acceptance criteria, recent bugs, and reopened issues.
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
- [ ] [Scenario]: [Brief description] — [Why it's critical]

**🟡 Important — Should Retest**
- [ ] [Scenario]: [Brief description] — [Why it matters]

**🟢 Low Risk — Retest If Time Permits**
- [ ] [Scenario]: [Brief description]

**Areas Impacted by Recent Changes**
- [Area]: [What changed and why retesting is needed]

**Risks Based on Existing Bugs**
- [Bug ID/Title]: [How this bug relates to the current change and why regression is likely]

8. If performance or security areas are impacted, include focused risk notes (not exhaustive checklists — just the 2-3 highest risks specific to this change).

**Output**: Regression scope table, manual regression checklist with prioritized scenarios, and risk analysis based on Jira/Confluence context.

### Regression Test Cases

**When triggered**: User selects "Generate regression test cases" from the next steps after regression planning.

Before generating, use `vscode/askQuestions` to ask:
1. **Scope** — Full E2E paths, critical area cases only, or both?
2. **Depth** — Top N high-risk scenarios only (specify N), or comprehensive coverage of all identified regression areas?

Convert the selected regression scenarios into structured test cases using the template at `./test-cases.example.md`. Focus on:

- **Full E2E paths** — complete user journeys that cover the critical flow end-to-end (e.g., login → action → verification → logout). These are the most valuable for later automation.
- **Critical area cases** — targeted test cases for high-risk areas identified in the regression scope analysis.
- **Positive and negative paths** — every regression scenario must have at least one happy-path case and one failure/edge-case.

Use the `TC-R001`, `TC-R002` numbering convention for regression cases (R prefix distinguishes them from feature test cases).

These regression test cases serve dual purpose:
1. **Immediate** — manual regression execution by the QA team
2. **Future** — input for the `tsh-e2e-engineer` agent to automate as Playwright tests

### E2E Automation Handoff

**When triggered**: User selects "Hand off to E2E engineer for automation" from the next steps.

Do NOT generate Playwright scripts or automation code. Instead, present the regression test cases formatted as a handoff brief and instruct the user to pass them to the `tsh-e2e-engineer` agent. The brief should include:
- The regression test cases (full E2E paths)
- Environment and preconditions
- Priority order (automate highest-risk first)
- Any known flaky areas or timing-sensitive flows to watch for

The user can then invoke the E2E engineer agent with the brief as input.

### Confluence Regression List Sync

**When triggered**: User selects "Publish regression checklist to Confluence" or "Sync to Confluence and create Jira task" from the next steps.

Maintain a living regression checklist in Confluence that serves as the single source of truth:

**Steps**:
1. Ask the user for the Confluence space key and (optionally) an existing page title to update. If no page exists, ask for the desired page title.
2. Format the regression checklist as a Confluence page:
   - **Header**: Regression Suite — [Feature Area / Release], last updated [date]
   - **Scope**: What this regression suite covers
   - **Checklist**: The full manual regression checklist grouped by risk level, with scenario descriptions
   - **Change log**: Append a dated entry noting what was added/changed and why
3. Use the `atlassian` tool to create or update the Confluence page.
4. If the user also wants a Jira task, create a Jira ticket (or sub-task) with:
   - **Summary**: "Regression Testing — [Feature Area / Release]"
   - **Description**: Link to the Confluence page + the regression checklist summary (pass/fail counts if reporting, or scenario list if planning)
   - This Jira ticket doubles as the regression execution report — testers update it with results.
5. Confirm to the user with links to the Confluence page and Jira ticket.

## Implementation vs. AC Verification

**When triggered**: `/verify-ac` or `verify implementation against AC`.

Compare the actual implementation against the stated Acceptance Criteria to identify gaps, deviations, or unimplemented requirements.

**Steps**:
1. Gather the AC from the task description or Jira ticket
2. Review the implementation (code changes, UI behavior, API responses) against each AC item
3. For each AC item, classify the status:

| Status | Meaning |
|--------|---------|
| ✅ **Met** | Implementation satisfies the criterion |
| ⚠️ **Partial** | Implementation covers some but not all aspects |
| ❌ **Not Met** | No evidence of implementation for this criterion |
| ❓ **Untestable** | AC is too vague to verify — needs clarification |

4. Produce an **AC Verification Table**:

| # | Acceptance Criterion | Status | Evidence / Notes |
|---|---------------------|--------|-----------------|
| 1 | [AC text] | ✅/⚠️/❌/❓ | [What was observed] |

5. Summarize: count of Met / Partial / Not Met / Untestable. If any are Not Met or Untestable, flag for resolution before sign-off.

**Output**: AC verification table with gap summary.

## Complex Test Data Generation

**When triggered**: `/test-data` or `generate test data`.

Generate realistic, edge-covering test data sets tailored to the feature under test.

**Steps**:
1. Identify the data entities involved (users, orders, products, etc.) and their field constraints from the AC and codebase
2. Generate data sets covering:
   - **Happy path**: Valid, typical data
   - **Boundary values**: Min/max lengths, zero, negative, empty, null
   - **Format edge cases**: Special characters, Unicode, RTL text, long strings, SQL/XSS payloads (for validation testing only)
   - **State combinations**: Different user roles, subscription tiers, feature flags
   - **Temporal data**: Past/future dates, timezone boundaries, leap years, DST transitions
3. Present data as Markdown tables grouped by category
4. Include a **Data Dependencies** note listing any setup required (e.g., "Requires an active subscription in state X")

**Output**: Categorized test data tables with dependency notes, ready for use in manual or automated testing.

## Quality Health Report Analysis

For quality health report creation, defect density analysis, and quality trend reporting, use the `tsh-analyzing-bugs` skill. It provides the full workflow, output templates, and HTML report template. Trigger with `/quality-health-report`, `analyze bugs`, or `quality health report`.

## Desktop Environment Extension

**Bug Summary**

| Category | Count | Details |
|----------|-------|---------|
| Total open bugs | [N] | [Breakdown by status] |
| Critical/High severity | [N] | [List titles] |
| Reopened bugs | [N] | [List titles — these indicate regression risk] |
| Recently created (last 2 weeks) | [N] | [Trend: increasing/stable/decreasing] |

**Defect Density by Area**

| Feature Area / Component | Open Bugs | Critical/High | Trend | Regression Risk |
|--------------------------|-----------|---------------|-------|-----------------|
| [Area] | [N] | [N] | ↑/→/↓ | High/Medium/Low |

**Regression Risk Indicators**
- Reopened bugs suggest incomplete fixes — list each with context
- Areas with highest defect density need priority in regression testing
- Recently fixed bugs in the current release should be retested
- Bugs related to recently changed code are high regression risk

**Recommended Manual Testing Focus**
Based on the bug analysis, recommend the top 5-10 areas where manual regression testing should be focused, with justification from the bug data.

3. If Confluence contains regression checklists or QA documentation, cross-reference with bug findings to identify gaps in existing regression coverage.
4. **Generate HTML report** (when requested or when presenting to stakeholders): Create a standalone HTML file using the template at `./quality-health-report.example.html`. The template is a self-contained single-file dashboard (no external dependencies) with:
   - KPI cards (open bugs, total, blockers, reopened, recent trend)
   - Bar chart showing defect density by feature area
   - Detailed breakdown table with severity and regression risk badges
   - Color-coded regression risk indicators (positive / high-risk / medium-risk)
   - Platform-specific pattern table (if applicable)
   - Numbered recommended manual testing focus list
   - Performance and security consideration panels
   - Overall assessment with trend direction
   - Confluence cross-reference (if docs found)

   Save the file as `[PROJECT_KEY]-quality-health-report.html` in the workspace root. Populate all `[placeholder]` values with actual data from the analysis. Adjust the assessment class (`assessment`, `assessment warning`, or `assessment critical`) based on overall project health.

**Output**: Structured quality health report in Markdown (always) + standalone HTML report file (when requested or for stakeholder presentation).

## Desktop Environment Extension

**When triggered**: `/desktop`.

**Steps**:
1. Extend or regenerate the Environment section with the latest stable versions of:
   - Chrome (Windows / macOS)
   - Firefox (Windows / macOS)
   - Safari (macOS)
   - Edge (Windows)
2. Append these to existing mobile devices; do not replace them

**Output**: Updated Environment section with desktop browser matrix.

## Severity Matrix

| Severity | Definition | Blocks Release? |
|----------|-----------|-----------------|
| 🔴 **Critical** | Feature is broken/unusable, data loss, or security vulnerability | Yes |
| 🟠 **High** | Major functionality impaired, no workaround available | Should block |
| 🟡 **Medium** | Functionality impaired but a workaround exists | Fix before next release |
| 🔵 **Low** | Cosmetic issue or minor UX inconsistency | Fix when convenient |

> **Note**: Severity levels follow bug tracking conventions (Critical/High/Medium/Low). For accessibility audit severity, see `tsh-accessibility-auditing` which uses Critical/Serious/Moderate/Minor aligned with axe-core.

When reporting bugs found during testing, use the bug report template at `./bug-report.example.md`. The template structures reports with severity classification, numbered steps to reproduce, actual vs expected behavior, and environment details.

## Definition of Done (Testing)

A test plan is considered complete when it covers:
- [ ] All acceptance criteria from the ticket mapped to test scenarios
- [ ] At least 2 negative/edge-case scenarios
- [ ] Preconditions and environment specified
- [ ] Out of Scope items explicitly listed

## Trigger Phrases

| Trigger | Action |
|---------|--------|
| `/test-plan` or `create test plan` | Generate full Test Plan from description or Jira ticket |
| `/edge-cases` | Focus only on negative/boundary scenarios |
| `/desktop` | Extend environment with desktop browser matrix |
| `/regression` | Analyze regression scope from code changes or diff |
| `/verify-ac` | Verify implementation against Acceptance Criteria |
| `/test-data` | Generate complex test data sets for the feature |
| `/quality-health-report` | Delegate to `tsh-analyzing-bugs` skill for quality health reports and regression priorities |
| `/regression-plan` | Plan manual regression testing with Jira/Confluence context (alias for enhanced `/regression`) |

## Connected Skills

- `tsh-accessibility-auditing` — for WCAG compliance testing which complements functional testing
- `tsh-e2e-testing` — for automated end-to-end test implementation that can build on manual test plans
- `tsh-code-reviewing` — for code testability analysis within the code review process
- `tsh-ui-verifying` — for Figma-vs-implementation comparison when acceptance criteria include UI requirements
- `tsh-task-analysing` — for gathering context from Jira tickets and Confluence pages before regression planning