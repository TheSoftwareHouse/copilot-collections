---
sidebar_position: 16
title: BA Transcript Worker (internal)
---

# BA Transcript Worker Agent

**File:** `.github/agents/tsh-ba-transcript-worker.agent.md`
**Type:** Internal worker — not user-invocable

Internal worker that cleans and structures raw workshop transcripts for the BA orchestrator. It turns noisy discussion material into a disciplined transcript summary that feeds later analysis and extraction phases.

## Responsibilities

- Clean transcripts and group content into clear topic sections.
- Capture decisions, action items, and open questions.
- Preserve business language over technical detail and flag notable ambiguities.

## Outputs

A structured transcript cleanup with topic sections, decisions, action items, open questions, and ambiguities that should flow into later BA analysis.

## Boundaries

- Never writes files.
- Never asks the user questions directly.
- Never creates backlog items or Jira tasks.
- Never presents results directly to the user.

## Tool Access

| Tool | Usage |
|---|---|
| **read** | Read local transcript notes or text-based workshop inputs |
| **search** | Find relevant transcript fragments or repeated references |
| **pdf-reader/*** | Read PDFs that contain transcript or meeting content |

## Skills Loaded

- `tsh-transcript-processing` — governing workflow for transcript cleanup, topic structuring, and decision extraction.

## Collaboration

Returns cleaned transcript output in-memory to `tsh-business-analyst`, structured for downstream analysis and extraction.

## Invocation

This agent is not directly invocable by users. It is delegated to by the [Business Analyst](./business-analyst) orchestrator (`tsh-business-analyst`), which receives its output in-memory.
