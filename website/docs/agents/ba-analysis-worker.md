---
sidebar_position: 17
title: BA Analysis Worker (internal)
---

# BA Analysis Worker Agent

**File:** `.github/agents/tsh-ba-analysis-worker.agent.md`
**Type:** Internal worker — not user-invocable

Internal worker that synthesizes workshop material, existing backlog context, and open questions for the BA orchestrator. It connects transcripts, designs, PDFs, and read-only backlog context into a structured business summary that supports later extraction.

## Responsibilities

- Identify likely epic candidates.
- Analyze overlap with existing baseline or Jira context supplied by the orchestrator.
- Surface unresolved business questions, contradictions, and gaps.

## Outputs

A structured summary covering business context, likely epic candidates, backlog or baseline overlap, open questions, and contradictions or gaps that need orchestration follow-up.

## Boundaries

- Never writes files.
- Never asks the user questions directly.
- Never creates final epics or stories for Jira.
- Never calls Jira directly; uses only orchestrator-supplied Jira context.
- Never presents results directly to the user.

## Tool Access

| Tool | Usage |
|---|---|
| **read** | Read workshop notes, baseline context, or supporting material |
| **search** | Look for related context, repeated terms, or baseline references |
| **figma/*** | Read design links or diagrams that affect business scope |
| **pdf-reader/*** | Extract business context from PDFs |

## Skills Loaded

- `tsh-task-analysing` — business/context synthesis, ambiguity resolution, and baseline overlap analysis.
- `tsh-codebase-analysing` — used when codebase context helps understand current capabilities or scope overlap.

## Collaboration

Returns structured analysis summaries in-memory to `tsh-business-analyst`, which merges them with transcript cleanup and extraction inputs.

## Invocation

This agent is not directly invocable by users. It is delegated to by the [Business Analyst](./business-analyst) orchestrator (`tsh-business-analyst`), which receives its output in-memory.
