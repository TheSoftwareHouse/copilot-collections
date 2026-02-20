---
sidebar_position: 1
title: Workflow Overview
---

# Workflow Overview

Copilot Collections follows a structured 4-phase delivery workflow for every task:

> **Research → Plan → Implement → Review**

Each phase is executed by a specialized agent and produces a documented artifact that feeds the next phase. This ensures consistent, high-quality outputs across teams.

:::tip The Relay Race Metaphor
Think of this workflow as a **relay race**. Each phase produces a deliverable — the "baton" — that is reviewed by the human and then passed to the next phase. The research document feeds the plan, the plan feeds the implementation, and the implementation feeds the review. Nothing is lost between steps, and every handoff is a documented artifact.
:::

## The 4 Phases

### 1. Research

- **Agent:** Business Analyst
- **Command:** `/research <JIRA_ID or description>`
- Builds context around a task using Jira, Figma, and other integrated tools.
- Identifies missing information, risks, and open questions.
- **Produces:** Research document (`.research.md`) with task summary, assumptions, open questions, and suggested next steps.

### 2. Plan

- **Agent:** Architect
- **Command:** `/plan <JIRA_ID or description>`
- Translates the task into a structured implementation plan.
- Breaks work into phases and executable steps.
- **Produces:** Implementation plan (`.plan.md`) with checklist-style phases, acceptance criteria, and technical constraints.

### 3. Implement

- **Agent:** Software Engineer
- **Command:** `/implement <JIRA_ID or description>`
- Executes against the agreed plan.
- Writes or modifies code with a focus on safety and clarity.
- **Produces:** Concrete code modifications scoped to the task, respecting existing architecture.

### 4. Review

- **Agent:** Code Reviewer
- **Command:** `/review <JIRA_ID or description>`
- Performs a structured code review against acceptance criteria, security, reliability, and maintainability.
- **Produces:** Structured review with clear pass/blockers/suggestions.

## Workflow Diagram

```
┌──────────┐     ┌──────────┐     ┌──────────────┐     ┌──────────┐
│ /research│────▶│  /plan   │────▶│ /implement   │────▶│  /review │
│  (BA)    │     │ (Arch)   │     │ (SE)         │     │  (CR)    │
└──────────┘     └──────────┘     └──────────────┘     └──────────┘
                                         │
                                         ▼
                                  ┌──────────────┐
                                  │ /implement-ui│ (for frontend)
                                  │    ┌─loop──┐ │
                                  │    │/review-│ │
                                  │    │  ui   │ │
                                  │    └───────┘ │
                                  └──────────────┘
```

## Human Review at Every Step

:::warning Important
Each step requires your review and verification. Open the generated documents, go through them carefully, and iterate as many times as needed until the output looks correct. AI assistance does not replace human judgment — treat each output as a draft that needs your approval before proceeding.
:::

## Workflow Variants

The standard workflow has specialized variants for different task types:

- **[Standard Flow](./standard-flow)** — Backend/fullstack tasks using `/research` → `/plan` → `/implement` → `/review`.
- **[Frontend Flow](./frontend-flow)** — UI tasks with Figma verification using `/implement-ui` and `/review-ui`.
- **[E2E Testing Flow](./e2e-flow)** — End-to-end test creation using `/e2e`.
