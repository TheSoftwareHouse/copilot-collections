---
sidebar_position: 11
title: UI Verification
---

# UI Verification

**Folder:** `.github/skills/ui-verification/`  
**Used by:** UI Reviewer, Software Engineer

Provides detailed criteria for comparing UI implementations against Figma designs, with severity definitions, tolerance rules, and structured report formats.

## Verification Categories

| Category | What to Check |
|---|---|
| **Structure** | Container hierarchy, element nesting, grouping |
| **Layout** | Flex direction, alignment, positioning |
| **Dimensions** | Width, height, padding, margin, gap |
| **Visual** | Typography, colors, border radius, shadows, backgrounds |
| **Components** | Correct variants, design tokens, interaction states |

## Severity Definitions

| Severity | Definition | Examples |
|---|---|---|
| **Critical** | Structural or layout mismatches | Wrong container hierarchy, missing sections, wrong flex direction |
| **Major** | Dimension differences >2px, wrong colors/fonts | Padding 24px vs 16px, wrong font weight |
| **Minor** | 1-2px browser rendering variance | 15px vs 16px due to subpixel rendering |

## Tolerance Rules

| Property | Tolerance |
|---|---|
| Structure / hierarchy | **None** — must match exactly |
| Layout direction / alignment | **None** — must match exactly |
| Colors | **None** — must match exactly |
| Typography (font, weight) | **None** — must match exactly |
| Dimensions / spacing | **1-2px** — browser rendering variance only |

## Pre-Verification Checklist

- [ ] Figma URL is available for the component.
- [ ] Development server is running.
- [ ] Target page is loaded and accessible.
- [ ] Viewport size matches the design's frame.

## Structure Verification Checklist

- [ ] Scrolled through the entire page.
- [ ] All sections/components are present.
- [ ] Container hierarchy matches Figma layer tree.
- [ ] Element order matches design.

## Common Mistakes

| Mistake | Explanation |
|---|---|
| Skipping structure check | Structure issues affect everything downstream |
| Only checking colors | Dimensions and layout are more impactful |
| Ignoring hover/focus states | Interactive states are part of the design |
| Not scrolling full page | Bottom sections often get missed |
| Assuming responsive | Check the specific viewport from design |
| Accepting "close enough" | Report exact values, let SE decide |

## Report Format

Reports use the following structure:

- **Result:** PASS or FAIL
- **Confidence:** HIGH / MEDIUM / LOW
- **Structural Issues** — Table of layout/hierarchy mismatches (CRITICAL)
- **Dimension/Visual Differences** — Table with expected, actual, severity
- **Recommended Fixes** — Specific actions with exact values

:::warning Never Guess — Always Ask
If you cannot determine whether a difference is intentional or a bug, report it and ask. Do not make assumptions about design intent.
:::
