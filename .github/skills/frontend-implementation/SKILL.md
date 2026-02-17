---
name: frontend-implementation
description: Frontend implementation patterns, accessibility requirements, design system usage, and performance guidelines. Use for implementing UI components, working with design tokens, ensuring a11y compliance, and building reusable frontend code.
---

# Frontend Implementation Patterns

This skill provides patterns and guidelines for implementing frontend features that are accessible, performant, maintainable, and consistent with the design system.

## When to Use

- Before implementing any UI component or feature
- When working with design systems and tokens
- When ensuring accessibility compliance
- When optimizing frontend performance

## Core Principles

### Component Design

- **Reusable over page-specific**: Implement composable UI components rather than tightly coupled page-specific code
- **Respect architecture boundaries**: Always follow the component hierarchy and boundaries defined in the implementation plan
- **Extend, don't duplicate**: Extend the existing design system and component library instead of creating parallel one-off styles
- **Single responsibility**: Each component should have one clear purpose

### Design System Usage

- **Use existing tokens**: Always use design tokens (colors, spacing, typography) from the project's design system
- **Map Figma values to tokens**: When Figma shows raw values (e.g., `#3B82F6`), map them to existing tokens (e.g., `--color-primary-500`)
- **Never hardcode values**: Avoid hardcoded colors, spacing, or typography values that bypass the design system
- **Document new tokens**: If a new token is absolutely required, document and justify it in the changelog

### Token Mapping Process

1. Extract value from Figma design
2. Search codebase for matching design token
3. If token exists → use it
4. If no exact match → find closest existing token and document deviation
5. If truly new → request architect approval before creating

## Accessibility Requirements

### Semantic Markup

- Use correct HTML elements for their semantic meaning (`<button>`, `<nav>`, `<main>`, `<article>`, etc.)
- Choose interactive elements appropriately (`<button>` for actions, `<a>` for navigation)
- Use heading hierarchy correctly (`<h1>` → `<h2>` → `<h3>`, no skipping levels)

### ARIA Usage

- **Prefer native semantics**: Use ARIA only when native HTML cannot convey the meaning
- **Follow ARIA patterns**: When ARIA is needed, follow WAI-ARIA Authoring Practices
- **Common patterns**:
  - `aria-label` for icon-only buttons
  - `aria-expanded` for collapsible sections
  - `aria-live` for dynamic content updates
  - `role` only when semantic HTML isn't available

### Keyboard Navigation

- All interactive elements must be focusable
- Tab order must follow visual/logical order
- Custom components need keyboard handlers (Enter, Space, Escape, Arrow keys as appropriate)
- Focus must be visible (never remove focus outline without replacement)
- Modal dialogs must trap focus

### Color & Contrast

- Minimum 4.5:1 contrast ratio for normal text
- Minimum 3:1 contrast ratio for large text (18px+ or 14px+ bold)
- Don't rely on color alone to convey information

## Performance Guidelines

### DOM Optimization

- Avoid unnecessary wrapper elements
- Keep DOM depth shallow where possible
- Use semantic elements that don't require extra wrappers

### Rendering Performance

- Avoid layout thrashing (batch DOM reads/writes)
- Use CSS transforms for animations (not `top`/`left`)
- Consider `will-change` for frequently animated elements
- Avoid expensive operations in render paths

### Asset Optimization

- Use appropriate image formats (WebP, SVG for icons)
- Implement lazy loading for below-fold images
- Consider code splitting for large components

### React-Specific (when applicable)

- Memoize expensive computations with `useMemo`
- Memoize callbacks with `useCallback` when passed to child components
- Use `React.memo` for pure presentational components
- Avoid creating objects/arrays in render (causes unnecessary re-renders)

## CRITICAL: Never Guess - Always Ask

**If you are unsure about ANYTHING, STOP and ask the user** using `vscode/askQuestions`.

Your job is to implement UI that matches the design exactly. If you don't have the design, credentials, tokens, or any other required information - you cannot do your job correctly. Do not guess. Do not assume. Do not improvise.

**The rule is simple:**

- If something is missing → ask
- If something is broken → ask
- If something is unexpected → ask
- If you're not 100% sure what to implement → ask

**Never:**

- Continue working based on assumptions
- Hardcode values you should look up
- Create new tokens/components without approval
- "Work around" missing information

## Component Implementation Checklist

Before marking a component complete, verify:

```
Accessibility:
- [ ] Semantic HTML elements used
- [ ] Keyboard navigable
- [ ] Focus states visible
- [ ] ARIA attributes added where needed
- [ ] Color contrast sufficient

Design System:
- [ ] Design tokens used (no hardcoded values)
- [ ] Existing components reused where possible
- [ ] Consistent with similar components in codebase

Performance:
- [ ] No unnecessary DOM nesting
- [ ] No expensive render operations
- [ ] Images optimized and lazy-loaded

Code Quality:
- [ ] Component is reusable (not page-specific)
- [ ] Props are well-typed and documented
- [ ] Edge cases handled (empty states, errors, loading)
```

## Anti-Patterns to Avoid

| Anti-Pattern                      | Instead Do                                        |
| --------------------------------- | ------------------------------------------------- |
| Hardcoded colors (`#3B82F6`)      | Use design tokens (`var(--color-primary-500)`)    |
| `<div>` for everything            | Use semantic elements (`<button>`, `<nav>`, etc.) |
| Removing focus outline            | Replace with visible custom focus style           |
| Creating similar components       | Extend existing component with variants           |
| Inline styles for theming         | Use CSS custom properties / design tokens         |
| `tabindex="0"` on non-interactive | Use interactive elements (`<button>`)             |
| Color-only error indication       | Add icons, text, or ARIA announcements            |

## Connected Skills

- `ui-verification` - for verifying implementation against Figma designs
- `technical-context-discovery` - for understanding project conventions before implementing
