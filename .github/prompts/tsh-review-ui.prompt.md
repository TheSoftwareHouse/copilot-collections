---
agent: "tsh-ui-reviewer"
model: "Claude Opus 4.6"
description: "Single-pass UI verification: compare implementation against Figma and report differences."
---

Perform a single verification pass comparing the current implementation against the Figma design. Report all differences found — do not fix code.

This prompt can be used standalone (user invokes directly) or the same verification is performed when `tsh-ui-reviewer` is called as a subagent from `tsh-implement-ui`.

## Required Skills

Before starting, load and follow these skills:

- `tsh-ui-verifying` - verification process, criteria, tolerances, severity definitions, report format

## Workflow

Follow the 5-step verification process defined in the `tsh-ui-verifying` skill. The skill contains the complete workflow including:

1. Validate inputs (Figma URL + running dev server)
2. Get EXPECTED from Figma via `figma-mcp-server`
3. Get ACTUAL from implementation via `playwright` — structure, actual rendered dimensions, and visual screenshot
4. Compare following the skill's verification categories and tolerances
5. Generate structured report following the skill's report format

The Figma design is the **source of truth** for every comparison. When in doubt, the design wins.
