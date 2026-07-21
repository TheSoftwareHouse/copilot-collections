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
  1. **Research** — Delegates to Context Engineer to gather context from Jira, Figma, and codebase. Asks for user confirmation before proceeding.
  2. **Plan** — Delegates to Architect to create a structured implementation plan. Asks for user confirmation before proceeding.
  3. **Implement** — Delegates to the existing implementation owner based on task type, including the UI Engineer for rendered UI.
- Tracks progress, runs quality checks after each task, and auto-triggers code review.
- **Produces:** Research document, implementation plan, and concrete code modifications.

### 3. Review

- **Agent:** Code Reviewer
- **Command:** `/tsh-review <JIRA_ID or description>`
- Performs a structured code review against acceptance criteria, security, reliability, and maintainability.
- **Produces:** Structured review with clear pass/blockers/suggestions.

## Platform Boundaries

`/tsh-implement` remains the canonical public implementation entry point. Platform classification and routing stay in the canonical orchestrator; this documentation does not add a second trigger or a mobile worker.

- Web/Figma UI uses the pinned browser URL and the web capture contract. Playwright artifacts such as `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml` verify the browser implementation only.
- Rendered React Native UI follows the existing UI Engineer route but does not enter browser/Figma verification. Native simulator or device behavior, accessibility, and end-to-end evidence are owned by the target project. Without an explicit target-project evidence contract, native verification remains a prerequisite or limitation.
- Playwright E2E is for web flows only. Native E2E is outside this collection's promise and remains target-project-owned.

## Workflow Diagram

import SdlcDiagram from '@site/src/components/SdlcDiagram';

<SdlcDiagram />

## Human Review at Every Step

:::warning Important
Each step requires your review and verification. Open the generated documents, go through them carefully, and iterate as many times as needed until the output looks correct. AI assistance does not replace human judgment — treat each output as a draft that needs your approval before proceeding.
:::

## Workflow Variants

The full lifecycle has specialized variants for different task types:

- **[Workshop Analysis Flow](./workshop-flow)** — Explore workshop context with `/tsh-explore-materials` or convert materials into Jira-ready epics and stories with `/tsh-analyze-materials`.
- **[Standard Flow](./standard-flow)** — Backend/fullstack tasks using `/tsh-implement` → `/tsh-review` (research and planning happen internally).
- **[Frontend Flow](./frontend-flow)** — UI tasks with Figma verification using `/tsh-implement` (which internally uses `/tsh-implement-ui`) and `/tsh-review-ui`.
- **[E2E Testing Flow](./e2e-flow)** — End-to-end test creation delegated by the Engineering Manager to the E2E Engineer via `/tsh-implement`.
