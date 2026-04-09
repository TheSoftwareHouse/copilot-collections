---
sidebar_position: 3
title: Context Engineer
---

# Context Engineer Agent

**File:** `.github/agents/tsh-context-engineer.agent.md`

The Context Engineer agent specializes in gathering requirements, analyzing processes, and building detailed context for development tasks.

## Responsibilities

- Gathering all information related to a task from the codebase, Jira, Confluence, Figma, and other sources.
- Analyzing the task thoroughly, including parent tasks and subtasks.
- Checking external links and Confluence pages linked to the task.
- Reviewing Figma designs when linked to the task.
- Identifying ambiguities and missing information, asking for clarification.
- Exploring industry standards and domain-specific best practices.

## What It Produces

A `.research.md` document containing:

- **Task summary** — Clear description of what needs to be done.
- **Requirements and acceptance criteria** — Detailed functional requirements.
- **User stories and key flows** — How users interact with the feature.
- **Assumptions** — What the agent assumed based on available information.
- **Open questions** — Unresolved ambiguities that need stakeholder input.
- **Suggested next steps** — Recommendations for the planning phase.

## What It Does NOT Do

- Does not provide implementation details or technical specifications.
- Does not create implementation plans, deployment plans, or test plans.
- These are provided by the Architect in the next phase.

## Tool Access

| Tool | Usage |
|---|---|
| **Atlassian** | Gather requirements from Jira and Confluence, search for related issues |
| **Figma** | Review designs, understand functional intent, identify missing states |
| **PDF Reader** | Read and extract content from PDF requirement documents |
| **Sequential Thinking** | Analyze complex business rules, identify edge cases, map dependencies |
| **File Read/Edit/Search** | Read, modify, and search workspace files |
| **VS Code Commands** | Execute VS Code commands and run tasks |
| **Sub-agents** | Delegate subtasks to specialized agents |
| **Todo** | Track research progress with structured checklists |

## Skills Loaded

- `tsh-task-analysing` — Analyze task descriptions, perform gap analysis, expand context, gather information from multiple sources.
- `tsh-codebase-analysing` — Analyze existing codebase to identify components and patterns related to the task.

## Handoffs

After completing research, the Context Engineer hands back to the Engineering Manager, which delegates to:

- **Architect** → implementation planning (via internal `/tsh-plan` prompt)
