---
name: tsh-generating-test-data
description: "Generate realistic, edge-covering test data sets tailored to feature constraints — boundary values, format edge cases, state combinations, and temporal data. Use when generating complex test data for manual or automated testing."
---

# Generating Test Data

Generates realistic, edge-covering test data sets tailored to the feature under test.

## Workflow

**When triggered**: `/test-data` or `generate test data`.

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

## Trigger Phrases

| Trigger | Action |
|---------|--------|
| `/test-data` | Generate complex test data sets for the feature |

## Connected Skills

- `tsh-planning-tests` — test plans may trigger test data generation as a follow-up
- `tsh-verifying-acceptance-criteria` — AC verification may reveal data scenarios to cover
