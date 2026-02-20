---
sidebar_position: 3
title: Business Analyst
---

# Business Analyst Agent

**File:** `.github/agents/tsh-business-analyst.agent.md`

The Business Analyst agent specializes in gathering requirements, analyzing processes, and building detailed context for development tasks.

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
| **Sequential Thinking** | Analyze complex business rules, identify edge cases, map dependencies |

## Skills Loaded

- `task-analysis` — Analyze task descriptions, perform gap analysis, expand context, gather information from multiple sources.
- `codebase-analysis` — Analyze existing codebase to identify components and patterns related to the task.

## Handoffs

After completing research, the Business Analyst can hand off to:

- **Architect** → `/plan` (create implementation plan for the current task)
