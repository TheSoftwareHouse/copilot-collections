---
sidebar_position: 3
title: Frontend Flow
---

For UI-heavy tasks with Figma designs, use the specialized frontend workflow. This extends the standard flow with iterative Figma verification to ensure the implementation matches the design within tolerance.

## Command Sequence

```text
1️⃣ /tsh-implement <JIRA_ID or task description>
   ↳ 🔍 Engineering Manager delegates to Context Engineer for research
   ↳ 📖 Review research doc – verify Figma links, requirements
   ↳ ✅ Confirm to proceed to planning
   ↳ 🧱 Engineering Manager delegates to Architect for planning
   ↳ 🧪 Engineering Manager delegates to Architect Reviewer via /tsh-review-plan for plan validation
   ↳ 📖 Review plan and review summary – check component breakdown, design references
   ↳ ✅ Confirm the approved plan aligns with Figma structure
   ↳ 🌐 Confirm the exact full dev server URL once and pin it for the session
   ↳ 💻 Engineering Manager delegates UI tasks to UI Engineer
   ↳ 📖 Review UI Verification Summary separately from code review
   ↳ ✅ Manually verify critical UI elements in browser
   ↳ 🔄 Engineering Manager calls /tsh-review-ui in a loop until the UI gate is PASS or reaches the structured post-5-iteration user gate
   ↳ 🚫 Do not start /tsh-review until the UI gate is closed

2️⃣ /tsh-review       <JIRA_ID or task description>
   ↳ 📖 Review findings – code quality, a11y, performance
   ↳ ✅ Address all blockers before merging
```

## How the Verification Loop Works

1. The Engineering Manager delegates a UI component implementation to the UI Engineer via the internal `/tsh-implement-ui` prompt.
2. After the UI Engineer completes, the Engineering Manager calls `/tsh-review-ui` to perform **single-pass verification** (read-only) on fresh live-capture artifacts.
3. `/tsh-review-ui` uses **Figma MCP** (EXPECTED) + CLI capture artifacts produced through `tsh-ui-capture-worker` (ACTUAL) → returns PASS, FAIL, or VERIFICATION NOT RUN with a diff table or blocker report.
4. If FAIL → the Engineering Manager delegates the fix to the UI Engineer, then re-captures and re-verifies on the new artifacts before considering the item closed.
5. Repeats until PASS or max **5 iterations**.
6. If mismatches remain after 5 iterations, the flow pauses behind a structured user gate with exactly 3 options: continue with an explicit extra iteration count, stop and accept the current state as `ESCALATED`, or provide a custom instruction.
7. If extra iterations are exhausted and gaps remain, the same structured gate runs again before anything can move to code review.
8. If capture is blocked by missing URL, auth, unreachable page, wrong page state, or incomplete artifacts, the result is `VERIFICATION NOT RUN`; resolve the blocker and rerun capture without consuming the 5-iteration budget.

## What `/tsh-review-ui` Does

- Single-pass, **read-only** verification — does not modify code.
- Uses **Figma MCP** to extract design specifications (spacing, typography, colors, dimensions).
- Uses **`tsh-ui-capture-worker` + Playwright CLI artifacts** to capture the current implementation state.
- Returns a structured report: **PASS/FAIL/VERIFICATION NOT RUN** + difference table or blocker guidance.
- Covers: structure (containers, nesting), dimensions (width, height, spacing), visual (typography, colors, radii), and components (variants, tokens, states).

## What `/tsh-implement-ui` Does

:::info Internal Prompt
`/tsh-implement-ui` is an internal prompt — not invoked directly by users. It is triggered automatically by `/tsh-implement` when the plan contains UI tasks with Figma references.
:::

- Orchestrated by the **Engineering Manager** agent, which delegates to the UI Engineer, UI Capture Worker, and UI Reviewer.
- Implements UI components following the plan.
- Runs **iterative verification loop** delegating to the `tsh-ui-reviewer` subagent after each component.
- **Fixes mismatches** by delegating fixes back to the UI Engineer based on subagent reports, then re-captures and re-verifies on fresh artifacts using the same pinned user-confirmed full URL.
- After 5 failed iterations, pauses behind a structured user gate with a detailed summary and exactly 3 options: continue with explicit extra iterations, stop and accept as `ESCALATED`, or provide a custom instruction.
- Produces a **UI Verification Summary** before handoff to code review, but keeps the UI gate separate from code review.

## Required Skills

The frontend flow loads these specialized skills:

- **tsh-implementing-frontend** — Component patterns, design system usage, composition, and performance guidelines.
- **tsh-ui-verifying** — Verification criteria, tolerances, severity definitions, and what constitutes PASS/FAIL.
- **tsh-ensuring-accessibility** — WCAG 2.1 AA compliance, semantic HTML, ARIA, keyboard navigation.
- **tsh-technical-context-discovering** — Project conventions and coding standards.

:::warning Important
The automated Figma verification loop helps catch visual mismatches, but it does not replace manual review. Always visually inspect the implemented UI in the browser, test interactions, and verify responsive behavior yourself.
:::
