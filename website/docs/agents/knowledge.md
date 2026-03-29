---
sidebar_position: 3
title: Knowledge
---

# Knowledge Agent

**File:** `.github/agents/tsh-knowledge.agent.md`

The Knowledge agent specializes in using task management and knowledge base tools to provide task details and knowledge insights. It acts as the single gateway to external task management systems (Jira, Shortcut) and knowledge bases (Confluence), ensuring that all operations on these systems are performed securely and with proper context.

## Responsibilities

- Providing task details from Jira or Shortcut based on project context.
- Retrieving knowledge and documentation from Confluence.
- Creating and updating issues in task management tools on behalf of other agents (e.g., Business Analyst).
- Remembering tool preferences per workspace using VS Code memory.
- Detecting and selecting the correct workspace when multiple are available.

## How It Determines Which Tool to Use

The Knowledge agent follows a strict discovery process:

1. **Check memory** — Look in VS Code memory for stored information about which tools the current project uses.
2. **Ask the user** — If no memory exists, ask the user about their task management and knowledge base preferences.
3. **Separate tool and knowledge base** — Never assume the same tool is used for both. A project may use Jira for tasks and Confluence for docs, or Shortcut for tasks with no knowledge base.

## What It Does NOT Do

- Does not process workshop materials or extract tasks (use the [Business Analyst](./business-analyst) for that).
- Does not produce implementation plans or architecture decisions.
- Does not suggest tools outside the supported list.

## Tool Access

| Tool | Usage |
|---|---|
| **Atlassian** | Access Jira for task management and Confluence for knowledge base |
| **Shortcut** | Access Shortcut for task management |
| **Sequential Thinking** | Decide which tool to use when the choice isn't obvious |
| **VS Code Memory** | Store and retrieve tool preferences per workspace |
| **Ask Questions** | Clarify user preferences and workspace selection |

## Skills Loaded

- `tsh-using-task-and-knowledge-management-tools` — Guidelines for interacting with supported task management and knowledge base tools.

## Supported Tools

### Task Management
- **Atlassian Jira**
- **Shortcut**

### Knowledge Base
- **Atlassian Confluence**

## How Other Agents Use It

The Knowledge agent is primarily invoked as a sub-agent by other agents that need to interact with external task management or knowledge base systems:

- **Business Analyst** — Delegates all task creation, updating, fetching, and backlog import operations.
- **Context Engineer** — Retrieves task details and related documentation for research.
- **Engineering Manager** — Fetches task context for implementation delegation.

:::note
The Knowledge agent stores tool preferences in VS Code memory scoped to the current workspace. This means it remembers your project's preferred tools across sessions without asking repeatedly.
:::
