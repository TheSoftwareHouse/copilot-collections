---
sidebar_position: 4
title: Software Engineer
---

# Software Engineer Agent

**File:** `.github/agents/tsh-software-engineer.agent.md`

The Software Engineer agent implements software solutions based on provided requirements and technical designs. It executes against implementation plans created by the Architect.

## Responsibilities

- Implementing code changes following the plan step by step.
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

## Tool Access

| Tool | Usage |
|---|---|
| **Context7** | Search API documentation, find solutions to errors, research best practices |
| **Figma** | Extract design specifications for frontend tasks |
| **Playwright** | Verify UI implementation by interacting with the running application |
| **Sequential Thinking** | Implement complex algorithms, debug issues, plan refactoring |

## Skills Loaded

- `technical-context-discovery` — Establish project conventions and patterns before implementing.
- `implementation-gap-analysis` — Verify what exists vs what needs to be built.
- `codebase-analysis` — Understand existing architecture for complex features.
- `frontend-implementation` — Accessibility, design system, component patterns.
- `ui-verification` — Tolerances and structure checklist for Figma verification.
- `sql-and-database` — SQL queries, database schemas, migrations, ORM patterns.

## Handoffs

After completing implementation, the Software Engineer can hand off to:

- **Code Reviewer** → `/review` (review implementation against the plan)
- **E2E Engineer** → `/e2e` (create E2E tests for the implemented feature)
