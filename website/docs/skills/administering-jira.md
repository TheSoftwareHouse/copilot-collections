---
sidebar_position: 35
title: Jira Administration
---

# Jira Administration

**Folder:** `.github/skills/tsh-administering-jira/`  
**Used by:** Jira Admin

Hybrid skill combining process checklists with domain-knowledge reference tables for Jira Cloud, Data Center, and JSM configuration review, change planning, project health audits, and operational documentation.

## Topics Covered

### 1. Project Health Audit

Comprehensive checklist for reviewing project health:

- Workflow complexity (status count, dead-end states).
- Status sprawl and redundant statuses.
- Assignment logic and escalation paths.
- Queue overlap detection.
- Dashboard relevance and usefulness.
- Field sprawl (unused, redundant, or missing required fields).
- Automation health (duplicate rules, failures, race conditions).
- Permission breadth (too broad or too restrictive).
- SLA alignment with business requirements.
- Manual work automation candidates.
- Bottleneck detection (status accumulation).

### 2. Change Planning

Every configuration change is documented with:

- **Goal** — What problem does this solve?
- **Affected objects** — Workflows, screens, fields, automations, permissions, queues, SLAs.
- **Dependencies** — Workflow → scheme → project → issue type chain.
- **Risks** — Data loss, access loss, automation breakage, SLA reset, queue disruption.
- **Test plan** — Sandbox validation, test issue types, automation dry runs.
- **Rollback plan** — Reversal strategy per change type.
- **Communication note** — Stakeholder notification.
- **Validation criteria** — Post-deployment confirmation.

### 3. Runbook and Documentation Patterns

Templates for common admin documentation:

| Template | Purpose |
|---|---|
| Troubleshooting Runbook | Symptoms, causes, investigation steps, resolution, escalation |
| Admin Checklist | Pre-requisites, steps, verification, rollback, post-completion |
| Stakeholder Update | Summary, impact, current status, next steps, timeline |

### 4. Queue Optimization

- Identifying and resolving overlapping queue JQL.
- Reducing queue count without losing coverage.
- Queue naming conventions and ordering.
- Agent group assignment best practices.

### 5. Dashboard and Filter Design

| Audience | Purpose | Key Gadgets |
|---|---|---|
| Operations team | Daily queue management | Filter Results, Pie Chart (by status), Created vs. Resolved |
| Team leads | Workload and bottleneck visibility | Two Dimensional Filter, Workload Pie Chart, SLA Status |
| Leadership | Trends and SLA compliance | Created vs. Resolved trend, SLA Met/Breached, Resolution Time |

### 6. Permission and Security Patterns

- Project roles vs. groups: decision criteria.
- Issue security scheme patterns (internal-only, partner-visible, customer-visible).
- JSM customer portal visibility rules.
- Workflow transitions vs. permission schemes for access control.

## Guiding Principles

1. **Safe and reversible first** — Recommend reversible changes before destructive ones.
2. **Audit before changing** — Understand the current state fully before modifying.
3. **Document impact and dependencies** — Map all affected objects before acting.
4. **Validate in test first** — Never skip sandbox validation.
5. **Communicate before and after** — Stakeholders need to know what's changing.
6. **Minimize disruption** — Prefer phased rollouts over big-bang changes.

## Connected Skills

- [JQL Writing](./writing-jql) — JQL is central to queue definitions, dashboard filters, and audit queries.
- [Troubleshooting Jira](./troubleshooting-jira) — Investigation findings feed into configuration improvement plans.
