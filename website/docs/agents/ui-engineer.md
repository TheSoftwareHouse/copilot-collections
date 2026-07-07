---
sidebar_position: 5.1
title: UI Engineer
---

# UI Engineer Agent

**File:** `.github/agents/tsh-ui-engineer.agent.md`

The UI Engineer agent is the specialized implementor for UI and frontend work. It handles design-driven implementation, accessibility, UI verification, and frontend refactors that need Figma and Playwright support. Non-UI implementation stays with `tsh-software-engineer`.

## Responsibilities

- Implementing UI and frontend solutions from requirements and design context.
- Translating Figma designs into working interfaces with the right component, spacing, and state choices.
- Verifying UI behavior with Playwright and design comparisons when the task requires it.
- Applying accessibility, hooks, forms, and frontend performance practices during UI work.
- Confirming scope with `vscode/askQuestions` when a plan is missing or the UI task is unclear.
- Handoff to review and E2E testing when the UI change is ready for validation.

## Outputs

- Completed UI components, screens, and frontend refinements.
- Design-aligned accessibility and UI verification updates.
- Review-ready UI changes with no speculative non-UI work.

## Non-goals

- Does not own backend, database, infrastructure, or other non-UI implementation.
- Does not take over `tsh-software-engineer` or `tsh-plan-implementor` scopes.
- Does not broaden beyond the delegated UI task.

## Tool Access

| Tool                      | Usage                                                                      |
| ------------------------- | ---------------------------------------------------------------------------- |
| **Context7**              | Look up design-system documentation and UI library guidance                 |
| **Figma**                 | Extract design specifications for UI tasks                                  |
| **Playwright**            | Verify UI implementation by interacting with the running application        |
| **Sequential Thinking**   | Plan complex UI refactors and debug layout or interaction issues            |
| **Terminal**              | Run build tools, tests, linters, and scripts                                |
| **File Read/Edit/Search** | Read, modify, and search workspace files                                    |
| **VS Code Commands**      | Execute VS Code commands and preview in browser                             |
| **Sub-agents**            | Delegate subtasks to specialized agents                                     |
| **Todo**                  | Track implementation progress with structured checklists                    |
| **Ask Questions**         | Confirm scope before proceeding when the plan is missing                    |

## Skills Loaded

- `tsh-technical-context-discovering` — Establish project conventions and patterns before implementing.
- `tsh-implementation-gap-analysing` — Verify what exists vs what needs to be built.
- `tsh-codebase-analysing` — Understand existing architecture for complex UI work.
- `tsh-implementing-frontend` — Component patterns, composition, and design-token-aligned UI implementation.
- `tsh-implementing-forms` — Schema validation, field composition, error handling, and multi-step form flows.
- `tsh-writing-hooks` — Custom hooks: naming, composition, stable returns, effect cleanup, and testing.
- `tsh-ensuring-accessibility` — WCAG 2.1 AA compliance, semantic HTML, ARIA, keyboard navigation, and focus management.
- `tsh-optimizing-frontend` — Rendering optimization, code splitting, memoization, and memory management.
- `tsh-ui-verifying` — Figma verification criteria, structure checks, severity definitions, and tolerances.

## Handoffs

After completing implementation, the UI Engineer can hand off to:

- **Code Reviewer** → `/tsh-review` (review implementation against the plan)
- **E2E Engineer** → delegated by the Engineering Manager for E2E test creation