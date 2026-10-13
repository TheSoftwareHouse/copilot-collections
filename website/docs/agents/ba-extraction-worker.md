---
sidebar_position: 18
title: BA Extraction Worker (internal)
---

# BA Extraction Worker Agent

**File:** `.github/agents/tsh-ba-extraction-worker.agent.md`
**Type:** Internal worker — not user-invocable

Internal worker that drafts intent briefs and extracts epics and stories from approved context for the BA orchestrator. It turns business intent into structured backlog content while preserving source traceability and stakeholder-friendly wording.

## Responsibilities

- Draft intent briefs.
- Identify epics, extract stories, and map dependencies.
- Write GIVEN/WHEN/THEN acceptance criteria and keep clear scope boundaries and business outcomes.

## Outputs

An intent brief and/or extracted backlog content with explicit source references, epic boundaries, story text, acceptance criteria, and priority notes where available.

## Boundaries

- Never writes files.
- Never asks the user questions directly.
- Never creates Jira tasks by itself.
- Never drops source traceability.

## Tool Access

| Tool | Usage |
|---|---|
| **read** | Read cleaned transcripts, workshop summaries, and supporting materials |
| **search** | Locate supporting evidence or repeated references |
| **sequential-thinking/*** | Reason through ambiguous scope boundaries, dependency chains, or epic/story splits |

## Skills Loaded

- `tsh-task-extracting` — intent brief drafting, epic and story extraction, dependency mapping, and source traceability.

## Collaboration

Returns intent brief and/or extracted task content in-memory to `tsh-business-analyst`, so the orchestrator can run its Gate 0 and Gate 1 workflows.

## Invocation

This agent is not directly invocable by users. It is delegated to by the [Business Analyst](./business-analyst) orchestrator (`tsh-business-analyst`), which receives its output in-memory.
