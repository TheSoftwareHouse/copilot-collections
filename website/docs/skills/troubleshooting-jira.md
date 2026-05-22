---
sidebar_position: 34
title: Troubleshooting Jira
---

# Troubleshooting Jira

**Folder:** `.github/skills/tsh-troubleshooting-jira/`  
**Used by:** Jira Admin

Process-oriented skill providing structured investigation workflows for diagnosing issues in Jira Cloud, Jira Data Center, and Jira Service Management. Each investigation type follows a checklist approach for thorough root-cause analysis.

## Investigation Types

### 1. Queue and Routing Issues

Checklist-driven investigation of why tickets land in the wrong queue or don't appear:

- Request type and issue type assumptions.
- Queue JQL or filter logic mismatches.
- Required fields or labels missing.
- Assignment logic or automation side effects.
- Permissions and issue security visibility.
- Workflow status constraints.
- SLA or team ownership side effects.

### 2. Automation Troubleshooting

Structured diagnosis of automation rule failures:

- Trigger assumptions (event type, scope).
- Conditions and branching logic.
- Expected vs. actual field values.
- Smart values and data availability.
- Rule and project scope.
- Actor permissions.
- Timing, race conditions, and duplicate rules.
- Audit log evidence.

### 3. Permission Issues

Investigation of access and visibility problems:

- Affected users, groups, and roles.
- Exact blocked action.
- Project role and permission scheme analysis.
- Issue security and request visibility.
- Workflow transition restrictions.
- Global vs. project-level vs. issue-level scope.

### 4. Workflow Issues

Diagnosis of workflow transition failures:

- Current vs. expected status mapping.
- Available transitions and their conditions.
- Post-function behavior.
- Workflow scheme assignment.
- Draft vs. published workflow state.

### 5. SLA and Escalation Issues

Investigation of SLA clock and escalation behavior:

- SLA configuration (start, pause, stop conditions).
- Calendar and business hours.
- Goal condition matching.
- Status-driven clock behavior.
- Escalation rule triggers.

## Response Format

Every troubleshooting response follows this structure:

1. What is likely happening
2. Most likely causes (ranked)
3. What to check first
4. JQL or investigation queries
5. Safe next steps
6. Risks or side effects
7. Stakeholder summary (if applicable)

## Connected Skills

- [JQL Writing](./writing-jql) — Construct investigation queries to isolate and verify issues.
- [Administering Jira](./administering-jira) — Translate findings into configuration changes, runbooks, or improvement plans.
