---
sidebar_position: 1
title: Agents Overview
---

# Agents Overview

Copilot Collections ships **6 specialized agents**, each with a clearly defined role within the delivery workflow. Agents are stored in `.github/agents/` as `.agent.md` files. VS Code loads these automatically when the corresponding mode is selected.

## How Agents Work

Each agent has:

- **A defined role** — What the agent specializes in and what it should/shouldn't do.
- **Tool access** — Which MCP integrations and VS Code tools it can use.
- **Skill bindings** — Which skills it loads for domain-specific knowledge.
- **Handoffs** — Buttons to seamlessly transition between workflow phases.

## Agent Handoff Diagram

```
┌──────────────────┐
│ Business Analyst  │
│  /research        │
└──────┬───────────┘
       │ Prepare Implementation Plan
       ▼
┌──────────────────┐
│    Architect      │
│    /plan          │
└──────┬───────────┘
       │ Start Implementation / Start UI Implementation
       ▼
┌──────────────────┐       ┌──────────────────┐
│ Software Engineer │──────▶│   UI Reviewer     │
│ /implement        │◀──────│   /review-ui      │
│ /implement-ui     │       └──────────────────┘
└──────┬───────────┘
       │ Run Code Review / Write E2E Tests
       ▼
┌──────────────────┐       ┌──────────────────┐
│  Code Reviewer    │       │  E2E Engineer     │
│  /review          │       │  /e2e             │
└──────────────────┘       └──────────────────┘
```

## Agent Summary

| Agent | File | Role | Key Tools |
|---|---|---|---|
| [Business Analyst](./business-analyst) | `tsh-business-analyst.agent.md` | Gathers requirements, builds context, identifies gaps | Atlassian, Figma, Sequential Thinking |
| [Architect](./architect) | `tsh-architect.agent.md` | Designs solutions, creates implementation plans | Atlassian, Context7, Figma, Sequential Thinking |
| [Software Engineer](./software-engineer) | `tsh-software-engineer.agent.md` | Implements code against the plan | Context7, Figma, Playwright, Sequential Thinking |
| [UI Reviewer](./ui-reviewer) | `tsh-ui-reviewer.agent.md` | Verifies UI matches Figma design | Figma, Playwright, Context7 |
| [Code Reviewer](./code-reviewer) | `tsh-code-reviewer.agent.md` | Reviews code quality, security, correctness | Atlassian, Context7, Figma, Sequential Thinking |
| [E2E Engineer](./e2e-engineer) | `tsh-e2e-engineer.agent.md` | Creates and maintains Playwright E2E tests | Playwright, Context7, Figma, Sequential Thinking |
