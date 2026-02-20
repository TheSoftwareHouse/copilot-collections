---
slug: /
sidebar_position: 1
title: Introduction
---

# Introduction

**Copilot Collections** is an opinionated GitHub Copilot setup for delivery teams — with shared workflows, agents, prompts, skills, and MCP integrations.

Focus on building features — let Copilot handle the glue. Built by [The Software House](https://tsh.io).

## What It Provides

| Capability | Description |
|---|---|
| 🧠 **Shared Workflows** | A 4-phase delivery flow: Research → Plan → Implement → Review |
| 🧑‍💻 **Specialized Agents** | Architect, Business Analyst, Software Engineer, UI Reviewer, Code Reviewer, E2E Engineer |
| 💬 **Task Prompts** | `/research`, `/plan`, `/implement`, `/implement-ui`, `/review`, `/review-ui`, `/e2e`, `/code-quality-check` |
| 🧰 **Reusable Skills** | Task Analysis, Architecture Design, Codebase Analysis, Code Review, Implementation Gap Analysis, E2E Testing, Technical Context Discovery, Frontend Implementation, UI Verification, SQL & Database Engineering |
| 🔌 **MCP Integrations** | Atlassian, Figma Dev Mode, Context7, Playwright, Sequential Thinking |
| 🧩 **VS Code Setup** | Plug-and-play global configuration via VS Code User Settings |

## Our Philosophy

**Focus on building features. Let Copilot handle the glue.**

The framework acts as a **virtual delivery team** that handles the grunt work that often slows engineers down or introduces risk:

- **Consolidates scattered requirements** — pulls details from Jira, Confluence, Figma, and the codebase into one place.
- **Extracts design specifics** — reads Figma designs via Dev Mode to capture UI requirements, states, and flows.
- **Maps what exists vs. what must be built** — analyzes the codebase to identify reuse opportunities and prevent duplicate work.
- **Turns requirements into actionable plans** — produces phased implementation plans with clear definitions of done.
- **Enforces quality gates** — runs structured reviews against acceptance criteria, security, and maintainability standards.

Think of this as a **relay race**: Copilot produces a deliverable after each phase, which is reviewed by the human, and then used for the following phase. Nothing is lost between steps — every handoff is an artifact.

## How It Works

Every task follows the same structured workflow:

1. **Research** — Gather context from Jira, Figma, and the codebase.
2. **Plan** — Create a step-by-step implementation plan.
3. **Implement** — Execute the plan with scoped, reviewable changes.
4. **Review** — Verify against acceptance criteria, security, and quality standards.

Each phase produces a documented artifact that feeds the next, ensuring nothing is lost between steps.

## Next Steps

- [Prerequisites](./getting-started/prerequisites) — Check license and VS Code version requirements.
- [Installation](./getting-started/installation) — Clone and configure VS Code.
- [MCP Setup](./getting-started/mcp-setup) — Connect Jira, Figma, and other tools.
- [Workflow Overview](./workflow/overview) — Understand the 4-phase delivery flow.
