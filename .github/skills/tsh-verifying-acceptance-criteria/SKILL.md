---
name: tsh-verifying-acceptance-criteria
description: "Compare implementation against stated Acceptance Criteria to identify gaps, deviations, or unimplemented requirements. Use when verifying implementation completeness against AC or performing AC gap analysis."
---

# Verifying Acceptance Criteria

Compares actual implementation against stated Acceptance Criteria to identify gaps, deviations, or unimplemented requirements.

## Workflow

**When triggered**: `/verify-ac` or `verify implementation against AC`.

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

## Trigger Phrases

| Trigger | Action |
|---------|--------|
| `/verify-ac` | Verify implementation against Acceptance Criteria |

## Connected Skills

- `tsh-planning-tests` — for generating test plans from AC before verification
- `tsh-task-analysing` — for gathering Jira/Confluence context when AC source is a ticket
