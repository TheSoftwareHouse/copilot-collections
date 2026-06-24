---
sidebar_position: 11
title: UI Verification
---

**Folder:** `.github/skills/tsh-ui-verifying/`  
**Used by:** UI Engineer, UI Reviewer, UI Capture Worker

Provides detailed criteria for comparing UI implementations against Figma designs, with severity definitions, tolerance rules, and structured report formats.

## Verification Process

The current verification flow has five steps:

1. **Validate inputs**: confirm the Figma URL, confirm the exact full dev server URL with the user for standalone runs or reuse the caller-provided confirmed URL unchanged for delegated runs, and make sure the target page is reachable through the CLI capture flow using that pinned URL.
2. **Get EXPECTED from Figma**: MANDATORY before capture — export the Figma node image and save it as `figma-expected.png` into the iteration directory, then extract structure, layout, dimensions, and visual specifications. If Figma cannot be fetched or `figma-expected.png` cannot be saved, the result is `VERIFICATION NOT RUN`.
3. **Get ACTUAL from implementation**: the capture worker owns viewport sizing, page loading, render stabilization, and evidence collection through the CLI-first capture flow.
4. **Compare using verification categories**: review EXPECTED versus ACTUAL across structure, layout, dimensions, visual, and component categories.
5. **Generate the report**: summarize all differences with exact expected and actual values plus severity.

## CLI-First Capture

The current verification flow is CLI-first for ACTUAL evidence collection. Figma remains the EXPECTED source of truth, while the running implementation is captured into an iteration artifact directory that the reviewer consumes.

- **Ownership boundary:** the capture worker handles viewport/page-loading mechanics and produces the ACTUAL artifacts; the reviewer consumes those artifacts and judges differences against Figma.
- **Pinned URL contract:** once the user confirms the full dev server URL, that exact URL is pinned for the session and must be forwarded unchanged to every capture and review pass.
- **Capture contract:** collect fresh `figma-expected.png`, `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml` for each verification pass, writing every file into the iteration directory with explicit paths. Never leave artifacts in `.playwright-cli/` or the working directory. Code reading is not a substitute for live capture.
- **Artifact directory:** store each pass under `specifications/<task-id>/ui-verification/iteration-<N>/`, alongside `figma-expected.png`, `report.md`, and optional `pixel-gate/` outputs.
- **Render stabilization:** use the pinned app URL only, resize to the Figma frame width, wait for `networkidle`, and emulate reduced motion before capture.
- **Optional tripwire:** `toHaveScreenshot` can add loose, non-blocking evidence under `pixel-gate/`, but it never replaces reviewer judgment.

UI verification is a separate gate from code review. Code review does not start until the UI gate is closed by PASS or an explicit, user-acknowledged escalation.

## Exit Codes and Escalation

- Non-zero `playwright-cli open` or `playwright-cli goto` is a pre-verification blocker, not a reason to continue silently.
- Login redirect, auth wall, unexpected page content, wrong page state, or a missing target component at the confirmed URL must escalate to the user before verification continues.
- If capture is blocked or incomplete, the result is `VERIFICATION NOT RUN`, not PASS, FAIL, or a partial pass.
- `VERIFICATION NOT RUN` is a blocker-resolution path and does not consume the 5-iteration verification budget.
- Tripwire exit codes from optional screenshot assertions are evidence, not verdicts: exit `0` suggests loose visual alignment, exit `1` shows visual difference to review.

## Iteration Loop and PASS Gate

- **Multi-pass loop:** a single FAIL is never terminal. The engineer fixes all reported differences, recaptures fresh artifacts, and re-verifies, looping until PASS or 5 completed iterations. After 5 iterations with remaining mismatches, a structured `vscode/askQuestions` gate offers continue-with-N, stop-as-ESCALATED, or a custom instruction.
- **Enumerate everything per pass:** each verification pass reports every difference across all categories, not just the first one, so fixes batch into fewer iterations.
- **Strict PASS gate:** PASS requires `figma-expected.png`, `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml` for the pass to exist, and zero structure/layout differences with dimensions within 1–2px, each backed by cited measured evidence. Layout and structure mismatches are CRITICAL and can never be accepted as "close enough".

## Verification Categories

| Category       | What to Check                                           |
| -------------- | ------------------------------------------------------- |
| **Structure**  | Container hierarchy, element nesting, grouping          |
| **Layout**     | Flex direction, alignment, positioning                  |
| **Dimensions** | Width, height, padding, margin, gap                     |
| **Visual**     | Typography, colors, border radius, shadows, backgrounds |
| **Components** | Correct variants, design tokens, interaction states     |

## Severity Definitions

| Severity     | Definition                                     | Examples                                                          |
| ------------ | ---------------------------------------------- | ----------------------------------------------------------------- |
| **Critical** | Structural or layout mismatches                | Wrong container hierarchy, missing sections, wrong flex direction |
| **Major**    | Dimension differences >2px, wrong colors/fonts | Padding 24px vs 16px, wrong font weight                           |
| **Minor**    | 1-2px browser rendering variance               | 15px vs 16px due to subpixel rendering                            |

## Tolerance Rules

| Property                     | Tolerance                                   |
| ---------------------------- | ------------------------------------------- |
| Structure / hierarchy        | **None** — must match exactly               |
| Layout direction / alignment | **None** — must match exactly               |
| Colors                       | **None** — must match exactly               |
| Typography (font, weight)    | **None** — must match exactly               |
| Dimensions / spacing         | **1-2px** — browser rendering variance only |

## Common Mistakes

| Mistake                     | Explanation                                   |
| --------------------------- | --------------------------------------------- |
| Skipping structure check    | Structure issues affect everything downstream |
| Only checking colors        | Dimensions and layout are more impactful      |
| Ignoring hover/focus states | Interactive states are part of the design     |
| Not scrolling full page     | Bottom sections often get missed              |
| Assuming responsive         | Check the specific viewport from design       |
| Accepting "close enough"    | Report exact values, let SE decide            |

## Report Format

Reports use the following structure:

- **Result:** PASS, FAIL, or VERIFICATION NOT RUN
- **Confidence:** HIGH / MEDIUM / LOW
- **Evidence:** Figma EXPECTED plus CLI-captured ACTUAL artifacts
- **Structural Issues** — Table of layout/hierarchy mismatches (CRITICAL)
- **Dimension/Visual Differences** — Table with expected, actual, severity
- **Recommended Fixes** — Specific actions with exact values

When the structure, layout, and visual fidelity are otherwise aligned, but the remaining gaps are limited to content, data, or state values that may vary by environment, locale, seed data, or user state, summarize those differences and ask the user whether they are intentional. Do not escalate those cases as automatic hard UI defects until the user confirms they should match Figma exactly.

After any UI fix from a verification finding, re-run capture and re-run verification on the new artifacts before marking the item PASS.

The post-5-iteration continue/stop/custom escalation gate is reserved for genuine exhausted verify-fix loops after real FAIL results. It does not apply to missing URL, capture, auth, or page-state blockers.

:::warning Never Guess — Always Ask
If you cannot determine whether a difference is intentional or a bug, report it and ask. Do not make assumptions about design intent.
:::
