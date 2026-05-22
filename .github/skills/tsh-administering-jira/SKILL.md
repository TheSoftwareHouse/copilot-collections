---
name: tsh-administering-jira
description: "Jira Cloud, Data Center, and JSM configuration review, change planning, project health audits, runbook drafting, and safe change procedures. Covers workflow simplification, queue optimization, permission audits, dashboard design, and stakeholder communication. Use when reviewing setups, planning changes, drafting admin documentation, or auditing Jira/JSM configurations."
---

# Jira Administration

This skill provides structured approaches for reviewing, improving, and documenting Jira Cloud, Jira Data Center, and JSM configurations. It covers project health auditing, safe change planning, runbook creation, and operational documentation.

## Guiding Principles

| Principle | Rationale |
|---|---|
| **Safe and reversible first** | Recommend reversible changes before destructive ones. Always include a rollback plan. |
| **Audit before changing** | Understand the current state fully before recommending modifications. |
| **Document impact and dependencies** | Every change affects workflows, automations, permissions, and SLAs. Map dependencies before acting. |
| **Validate in test first** | Never recommend production changes without a test plan and validation criteria. |
| **Communicate before and after** | Stakeholders need to know what's changing, why, and what to expect. |
| **Minimize disruption** | Prefer phased rollouts over big-bang changes. |

---

## 1. Project Health Audit

Use this checklist to perform a comprehensive project configuration review:

```
Project Health Audit:
- [ ] Workflow complexity: count statuses, transitions, and dead-end states
- [ ] Status sprawl: identify redundant or unused statuses
- [ ] Assignment logic: verify clear ownership and escalation paths
- [ ] Queue overlap: check for queues with overlapping JQL that cause duplicates
- [ ] Dashboard usefulness: verify dashboards reflect actual operational needs
- [ ] Field sprawl: identify unused custom fields, redundant fields, and missing required fields
- [ ] Automation health: check for duplicate rules, failed rules, and race conditions
- [ ] Permission audit: verify permissions are neither too broad nor too restrictive
- [ ] SLA configuration: verify SLA goals match business requirements
- [ ] Manual work candidates: identify repetitive manual tasks that could be safely automated
- [ ] Bottleneck detection: look for statuses where tickets accumulate
```

### Audit Guidance per Item

**Workflow complexity**
Count the total number of statuses and transitions in each workflow. Workflows with more than 8–10 statuses or transitions that loop back to earlier statuses without clear purpose are candidates for simplification. Look for dead-end statuses — statuses with no outgoing transitions — which trap issues permanently. Use the workflow editor or REST API (`/rest/api/3/workflow`) to enumerate transitions.

**Status sprawl**
Search for statuses that have zero or near-zero issues in them over the past 90 days. Compare status names across projects — similar statuses with slight naming differences (e.g., "In Review" vs. "Under Review") indicate consolidation opportunities. JQL: `status WAS "StatusName" AFTER startOfMonth(-3)` to check recent usage.

**Assignment logic**
Verify that every workflow transition either auto-assigns or prompts for an assignee. Unassigned issues in active statuses indicate gaps in the assignment flow. Check automation rules that handle assignment — are they based on components, labels, request types, or round-robin? Confirm escalation paths exist for tickets aging beyond SLA thresholds.

**Queue overlap**
Export the JQL from every JSM queue. Compare clauses to identify overlap — two queues matching the same issue cause confusion for agents. Flag any queue whose JQL is a superset of another queue's JQL. Use `tsh-writing-jql` to rewrite overlapping queries into mutually exclusive sets.

**Dashboard usefulness**
Review each dashboard's gadgets. Ask: "Does this gadget answer a question someone needs answered daily?" Remove or replace gadgets that show stale data, unused filters, or vanity metrics. Verify that dashboards are shared with the correct groups and that auto-refresh intervals are appropriate.

**Field sprawl**
List all custom fields using the admin UI or REST API (`/rest/api/3/field`). Cross-reference with screens and issue types to find fields that exist but are not on any screen, or are on screens but never populated. Fields with more than 80% empty values across all issues are candidates for removal.

**Automation health**
Review the automation audit log for failed executions. Group failures by rule to find recurring issues. Look for pairs of rules that fire on the same trigger and modify the same fields — these create race conditions. Check for rules with broad triggers (e.g., "When: Issue created") that lack sufficient conditions, causing them to fire on unintended issue types.

**Permission audit**
Export the permission scheme for each project. Verify that project roles are used instead of individual users or ad-hoc groups. Check that "Browse Projects" is not granted to overly broad groups. For JSM projects, verify that customer portal visibility matches the intended audience.

**SLA configuration**
Compare SLA goals (time-to-first-response, time-to-resolution) against actual performance data. JQL: `"Time to first response" != EMPTY` filtered by request type can reveal misconfigured SLA calendars or missing request type mappings. Check that SLA calendars reflect actual business hours and holidays.

**Manual work candidates**
Ask agents: "What do you do repeatedly that feels mechanical?" Look for patterns like manual status transitions after specific events, copy-paste between fields, or recurring label/component assignments. Cross-reference with automation capabilities to identify safe automation candidates.

**Bottleneck detection**
Run JQL to find statuses where issues accumulate: `status = "StatusName" AND updated < startOfDay(-7)`. Statuses with a high count of aging issues indicate process bottlenecks — either the work takes too long, ownership is unclear, or the status is used as a parking lot.

---

## 2. Change Planning

For every proposed configuration change, produce this structure:

```
Change Plan:
- [ ] Goal: what problem does this solve?
- [ ] Affected objects: workflows, screens, fields, automations, permissions, queues, SLAs
- [ ] Dependencies: what other configurations depend on the changed objects?
- [ ] Risks: what could go wrong?
- [ ] Test plan: how to validate the change before production deployment?
- [ ] Rollback plan: how to reverse the change if it fails?
- [ ] Communication note: what stakeholders need to know?
- [ ] Validation criteria: how to confirm the change worked post-deployment?
```

### Dependency Identification

Trace dependencies through the full configuration chain:

```
Workflow → Workflow Scheme → Project → Issue Type Scheme → Issue Types
Field → Screen → Screen Scheme → Issue Type Screen Scheme → Project
Permission Scheme → Project
Notification Scheme → Project
Automation Rule → Project (or global) → Trigger conditions → Actions
Queue → JQL → Fields, Statuses, Request Types
SLA → Calendar → Request Type → Queue
```

Before changing any object, identify every other object that references it. Changing a workflow used by three projects affects all three. Removing a status used in queue JQL breaks that queue. Adding a required field to a screen used by automation rules may cause those rules to fail if they don't populate the field.

### Risk Categories

| Risk Category | Examples | Mitigation |
|---|---|---|
| **Data loss** | Removing a custom field deletes all its values permanently | Export field values before removal; use field hiding instead of deletion when possible |
| **Access loss** | Overly restrictive permission change locks users out | Test permission changes in a sandbox project with test users first |
| **Automation breakage** | Field rename or removal breaks automation rule conditions/actions | Search all automation rules for references to the field before changing |
| **SLA reset** | Workflow changes can reset active SLA timers | Document which SLAs are affected; schedule changes during low-volume periods |
| **Queue disruption** | JQL field or status changes silently empty queues | Test queue JQL changes in a draft queue or ad-hoc search before deploying |

### Test Plan Patterns

| Change Type | Test Approach |
|---|---|
| Workflow edit | Create a sandbox project using the same workflow scheme. Walk a test issue through all transitions. Verify automation rules still fire correctly. |
| Permission change | Create a test user in the affected role. Verify they can perform expected actions and cannot perform restricted ones. |
| Field addition/removal | Test on a single issue type in a sandbox project. Verify screens, automation rules, and JQL filters still work. |
| Automation rule change | Use the "Run rule" manual trigger on a test issue. Check audit log for the expected outcome. |
| Queue JQL change | Run the new JQL in ad-hoc search first. Compare results with the current queue contents. |
| SLA change | Create a test issue matching the request type. Verify the SLA timer starts and pauses correctly. |

### Rollback Strategies

| Change Type | Rollback Method |
|---|---|
| Workflow status/transition added | Remove the new status/transition. Move any issues in the new status to an appropriate existing status first. |
| Workflow status/transition removed | Re-add the status/transition. Note: issues that were moved out of the removed status cannot be auto-restored. |
| Permission scheme change | Revert to the previous permission scheme configuration. Document the previous state before making changes. |
| Custom field added | Remove the field from screens and hide it. Only delete the field if no data was entered. |
| Custom field removed | **Not reversible.** Data is permanently lost. This is why field hiding is preferred over deletion. |
| Automation rule change | Disable the modified rule and re-enable the previous version. Keep old rules disabled rather than deleted during transition periods. |

---

## 3. Runbook and Documentation Patterns

### Troubleshooting Runbook Template

```markdown
# [Issue Type] Troubleshooting Runbook

## Symptoms
What the reporter observes. Include error messages, screenshots, or behavioral descriptions.

## Common Causes
Ranked list of likely root causes, most frequent first.

## Investigation Steps
1. Step-by-step diagnostic procedure.
2. Include JQL queries, admin screens to check, and API endpoints to call.
3. Each step should narrow the possible causes.

## Resolution Steps
Per-cause resolution procedure. Reference specific admin screens and settings.

## Escalation Path
When to escalate, to whom, and what information to include.

## Related Automation Rules
List automation rules that interact with this issue type.

## Related JQL Queries
Diagnostic JQL queries used during investigation.
```

### Admin Checklist Template

```markdown
# [Task] Admin Checklist

## Pre-requisites
Permissions, access, and information needed before starting.

## Steps
Numbered step-by-step procedure with verification after each critical step.

## Verification
How to confirm the task was completed successfully.

## Rollback
How to reverse the changes if something goes wrong.

## Post-completion
Notifications to send, documentation to update, monitoring to check.
```

### Stakeholder Update Template

```markdown
# [Change/Incident] Update

## Summary
1-2 sentences in plain English. No jargon.

## Impact
Who is affected and how. What changed in their daily workflow.

## Current Status
What has been done so far. What is still in progress.

## Next Steps
Concrete actions with owners.

## Timeline
Key dates: when the change was made, when validation completes, when to report issues.
```

---

## 4. Queue Optimization

### Identifying Overlapping Queues

Export the JQL from every queue in the JSM project. Compare them side by side:
- If Queue A's JQL is a subset of Queue B's JQL, an issue matching A also matches B.
- If two queues share the same base filter and differ only in a non-exclusive condition, they overlap.

Use `tsh-writing-jql` to rewrite overlapping conditions into mutually exclusive clauses (e.g., add explicit `AND status != ...` exclusions or use `request type` to partition).

### Reducing Queue Count

Consolidate queues that serve the same agent group and have similar SLA requirements. A smaller number of well-defined queues is easier to manage than many narrow queues. Target: each agent group should have 3–7 queues covering their main work categories.

### Queue Naming Conventions

| Pattern | Example | When to Use |
|---|---|---|
| `[Team] - [Work Type]` | `Platform - Access Requests` | Multi-team projects |
| `[Priority/SLA Tier]` | `P1 - Critical Incidents` | Priority-driven triage |
| `[Request Category]` | `Software Requests` | Single-team projects with clear categories |

Avoid generic names like "General" or "Other" — they become catch-all dumping grounds.

### Queue Ordering and Priority

Place high-urgency queues at the top of the queue list. Agents work top-to-bottom by default. Order by:
1. SLA breach risk (closest to breach first)
2. Priority (P1 before P2)
3. Age (oldest first within the same tier)

### Agent Group Assignment

Assign queues to the smallest capable agent group. Broad assignment (all agents see all queues) dilutes ownership. Narrow assignment (one agent per queue) creates single points of failure. Target: 3–5 agents per queue for coverage without diffusion.

### Queue JQL Performance

Avoid expensive JQL in queues that auto-refresh frequently:
- Avoid `ORDER BY` on non-indexed fields.
- Avoid deeply nested `OR` clauses.
- Avoid functions that require per-issue evaluation (e.g., complex date calculations on large result sets).
- Prefer indexed standard fields (`status`, `assignee`, `priority`, `request type`) over custom fields where possible.

---

## 5. Dashboard and Filter Design

### Dashboard Audience Types

| Audience | Purpose | Key Gadgets |
|---|---|---|
| **Operations team** | Daily queue management | Filter Results, Pie Chart (by status), Created vs. Resolved |
| **Team leads** | Workload and bottleneck visibility | Two Dimensional Filter, Workload Pie Chart, SLA Status |
| **Leadership** | Trends and SLA compliance | Created vs. Resolved trend, SLA Met/Breached, Resolution Time |

Design dashboards for a specific audience. A dashboard that tries to serve everyone serves no one.

### Recommended Gadgets per Audience

**Operations team:**
- Filter Results (sorted by priority, limited to 50) — the daily work list
- Pie Chart by status — quick health check
- Created vs. Resolved (last 7 days) — are we keeping up?

**Team leads:**
- Two Dimensional Filter (assignee × status) — workload distribution
- SLA Status gadget — breach risk visibility
- Activity Stream — recent changes and updates

**Leadership:**
- Created vs. Resolved trend (30/90 days) — demand vs. capacity trend
- SLA Met/Breached percentage — compliance metrics
- Average Resolution Time — efficiency tracking

### Filter Ownership and Sharing

- Every dashboard gadget should use a named saved filter, not inline JQL.
- Assign filter ownership to a service account or team lead — not individual contributors who may leave.
- Share filters with project roles, not individual users.
- Name filters descriptively: `[Project] - [Purpose] - [Audience]` (e.g., `HELPDESK - Open P1 Incidents - Ops Team`).

### Dashboard Performance

- Limit auto-refresh to dashboards that need real-time data (operations). Set team lead and leadership dashboards to manual refresh or 15+ minute intervals.
- Avoid gadgets that run expensive JQL (large result sets, multiple `OR` clauses, non-indexed custom fields).
- Limit Filter Results gadgets to 50 results maximum — agents don't process more than that in a single view.

---

## 6. Permission and Security Patterns

### Project Roles vs. Groups

| Mechanism | When to Use | Advantage |
|---|---|---|
| **Project roles** | Per-project access control (e.g., developers on Project A, not Project B) | Role membership is project-scoped; one role definition, many project-specific members |
| **Groups** | Organization-wide access (e.g., all-staff, all-developers) | Membership is global; simpler for permissions that apply across all projects |

**Rule:** Use project roles for permission schemes. Use groups for global application access and as members of project roles.

### Issue Security Scheme Patterns

| Level | Visibility | Typical Use |
|---|---|---|
| **Internal only** | Project team members only | Sensitive internal discussions, HR-related issues |
| **Partner-visible** | Project team + named external partners | Shared development, vendor collaboration |
| **Customer-visible** | Portal customers can see via JSM | Support requests, service requests |
| **Unrestricted** | All users with Browse Projects permission | Default for most operational issues |

Apply issue security at the issue level, not the project level. Use automation rules to set security level automatically based on request type, component, or label.

### Common Permission Configurations for Operations Projects

- **Browse Projects**: Project role "Users" + relevant groups
- **Create Issues**: Same as Browse Projects (anyone who can see can report)
- **Transition Issues**: Project role "Agents" (only team members move issues)
- **Assign Issues**: Project role "Agents" + "Team Leads"
- **Edit Issues**: Project role "Agents" (reporters can edit via portal, not direct edit)
- **Delete Issues**: Project role "Administrators" only
- **Manage Sprints / Manage Queue**: Project role "Team Leads" + "Administrators"

### JSM Customer Portal Visibility

- Customers see only their own requests by default.
- Organization members can see all requests from their organization (if enabled).
- Portal request types determine what customers can submit — hide internal-only request types from the portal.
- Comments with "Internal" visibility are hidden from customers.

### Workflow Transitions vs. Permission Schemes for Access Control

| Approach | Use When |
|---|---|
| **Workflow conditions/validators** | You need to restrict WHO can move an issue to a specific status (e.g., only QA can transition to "Verified") |
| **Permission schemes** | You need to restrict WHO can perform an action across all statuses (e.g., only admins can delete issues) |

Prefer workflow conditions for status-specific restrictions. Prefer permission schemes for action-level restrictions. Do not duplicate the same restriction in both places.

---

## Connected Skills

- `tsh-writing-jql` — JQL is central to queue definitions, dashboard filters, and audit queries.
- `tsh-troubleshooting-jira` — Investigation findings often lead to configuration changes that this skill helps plan safely.
