---
name: tsh-functional-testing
description: "Quality engineering workflows: test plan generation, edge-case detection, regression scope analysis, AC verification, complex test data generation, environment matrix, and Jira QA sub-task creation. Use when creating test plans, detecting edge cases, analysing regression scope, verifying implementation against AC, generating test data, or performing Jira-integrated QA workflows."
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

Present **only** the test plan first. Do not generate test cases or additional content yet.

**Step 3: Detect edge cases**

Brainstorm negative testing scenarios for every task, including:
- Loss of connectivity / network failures
- Invalid character inputs and boundary conditions
- Concurrent sessions and race conditions
- Empty states and maximum data limits
- Permission/authorization edge cases
- Device-specific and browser-specific behaviors

**Step 4: Present next steps**

After generating the test plan, present the user with options:
1. Generate specific test cases (as Markdown tables)
2. Focus on edge cases only
3. Create a Jira QA sub-task with the test plan
4. Extend with desktop environment matrix
5. Run regression scope analysis
6. Verify implementation against AC
7. Generate complex test data

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

Analyze code changes or diffs to determine which existing features may be affected and require regression testing.

**Steps**:
1. Identify the changed files and their scope (use `get_changed_files` tool or accept a diff/PR description from the user)
2. Map changed code to functional areas:
   - Which user-facing features depend on the changed modules?
   - Which API endpoints or data flows are affected?
   - Are there shared utilities or components that propagate risk?
3. Classify regression risk per area:

| Risk Level | Criteria |
|------------|----------|
| 🔴 **High** | Direct dependency on changed code; critical user flow |
| 🟡 **Medium** | Indirect dependency; shared component or utility changed |
| 🟢 **Low** | No dependency detected; change is isolated |

4. Produce a **Regression Scope Table**:

| Functional Area | Risk Level | Reason | Suggested Scenarios |
|----------------|-----------|--------|-------------------|
| [Area] | 🔴/🟡/🟢 | [Why this area is affected] | [Key scenarios to retest] |

**Output**: Regression scope table with risk classification and suggested retest scenarios.

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

To record test execution results, use the template at `./test-results.example.md`. Track pass/fail status per scenario across test iterations.

## Trigger Phrases

| Trigger | Action |
|---------|--------|
| `/test-plan` or `create test plan` | Generate full Test Plan from description or Jira ticket |
| `/edge-cases` | Focus only on negative/boundary scenarios |
| `/desktop` | Extend environment with desktop browser matrix |
| `/regression` | Analyze regression scope from code changes or diff |
| `/verify-ac` | Verify implementation against Acceptance Criteria |
| `/test-data` | Generate complex test data sets for the feature |

## Connected Skills

- `tsh-accessibility-auditing` — for WCAG compliance testing which complements functional testing
- `tsh-e2e-testing` — for automated end-to-end test implementation that can build on manual test plans
- `tsh-code-reviewing` — for code testability analysis within the code review process
- `tsh-ui-verifying` — for Figma-vs-implementation comparison when acceptance criteria include UI requirements