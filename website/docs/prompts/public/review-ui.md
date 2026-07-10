---
sidebar_position: 7
title: /tsh-review-ui
---

**Agent:** UI Reviewer  
**File:** `.github/prompts/tsh-review-ui.prompt.md`

Performs a single-pass, read-only verification comparing the implemented UI against the Figma design.

## Usage

Called automatically by `/tsh-implement` (via the internal UI prompt) in a verification loop. Can also be invoked manually:

```text
/tsh-review-ui <component or page description>
```

## What It Does

1. **Validates inputs** — Ensures the Figma URL is available and that UI verification has the exact user-confirmed full dev server URL. Standalone runs must confirm the URL first.
2. **Gets EXPECTED** — Calls Figma MCP to extract design specifications (layer hierarchy, layout, spacing, typography, colors, dimensions).
3. **Gets ACTUAL** — Uses `tsh-ui-capture-worker` to collect fresh Playwright CLI artifacts for the running app.
4. **Compares** — Follows `tsh-ui-verifying` skill criteria: structure, layout, dimensions, visual, and components.
5. **Reports** — Generates a structured PASS/FAIL/VERIFICATION NOT RUN report with differences or blocker guidance.

## Skills Loaded

- `tsh-ui-verifying` — Verification criteria, structure checklist, severity definitions, tolerances.

## Output Format

```markdown
## Verification Result: [PASS | FAIL | VERIFICATION NOT RUN]

### Component: [name]

**Confidence:** [HIGH | MEDIUM | LOW]

### Differences

| Property | Expected (Figma) | Actual (Implementation) | Severity |

### Clarification Needed

- [content/data/state differences that may be intentional]

### Recommended Fixes

- [specific fix with exact values]

### Blocker Resolution

- [next step when verification did not run]
```

## Key Rules

- **Read-only** — Does not modify code. Only reports differences.
- **Both sides required** — Uses Figma MCP (EXPECTED) and `tsh-ui-capture-worker` Playwright CLI artifacts (ACTUAL).
- **Structure mismatches = automatic FAIL** — Layout/hierarchy issues are never ignored.
- **1-2px tolerance** — Only for browser rendering variance, not for structure/layout.
- **Reports differences per verification order** — Structure, layout, dimensions, visual, and components. It does not stop on the first critical finding.
- **Capture blockers are pre-verification blockers** — Missing URL, auth blockers, wrong page state, or incomplete artifacts must return `VERIFICATION NOT RUN`; they do not consume the 5-iteration fix budget.

## Confidence Levels

| Level      | Meaning                                                       |
| ---------- | ------------------------------------------------------------- |
| **HIGH**   | Both tools returned complete data; comparison is reliable     |
| **MEDIUM** | Some values could not be extracted; manual review recommended |
| **LOW**    | Tool errors occurred; treat as incomplete verification        |
