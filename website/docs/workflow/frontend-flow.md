---
sidebar_position: 3
title: Frontend Flow
---

# Frontend Flow

For UI-heavy tasks with Figma designs, use the specialized frontend workflow. This extends the standard flow with iterative Figma verification to ensure the implementation matches the design within tolerance.

## Command Sequence

```text
1️⃣ /tsh-implement <JIRA_ID or task description>
   ↳ 🔍 Engineering Manager delegates to Context Engineer for research
   ↳ 📖 Review research doc – verify Figma links, requirements
   ↳ ✅ Confirm to proceed to planning
   ↳ 🧱 Engineering Manager delegates to Architect for planning
   ↳ 📖 Review plan – check component breakdown, design references
   ↳ ✅ Confirm phases align with Figma structure
   ↳ 💻 Engineering Manager delegates UI tasks to Software Engineer
   ↳ 📖 Review code changes and UI Verification Summary
   ↳ ✅ Manually verify critical UI elements in browser
   ↳ 🔄 Engineering Manager calls /tsh-review-ui in a loop until PASS or escalation

2️⃣ /tsh-review       <JIRA_ID or task description>
   ↳ 📖 Review findings – code quality, a11y, performance
   ↳ ✅ Address all blockers before merging
```

## How the Verification Loop Works

1. The Engineering Manager delegates a UI component implementation to the Software Engineer via the internal `/tsh-implement-ui` prompt.
2. After the Software Engineer completes, the Engineering Manager calls `/tsh-review-ui` to perform **single-pass verification** (read-only).
3. `/tsh-review-ui` uses **Figma MCP** (EXPECTED) + **Playwright MCP** (ACTUAL) → returns PASS or FAIL with diff table.
4. If FAIL → the Engineering Manager delegates the fix to the Software Engineer and calls `/tsh-review-ui` again.
5. Repeats until PASS or max **5 iterations** (then escalates to the developer).

## What `/tsh-review-ui` Does

- Single-pass, **read-only** verification — does not modify code.
- Uses **Figma MCP** to extract design specifications (spacing, typography, colors, dimensions).
- Uses **Playwright MCP** to capture the current implementation state.
- Returns a structured report: **PASS/FAIL** + difference table with exact values.
- Covers: structure (containers, nesting), dimensions (width, height, spacing), visual (typography, colors, radii), and components (variants, tokens, states).

## What `/tsh-implement-ui` Does

:::info Internal Prompt
`/tsh-implement-ui` is an internal prompt — not invoked directly by users. It is triggered automatically by `/tsh-implement` when the plan contains UI tasks with Figma references.
:::

- Orchestrated by the **Engineering Manager** agent, which delegates to the Software Engineer and UI Reviewer.
- Implements UI components following the plan.
- Runs **iterative verification loop** delegating to the `tsh-ui-reviewer` subagent after each component.
- **Fixes mismatches** by delegating fixes back to the Software Engineer based on subagent reports.
- Escalates after 5 failed iterations with a detailed report.
- Produces a **UI Verification Summary** before handing off to code review.

## Required Skills

The frontend flow loads these specialized skills:

- **tsh-implementing-frontend** — Component patterns, design system usage, composition, and performance guidelines.
- **tsh-ui-verifying** — Verification criteria, tolerances, severity definitions, and what constitutes PASS/FAIL.
- **tsh-ensuring-accessibility** — WCAG 2.1 AA compliance, semantic HTML, ARIA, keyboard navigation.
- **tsh-technical-context-discovering** — Project conventions and coding standards.

:::warning Important
The automated Figma verification loop helps catch visual mismatches, but it does not replace manual review. Always visually inspect the implemented UI in the browser, test interactions, and verify responsive behavior yourself.
:::
