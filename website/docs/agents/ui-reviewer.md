---
sidebar_position: 5
title: UI Reviewer
---

# UI Reviewer Agent

**File:** `.github/agents/tsh-ui-reviewer.agent.md`

The UI Reviewer agent performs single-pass, read-only verification comparing the implemented UI against the Figma design. It reports differences — it does **not** fix code.

## Responsibilities

- Getting the **EXPECTED** design state from Figma via the Figma MCP.
- Getting the **ACTUAL** implementation state from the running app via Playwright.
- Comparing and producing a structured report with all differences.
- Verifying structure, dimensions, visual properties, and component usage.

## What It Verifies

| Category | Checks |
|---|---|
| **Structure** | Containers, nesting, grouping |
| **Dimensions** | Width, height, spacing, gaps |
| **Visual** | Typography, colors, radii, shadows, backgrounds |
| **Components** | Correct variants, tokens, states |

## How It Works

1. Extracts design specifications from Figma (fileKey + nodeId from URL).
2. Captures current implementation state via Playwright accessibility tree.
3. Compares expected vs actual values.
4. Produces a **PASS/FAIL** report with a difference table showing exact values.

:::info Read-Only
The UI Reviewer never modifies code. It only reports differences so the Software Engineer (`/implement-ui`) can fix them. When called in a loop, each call is an independent verification pass.
:::

## Tool Access

| Tool | Usage |
|---|---|
| **Figma** | Get EXPECTED design state — spacing, typography, colors, dimensions |
| **Playwright** | Get ACTUAL implementation state — accessibility tree and screenshots |
| **Context7** | Look up design system documentation and UI library guidelines |

## Skills Loaded

- `ui-verification` — Verification criteria, structure checklist, severity definitions, and tolerances.

## Handoffs

After verification, the UI Reviewer can hand off to:

- **Software Engineer** → `/implement-ui` (implement UI fixes based on the verification report)
- **Code Reviewer** → `/review` (proceed to code review if PASS)
