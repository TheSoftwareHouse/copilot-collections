---
sidebar_position: 6
title: Frontend Implementation
---

# Frontend Implementation

**Folder:** `.github/skills/frontend-implementation/`  
**Used by:** Software Engineer

Provides comprehensive frontend guidelines covering component design, design system usage, accessibility, and performance.

## Component Design Principles

- **Reusable** — Build components that can be composed and reused.
- **Extend, don't duplicate** — Wrap existing components instead of copying.
- **Single responsibility** — Each component does one thing well.

## Design System Usage

A 5-step token mapping process:

1. Identify the visual property in the Figma design.
2. Find the corresponding design token in the codebase.
3. Map the Figma value to the closest existing token.
4. If no token exists, ask before creating a new one.
5. **Never hardcode** color, spacing, or typography values.

## Accessibility Requirements

| Requirement | Details |
|---|---|
| **Semantic HTML** | Use correct elements (`<button>`, `<nav>`, `<main>`, etc.) |
| **ARIA** | Add ARIA attributes where semantic HTML is insufficient |
| **Keyboard navigation** | All interactive elements must be keyboard accessible |
| **Color contrast** | Minimum 4.5:1 for normal text, 3:1 for large text |
| **Focus management** | Visible focus indicators on all interactive elements |

## Performance Guidelines

| Area | Approach |
|---|---|
| **DOM** | Minimize DOM depth, use virtual lists for large datasets |
| **Rendering** | Avoid unnecessary re-renders, use `React.memo` and `useMemo` appropriately |
| **Assets** | Optimize images, lazy-load below-the-fold content |
| **React-specific** | Use `useCallback` for event handlers, avoid inline objects in JSX |

## Anti-Patterns

| Anti-Pattern | Correction |
|---|---|
| Hardcoded colors/spacing | Use design tokens |
| `div` for buttons | Use `<button>` element |
| Missing alt text on images | Always provide descriptive alt text |
| Inline styles | Use CSS modules or design system classes |
| God components (500+ lines) | Split into smaller, focused components |
| CSS `!important` | Fix specificity issues at the source |
| Missing error boundaries | Wrap feature sections in error boundaries |

## Connected Skills

- `ui-verification` — Verification criteria and tolerances.
- `technical-context-discovery` — Project conventions.

:::warning Never Guess — Always Ask
If a design specification is unclear, a token is missing, or behavior is ambiguous, stop and ask. Do not guess or make assumptions about design intent.
:::
