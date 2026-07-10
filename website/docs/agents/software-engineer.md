---
sidebar_position: 5
title: Software Engineer
---

# Software Engineer Agent

**File:** `.github/agents/tsh-software-engineer.agent.md`

The Software Engineer agent is the standard **non-UI** implementor for software solutions based on provided requirements and technical designs. It executes against implementation plans created by the Architect, and UI work now belongs to `tsh-ui-engineer`.

The agent's model array is **Kimi K2.7 Code**, **GPT-5.3-Codex**, and **Gemini 3.5 Flash**, matching the current source frontmatter. At delegation time, the orchestrator (via the orchestration skill) selects between `GPT-5.3-Codex` when the task needs medium-reasoning precision for more complex non-UI work, and `Gemini 3.5 Flash` when a fast, inexpensive option with a larger context window suits broad codebase analysis.

## Responsibilities

- Implementing non-UI code changes following the plan step by step.
- Writing clean, efficient, and maintainable code.
- Following best practices and coding standards.
- Adhering to security considerations and quality assurance guidelines from the plan.
- Reviewing own code to ensure it meets requirements.
- Communicating with the Architect when ambiguities arise.

## Key Behaviors

- **Strictly follows the plan** — Does not deviate unless explicitly instructed.
- **No dead code** — Does not create unused functions or future-only code.
- **No unnecessary files** — Focus on delivering required changes efficiently.
- **Well-documented** — Includes comments and documentation for future maintainability.
- **Never wipes the working tree** — Does not discard, revert, stash, or clean uncommitted changes outside the delegated task; treats them as intentional and reports blockers instead.

## Tool Access

| Tool                      | Usage                                                                       |
| ------------------------- | --------------------------------------------------------------------------- |
| **Context7**              | Search API documentation, find solutions to errors, research best practices |
| **Sequential Thinking**   | Implement complex algorithms, debug issues, plan refactoring                |
| **Terminal**              | Run build tools, tests, linters, and scripts                                |
| **File Read/Edit/Search** | Read, modify, and search workspace files                                    |
| **VS Code Commands**      | Execute VS Code commands and preview in browser                             |
| **Sub-agents**            | Delegate subtasks to specialized agents                                     |
| **Todo**                  | Track implementation progress with structured checklists                    |
| **Ask Questions**         | Confirm scope before proceeding when the plan is missing                    |

## Skills Loaded

- `tsh-technical-context-discovering` — Establish project conventions and patterns before implementing.
- `tsh-implementation-gap-analysing` — Verify what exists vs what needs to be built.
- `tsh-codebase-analysing` — Understand existing architecture for complex features.
- `tsh-sql-and-database-understanding` — SQL queries, database schemas, migrations, ORM patterns.
- `tsh-implementing-backend` — REST and GraphQL APIs, CRUD endpoints, data handling, authentication, and service integration.

## Handoffs

After completing implementation, the Software Engineer can hand off to:

- **Code Reviewer** → `/tsh-review` (review implementation against the plan)
- **E2E Engineer** → delegated by the Engineering Manager for E2E test creation
