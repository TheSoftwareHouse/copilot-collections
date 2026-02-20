---
sidebar_position: 1
title: Prompts Overview
---

# Prompts Overview

Prompts are slash commands that trigger specific workflow actions. They are stored in `.github/prompts/` as `.prompt.md` files and become available as `/command` shortcuts in VS Code chat.

## How Prompts Work

Each prompt file defines:

- **Agent binding** — Which agent executes the command.
- **Model** — The AI model to use (e.g., Claude Opus 4.6).
- **Description** — Shown in VS Code's command palette.
- **Instructions** — Detailed workflow steps, required skills, and output format.

When you type `/research`, `/plan`, etc. in the VS Code chat, the corresponding prompt file is loaded and executed by the bound agent.

## Available Prompts

### Core Workflow

| Command | Agent | Description |
|---|---|---|
| [/research](./research) | Business Analyst | Gather context and requirements for a task |
| [/plan](./plan) | Architect | Create a structured implementation plan |
| [/implement](./implement) | Software Engineer | Execute the implementation plan |
| [/review](./review) | Code Reviewer | Review implementation against plan and standards |

### Frontend Workflow

| Command | Agent | Description |
|---|---|---|
| [/implement-ui](./implement-ui) | Software Engineer | Implement UI with iterative Figma verification |
| [/review-ui](./review-ui) | UI Reviewer | Single-pass Figma vs implementation comparison |

### Testing & Quality

| Command | Agent | Description |
|---|---|---|
| [/e2e](./e2e) | E2E Engineer | Create, maintain, and debug Playwright E2E tests |
| [/code-quality-check](./code-quality-check) | Architect | Comprehensive code quality analysis |

## Input Format

All prompts accept either:

- A **Jira ticket ID**: `/research PROJ-123`
- A **task description**: `/research Add pagination to the user list API`

The agent adapts its behavior based on the input type — pulling context from Jira/Confluence for ticket IDs, or working from the description and codebase for free-form text.
