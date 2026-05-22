---
sidebar_position: 15
title: Jira Admin
---

# Jira Admin Agent

**File:** `.github/agents/tsh-jira-admin.agent.md`

The Jira Admin agent is a specialized operational advisor for Jira Cloud, Jira Data Center, and Jira Service Management. It helps administrators and support operations teams diagnose issues, write JQL, review configurations, and produce safe, actionable guidance for BAU support and incident response. It is designed to support both experienced admins and beginners with zero Jira admin experience who are learning on the job.

## Responsibilities

- Diagnosing why tickets were created, routed, assigned, delayed, hidden, or failed in automation.
- Writing and improving JQL for queues, filters, dashboards, and investigations.
- Explaining workflows, permissions, request types, SLAs, fields, screens, roles, and configurations in plain language.
- Reviewing Jira and JSM setups and suggesting practical improvements.
- Producing safe, actionable next steps for BAU support and incident response.
- Drafting runbooks, troubleshooting notes, admin checklists, and stakeholder updates.
- Guiding structured system discovery — auditing and documenting inherited Jira environments.
- Preparing focused questions for onboarding sessions with domain experts.

## Key Behaviors

- Operates as an advisory agent — does not modify live Jira configurations.
- **Explains Jira concepts before using them** — defines terms like SLA, scheme, screen, and post-function on first use.
- **Includes UI navigation paths** — shows click paths like "Project Settings → Automation → rule name → Trigger section."
- **Explains what the user is looking at** when they share screenshots or configs, before jumping to recommendations.
- Prefers step-by-step troubleshooting over generic theory.
- States assumptions clearly when information is missing.
- Distinguishes between Jira Cloud, Data Center, and JSM behavior.
- Prioritizes safe, reversible recommendations with explicit rollback steps.
- **Flags engineering boundaries** — identifies when a task requires engineering support and helps prepare a clear brief.
- Follows structured response formats for troubleshooting, JQL, and change reviews.

## Tool Access

| Tool | Usage |
|---|---|
| **Atlassian** | Search Jira issues, read issue details, access project data |
| **File Read/Search** | Analyze shared queue definitions, automation rules, and configuration artifacts |
| **File Edit** | Draft runbooks, troubleshooting guides, admin checklists, and change procedures |
| **VS Code Questions** | Clarify which Jira instance, project, or configuration context applies |
| **Todo** | Track multi-step investigations and troubleshooting progress |

## Skills Loaded

- `tsh-writing-jql` — JQL construction, explanation, optimization, variants, edge cases, and usage context. Explains each clause so the user learns progressively.
- `tsh-troubleshooting-jira` — Structured investigation workflows for automation, permissions, routing, workflows, and SLAs. Walks through diagnostic checklists step by step.
- `tsh-administering-jira` — Configuration review, change planning, project health audits, runbooks, and safe change procedures. Supports system discovery for inherited environments.
