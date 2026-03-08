---
sidebar_position: 3
title: Frontend Flow
---

# Frontend Flow

For UI-heavy tasks with Figma designs, use the specialized frontend workflow. This extends the standard flow with iterative Figma verification to ensure the implementation matches the design within tolerance.

## Command Sequence

```text
1️⃣ /tsh-research     <JIRA_ID or task description>
   ↳ 📖 Review research doc – verify Figma links, requirements
   ↳ ✅ Iterate until context is complete and accurate

2️⃣ /tsh-plan         <JIRA_ID or task description>
   ↳ 📖 Review plan – check component breakdown, design references
   ↳ ✅ Confirm phases align with Figma structure

3️⃣ /tsh-implement-ui <JIRA_ID or task description>
   ↳ 📖 Review code changes and UI Verification Summary
   ↳ ✅ Manually verify critical UI elements in browser
   ↳ 🔄 Agent calls /tsh-review-ui in a loop until PASS or escalation

4️⃣ /tsh-review       <JIRA_ID or task description>
   ↳ 📖 Review findings – code quality, a11y, performance
   ↳ ✅ Address all blockers before merging
```

## How the Verification Loop Works

1. `/tsh-implement-ui` implements a UI component.
2. Calls `/tsh-review-ui` to perform **single-pass verification** (read-only).
3. `/tsh-review-ui` uses **Figma MCP** (EXPECTED) + **Playwright MCP** (ACTUAL) → returns PASS or FAIL with diff table.
4. If FAIL → `/tsh-implement-ui` fixes the code and calls `/tsh-review-ui` again.
5. Repeats until PASS or max **5 iterations** (then escalates to the developer).

## What `/tsh-review-ui` Does

- Single-pass, **read-only** verification — does not modify code.
- Uses **Figma MCP** to extract design specifications (spacing, typography, colors, dimensions).
- Uses **Playwright MCP** to capture the current implementation state.
- Returns a structured report: **PASS/FAIL** + difference table with exact values.
- Covers: structure (containers, nesting), dimensions (width, height, spacing), visual (typography, colors, radii), and components (variants, tokens, states).

## What `/tsh-implement-ui` Does

- Implements UI components following the plan.
- Runs **iterative verification loop** delegating to the `tsh-ui-reviewer` subagent after each component.
- **Fixes mismatches** based on subagent reports.
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
