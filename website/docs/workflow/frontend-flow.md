---
sidebar_position: 3
title: Frontend Flow
---

# Frontend Flow

For UI-heavy tasks with Figma designs, use the specialized frontend workflow. This extends the standard flow with iterative Figma verification to ensure the implementation matches the design within tolerance.

## Command Sequence

```text
1️⃣ /research     <JIRA_ID or task description>
   ↳ 📖 Review research doc – verify Figma links, requirements
   ↳ ✅ Iterate until context is complete and accurate

2️⃣ /plan         <JIRA_ID or task description>
   ↳ 📖 Review plan – check component breakdown, design references
   ↳ ✅ Confirm phases align with Figma structure

3️⃣ /implement-ui <JIRA_ID or task description>
   ↳ 📖 Review code changes and UI Verification Summary
   ↳ ✅ Manually verify critical UI elements in browser
   ↳ 🔄 Agent calls /review-ui in a loop until PASS or escalation

4️⃣ /review       <JIRA_ID or task description>
   ↳ 📖 Review findings – code quality, a11y, performance
   ↳ ✅ Address all blockers before merging
```

## How the Verification Loop Works

1. `/implement-ui` implements a UI component.
2. Calls `/review-ui` to perform **single-pass verification** (read-only).
3. `/review-ui` uses **Figma MCP** (EXPECTED) + **Playwright MCP** (ACTUAL) → returns PASS or FAIL with diff table.
4. If FAIL → `/implement-ui` fixes the code and calls `/review-ui` again.
5. Repeats until PASS or max **5 iterations** (then escalates to the developer).

## What `/review-ui` Does

- Single-pass, **read-only** verification — does not modify code.
- Uses **Figma MCP** to extract design specifications (spacing, typography, colors, dimensions).
- Uses **Playwright MCP** to capture the current implementation state.
- Returns a structured report: **PASS/FAIL** + difference table with exact values.
- Covers: structure (containers, nesting), dimensions (width, height, spacing), visual (typography, colors, radii), and components (variants, tokens, states).

## What `/implement-ui` Does

- Implements UI components following the plan.
- Runs **iterative verification loop** calling `/review-ui` after each component.
- **Fixes mismatches** based on `/review-ui` reports.
- Escalates after 5 failed iterations with a detailed report.
- Produces a **UI Verification Summary** before handing off to code review.

## Required Skills

The frontend flow loads these specialized skills:

- **frontend-implementation** — Accessibility requirements, design system usage, component patterns, and performance guidelines.
- **ui-verification** — Verification criteria, tolerances, severity definitions, and what constitutes PASS/FAIL.
- **technical-context-discovery** — Project conventions and coding standards.

:::warning Important
The automated Figma verification loop helps catch visual mismatches, but it does not replace manual review. Always visually inspect the implemented UI in the browser, test interactions, and verify responsive behavior yourself.
:::
