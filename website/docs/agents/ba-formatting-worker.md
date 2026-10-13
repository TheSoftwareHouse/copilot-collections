---
sidebar_position: 20
title: BA Formatting Worker (internal)
---

# BA Formatting Worker Agent

**File:** `.github/agents/tsh-ba-formatting-worker.agent.md`
**Type:** Internal worker — not user-invocable

Internal worker that prepares Jira-ready task formatting, supports post-push verification comparisons, and helps compute archive or baseline-refresh content for the BA orchestrator. The final mutation flow stays with the orchestrator.

## Responsibilities

- Format extracted tasks as Jira-ready drafts.
- Compare read-back verification payloads supplied by the orchestrator against the pushed tasks.
- Compute archive or baseline-refresh content.

## Outputs

Jira-ready formatting, read-back verification notes, and archive or baseline-refresh content with clear task mapping and any discrepancies called out.

## Boundaries

- Never writes files; output is in-memory only.
- Never asks the user questions directly.
- Never performs Jira create/update side effects on its own.
- Never calls Jira directly; the orchestrator supplies any Jira context or verification data.

## Tool Access

| Tool | Usage |
|---|---|
| **read** | Read extracted tasks, Jira-ready drafts, or verification context |
| **search** | Locate related task fragments or verify consistency |

## Skills Loaded

- `tsh-jira-task-formatting` — Jira-ready formatting, verification support, and archive or baseline refresh content.

## Collaboration

Returns formatting output, verification summaries, and baseline-refresh content in-memory to `tsh-business-analyst`. The orchestrator owns Gate 2 approval and all final Jira mutations.

## Invocation

This agent is not directly invocable by users. It is delegated to by the [Business Analyst](./business-analyst) orchestrator (`tsh-business-analyst`), which receives its output in-memory.
