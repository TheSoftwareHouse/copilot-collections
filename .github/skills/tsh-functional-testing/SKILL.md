---
name: tsh-functional-testing
description: "Manual QA and functional testing workflows: test plan generation from task descriptions or Jira tickets, edge-case detection, professional bug reporting, test result reporting, and Jira QA sub-task creation. Use when creating test plans, detecting edge cases, writing bug reports, generating test result templates, or performing Jira-integrated QA workflows."
---

# Functional Testing

Generates structured test plans, detects edge cases, produces professional bug reports, and creates test result reports for manual QA workflows.

<principles>

<always-challenge>
Never state "this looks fine" without suggesting at least one potential edge case or failure point. Every feature has hidden assumptions worth questioning.
</always-challenge>

<test-before-automate>
Manual test plans establish the ground truth. Validate scenarios manually first — automated tests codify what manual testing already proved correct.
</test-before-automate>

</principles>

## Functional Testing Process

Use the checklist below and track your progress:

```
Progress:
- [ ] Step 1: Gather task context
- [ ] Step 2: Generate test plan
- [ ] Step 3: Detect edge cases
- [ ] Step 4: Present next steps
```

**Step 1: Gather task context**

Determine the source of the task and ensure full understanding:
- If a **Jira ticket ID** is provided, use the `atlassian` tool to fetch the ticket's summary, description, and acceptance criteria.
- If a **task description** is provided directly, extract the testable requirements.
- If **In Scope** or **Navigation** details are missing, infer them using general QA standards.

**Interaction Protocols:**
- **MUST use `askQuestions`** when confidence about testing scope or Acceptance Criteria is below 80%.
- Frame questions as multiple-choice where possible to speed up the process.
- One question per call — do not batch unrelated questions.
- Always check the `skipped` field in the response — if true, use a sensible QA default (e.g., standard login flow if MFA is not specified).
- Include story/epic context in the header: `"[PROJ-XXX] Missing AC details"`.

**Step 2: Generate test plan**

Generate a test plan using the template at `./test-plan.example.md`. Follow these rules:
- Use bolded text, numbered lists, and bullet points for the general structure — do **not** use tables for the overall plan layout
- Include at least 2 negative/edge-case scenarios
- Specify preconditions and environment
- Explicitly list out-of-scope items
- Each scenario must have clear action steps and specific verification criteria

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
3. Generate a bug report template
4. Generate test results template
5. Create a Jira QA sub-task with the test plan
6. Extend with desktop environment matrix

Wait for the user's choice before generating additional content.

## Jira Integration Flow

**When triggered**: User provides a Jira ticket ID.

**Steps**:
1. Fetch the ticket details using the `atlassian` tool
2. Generate a Test Plan based on the ticket's summary, description, and acceptance criteria
3. Present the test plan to the user for approval
4. Once approved, create a Sub-task under the original ticket titled **"QA Task"** with the test plan as the description

**Output**: Jira sub-task with test plan as description.

## Bug Reporting

**When triggered**: `/bug-report` or `create bug report`.

**Steps**:
1. Use the template at `./bug-report.example.md`
2. Include Steps to Reproduce (numbered, specific)
3. Include Actual vs Expected behavior
4. Classify severity using the severity matrix below

**Output**: Formatted bug report ready for Jira or team communication.

## Test Results

**When triggered**: `/test-results` or `test results`.

**Steps**:
1. Use the template at `./test-results.example.md`
2. Use the **same scenarios** as the corresponding test plan
3. Do **not** create test cases in table format
4. Do **not** create potential bugs — leave findings blank for the tester to fill

**Output**: Blank test results report matching the current test plan.

## Code Testability Review

**When triggered**: `/code-review` or `analyze code for testability`.

**Steps**:
1. Identify the code changes or files in scope
2. Analyze code for testability: are there clear inputs/outputs, separable units, mockable dependencies?
3. Flag areas that are hard to test manually (tightly coupled logic, hidden side effects, implicit state)
4. Suggest specific functional test scenarios that cover the changed code paths

**Output**: List of testability observations and suggested manual test scenarios.

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

## Definition of Done (Testing)

A test plan is considered complete when it covers:
- [ ] All acceptance criteria from the ticket
- [ ] At least 2 negative/edge-case scenarios
- [ ] Preconditions and environment specified
- [ ] Out of Scope items explicitly listed

## Trigger Phrases

| Trigger | Action |
|---------|--------|
| `/test-plan` or `create test plan` | Generate full Test Plan from description or Jira ticket |
| `/edge-cases` | Focus only on negative/boundary scenarios |
| `/bug-report` | Format input into a professional bug report |
| `/test-results` | Generate blank Test Report matching current plan |
| `/code-review` | Analyze code for testability and suggest tests |
| `/desktop` | Extend environment with desktop browser matrix |

## Connected Skills

- `tsh-accessibility-auditing` - for WCAG compliance testing which complements functional testing
- `tsh-e2e-testing` - for automated end-to-end test implementation that can build on manual test plans

## Interaction Decision Framework

Use the following logic to decide between inferring info vs. using `askQuestions`:

| Situation | Action |
|-----------|--------|
| Missing minor navigation detail | **Infer** (use common sense) |
| Ambiguous Acceptance Criteria | **askQuestions** (Multiple Choice) |
| Missing technical environment info | **Infer** (use defaults) |
| Critical business logic gap | **askQuestions** (Open-ended or MC) |

*Note: If the user skips the interaction, explicitly state in the chat: "User skipped clarification; proceeding with default QA assumptions."*