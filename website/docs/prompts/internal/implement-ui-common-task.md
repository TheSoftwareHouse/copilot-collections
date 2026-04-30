---
sidebar_position: 7
title: /tsh-implement-ui-common-task
---

# /tsh-implement-ui-common-task

:::info
Not invoked directly by users. To trigger UI implementation, use [`/tsh-implement`](../public/implement) — the [Engineering Manager](../../agents/engineering-manager) will automatically delegate to the [Software Engineer](../../agents/software-engineer) via the internal [`/tsh-implement-ui`](./implement-ui) prompt.
:::

**Agent:** Software Engineer
**File:** `.github/internal-prompts/tsh-implement-ui-common-task.prompt.md`

Extends the standard implementation workflow with UI-specific behaviors — Figma design references, frontend component patterns, and accessibility compliance.

## How It's Triggered

```text
/tsh-implement <JIRA_ID or task description>
```

The Engineering Manager identifies UI tasks in the plan and delegates them to the Software Engineer via the internal `/tsh-implement-ui` prompt, which passes Figma design context.

## What It Does

### 1. Design Reference Extraction

- Reads the research file (`*.research.md`) for Figma URLs in `Relevant Links` and `Gathered Information`.
- Reads the plan file (`*.plan.md`) for Figma URLs in `Task details` and `Design References`.
- If a Figma link is missing for a component, **stops and asks the user** before proceeding.

### 2. Implementation

- Follows the base workflow from `tsh-implement-common-task` plus UI-specific skills.
- Uses `figma` to extract exact design specs — spacing, color tokens, typography, component variants.
- Implements semantic HTML, design system tokens, and WCAG 2.1 AA accessibility patterns.

### 3. Verification

- After implementation, the Engineering Manager triggers [`/tsh-review-ui`](../public/review-ui) via the UI Reviewer for automated Figma comparison.
- Mismatches are fixed and re-verified in a loop (up to 5 iterations).

## Skills Loaded

- Everything from `tsh-implement-common-task`, plus:
- `tsh-implementing-frontend` — Component patterns, design system usage, composition, and performance.
- `tsh-ensuring-accessibility` — WCAG 2.1 AA compliance, semantic HTML, ARIA, keyboard navigation.
- `tsh-technical-context-discovering` — Project conventions before implementing.
