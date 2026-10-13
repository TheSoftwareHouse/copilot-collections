---
sidebar_position: 19
title: BA Quality Worker (internal)
---

# BA Quality Worker Agent

**File:** `.github/agents/tsh-ba-quality-worker.agent.md`
**Type:** Internal worker — not user-invocable

Internal worker that runs Lite or Full quality-review passes over approved extracted tasks and returns structured findings for the BA orchestrator. It identifies gaps, overlaps, missing acceptance criteria, and refinement opportunities.

## Responsibilities

- Run Lite and Full review passes over extracted tasks.
- Find duplicates, overlaps, gaps, and missing acceptance criteria.
- Respect the protected status policy and note protected-task exclusions explicitly.

## Outputs

Structured review findings grouped by pass or epic, with suggestion IDs, confidence, finding, proposed change, and any protected-task exclusions. The orchestrator accepts, rejects, merges, and writes them.

## Boundaries

- Never writes files.
- Never asks the user questions directly.
- Never creates or updates Jira issues.
- Never calls Jira directly; uses only orchestrator-supplied Jira or board context.

## Tool Access

| Tool | Usage |
|---|---|
| **read** | Read extracted task content and review context |
| **search** | Find related task references, duplicates, or repeated patterns |

## Skills Loaded

- `tsh-task-quality-reviewing` — Lite and Full review passes, structured findings, confidence scoring, and improvement suggestions.

## Collaboration

Returns quality-review findings in-memory to `tsh-business-analyst`, which manages the Gate 1.5 decisions and applies accepted suggestions.

## Invocation

This agent is not directly invocable by users. It is delegated to by the [Business Analyst](./business-analyst) orchestrator (`tsh-business-analyst`), which receives its output in-memory.
