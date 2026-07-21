---
sidebar_position: 1
title: Agents Overview
---

# Agents Overview

Copilot Collections provides **13 user-facing specialized agents** plus internal worker agents that together form an AI product engineering team covering the full delivery lifecycle — from product ideation through development, infrastructure, and quality assurance. Agents are stored in `.github/agents/` as `.agent.md` files. VS Code loads the user-facing agents automatically when the corresponding mode is selected.

## How Agents Work

Each agent has:

- **A defined role** — What the agent specializes in and what it should/shouldn't do.
- **Tool access** — Which MCP integrations and VS Code tools it can use.
- **Skill bindings** — Which skills it loads for domain-specific knowledge.
- **Handoffs** — Buttons to seamlessly transition between workflow phases.

## Agent Handoff Diagram

```
┌──────────────────────┐
│  Business Analyst     │
│  /tsh-analyze-materials│
└──────┬───────────────┘
       │ Start Implementation
       ▼
┌─────────────────────────┐
│   Engineering Manager    │  ← Orchestrates the full cycle
│   /tsh-implement         │
└──────┬──────────────────┘
       │ Delegates to specialized agents
       ├─────────────────┬─────────────────┬─────────────────┬─────────────────┬─────────────────┬─────────────────┬─────────────────┬─────────────────┬─────────────────┬─────────────────┐
       ▼                 ▼                 ▼                 ▼                 ▼                 ▼                 ▼                 ▼                 ▼                 ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  Context     │  │  Architect   │  │  Architect   │  │  UI          │  │  Software    │  │  Plan        │  │  DevOps      │  │  E2E         │  │  Prompt      │  │  UI Reviewer │
│  Engineer    │  │  (plan)      │  │  Reviewer    │  │  Engineer    │  │  Engineer    │  │  Implementor │  │  Engineer    │  │  Engineer    │  │  Engineer    │  │  /tsh-review-│
│  (research)  │  │              │  │ (plan review)│  │  (UI)        │  │  (non-UI)    │  │  (strict     │  │  (infra)     │  │  (tests)     │  │  (prompts)   │  │  ui          │
└──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘
       │
       ▼
┌──────────────┐
│ Code Reviewer │
│ /tsh-review   │
└──────────────┘
```

## Platform Boundaries

The existing agent graph and `/tsh-implement` entry point apply to both web and React Native work. Browser capture is a web/Figma contract only: `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml` are not evidence of native behavior.

For rendered React Native UI, the existing UI Engineer owns implementation and the target project owns native simulator or device, accessibility, and end-to-end evidence. If that project does not provide an explicit evidence contract, native verification remains an explicit prerequisite or limitation. The collection does not add a mobile worker or native automation promise. Playwright E2E remains web-only; native E2E is target-project-owned.

## Agent Summary

### 📋 Product Ideation Agents

| Agent | File | Role | Key Tools |
|---|---|---|---|
| [Business Analyst](./business-analyst) | `tsh-business-analyst.agent.md` | Orchestrates workshop analysis into Jira-ready epics and stories | Atlassian, Figma, PDF Reader, Sequential Thinking |

### 🛠 Development Agents

| Agent | File | Role | Key Tools |
|---|---|---|---|
| [Context Engineer](./context-engineer) | `tsh-context-engineer.agent.md` | Gathers requirements, builds context, identifies gaps | Atlassian, Figma, PDF Reader, Sequential Thinking |
| [Architect](./architect) | `tsh-architect.agent.md` | Designs solutions, creates implementation plans | Atlassian, Context7, Figma, PDF Reader, Sequential Thinking |
| [Engineering Manager](./engineering-manager) | `tsh-engineering-manager.agent.md` | Orchestrates implementation by delegating to specialized agents | Atlassian, Sequential Thinking |
| [UI Engineer](./ui-engineer) | `tsh-ui-engineer.agent.md` | Implements UI and frontend solutions | Context7, Figma, Playwright, Sequential Thinking |
| [Software Engineer](./software-engineer) | `tsh-software-engineer.agent.md` | Implements non-UI code against the plan | Context7, Sequential Thinking |
| [Prompt Engineer](./prompt-engineer) | `tsh-prompt-engineer.agent.md` | Designs, optimizes, and secures LLM application prompts | Context7, Sequential Thinking |

### 🏗 Infrastructure & DevOps Agents

| Agent | File | Role | Key Tools |
|---|---|---|---|
| [DevOps Engineer](./devops-engineer) | `tsh-devops-engineer.agent.md` | Infrastructure automation, CI/CD, cloud governance, cost optimization | Context7, Sequential Thinking, AWS API, AWS Docs, GCP Gcloud, GCP Observability, GCP Storage |

### ✅ Quality Agents

| Agent | File | Role | Key Tools |
|---|---|---|---|
| [Code Reviewer](./code-reviewer) | `tsh-code-reviewer.agent.md` | Reviews code quality, security, correctness | Atlassian, Context7, Figma, Sequential Thinking |
| [UI Reviewer](./ui-reviewer) | `tsh-ui-reviewer.agent.md` | Verifies UI matches Figma design | Figma, Playwright, Context7 |
| [E2E Engineer](./e2e-engineer) | `tsh-e2e-engineer.agent.md` | Creates and maintains Playwright E2E tests | Playwright, Context7, Figma, Sequential Thinking |

### ⚙️ Copilot Customization Agents

| Agent | File | Role | Key Tools |
|---|---|---|---|
| [Copilot Engineer](./copilot-engineer) | `tsh-copilot-engineer.agent.md` | Designs, creates, reviews Copilot customization artifacts | Context7, Sequential Thinking |
| [Copilot Orchestrator](./copilot-orchestrator) | `tsh-copilot-orchestrator.agent.md` | Coordinates complex multi-step Copilot customization tasks | Sequential Thinking |

### 🔧 Internal Worker Agents

These agents are not invoked directly by users. The Business Analyst internally delegates transcript, analysis, extraction, quality-review, and formatting phases to BA workers, the Copilot Orchestrator delegates to the customization workers below, and the Engineering Manager delegates implementation-specialist and documentation-only work to the workers below.

| Agent | File | Role |
|---|---|---|
| [Copilot Researcher](./copilot-researcher) | `tsh-copilot-researcher.agent.md` | Analyzes codebases and documentation, extracts patterns |
| [Copilot Artifact Creator](./copilot-artifact-creator) | `tsh-copilot-artifact-creator.agent.md` | Creates and modifies Copilot customization artifacts |
| [Copilot Artifact Reviewer](./copilot-artifact-reviewer) | `tsh-copilot-artifact-reviewer.agent.md` | Validates quality and consistency of artifacts |
| [Architect Reviewer](./plan-reviewer) | `tsh-plan-reviewer.agent.md` | Stress-tests implementation plans before implementation starts |
| [Plan Implementor](./plan-implementor) | `tsh-plan-implementor.agent.md` | Internal strict single-task implementor for one plan step at a time |
| [Technical Writer](./technical-writer) | `tsh-technical-writer.agent.md` | Authors and updates README, CHANGELOG, `/docs`, and published documentation-site pages |
