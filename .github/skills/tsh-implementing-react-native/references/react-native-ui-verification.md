# React Native UI Verification

UI verification patterns for the `tsh-implementing-react-native` skill. Load this reference when verifying that a React Native implementation matches the Figma design. Replaces `tsh-ui-verifying` which requires Playwright and a browser — not applicable for native mobile apps.

## Table of Contents

- [Verification Process](#verification-process)
- [Capturing Implementation State](#capturing-implementation-state)
- [Comparison Criteria](#comparison-criteria)
- [Tolerances](#tolerances)
- [Visual Regression Testing](#visual-regression-testing)
- [Report Format](#report-format)

## Verification Process

```
Progress:
- [ ] Step 1: Validate inputs
- [ ] Step 2: Get EXPECTED from Figma
- [ ] Step 3: Get ACTUAL from running app
- [ ] Step 4: Compare using verification categories
- [ ] Step 5: Generate report
```

**Step 1: Validate inputs**

Before starting verification, confirm:

- Figma URL is available for the component/screen being verified.
- The app is running on a simulator/emulator or physical device.
- **Ask the user**: "Which platform should I verify against — iOS Simulator, Android Emulator, or both?" and "Is the app running and on the correct screen?"
- If the Figma design has separate iOS and Android frames, verify against the platform-specific frame.
- If any input is missing, **stop and ask** — do not proceed with assumptions.

**Step 2: Get EXPECTED from Figma**

Use `figma-mcp-server` to extract design specifications:

- Component hierarchy and grouping
- Layout direction, alignment, spacing
- Frame dimensions — determine whether containers are full-width, fixed-width, or content-hugging
- Typography: font family, size, weight, line height, letter spacing
- Colors: text, background, border (map to design tokens)
- Corner radii, shadows/elevation
- Component variants and states (pressed, disabled, loading, error, empty)
- Platform-specific differences between iOS and Android frames (if present)

**Step 3: Get ACTUAL from running app**

Since Playwright cannot interact with native apps, use these methods:

### Screenshots

- **iOS Simulator**: `xcrun simctl io booted screenshot <filename>.png`
- **Android Emulator**: `adb exec-out screencap -p > <filename>.png`
- **Expo Go / Dev Client**: Shake device → "Take Screenshot" (saves to device gallery)

Save screenshots with descriptive names: `<component>-<platform>-<state>-iteration-<n>.png`
Example: `product-card-ios-default-iteration-1.png`

### Layout Inspection

Without Playwright's computed styles, verify layout through:

1. **Code review**: Inspect the style definitions — check flex direction, alignment, spacing values, dimensions against Figma specs.
2. **React Native DevTools**: Use the element inspector (shake → "Toggle Inspector") to tap elements and view their computed layout (margin, padding, dimensions).
3. **Visual comparison**: Place screenshot side-by-side with Figma frame export at the same dimensions.

### Content and Structure

1. **Component tree review**: Read the component JSX to verify element hierarchy matches Figma's layer structure.
2. **React Native DevTools**: Component tree inspector shows the runtime hierarchy.

**Step 4: Compare using verification categories**

Compare EXPECTED (Figma) against ACTUAL (implementation). Complete ALL categories in a single pass.

### Structure

| Check | How to verify |
|-------|---------------|
| Component hierarchy | Code review: does JSX nesting match Figma layer tree? |
| Grouping | Are related elements wrapped in the same parent `View`? |
| Element order | Does render order match visual order in Figma? |
| Sections present | Are ALL sections from Figma present in the implementation? |
| Conditional states | Are loading, error, and empty states implemented? |

### Layout

| Check | How to verify |
|-------|---------------|
| Flex direction | Code: `flexDirection` matches Figma's auto-layout direction |
| Alignment | Code: `alignItems`, `justifyContent` match Figma alignment |
| Spacing | Code: `gap`, `padding`, `margin` values match Figma spacing |
| Distribution | Code: `flex: 1` or fixed sizes match Figma's distribution |
| Safe areas | Screens near edges use `SafeAreaView` or safe area hooks |

### Dimensions

| Check | How to verify |
|-------|---------------|
| Fixed sizes | Code: explicit `width`/`height` match Figma (convert px to dp) |
| Flex sizing | Code: `flex` values produce correct proportions |
| Min/max constraints | Code: `minHeight`, `maxWidth` match design constraints |
| Touch targets | Code: minimum 44×44 pt (iOS) / 48×48 dp (Android) |
| Aspect ratios | Code: `aspectRatio` prop or calculated dimensions match |

### Visual

| Check | How to verify |
|-------|---------------|
| Typography | Code: font family, size, weight, lineHeight, letterSpacing match tokens |
| Colors | Code: text, background, border colors use correct design tokens |
| Corner radii | Code: `borderRadius` values match Figma |
| Shadows / Elevation | Code: iOS `shadow*` props or Android `elevation` match design |
| Backgrounds | Code: solid colors, gradients (LinearGradient) match |

### Components

| Check | How to verify |
|-------|---------------|
| Correct variants | Code: the right component variant/props are used |
| Design tokens | Code: no hardcoded values — all visual values from theme |
| States | Code: pressed, focused, disabled styles implemented |
| Platform differences | Code: platform-specific rendering where design differs |

**Step 5: Generate report**

Produce a structured report following the Report Format below.

## Tolerances

| Category | Tolerance | Notes |
|----------|-----------|-------|
| Structure | **None** | Missing sections or wrong hierarchy = FAIL |
| Layout direction | **None** | row vs column must match exactly |
| Alignment | **None** | Centering, justify, align must match |
| Dimensions | **1-2 dp** | Platform rendering variance only |
| Colors | **Exact match** | Must use correct design tokens |
| Typography | **Exact match** | Font properties must match tokens |
| Spacing | **1-2 dp** | Platform rendering variance only |
| Shadows | **Approximate** | iOS and Android render shadows differently — match intent |

## Visual Regression Testing

For automated visual regression in CI, use one of these tools:

### Maestro (recommended for Expo)

```yaml
# .maestro/visual-test.yaml
appId: com.example.app
---
- launchApp
- navigateTo: "/product/123"
- takeScreenshot: "product-screen"
- assertVisual:
    screenshot: "product-screen"
    threshold: 0.01  # 1% pixel difference tolerance
```

### Detox (for projects already using Detox)

```typescript
it('matches product card design', async () => {
  await element(by.id('product-card')).toBeVisible();
  await device.takeScreenshot('product-card-default');
  // Compare against baseline in CI
});
```

### Manual Baseline Process

When no automated tool is configured:

1. Export the Figma frame as PNG at 1x, 2x, 3x scales.
2. Take a screenshot of the running app at the matching scale.
3. Use image diff tools (`pixelmatch`, `reg-suit`, or visual diff in Figma) to compare.
4. Acceptable threshold: < 1% pixel difference (excluding platform-specific rendering like font anti-aliasing and shadow rendering).

## Report Format

```markdown
## Verification Result: [PASS | FAIL]

### Screen/Component: [name]
### Platform: [iOS / Android / Both]

**Confidence:** [HIGH | MEDIUM | LOW]

### Differences

| Property | Expected (Figma) | Actual (Implementation) | Severity | How Verified |
|----------|-----------------|------------------------|----------|--------------|
| [prop]   | [expected]      | [actual]               | [severity] | [code review / screenshot / inspector] |

### Recommended Fixes

- [specific fix with exact values and file path]
```

**Severity definitions:**

| Severity | Description | Action |
|----------|-------------|--------|
| Critical | Wrong structure, missing sections, wrong layout direction | Must fix immediately |
| Major | Dimensions off by >2dp, wrong colors/typography tokens | Must fix before merge |
| Minor | 1-2dp platform rendering variance, shadow approximation | Acceptable, document |

**Confidence levels:**

- **HIGH** — Figma specs extracted, code inspected, screenshot compared
- **MEDIUM** — Code review only, no screenshot comparison
- **LOW** — Partial verification, manual review recommended
