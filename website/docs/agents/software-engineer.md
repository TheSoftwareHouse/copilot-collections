---
sidebar_position: 5
title: Software Engineer
---

# Software Engineer Agent

**File:** `.github/agents/tsh-software-engineer.agent.md`

The Software Engineer agent is the **exception**-route implementor for complex **non-UI** software solutions based on provided requirements and technical designs. It executes against implementation plans created by the Architect; `tsh-plan-implementor` is the DEFAULT executor for actionable, low-risk plan seams, and UI work belongs to `tsh-ui-engineer`.

Before any file change, validate from disk a plan whose current Human Approval record satisfies exactly `Human Decision=APPROVED`, `Approved Revision=current Plan Revision`, and a valid ISO 8601 UTC `Decision Timestamp` ending in `Z`. Fail closed when a field is missing, stale, mismatched, inferred, based only on Reviewer approval, or when the plan cannot be located or read; retry an unreadable or ambiguous reference once and resolve relative paths against the workspace root. Name the exact failed field, condition, or file, then use `vscode/askQuestions` for guided recovery on every entry path, including direct selection as the primary chat agent. Offer pointing to the correct plan, obtaining Human approval for an existing plan, starting plan preparation, or, when delegated, handing back to `tsh-engineering-manager`; continue only from the user's explicit choice, which is never Human approval.

The agent's model array is **Kimi K2.7 Code**, **GPT-5.3-Codex**, and **Gemini 3.6 Flash**, matching the current source frontmatter. At delegation time, the orchestrator (via the orchestration skill) selects between `GPT-5.3-Codex` when the task needs medium-reasoning precision for more complex non-UI work, and `Gemini 3.6 Flash` when a fast, inexpensive option with a larger context window suits broad codebase analysis.

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

| Tool | Usage |
| --- | --- |
| **Context7** | Search API documentation, find solutions to errors, research best practices |
| **Sequential Thinking** | Implement complex algorithms, debug issues, plan refactoring |
| **Terminal** | Run build tools, tests, linters, and scripts |
| **File Read/Edit/Search** | Read, modify, and search workspace files |
| **VS Code Commands** | Execute VS Code commands and preview in browser |
| **Sub-agents** | Delegate subtasks to specialized agents |
| **Todo** | Track implementation progress with structured checklists |
| **Ask Questions** | Clarify genuine implementation ambiguity within a Human-approved current plan revision — never used to seek permission to proceed without a valid plan |

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
- `tsh-implementing-backend` — REST and GraphQL APIs, CRUD endpoints, data handling, authentication, and service integration.

## Handoffs

After completing implementation, the Software Engineer can hand off to:

- **Code Reviewer** → `/tsh-review` (review implementation against the plan)
- **E2E Engineer** → delegated by the Engineering Manager for E2E test creation
