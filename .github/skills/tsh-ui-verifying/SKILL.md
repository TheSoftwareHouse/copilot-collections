---
name: tsh-ui-verifying
description: UI verification criteria, structure checklists, severity definitions, and tolerance rules for comparing implementations against Figma designs. Use for verifying UI matches design, understanding what to check, and determining acceptable differences.
---

# UI Verification

Verification process, criteria, and tolerances for comparing UI implementations against Figma designs.

## Verification Process

Use the checklist below and track your progress:

```
Progress:
- [ ] Step 1: Validate inputs
- [ ] Step 2: Get EXPECTED from Figma
- [ ] Step 3: Get ACTUAL from implementation
- [ ] Step 4: Compare using verification categories
- [ ] Step 5: Generate report
```

**Step 1: Validate inputs**

Before starting verification, confirm:

- Figma URL is available for the component/section being verified
- Dev server URL is known:
  - Check the project configuration (`package.json` scripts, `.env`, `vite.config`, `next.config`, etc.) for the configured port
  - On first verification in a session, **ask the user to confirm** the dev server URL (e.g., "I detected port 3001 from package.json — is the app running at http://localhost:3001?"). The user can correct it if needed.
  - Use the confirmed URL for all subsequent verifications in the same session
- Dev server is running and the page is accessible at that URL
- If any input is missing, stop and ask the user — do not proceed without all three (Figma URL, confirmed dev server URL, accessible page)

**Step 2: Get EXPECTED from Figma**

Use `figma-mcp-server` to extract the design specifications:

- Layer hierarchy and component structure
- Layout direction, alignment, spacing
- Frame widths relative to page — these determine whether containers should be narrow/centered or full-width
- Typography, colors, radii, shadows
- Component variants and states

**Step 3: Get ACTUAL from implementation**

Use `playwright` to capture the running implementation. You MUST collect **all three** types of data — a verification that skips any type is incomplete:

1. **Structure & content** — element hierarchy, order, grouping (via accessibility snapshot)
2. **Actual rendered dimensions** — computed widths, heights, paddings, margins, gaps of every major container (via JavaScript evaluation of computed styles). This is the most commonly missed step — without it you cannot detect sizing/layout differences.
3. **Visual appearance** — full-page screenshot for side-by-side comparison with the design

> **CRITICAL**: The accessibility tree does NOT contain CSS dimensions. A full-width container and a narrow centered container produce identical accessibility trees. If you only collected structure without measuring actual rendered dimensions, your verification is INVALID — mark confidence as LOW and report what's missing.

**Step 4: Compare using verification categories**

Compare EXPECTED (Figma) against ACTUAL (implementation) following the Verification Order and Categories below. The Figma design is the **source of truth** for every comparison. When in doubt, the design wins.

**Step 5: Generate report**

Produce a structured report following the Report Format below. Include exact values from both Figma and implementation for every difference found.

## Verification Order

Always verify in this order — stop and report on first CRITICAL failure:

1. **Structure** (CRITICAL)
2. **Layout** (CRITICAL)
3. **Dimensions** (CRITICAL)
4. **Visual** (CRITICAL)
5. **Components**

## Verification Categories

### Structure (CRITICAL)

| Check                   | Description                                              |
| ----------------------- | -------------------------------------------------------- |
| **Container hierarchy** | Does DOM structure match Figma's layer hierarchy?        |
| **Nesting depth**       | Are elements nested at the same level as in Figma?       |
| **Grouping**            | Are related elements grouped together as in design?      |
| **Element order**       | Is the visual order of elements the same?                |
| **Wrapper elements**    | Are there extra/missing wrapper divs that change layout? |
| **Sections present**    | Are ALL sections from Figma present in implementation?   |

### Layout (CRITICAL)

| Check                   | Description                                        |
| ----------------------- | -------------------------------------------------- |
| **Flex/Grid direction** | row vs column, wrap behavior                       |
| **Alignment**           | justify-content, align-items values                |
| **Distribution**        | How space is distributed between elements          |
| **Positioning**         | relative, absolute, fixed - matches design intent? |
| **Centering**           | Is content centered as in design?                  |

### Dimensions (CRITICAL)

| Check                        | Description                                  |
| ---------------------------- | -------------------------------------------- |
| **Container width**          | max-width, fixed width constraints           |
| **Card/panel boundaries**    | Does card have same width as in Figma?       |
| **Content area vs viewport** | Ratio of content width to available space    |
| **Width/Height**             | Fixed, percentage, auto, min/max constraints |
| **Spacing**                  | Padding, margin, gap between elements        |
| **Gaps**                     | Space between flex/grid children             |

> **WARNING**: Accessibility tree does NOT contain CSS dimensions. A full-width container and a narrow centered one look identical in it. You must measure actual computed styles to detect width/sizing differences.

### Visual

| Check           | Description                                            |
| --------------- | ------------------------------------------------------ |
| **Typography**  | font-family, size, weight, line-height, letter-spacing |
| **Colors**      | Text, background, border colors                        |
| **Radii**       | border-radius values                                   |
| **Shadows**     | box-shadow, drop-shadow                                |
| **Backgrounds** | Solid, gradient, image                                 |

### Components

| Check                | Description                                     |
| -------------------- | ----------------------------------------------- |
| **Correct variants** | Is the right variant of a component used?       |
| **Design tokens**    | Are correct tokens used (not hardcoded values)? |
| **States**           | hover, focus, active, disabled states           |

## Tolerances

| Category         | Tolerance       | Notes                                |
| ---------------- | --------------- | ------------------------------------ |
| Structure        | **None**        | Any structural difference = FAIL     |
| Layout direction | **None**        | row vs column must match exactly     |
| Alignment        | **None**        | Centering, justify, align must match |
| Dimensions       | **1-2px**       | Only for browser rendering variance  |
| Colors           | **Exact match** | Must use correct design tokens       |
| Typography       | **Exact match** | Font properties must match           |
| Spacing          | **1-2px**       | Only for browser rendering variance  |

## Severity Definitions

| Severity     | Description                                        | Action                            |
| ------------ | -------------------------------------------------- | --------------------------------- |
| **Critical** | Structure/layout differences, wrong component used | Must fix immediately              |
| **Major**    | Dimensions off by >2px, wrong colors/typography    | Must fix before merge             |
| **Minor**    | 1-2px browser rendering variance                   | Acceptable, document if recurring |

## Verification Checklist

Before reporting PASS:

- [ ] Verified ENTIRE page (scrolled from top to bottom)
- [ ] All sections from Figma are present in implementation
- [ ] Container hierarchy matches Figma layers
- [ ] Flex/grid direction is correct
- [ ] Alignment (justify/align) matches design
- [ ] Element order matches design
- [ ] No extra/missing wrapper elements that change layout
- [ ] Actual computed container widths measured (not inferred from accessibility tree)
- [ ] Full-page screenshot taken and visually compared against Figma

## Report Format

```markdown
## Verification Result: [PASS | FAIL]

### Component: [name]

**Confidence:** [HIGH | MEDIUM | LOW]

### Differences

| Property | Expected (Figma) | Actual (Implementation) | Severity   |
| -------- | ---------------- | ----------------------- | ---------- |
| [prop]   | [expected]       | [actual]                | [severity] |

### Recommended Fixes

- [specific fix with exact values]
```

**Confidence levels:**

- **HIGH** — Both Figma and implementation data complete, comparison is reliable
- **MEDIUM** — Some values couldn't be extracted, manual review recommended
- **LOW** — Tool errors occurred, manual verification required before making changes

## Connected Skills

- `tsh-implementing-frontend` - for implementing fixes following design system patterns
- `tsh-technical-context-discovering` - for understanding project's design token conventions
