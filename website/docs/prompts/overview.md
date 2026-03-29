---
sidebar_position: 1
title: Prompts Overview
---

# Prompts Overview

Copilot Collections includes **12 public prompts** and **4 internal prompts** — slash commands that trigger specific workflow actions across the full product lifecycle. Prompts are stored in `.github/prompts/` and become available as `/command` shortcuts in VS Code chat.

## How Prompts Work

Each prompt file defines:

- **Agent binding** — Which agent executes the command.
- **Model** — The AI model to use (e.g., Claude Opus 4.6).
- **Description** — Shown in VS Code's command palette.
- **Instructions** — Detailed workflow steps, required skills, and output format.

When you type `/tsh-implement`, `/tsh-review`, etc. in the VS Code chat, the corresponding prompt file is loaded and executed by the bound agent.

## Public Prompts

These are the user-facing commands available in VS Code chat.

### 📋 Product Ideation Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-analyze-materials](./public/analyze-materials) | Business Analyst | Process workshop materials into epics and stories for Jira or Shortcut |

### 🛠 Development Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-implement](./public/implement) | Engineering Manager | Orchestrate full development cycle: research → plan → implement |

### ✅ Quality Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-review](./public/review) | Code Reviewer | Review implementation against plan and standards |
| [/tsh-review-ui](./public/review-ui) | UI Reviewer | Single-pass Figma vs implementation comparison |
| [/tsh-review-codebase](./public/review-codebase) | Architect | Comprehensive code quality analysis |

### ⚙️ Copilot Customization Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-create-custom-agent](./public/create-custom-agent) | Copilot Orchestrator | Create a new custom agent |
| [/tsh-create-custom-skill](./public/create-custom-skill) | Copilot Orchestrator | Create a new custom skill |
| [/tsh-create-custom-prompt](./public/create-custom-prompt) | Copilot Orchestrator | Create a new custom prompt |
| [/tsh-create-custom-instructions](./public/create-custom-instructions) | Copilot Orchestrator | Create custom instruction files |

### 🏗 Infrastructure & Cost Analysis Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-audit-infrastructure](./public/audit-infrastructure) | DevOps Engineer | Audit infrastructure for security gaps, cost waste, and best practices |
| [/tsh-analyze-aws-costs](./public/analyze-aws-costs) | DevOps Engineer | AWS cost optimization and tagging compliance audit |
| [/tsh-analyze-gcp-costs](./public/analyze-gcp-costs) | DevOps Engineer | GCP cost optimization and labeling compliance audit |

## Internal Prompts

These prompts are not invoked directly by users. They are triggered automatically by `/tsh-implement` when the Engineering Manager delegates to specialized agents:

| Prompt | Agent | Description |
|---|---|---|
| [/tsh-research](./internal/research) | Context Engineer | Gather context and requirements for a task |
| [/tsh-plan](./internal/plan) | Architect | Create a structured implementation plan |
| [/tsh-implement-ui](./internal/implement-ui) | Software Engineer + UI Reviewer | Implement UI components with Figma verification loop |
| [/tsh-engineer-prompt](./internal/engineer-prompt) | Prompt Engineer | Design and optimize LLM application prompts |

## Delegation via /tsh-implement

When you run [`/tsh-implement`](./public/implement), the Engineering Manager automatically delegates tasks to specialized agents based on the implementation plan. You don't need to invoke individual agents — the orchestration is handled for you.

| Task Type | Delegated To |
|---|---|
| Backend / general code | Software Engineer |
| Frontend with Figma | Software Engineer (via [internal UI prompt](./internal/implement-ui)) |
| E2E tests | E2E Engineer |
| LLM application prompts | Prompt Engineer (via [internal engineer-prompt](./internal/engineer-prompt)) |
| Kubernetes, Terraform, CI/CD, observability | DevOps Engineer |
| UI verification | UI Reviewer |

## Input Format

All prompts accept either:

- A **task ID**: `/tsh-implement PROJ-123` (Jira) or `/tsh-implement sc-12345` (Shortcut)
- A **task description**: `/tsh-implement Add pagination to the user list API`

The agent adapts its behavior based on the input type — pulling context from Jira/Confluence for ticket IDs, or working from the description and codebase for free-form text.
