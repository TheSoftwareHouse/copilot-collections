---
sidebar_position: 7
title: /review-ui
---

# /review-ui

**Agent:** UI Reviewer  
**File:** `.github/prompts/review-ui.prompt.md`

Performs a single-pass, read-only verification comparing the implemented UI against the Figma design.

## Usage

Called automatically by `/implement-ui` in a verification loop. Can also be invoked manually:

```text
/review-ui <component or page description>
```

## What It Does

1. **Validates inputs** — Ensures Figma URL is available and dev server is running.
2. **Gets EXPECTED** — Calls Figma MCP to extract design specifications (layer hierarchy, layout, spacing, typography, colors, dimensions).
3. **Gets ACTUAL** — Uses Playwright MCP to capture the running app (scrolls through entire page, captures accessibility tree).
4. **Compares** — Follows `ui-verification` skill criteria: structure FIRST, then dimensions, then visual.
5. **Reports** — Generates a structured PASS/FAIL report with difference table.

## Skills Loaded

- `ui-verification` — Verification criteria, structure checklist, severity definitions, tolerances.

## Output Format

```markdown
## Verification Result: [PASS | FAIL]

### Component: [name]
**Confidence:** [HIGH | MEDIUM | LOW]

### Structural Issues (CRITICAL)
| Issue | Expected (Figma) | Actual (Implementation) |

### Dimension/Visual Differences
| Property | Expected (Figma) | Actual (Implementation) | Severity |

### Recommended Fixes
- [specific fix with exact values]
```

## Key Rules

- **Read-only** — Does not modify code. Only reports differences.
- **Both tools required** — Uses Figma MCP (EXPECTED) and Playwright MCP (ACTUAL).
- **Structure mismatches = automatic FAIL** — Layout/hierarchy issues are never ignored.
- **1-2px tolerance** — Only for browser rendering variance, not for structure/layout.
- **Reports all differences** — Structure, layout, dimensions, visual properties, components.

## Confidence Levels

| Level | Meaning |
|---|---|
| **HIGH** | Both tools returned complete data; comparison is reliable |
| **MEDIUM** | Some values could not be extracted; manual review recommended |
| **LOW** | Tool errors occurred; treat as incomplete verification |
