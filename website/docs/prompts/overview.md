---
sidebar_position: 1
title: Prompts Overview
---

# Prompts Overview

Copilot Collections includes **14 public prompts** — slash commands that trigger specific workflow actions across the full product lifecycle. Prompts are stored in `.github/prompts/` and become available as `/command` shortcuts in VS Code chat.

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
| [/tsh-analyze-materials](./public/analyze-materials) | Business Analyst | Process workshop materials into Jira-ready epics and stories |

### 🛠 Development Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-implement](./public/implement) | Engineering Manager | Orchestrate the full cycle: research → plan → implementation |

### ✅ Quality Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-review](./public/review) | Code Reviewer | Review implementation against plan and standards |
| [/tsh-review-ui](./public/review-ui) | UI Reviewer | Single-pass Figma vs implementation comparison |
| [/tsh-review-codebase](./public/review-codebase) | Architect | Comprehensive code quality analysis |
| [/tsh-plan-testing](./public/plan-testing) | QA Engineer | Generate structured test plan with edge-case detection |
| [/tsh-report-bug](./public/report-bug) | QA Engineer | Create professional bug report with severity classification |

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

## Delegation via /tsh-implement

When you run [`/tsh-implement`](./public/implement), the Engineering Manager automatically handles the full development cycle. It first gathers context and creates an implementation plan (if needed), then delegates tasks to specialized agents. You don’t need to invoke individual agents — the orchestration is handled for you.

| Phase | Delegated To |
|---|---|
| Research (context gathering) | Context Engineer (via [internal research prompt](./internal/research)) |
| Planning (architecture) | Architect (via [internal plan prompt](./internal/plan)) |
| Backend / general code | Software Engineer |
| Frontend with Figma | Software Engineer (via [internal UI prompt](./internal/implement-ui)) |
| E2E tests | E2E Engineer |
| LLM application prompts | Prompt Engineer (via [internal engineer-prompt](./internal/engineer-prompt)) |
| Kubernetes, Terraform, CI/CD, observability | DevOps Engineer |
| UI verification | UI Reviewer |

## Input Format

All prompts accept either:

- A **Jira ticket ID**: `/tsh-implement PROJ-123`
- A **task description**: `/tsh-implement Add pagination to the user list API`

The agent adapts its behavior based on the input type — pulling context from Jira/Confluence for ticket IDs, or working from the description and codebase for free-form text.
