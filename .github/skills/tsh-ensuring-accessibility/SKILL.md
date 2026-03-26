---
name: tsh-ensuring-accessibility
description: WCAG 2.1 AA compliance, semantic HTML, ARIA patterns, keyboard navigation, focus management, screen reader support, and color contrast requirements. Use when implementing accessible components, auditing UI for accessibility issues, reviewing frontend code for a11y compliance, or building inclusive forms and interactive widgets.
---

# Ensuring Accessibility

Provides WCAG 2.1 AA compliance patterns for building inclusive frontend interfaces with proper semantic markup, keyboard navigation, focus management, and screen reader support.

<principles>

<semantic-html-first>
Start with the correct HTML element. `<button>` for actions, `<a>` for navigation, `<nav>` for navigation regions, `<main>` for primary content. Native semantics are free, reliable, and require zero ARIA. Only reach for ARIA when HTML alone cannot convey the meaning.
</semantic-html-first>

<keyboard-is-mandatory>
Every interaction available to a mouse user must be available to a keyboard user. Tab, Escape, Enter, Space, Arrow keys — these are the vocabulary of keyboard interaction. Missing keyboard support is not a minor issue — it is a blocker for many users.
</keyboard-is-mandatory>

<never-color-alone>
Color must never be the sole means of conveying information. Error states need icons + text, not just red borders. Status indicators need labels, not just colored dots. Always pair visual indicators with non-visual alternatives.
</never-color-alone>

</principles>

## Accessibility Implementation Process

Use the checklist below and track your progress:

```
Progress:
- [ ] Step 1: Choose semantic elements
- [ ] Step 2: Implement keyboard navigation
- [ ] Step 3: Add ARIA where HTML falls short
- [ ] Step 4: Verify color and contrast
- [ ] Step 5: Test with assistive technology
```

**Step 1: Choose semantic elements**

Select the correct HTML element for each piece of UI:

- **Interactive elements**:
  - `<button>` — actions (submit, toggle, open menu)
  - `<a href>` — navigation to another page or location
  - `<input>`, `<select>`, `<textarea>` — form data entry
- **Landmarks**:
  - `<header>` — page or section header
  - `<nav>` — navigation region
  - `<main>` — primary content (one per page)
  - `<aside>` — tangentially related content
  - `<footer>` — page or section footer
- **Structure**:
  - `<article>` — self-contained composition
  - `<section>` — thematic grouping (must have a heading)
  - `<details>` / `<summary>` — native expand/collapse
- **Heading hierarchy**:
  - One `<h1>` per page
  - Logical nesting: `h2` → `h3` → `h4`
  - Never skip levels (e.g., `h2` → `h4`)
- **Lists**:
  - `<ul>` / `<ol>` for collections of items
  - `<dl>` for key-value pairs (definition lists)

If the component library wraps these elements, verify the rendered HTML output matches expectations using browser devtools.

**Step 2: Implement keyboard navigation**

All interactive elements must be focusable. Native interactive elements (`<button>`, `<a>`, `<input>`) are focusable by default. Custom interactive elements need `tabindex="0"`.

- **Tab order** must follow visual and logical reading order. Avoid `tabindex` values greater than 0 — they create unpredictable focus sequences.
- **Custom interactive components** need explicit keyboard handlers:

  | Component      | Keyboard behavior                                                |
  | -------------- | ---------------------------------------------------------------- |
  | Button         | Enter + Space to activate                                        |
  | Menu           | Arrow keys to navigate items, Escape to close, Enter to select   |
  | Tabs           | Left/Right arrows to switch tabs, Tab to leave the tab group     |
  | Dialog / Modal | Tab trapped inside, Escape to close                              |
  | Accordion      | Enter/Space to expand/collapse, Arrow keys between headers       |
  | Combobox       | Arrow keys to navigate options, Enter to select, Escape to close |

- **Focus visibility** — never remove the focus outline (`outline: none`) without providing a visible replacement. Custom focus styles must have at least 3:1 contrast against adjacent colors.
- **Programmatic focus management** — move focus when context changes:
  - Modal opens → focus the first focusable element inside
  - Modal closes → return focus to the element that triggered it
  - Route change → focus the new page heading or main content
  - Dynamic content added → focus the new content or announce it via `aria-live`

**Step 3: Add ARIA where HTML falls short**

Rule: prefer native HTML semantics. Only add ARIA when HTML cannot express the pattern.

Common patterns requiring ARIA:

- **Icon-only buttons**: Add `aria-label="Close"` (or the appropriate action description).
- **Expandable sections**: `aria-expanded="true"` or `aria-expanded="false"` on the trigger element.
- **Live updates**: `aria-live="polite"` for non-urgent updates (data refreshed, filter applied). `aria-live="assertive"` for urgent updates (session expiring, critical error).
- **Dialogs**: `aria-modal="true"`, `aria-labelledby` pointing to the dialog title, `aria-describedby` pointing to the dialog description.
- **Form errors**:
  - `aria-invalid="true"` on the invalid field
  - `aria-describedby` pointing to the error message element
  - Error container with `role="alert"` or `aria-live="assertive"` for immediate announcement
- **Loading states**: Container with `role="status"` for the loading message (e.g., "Loading results..."). Note: `role="status"` implicitly sets `aria-live="polite"` — no need to add both.
- **Current page in navigation**: `aria-current="page"` on the active nav link.
- **Progress indicators**: `role="progressbar"` with `aria-valuenow`, `aria-valuemin`, `aria-valuemax`.

Never do:

- `role="button"` on a `<div>` — use `<button>` instead
- ARIA that duplicates native semantics (e.g., `role="heading"` on an `<h2>`)
- `aria-label` on non-interactive, non-landmark elements (screen readers may ignore it)

**Step 4: Verify color and contrast**

| Element                                           | Minimum contrast ratio | Examples                                      |
| ------------------------------------------------- | ---------------------- | --------------------------------------------- |
| Normal text (< 24px)                              | 4.5:1                  | Body text, labels, captions, small links      |
| Large text (≥ 24px / 18pt, or ≥ 19px / 14pt bold) | 3:1                    | Headings, large labels, prominent links       |
| Interactive component boundaries                  | 3:1                    | Button borders, input outlines, toggle tracks |
| Non-text content conveying information            | 3:1                    | Status icons, chart segments, badges          |

Additional rules:

- Never convey information through color alone. Error states need an icon or text label in addition to color. Status indicators need a text label, not just a colored dot.
- Ensure focus indicators meet 3:1 contrast against the background.
- Test both light and dark themes if the application supports them.
- Verify disabled states are visually distinguishable but don't need to meet contrast minimums (WCAG exempts disabled controls).

**Step 5: Test with assistive technology**

Run through these verification steps:

1. **Keyboard walkthrough**:
   - Tab through the entire page. Is every interactive element reachable?
   - Is the focus order logical (matches visual layout)?
   - Is focus always visible?
   - Can you dismiss overlays with Escape? Navigate menus with arrows?

2. **Screen reader verification**:
   - Do headings, landmarks, buttons, links, and form fields announce correctly?
   - Are images described (alt text) or hidden (`alt=""` for decorative)?
   - Do dynamic changes announce via live regions?
   - Do form errors announce when they appear?

3. **Zoom and reflow**:
   - At 200% zoom, is text resizable without loss of content or functionality? (SC 1.4.4)
   - At 400% zoom (320px viewport width), does content reflow without horizontal scrolling? (SC 1.4.10)
   - Are touch targets generously sized? (44×44 CSS pixels recommended as best practice — not a WCAG 2.1 AA requirement)

4. **Accessibility tree inspection**:
   - Open browser devtools → Accessibility tab.
   - Verify the semantic structure matches the intended component roles.
   - Check that ARIA attributes are correctly applied and not conflicting.

5. **Automated accessibility testing** (agent-actionable):
   - Run axe-core CLI against the page: `npx @axe-core/cli <URL>`.
   - If the URL is not known, ask the user for the URL before running.
   - Parse the output and group violations by impact level (critical, serious, moderate, minor).
   - For each violation, report: rule ID, impact, affected elements, and recommended fix.
   - Re-run after fixes to confirm violations are resolved.

## ARIA Usage Quick Reference

| Need              | HTML Solution             | ARIA Fallback (only if HTML insufficient)       |
| ----------------- | ------------------------- | ----------------------------------------------- |
| Button            | `<button>`                | `role="button"` + `tabindex="0"` + key handlers |
| Link              | `<a href>`                | `role="link"` (rare)                            |
| Navigation region | `<nav>`                   | `role="navigation"`                             |
| Main content      | `<main>`                  | `role="main"`                                   |
| Dialog            | `<dialog>`                | `role="dialog"` + `aria-modal="true"`           |
| Live update       | —                         | `aria-live="polite"` on container               |
| Expand/collapse   | `<details>` / `<summary>` | `aria-expanded` on trigger                      |
| Icon-only button  | —                         | `aria-label` on the button                      |
| Form error        | —                         | `aria-invalid` + `aria-describedby`             |
| Current page      | —                         | `aria-current="page"` on nav link               |
| Progress          | `<progress>`              | `role="progressbar"` + `aria-valuenow`          |

## Contrast Requirements

| Element                                           | Minimum ratio | Example                        |
| ------------------------------------------------- | ------------- | ------------------------------ |
| Normal text (< 24px)                              | 4.5:1         | Body text, labels, captions    |
| Large text (≥ 24px / 18pt, or ≥ 19px / 14pt bold) | 3:1           | Headings, large labels         |
| Interactive component boundaries                  | 3:1           | Button borders, input outlines |
| Non-text (icons conveying info)                   | 3:1           | Status icons, chart segments   |

## Accessibility Checklist

```
Accessibility:
- [ ] Semantic HTML elements used (button, nav, main, etc.)
- [ ] One h1 per page, logical heading hierarchy (no skipped levels)
- [ ] All interactive elements keyboard-navigable
- [ ] Focus visible on every interactive element
- [ ] Tab order follows visual/logical layout
- [ ] Modal/dialog traps focus and returns on close
- [ ] Icon-only buttons have aria-label
- [ ] Form fields have visible labels (not placeholder-only)
- [ ] Form errors announced to screen readers (role="alert" or aria-live)
- [ ] Error states use icon/text in addition to color
- [ ] Color contrast meets 4.5:1 (normal text) / 3:1 (large text)
- [ ] ARIA landmarks present (header, main, nav, footer)
- [ ] Text resizable to 200% without loss of content (SC 1.4.4)
- [ ] Content reflows at 400% zoom / 320px width without horizontal scroll (SC 1.4.10)
```

## RTL / Bidirectional Text Support

| Rule                               | Description                                                                                     |
| ---------------------------------- | ----------------------------------------------------------------------------------------------- |
| Use logical CSS properties         | `margin-inline-start` instead of `margin-left`; `padding-inline-end` instead of `padding-right` |
| Let layout engine handle direction | Set `dir="rtl"` on root; avoid manual transforms for standard layout                            |
| Icons may need flipping            | Directional icons (arrows, progress bars) may need `transform: scaleX(-1)` in RTL               |
| Test both directions               | Verify layout, alignment, and text truncation in both LTR and RTL                               |

## Connected Skills

- `tsh-implementing-frontend` — for component composition patterns that support accessible structure
- `tsh-implementing-react-native` — for React Native accessibility (VoiceOver, TalkBack, accessibilityRole, accessibilityLabel)
- `tsh-implementing-forms` — for accessible form field patterns, labels, and error announcements
- `tsh-reviewing-frontend` — for accessibility spot-checks during code review
- `tsh-optimizing-frontend` — for performance optimizations that also impact accessibility (loading speed, interaction responsiveness)
