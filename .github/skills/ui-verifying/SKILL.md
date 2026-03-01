---
name: ui-verifying
description: UI verification criteria, structure checklists, severity definitions, and tolerance rules for comparing implementations against Figma designs. Use for verifying UI matches design, understanding what to check, and determining acceptable differences.
---

# UI Verification

This skill provides criteria and guidelines for verifying that UI implementations match Figma designs. It defines what to verify, severity levels, and acceptable tolerances.

## When to Use

- When verifying UI implementation against Figma designs
- When performing self-verification before code review
- When reviewing frontend changes that involve visual elements
- When determining if a difference is a bug or acceptable variance

## Verification Categories

### Structure (CRITICAL - never ignore)

Structure differences are **automatic failures**. Always verify:

| Check                   | Description                                              |
| ----------------------- | -------------------------------------------------------- |
| **Container hierarchy** | Does DOM structure match Figma's layer hierarchy?        |
| **Nesting depth**       | Are elements nested at the same level as in Figma?       |
| **Grouping**            | Are related elements grouped together as in design?      |
| **Element order**       | Is the visual order of elements the same?                |
| **Wrapper elements**    | Are there extra/missing wrapper divs that change layout? |
| **Sections present**    | Are ALL sections from Figma present in implementation?   |

### Layout (CRITICAL - never ignore)

| Check                   | Description                                        |
| ----------------------- | -------------------------------------------------- |
| **Flex/Grid direction** | row vs column, wrap behavior                       |
| **Alignment**           | justify-content, align-items values                |
| **Distribution**        | How space is distributed between elements          |
| **Positioning**         | relative, absolute, fixed - matches design intent? |
| **Centering**           | Is content centered as in design?                  |

### Dimensions (CRITICAL - never ignore)

| Check                        | Description                                  |
| ---------------------------- | -------------------------------------------- |
| **Container width**          | max-width, fixed width constraints           |
| **Card/panel boundaries**    | Does card have same width as in Figma?       |
| **Content area vs viewport** | Ratio of content width to available space    |
| **Width/Height**             | Fixed, percentage, auto, min/max constraints |
| **Spacing**                  | Padding, margin, gap between elements        |
| **Gaps**                     | Space between flex/grid children             |

**CRITICAL**: If a card/container in Figma is narrow and centered, but implementation shows it wider or full-width, this MUST be reported.

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

## Severity Definitions

| Severity     | Description                                        | Action                            |
| ------------ | -------------------------------------------------- | --------------------------------- |
| **Critical** | Structure/layout differences, wrong component used | Must fix immediately              |
| **Major**    | Dimensions off by >2px, wrong colors/typography    | Must fix before merge             |
| **Minor**    | 1-2px browser rendering variance                   | Acceptable, document if recurring |

## Tolerance Rules

| Category         | Tolerance       | Notes                                |
| ---------------- | --------------- | ------------------------------------ |
| Structure        | **None**        | Any structural difference = FAIL     |
| Layout direction | **None**        | row vs column must match exactly     |
| Alignment        | **None**        | Centering, justify, align must match |
| Dimensions       | **1-2px**       | Only for browser rendering variance  |
| Colors           | **Exact match** | Must use correct design tokens       |
| Typography       | **Exact match** | Font properties must match           |
| Spacing          | **1-2px**       | Only for browser rendering variance  |

## CRITICAL: Never Guess - Always Ask

**If you are unsure about ANYTHING, STOP and ask the user.**

Check your available tools for a way to ask the user questions (e.g., a tool that allows user interaction or questions). Use it to get the missing information before continuing.

This skill requires comparing the actual implementation against the expected design. If you cannot reliably get either side of that comparison, you cannot do your job. Do not guess. Do not assume. Do not continue hoping it will work out.

**The rule is simple:**

- If something is missing → ask
- If something is broken → ask
- If something is unexpected → ask
- If you're not 100% sure you're looking at the right thing → ask

**Never:**

- Continue working based on assumptions
- Make up data you couldn't retrieve
- Skip steps because something didn't work
- "Work around" missing information

## Pre-Verification Checklist

Before starting verification:

- [ ] Figma URL available for the component/view
- [ ] Dev server is running
- [ ] Page fully loaded (no skeleton states)
- [ ] Correct viewport size set

## Structure Verification Checklist

Before reporting PASS, verify:

- [ ] **Verified ENTIRE page** (scrolled from top to bottom)
- [ ] **All sections from Figma are present** in implementation
- [ ] Container hierarchy matches Figma layers
- [ ] Flex/grid direction is correct
- [ ] Alignment (justify/align) matches design
- [ ] Element order matches design
- [ ] No extra wrapper elements that change layout
- [ ] No missing container elements
- [ ] Spacing between elements matches design

## Common Mistakes to Catch

| Mistake                                 | Why It's Wrong                        |
| --------------------------------------- | ------------------------------------- |
| "It looks similar enough"               | Structure must match exactly          |
| "It's just an extra wrapper"            | Extra wrappers change layout behavior |
| "The alignment is close"                | Alignment must be exact               |
| "Only verified visible viewport"        | Must verify entire scrollable page    |
| "Assumed off-screen content is correct" | Must scroll and verify everything     |

## Verification Report Format

```markdown
## Verification Result: [PASS | FAIL]

### Component: [name]

**Confidence:** [HIGH | MEDIUM | LOW]

- HIGH: Both tools returned complete data, comparison is reliable
- MEDIUM: Some values could not be extracted, manual review recommended
- LOW: Tool errors occurred, treat as incomplete verification

### Structural Issues (CRITICAL)

| Issue   | Expected (Figma) | Actual (Implementation) |
| ------- | ---------------- | ----------------------- |
| [issue] | [expected]       | [actual]                |

### Dimension/Visual Differences

**Differences found:** [count]

| Property | Expected (Figma) | Actual (Implementation) | Severity               |
| -------- | ---------------- | ----------------------- | ---------------------- |
| [prop]   | [expected]       | [actual]                | [Critical/Major/Minor] |

### Recommended Fixes

- [specific fix with exact values]
```

## Confidence Levels

| Level      | Meaning                                     | Action                                                |
| ---------- | ------------------------------------------- | ----------------------------------------------------- |
| **HIGH**   | Both Figma and implementation data complete | Trust the report, fix all differences                 |
| **MEDIUM** | Some values couldn't be extracted           | Fix obvious differences, manually verify unclear ones |
| **LOW**    | Tool errors occurred                        | Manual verification required before making changes    |

## Connected Skills

- `implementing-frontend` - for implementing fixes following design system patterns
- `technical-context-discovering` - for understanding project's design token conventions
