---
name: tsh-planning-tests
description: "Test plan generation from acceptance criteria with edge-case detection, environment matrix, and template-enforced output. Use when creating test plans, detecting edge cases, or extending environment coverage."
---

# Planning Tests

Generates structured test plans from acceptance criteria with built-in edge-case detection and strict template enforcement.

<principles>

<always-challenge>
Never state "this looks fine" without suggesting at least one potential edge case or failure point. Every feature has hidden assumptions worth questioning.
</always-challenge>

<test-before-automate>
Manual test plans establish the ground truth. Validate scenarios manually first — automated tests codify what manual testing already proved correct.
</test-before-automate>

<ac-is-the-contract>
Acceptance Criteria are the contract between product and QA. QA consumes AC — it does not create, complete, or normalize them. If AC are incomplete, redirect to the BA workflow (`/tsh-analyze-materials`) before testing begins.
</ac-is-the-contract>

<api-relevance-gate>
Not all projects test the backend directly. Before generating API test scenarios, always confirm with the user whether API testing is relevant. If not applicable, skip entirely.
</api-relevance-gate>

</principles>

## Process

```
Progress:
- [ ] Step 1: Gather task context and validate AC
- [ ] Step 2: Generate test plan
- [ ] Step 3: Detect edge cases
- [ ] Step 4: Present next steps
```

**Step 1: Gather task context and validate AC**

Determine the source of the task:
- If a **Jira ticket ID** is provided, use the `atlassian` tool to fetch the ticket's summary, description, and acceptance criteria.
- If a **task description** is provided directly, use the stated acceptance criteria as input.

**AC Completeness Gate:**
Before generating any test plan, verify that the Acceptance Criteria are sufficient for testing. AC are considered **test-ready** when they define:
- At least one clear expected outcome per user-facing behavior
- Identifiable preconditions (user state, data state)
- Boundaries or constraints (e.g., max length, allowed roles, supported formats)

If the AC are **incomplete or ambiguous**:
1. List the specific gaps found.
2. Redirect the user: _"The Acceptance Criteria for this task are not test-ready. Please complete them via the BA workflow (`/tsh-analyze-materials`) before proceeding with test planning. Gaps found: [list gaps]."_
3. **Stop** — do not generate a test plan, do not attempt to fill the gaps.

> **Boundary rule**: QA validates AC — it does not supplement, rewrite, or expand them.

If **navigation paths** or **environment/browser details** are missing, infer them using standard QA defaults (operational details, not business requirements).

**Step 2: Generate test plan**

Generate a test plan using the template at `./examples/test-plan.example.md`. The output MUST reproduce the exact structural format of the template.

<template-enforcement>
**Mandatory structure (in this exact order):**
1. Title line: `# Test Plan - [date]`
2. `**Navigation:**` followed by the path on a new line
3. `**In Scope:**` followed by bullet list (`- item`)
4. `**Out of Scope:**` followed by bullet list
5. `**Preconditions:**` followed by bullet list
6. `**Environment:**` followed by bullet list of devices
7. Horizontal rule (`---`)
8. `## Scenarios` heading
9. Each scenario as: `**Scenario N: [Title]**` followed by action steps as bullets (`- step`) and verification as `- Verify that: [criteria]`
10. Edge cases use format: `**Scenario N (Edge Case): [Title]**`
11. Horizontal rule (`---`)
12. Optional sections (Regression, Performance, Security, API) follow the same format as in the template

**Formatting rules:**
- Use `**bold**` for section labels and scenario titles — never use headings (`##`) for individual scenarios
- Use `-` bullet lists for steps and items — never use numbered lists (`1.`) for scenario steps
- Use `- Verify that:` prefix for all verification criteria
- Separate major sections with `---`
- Do NOT use tables anywhere in the test plan
- Do NOT add emojis, icons, or decorative elements
- Do NOT wrap the plan in a code block
</template-enforcement>

Follow these additional rules:
- Include at least 2 negative/edge-case scenarios
- Specify preconditions and environment
- Explicitly list out-of-scope items
- Each scenario must have clear action steps and specific verification criteria
- Map every AC item to at least one test scenario
- **API Testing Gate**: If the feature involves backend interaction, ask the user whether API test scenarios should be included before generating them. Use `vscode/askQuestions` to confirm.
- **Performance Considerations**: Include when the feature involves data loading, large datasets, or user-facing latency. List only the 3-5 highest-risk items.
- **Security Considerations**: Include when the feature involves authentication, authorization, user data, or input handling. List only the 3-5 highest-risk items.

Present **only** the test plan first. Do not generate test cases or additional content yet.

**Step 3: Detect edge cases**

Brainstorm negative testing scenarios including:
- Loss of connectivity / network failures
- Invalid character inputs and boundary conditions
- Concurrent sessions and race conditions
- Empty states and maximum data limits
- Permission/authorization edge cases
- Device-specific and browser-specific behaviors
- Performance-related risks
- Security-related risks

**Step 4: Present next steps**

After generating the test plan, present the user with options:
1. Generate specific test cases (using `./examples/test-cases.example.md`)
2. Focus on edge cases only
3. Extend with desktop environment matrix
4. Run regression scope analysis (delegates to `tsh-analyzing-regression-risk`)
5. Verify implementation against AC (delegates to `tsh-verifying-acceptance-criteria`)
6. Generate complex test data (delegates to `tsh-generating-test-data`)

Wait for the user's choice before generating additional content.

## Jira Integration Flow

**When triggered**: User provides a Jira ticket ID.

**Steps**:
1. Fetch the ticket details using the `atlassian` tool
2. Validate the AC Completeness Gate (Step 1) — stop if AC are incomplete
3. Generate a Test Plan based on the ticket's summary, description, and acceptance criteria
4. Present the test plan to the user for approval
5. Deliver to the user's chosen destination (chat, Jira comment, or file)

## Desktop Environment Extension

**When triggered**: `/desktop`.

Extend or regenerate the Environment section with the latest stable versions of Chrome, Firefox, Safari, Edge across Windows and macOS. Append to existing mobile devices; do not replace them.

## Severity Matrix

| Severity | Definition | Blocks Release? |
|----------|-----------|-----------------|
| 🔴 **Critical** | Feature is broken/unusable, data loss, or security vulnerability | Yes |
| 🟠 **High** | Major functionality impaired, no workaround available | Should block |
| 🟡 **Medium** | Functionality impaired but a workaround exists | Fix before next release |
| 🔵 **Low** | Cosmetic issue or minor UX inconsistency | Fix when convenient |

When reporting bugs found during testing, use the bug report template at `./examples/bug-report.example.md`.

## Definition of Done (Testing)

A test plan is considered complete when it covers:
- [ ] All acceptance criteria from the ticket mapped to test scenarios
- [ ] At least 2 negative/edge-case scenarios
- [ ] Preconditions and environment specified
- [ ] Out of Scope items explicitly listed

## Trigger Phrases

| Trigger | Action |
|---------|--------|
| `/test-plan` or `create test plan` | Generate full Test Plan |
| `/edge-cases` | Focus only on negative/boundary scenarios |
| `/desktop` | Extend environment with desktop browser matrix |

## Connected Skills

- `tsh-analyzing-regression-risk` — for regression scope analysis
- `tsh-verifying-acceptance-criteria` — for AC verification
- `tsh-generating-test-data` — for complex test data sets
- `tsh-accessibility-auditing` — for WCAG compliance testing
- `tsh-task-analysing` — for gathering context before test planning
