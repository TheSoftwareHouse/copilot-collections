---
sidebar_position: 1
title: Workflow Overview
---

# Workflow Overview

Copilot Collections is an AI product engineering framework that covers the **full product lifecycle** through a structured 5-phase workflow:

> **Ideate → Research → Plan → Implement → Review**

Each phase is executed by a specialized agent and produces a documented artifact that feeds the next phase. This ensures consistent, high-quality outputs across teams — from workshop materials all the way to production-ready, reviewed code.

:::tip The Relay Race Metaphor
Think of this workflow as a **relay race**. Each phase produces a deliverable — the "baton" — that is reviewed by the human and then passed to the next phase. Workshop materials feed the backlog, the research document feeds the plan, the plan feeds the implementation, and the implementation feeds the review. Nothing is lost between steps, and every handoff is a documented artifact.
:::

## The 5 Phases

### 1. Ideate

- **Agent:** Business Analyst
- **Command:** `/tsh-analyze-materials <workshop materials>`
- Processes raw workshop materials (transcripts, Figma designs, documents) into structured epics and stories.
- Runs 10-pass quality review with three mandatory human review gates.
- **Produces:** Jira-ready epics and stories with acceptance criteria, dependencies, and priorities.

### 2. Research

- **Agent:** Context Engineer
- **Command:** `/tsh-research <JIRA_ID or description>`
- Builds context around a task using Jira, Figma, and other integrated tools.
- Identifies missing information, risks, and open questions.
- **Produces:** Research document (`.research.md`) with task summary, assumptions, open questions, and suggested next steps.

### 3. Plan

- **Agent:** Architect
- **Command:** `/tsh-plan <JIRA_ID or description>`
- Translates the task into a structured implementation plan.
- Breaks work into phases and executable steps.
- **Produces:** Implementation plan (`.plan.md`) with checklist-style phases, acceptance criteria, and technical constraints.

### 4. Implement

- **Agent:** Engineering Manager (orchestrates specialized agents)
- **Command:** `/tsh-implement <JIRA_ID or description>`
- Automatically handles the full development cycle:
  1. **Research** — Delegates to Context Engineer to gather context from Jira, Figma, and codebase. Asks for user confirmation before proceeding.
  2. **Plan** — Delegates to Architect to create a structured implementation plan. Asks for user confirmation before proceeding.
  3. **Implement** — Delegates to Software Engineer, Prompt Engineer, DevOps Engineer, or E2E Engineer based on task type.
- Tracks progress, runs quality checks after each task, and auto-triggers code review.
- **Produces:** Concrete code modifications scoped to the task, applied by delegated agents.

### 5. Review

- **Agent:** Code Reviewer
- **Command:** `/tsh-review <JIRA_ID or description>`
- Performs a structured code review against acceptance criteria, security, reliability, and maintainability.
- **Produces:** Structured review with clear pass/blockers/suggestions.

## Workflow Diagram

import SdlcDiagram from '@site/src/components/SdlcDiagram';

<SdlcDiagram />

## Human Review at Every Step

:::warning Important
Each step requires your review and verification. Open the generated documents, go through them carefully, and iterate as many times as needed until the output looks correct. AI assistance does not replace human judgment — treat each output as a draft that needs your approval before proceeding.
:::

## Workflow Variants

The full lifecycle has specialized variants for different task types:

- **[Workshop Analysis Flow](./workshop-flow)** — Convert discovery workshop materials into Jira-ready epics and stories using `/tsh-analyze-materials`.
- **[Standard Flow](./standard-flow)** — Backend/fullstack tasks using `/tsh-research` → `/tsh-plan` → `/tsh-implement` → `/tsh-review`.
- **[Frontend Flow](./frontend-flow)** — UI tasks with Figma verification using `/tsh-implement` (which internally uses `/tsh-implement-ui`) and `/tsh-review-ui`.
- **[E2E Testing Flow](./e2e-flow)** — End-to-end test creation delegated by the Engineering Manager to the E2E Engineer via `/tsh-implement`.
