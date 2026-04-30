---
sidebar_position: 5
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

| Tool                      | Usage                                                                       |
| ------------------------- | --------------------------------------------------------------------------- |
| **Atlassian**             | Search for task requirements and related context (search only)              |
| **Context7**              | Search API documentation, find solutions to errors, research best practices |
| **Figma**                 | Extract design specifications for frontend tasks                            |
| **Playwright**            | Verify UI implementation by interacting with the running application        |
| **Sequential Thinking**   | Implement complex algorithms, debug issues, plan refactoring                |
| **Terminal**              | Run build tools, tests, linters, and scripts                                |
| **File Read/Edit/Search** | Read, modify, and search workspace files                                    |
| **VS Code Commands**      | Execute VS Code commands and preview in browser                             |
| **Sub-agents**            | Delegate subtasks to specialized agents                                     |
| **Todo**                  | Track implementation progress with structured checklists                    |

## Skills Loaded

- `tsh-technical-context-discovering` — Establish project conventions and patterns before implementing.
- `tsh-implementation-gap-analysing` — Verify what exists vs what needs to be built.
- `tsh-codebase-analysing` — Understand existing architecture for complex features.
- `tsh-implementing-frontend` — Component patterns, composition, design tokens, Figma-to-code workflow.
- `tsh-implementing-react-native` — React Native mobile UI: platform-specific components, navigation, gestures, animations, Figma-to-native workflow.
- `tsh-implementing-forms` — Schema validation, field composition, error handling, multi-step form flows.
- `tsh-writing-hooks` — Custom hooks: naming, composition, stable returns, effect cleanup, testing.
- `tsh-ensuring-accessibility` — WCAG 2.1 AA compliance: semantic HTML, ARIA, keyboard navigation, focus management.
- `tsh-optimizing-frontend` — Code splitting, memoization, bundle size, rendering optimization, memory management.
- `tsh-ui-verifying` — Tolerances and structure checklist for Figma verification.
- `tsh-sql-and-database-understanding` — SQL queries, database schemas, migrations, ORM patterns.
- `tsh-engineering-prompts` — LLM prompt design: structure patterns, optimization, security, templates.

## Handoffs

After completing implementation, the Software Engineer can hand off to:

- **Code Reviewer** → `/tsh-review` (review implementation against the plan)
- **E2E Engineer** → delegated by the Engineering Manager for E2E test creation
