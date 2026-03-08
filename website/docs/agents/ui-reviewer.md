---
sidebar_position: 5
title: UI Reviewer
---

# UI Reviewer Agent

**File:** `.github/agents/tsh-ui-reviewer.agent.md`

The UI Reviewer agent performs read-only verification comparing implemented UI against Figma designs and reports differences. It is called either directly by a user or as a subagent by the Software Engineer during the UI implementation loop. It does **not** fix code.

## Responsibilities

- Getting the **EXPECTED** design state from Figma via the Figma MCP.
- Getting the **ACTUAL** implementation state from the running app via Playwright.
- Comparing both using measured data — never by reading code or comparing mentally.
- Producing a structured report with differences found following the verification order.
- Reporting tool failures transparently with LOW confidence when data is incomplete.

## What It Verifies

| Category       | Checks                                          |
| -------------- | ----------------------------------------------- |
| **Structure**  | Containers, nesting, grouping                   |
| **Dimensions** | Width, height, spacing, gaps                    |
| **Visual**     | Typography, colors, radii, shadows, backgrounds |
| **Components** | Correct variants, tokens, states                |

## How It Works

1. Extracts design specifications from Figma (fileKey + nodeId from URL).
2. Captures current implementation state via Playwright accessibility tree.
3. Compares expected vs actual values.
4. Produces a **PASS/FAIL** report with a difference table showing exact values.

:::info Read-Only
The UI Reviewer never modifies code. It only reports differences so the Software Engineer (`/tsh-implement-ui`) can fix them. When called in a loop, each call is an independent verification pass.
:::

## Tool Access

| Tool                      | Usage                                                                |
| ------------------------- | -------------------------------------------------------------------- |
| **Context7**              | Look up design system documentation and UI library guidelines        |
| **Figma**                 | Get EXPECTED design state — spacing, typography, colors, dimensions  |
| **Playwright**            | Get ACTUAL implementation state — accessibility tree and screenshots |
| **Sequential Thinking**   | Analyze complex layout discrepancies, evaluate tolerance decisions   |
| **Terminal**              | Run commands to verify application state                             |
| **File Read/Edit/Search** | Read, modify, and search workspace files                             |
| **VS Code Commands**      | Execute VS Code commands and preview in browser                      |
| **Sub-agents**            | Delegate subtasks to specialized agents                              |
| **Todo**                  | Track verification progress with structured checklists               |

## Skills Loaded

- `tsh-ui-verifying` — Verification criteria, structure checklist, severity definitions, and tolerances.

## Handoffs

After verification, the UI Reviewer can hand off to:

- **Software Engineer** → `/tsh-implement-ui` (start UI implementation according to the plan)
- **Software Engineer** → `/tsh-implement-ui` (implement UI fixes based on the verification report)
- **Code Reviewer** → `/tsh-review` (proceed to code review if PASS)
