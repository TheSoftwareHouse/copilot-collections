---
sidebar_position: 5
title: UI Reviewer
---

**File:** `.github/agents/tsh-ui-reviewer.agent.md`

The UI Reviewer agent performs read-only verification comparing implemented UI against Figma designs and reports differences. It is called either directly by a user or as a subagent by `tsh-ui-engineer` during the UI implementation loop. It does **not** fix code.

## Responsibilities

- Getting the **EXPECTED** design state from Figma via the Figma MCP.
- Getting the **ACTUAL** implementation state from fresh live-capture artifacts, or delegating that evidence collection to `tsh-ui-capture-worker` using the caller-provided user-confirmed full URL unchanged.
- Comparing both using measured data — never by reading code or comparing mentally.
- Producing a structured report with differences found following the verification order.
- Returning `VERIFICATION NOT RUN` when capture is missing, blocked, stale, or on the wrong page state; a code-only or partial assessment is not a valid verdict.
- Summarizing content/data/state-only differences and asking the user whether they are intentional when the rest of the UI is otherwise aligned.
- Stopping for user clarification when Figma input, app access, or capture evidence is incomplete.

## What It Verifies

| Category       | Checks                                          |
| -------------- | ----------------------------------------------- |
| **Structure**  | Containers, nesting, grouping                   |
| **Layout**     | Direction, alignment, positioning               |
| **Dimensions** | Width, height, spacing, gaps                    |
| **Visual**     | Typography, colors, radii, shadows, backgrounds |
| **Components** | Correct variants, tokens, states                |

## How It Works

1. Extracts design specifications from Figma (fileKey + nodeId from URL).
2. Reads the current iteration artifacts, or delegates ACTUAL capture to `tsh-ui-capture-worker` when fresh evidence is missing or stale, always forwarding the pinned confirmed full URL unchanged.
3. Compares Figma EXPECTED against CLI-captured ACTUAL across structure, layout, dimensions, visual details, and components.
4. If the remaining differences are plausibly environment-specific content, data, or state values, asks the user to confirm whether they are intentional before treating them as defects.
5. Produces a **PASS / FAIL / VERIFICATION NOT RUN** report with exact differences and recommended fixes.

:::info Read-Only
The UI Reviewer never modifies code. It only reports differences so the UI Engineer can fix them. When called in a loop, each call is an independent verification pass.
:::

Each verification pass is independent. After a UI fix, the next pass must use fresh capture artifacts; prior results do not carry over.

Capture blockers are pre-verification blockers. They return `VERIFICATION NOT RUN` and a blocker-resolution path; they do not consume the 5-iteration fix budget.

## Tool Access

| Tool                 | Usage                                                                        |
| -------------------- | ---------------------------------------------------------------------------- |
| **Figma**            | Get EXPECTED design state — spacing, typography, colors, dimensions          |
| **File Read/Search** | Locate the active artifact directory and inspect capture outputs             |
| **Sub-agents**       | Delegate ACTUAL evidence collection to `tsh-ui-capture-worker`               |
| **Ask Questions**    | Resolve missing Figma links, app URL issues, auth blockers, or stale capture |

## Skills Loaded

- `tsh-ui-verifying` — Verification process, CLI-first artifact contract, severity definitions, and tolerances.

## Handoffs

After verification, the UI Reviewer can hand off to:

- **Code Reviewer** → `/tsh-review` (request broader review after a clean verification pass)
