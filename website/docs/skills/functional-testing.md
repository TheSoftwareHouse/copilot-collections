---
sidebar_position: 26
title: Functional Testing
---

# Functional Testing

**Folder:** `.github/skills/tsh-functional-testing/`  
**Used by:** QA Engineer

Strategic quality engineering skill focused on test planning, edge-case detection, regression scope analysis, implementation vs. AC verification, complex test data generation, and Jira QA integration.

## Process

### Step 1: Gather Task Context and Validate AC

Determine the source (Jira ticket or task description) and validate that Acceptance Criteria are complete.

**AC Completeness Gate:** Before generating any test plan, AC must define:
- At least one clear expected outcome per user-facing behavior
- Identifiable preconditions (user state, data state)
- Boundaries or constraints (max length, allowed roles, supported formats)

If AC are incomplete, the skill stops and instructs the user to complete them via the BA workflow (`/tsh-analyze-materials`) before proceeding.

### Step 2: Generate Test Plan

Creates a structured test plan using the `test-plan.example.md` template:
- Minimum 2 negative/edge-case scenarios
- Every AC item mapped to at least one test scenario
- Preconditions, environment, and out-of-scope items specified

### Step 3: Detect Edge Cases

Brainstorms negative testing scenarios: connectivity failures, invalid inputs, boundary conditions, concurrent sessions, empty states, max data limits, permission edge cases, device-specific behaviors.

### Step 4: Present Next Steps

Offers follow-up options: test cases, edge cases, Jira sub-task, desktop matrix, regression analysis, AC verification, or test data generation.

## Capabilities

### Regression Scope Analysis

Analyzes code changes or diffs to determine which existing features may be affected. Produces a regression scope table with risk classification (High / Medium / Low) and suggested retest scenarios.

### Implementation vs. AC Verification

Compares actual implementation against stated Acceptance Criteria. Classifies each AC item as Met, Partial, Not Met, or Untestable. Produces a verification table with gap summary.

### Complex Test Data Generation

Generates realistic, edge-covering test data sets: happy path, boundary values, format edge cases, state combinations, and temporal data. Output as categorized Markdown tables with dependency notes.

### Jira Integration

When a Jira ticket ID is provided, fetches ticket details, validates AC, generates a test plan, and (on approval) creates a QA sub-task under the original ticket.

### Desktop Environment Extension

Extends the environment section with latest stable desktop browser versions (Chrome, Firefox, Safari, Edge).

## Trigger Phrases

| Trigger | Action |
|---|---|
| `/test-plan` | Generate full test plan from description or Jira ticket |
| `/edge-cases` | Focus on negative/boundary scenarios |
| `/desktop` | Extend environment with desktop browser matrix |
| `/regression` | Analyze regression scope from code changes |
| `/verify-ac` | Verify implementation against Acceptance Criteria |
| `/test-data` | Generate complex test data sets |

## Connected Skills

- `tsh-accessibility-auditing` — WCAG compliance testing that complements functional testing.
- `tsh-e2e-testing` — Automated E2E test implementation that builds on manual test plans.
- `tsh-code-reviewing` — Code testability analysis within the code review process.
