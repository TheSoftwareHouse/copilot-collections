---
sidebar_position: 5.1
title: UI Engineer
---

**File:** `.github/agents/tsh-ui-engineer.agent.md`

The UI Engineer agent is the specialized implementor for UI and frontend work. It handles design-driven implementation, accessibility, and the verification loop that keeps implementation aligned with the design reference. Non-UI implementation stays with `tsh-software-engineer`.

For React Native, this agent owns rendered screens, components, navigation, layout, styling, gestures, animations, and accessibility-facing UI, and loads [`tsh-implementing-react-native`](../skills/react-native-implementation) for profile-driven guidance. React Native business logic, state, data, services, integrations, native modules, and other non-rendered work remain on the existing non-UI route. Native simulator/device, native accessibility, and native end-to-end evidence are target-project responsibilities; this collection's browser artifacts do not verify native behavior.

## Responsibilities

- Implementing UI and frontend solutions from requirements and design context.
- Translating Figma designs into working interfaces with the right component, spacing, and state choices.
- Running the implementation loop: implement, delegate ACTUAL capture to `tsh-ui-capture-worker`, delegate design review to `tsh-ui-reviewer`, then apply fixes and re-capture using the same pinned user-confirmed full URL throughout the session.
- Applying accessibility, hooks, forms, and frontend performance practices during UI work.
- Loading `tsh-implementing-react-native` for rendered React Native UI and preserving the non-UI ownership boundary.
- Confirming scope with `vscode/askQuestions` when a plan is missing or the UI task is unclear.
- Pausing behind `vscode/askQuestions` when capture or review is blocked by missing Figma input, unknown app URL, auth issues, or failed evidence collection.
- Limiting the verification loop to 5 iterations before pausing behind a structured user gate.
- Keeping the UI gate separate from code review until every UI item is verified, escalated, or explicitly acknowledged as blocked.
- Handoff to review and E2E testing when the UI change is ready for broader validation.

## Outputs

- Completed UI components, screens, and frontend refinements.
- Design-aligned fixes informed by capture artifacts and reviewer feedback.
- Review-ready UI changes with no speculative non-UI work.

## Non-goals

- Does not own backend, database, infrastructure, or other non-UI implementation.
- Does not take over `tsh-software-engineer` or `tsh-plan-implementor` scopes.
- Does not perform the low-level CLI capture step itself when `tsh-ui-capture-worker` is available.
- Does not broaden beyond the delegated UI task.

## Tool Access

| Tool                      | Usage                                                                              |
| ------------------------- | ---------------------------------------------------------------------------------- |
| **Context7**              | Look up design-system documentation and UI library guidance                        |
| **Figma**                 | Extract design specifications for UI tasks                                         |
| **Sequential Thinking**   | Plan complex UI refactors and debug layout or interaction issues                   |
| **Terminal**              | Run build tools, tests, linters, and scripts                                       |
| **File Read/Edit/Search** | Read, modify, and search workspace files                                           |
| **VS Code Commands**      | Execute VS Code commands and preview in browser                                    |
| **Sub-agents**            | Delegate capture to `tsh-ui-capture-worker` and design review to `tsh-ui-reviewer` |
| **Todo**                  | Track implementation progress with structured checklists                           |
| **Ask Questions**         | Confirm missing scope and unblock capture or review failures                       |

## Skills Loaded

- `tsh-technical-context-discovering` — Establish project conventions and patterns before implementing.
- `tsh-implementation-gap-analysing` — Verify what exists vs what needs to be built.
- `tsh-codebase-analysing` — Understand existing architecture for complex UI work.
- `tsh-implementing-frontend` — Component patterns, composition, and design-token-aligned UI implementation.
- `tsh-implementing-forms` — Schema validation, field composition, error handling, and multi-step form flows.
- `tsh-writing-hooks` — Custom hooks: naming, composition, stable returns, effect cleanup, and testing.
- `tsh-ensuring-accessibility` — WCAG 2.1 AA compliance, semantic HTML, ARIA, keyboard navigation, and focus management.
- `tsh-optimizing-frontend` — Rendering optimization, code splitting, memoization, and memory management.
- `tsh-implementing-react-native` — Profile-driven guidance for rendered React Native screens, components, navigation, layout, styling, gestures, animations, and accessibility-facing UI.
- `tsh-ui-verifying` — The implement -> capture -> review loop, verification criteria, tolerances, and report expectations.

## How It Works

1. Implement or patch the UI against the current plan and design context.
2. Delegate mechanical CLI capture to `tsh-ui-capture-worker` using the pinned user-confirmed full URL unchanged.
3. Delegate design verification to `tsh-ui-reviewer` using the resulting artifacts plus Figma and the same pinned URL.
4. Apply the reported fixes, then trigger a fresh capture and a fresh verification pass on the new artifacts.
5. Repeat as needed, up to 5 iterations, or sooner if a blocker requires `vscode/askQuestions`.
6. After the 5-iteration budget is exhausted, pause behind the structured user gate with exactly 3 options: continue-with-N, stop as `ESCALATED`, or custom instruction.

Do not move to code review while any UI item is still open or unverified.

Missing URL, auth, page-state, or capture blockers produce `VERIFICATION NOT RUN` and blocker-resolution work. They do not consume the 5-iteration fix budget.

## Handoffs

After completing implementation, the UI Engineer can hand off to:

- **Code Reviewer** → `/tsh-review` (review implementation against the plan)
- **E2E Engineer** → delegated by the Engineering Manager for E2E test creation
