---
sidebar_position: 4
title: Engineering Manager
---

# Engineering Manager Agent

**File:** `.github/agents/tsh-engineering-manager.agent.md`

The Engineering Manager agent orchestrates the implementation phase. It does not write code itself — instead, it reads implementation plans and delegates tasks to specialized agents based on the type of work required. It ensures each task reaches the right agent with the right context, tracks progress, and triggers quality checks automatically.

## Delegation Flow

```
Implementation Plan
        │
        ▼
┌──────────────────────┐
│  Engineering Manager  │ ← Reads plan, delegates tasks
└──────┬───────────────┘
       │
  ┌────┼────┬────┬────┬────┬────┐
  ▼    ▼    ▼    ▼    ▼    ▼    ▼
 SE   E2E  DevOps Arch  CR  UIR  PE
```

The Engineering Manager is bound to the `/tsh-implement` public prompt. When invoked, it parses the implementation plan, identifies individual tasks, and routes each one to the appropriate specialized agent. For UI tasks with Figma references, it uses the internal `/tsh-implement-ui` prompt to orchestrate the verification loop.

## Agent Delegation

| Agent | Handles | When Used |
|---|---|---|
| **Software Engineer** | Application code, features, bug fixes | Task involves writing or modifying application code |
| **E2E Engineer** | End-to-end tests | Task requires writing or updating E2E test suites |
| **DevOps Engineer** | Infrastructure, CI/CD, deployments | Task involves infrastructure changes or pipeline configuration |
| **Architect** | Codebase analysis, technical context | Before implementation starts, to establish codebase understanding |
| **Code Reviewer** | Code quality, best practices | After implementation completes, or when no review phase is defined |
| **Prompt Engineer** | LLM application prompts | Task involves designing, optimizing, or securing LLM prompts |
| **UI Reviewer** | Figma verification, visual correctness | After UI implementation, to verify against design specifications |

## How to Use

All delegation happens automatically when you run [`/tsh-implement`](../prompts/public/implement). The Engineering Manager reads the implementation plan, identifies each task type, and routes it to the right agent with full context — plan details, acceptance criteria, and technical constraints are packaged automatically.

## Tool Access

| Tool | Usage |
|---|---|
| **Atlassian** | Gathers Jira tickets and Confluence documentation for task context |
| **Sequential Thinking** | Decides which agent to delegate to when the task type is ambiguous |
| **Sub-agents** | Invokes specialized agents for delegation |
| **Terminal** | Runs commands to verify environment state |
| **File Read/Edit/Search** | Navigates the codebase and implementation plan |
| **Todo** | Tracks task completion within the plan |
| **VS Code Commands** | Executes VS Code commands and asks user for clarification |

## Key Behaviors

- **Delegates every task** — Never writes code itself; all implementation is routed to specialized agents.
- **Routes based on task type** — Application code → Software Engineer, E2E tests → E2E Engineer, infrastructure → DevOps Engineer, LLM prompts → Prompt Engineer.
- **Packages context automatically** — Each delegation includes structured context from the implementation plan.
- **Runs codebase analysis first** — Invokes the Architect agent to establish technical context before starting implementation.
- **Auto-triggers Code Reviewer** — Automatically runs the Code Reviewer at the end of implementation if no review phase is defined in the plan.
- **Tracks progress** — Updates plan checkboxes after each completed task.
- **Asks before deviating** — Requests user confirmation before deviating from the implementation plan.
- **Uses Sequential Thinking for ambiguous routing** — When the task type doesn't clearly map to one agent, uses the Sequential Thinking tool to reason through the delegation decision.

## Handoffs

The Engineering Manager receives work from:
- **Architect** — Provides the implementation plan that the Engineering Manager executes against.

After completing all tasks, the Engineering Manager can hand off to:
- **Code Reviewer** — For a final quality review of the full implementation (triggered automatically if not already planned).
- **UI Reviewer** — For Figma verification of UI changes.
