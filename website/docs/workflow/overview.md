---
sidebar_position: 1
title: Workflow Overview
---

# Workflow Overview

Copilot Collections is an AI product engineering framework that covers the **full product lifecycle** through a structured workflow:

> **Ideate → Implement → Review**

The Implement phase internally handles research and planning automatically. Each phase is executed by a specialized agent and produces documented artifacts. This ensures consistent, high-quality outputs across teams — from workshop materials all the way to production-ready, reviewed code.

:::tip The Relay Race Metaphor
Think of this workflow as a **relay race**. Each phase produces a deliverable — the "baton" — that is reviewed by the human and then passed to the next phase. Workshop materials feed the backlog, the Engineering Manager orchestrates research, planning, and implementation as a single flow, and the implementation feeds the review. Nothing is lost between steps, and every handoff is a documented artifact.
:::

## The Phases

### 1. Ideate

- **Agent:** Business Analyst
- **Commands:** `/tsh-explore-materials <workshop materials>` or `/tsh-analyze-materials <workshop materials>`
- Can start with exploration-only business/context synthesis before backlog extraction.
- Processes workshop materials through intent brief, extraction, quality review, Jira formatting, and verified Jira sync.
- Uses Gate 0, Gate 1, Gate 1.5, and Gate 2 as mandatory human review points.
- **Produces:** Exploration summaries, intent briefs, Jira-ready epics and stories, and refreshed backlog continuity artifacts.

### 2. Implement

- **Agent:** Engineering Manager (orchestrates specialized agents)
- **Command:** `/tsh-implement <JIRA_ID or description>`
- Automatically handles the full development cycle:
  1. **Research** — Delegates to Context Engineer to gather context from Jira, Figma, and codebase. You review the research document; this review is a quality checkpoint, not a separate authorization gate.
  2. **Plan** — Delegates to Architect to create a structured implementation plan, validated by the Architect Reviewer. You review the plan; the only step that authorizes implementation is the Human approval gate below.
  3. **Implement** — Delegates to the owning specialist per task: Plan Implementor by default for actionable, low-risk plan seams, Software Engineer for complex non-UI work, UI Engineer for Figma/UI, E2E Engineer for end-to-end tests, DevOps Engineer for infrastructure/CI/CD/observability, Prompt Engineer for LLM prompts, or Technical Writer for repository documentation.
- Tracks progress, runs quality checks after each task, and auto-triggers code review.
- **Produces:** Research document, implementation plan, and concrete code modifications.

The command accepts a task description, Jira ID, standalone `*.research.md`, or `*.plan.md`. Missing research or plan companions trigger preparation and never authorize no-plan implementation. The persisted current-revision `## Human Approval` record authorizes the first file-changing delegation, normally set at the Architect's plan-authoring gate or through the Engineering Manager's recovery gate when no valid record exists, regardless of which gate recorded it; intermediate research and plan reviews inform you but are not separate authorization gates on their own. Full Flow requires Human approval of the exact current plan revision before the first file-changing delegation. `tsh-plan-reviewer` `APPROVED` is Reviewer approval only and is not permission to implement. Before execution, the Architect's own plan-authoring gate (`Approve plan` / `I have comments`) runs immediately after it accepts a Reviewer `APPROVED` verdict and may record the Human Approval that the Manager later reuses; when recovery is needed, the Manager's gate uses `Approve current plan` / `Request changes` / `Stop` to establish that record.

Before any file change, the execution owner validates the Human Approval record from the referenced plan on disk. If validation fails, the owner fails closed, names the exact failed field, condition, or file, and uses `vscode/askQuestions` on every entry path to offer guided recovery: point to the correct plan path, obtain Human approval for an existing plan, start plan preparation, or, for a delegated subagent, hand back to `tsh-engineering-manager` as one offered choice. The user's answer selects a next step but is never itself Human approval.

When the Architect records plan-authoring Human approval, the authoring discussion ends and delivery begins in a new discussion. That discussion reuses the unchanged persisted approval without asking for approval twice.

### 3. Review

- **Agent:** Code Reviewer
- **Command:** `/tsh-review <JIRA_ID or description>`
- Performs a structured code review against acceptance criteria, security, reliability, and maintainability.
- **Produces:** Structured review with clear pass/blockers/suggestions.

## Platform Boundaries

`/tsh-implement` remains the canonical full-delivery implementation entry point. For a single Figma-backed React Native or Expo view in a known app, [`/tsh-implement-figma-rn`](../prompts/public/implement-figma-rn) is a direct fast path to the same UI Engineer; it skips full planning, orchestration, and web browser verification without introducing a mobile worker.

- Web/Figma UI uses the pinned browser URL and the web capture contract. Playwright artifacts such as `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml` verify the browser implementation only.
- Rendered React Native UI follows the existing UI Engineer route but does not enter browser/Figma verification. Native simulator or device behavior, accessibility, and end-to-end evidence are owned by the target project. Without an explicit target-project evidence contract, native verification remains a prerequisite or limitation.
- Playwright E2E is for web flows only. Native E2E is outside this collection's promise and remains target-project-owned.

## Workflow Diagram

import SdlcDiagram from '@site/src/components/SdlcDiagram';

<SdlcDiagram />

## Human Review at Every Step

:::warning Important
Each step requires your review and verification. Open the generated documents, go through them carefully, and give feedback when something needs to change. AI assistance does not replace human judgment. Reviewing research and draft plans keeps quality high, while the persisted current-revision Human Approval record — normally recorded at the Architect's plan-authoring gate or, when needed, through the Engineering Manager's recovery gate — authorizes or halts execution regardless of which gate recorded it; treat other reviews as checkpoints, not confirmation-to-continue rituals, and reserve your input for real ambiguity or blockers rather than a generic "continue?" prompt.
:::

## Workflow Variants

The full lifecycle has specialized variants for different task types:

- **[Workshop Analysis Flow](./workshop-flow)** — Explore workshop context with `/tsh-explore-materials` or convert materials into Jira-ready epics and stories with `/tsh-analyze-materials`.
- **[Standard Flow](./standard-flow)** — Backend/fullstack tasks using `/tsh-implement` → `/tsh-review` (research and planning happen internally).
- **[Frontend Flow](./frontend-flow)** — UI tasks with Figma verification using `/tsh-implement` (which internally uses `/tsh-implement-ui`) and `/tsh-review-ui`.
- **[E2E Testing Flow](./e2e-flow)** — End-to-end test creation delegated by the Engineering Manager to the E2E Engineer via `/tsh-implement`.
