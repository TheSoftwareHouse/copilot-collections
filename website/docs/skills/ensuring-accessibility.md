---
sidebar_position: 27
title: Ensuring Accessibility
---

# Ensuring Accessibility

**Folder:** `.github/skills/tsh-ensuring-accessibility/`  
**Used by:** Software Engineer

Provides WCAG 2.1 AA compliance guidelines covering semantic HTML, ARIA patterns, keyboard navigation, focus management, screen reader support, and color contrast requirements.

## Key Areas

| Area                    | Coverage                                                                  |
| ----------------------- | ------------------------------------------------------------------------- |
| **Semantic HTML**       | Correct element usage (`<button>`, `<nav>`, `<main>`, `<dialog>`, etc.)   |
| **ARIA**                | Roles, states, properties — only when semantic HTML is insufficient       |
| **Keyboard Navigation** | Tab order, focus traps for modals, arrow key patterns for composites      |
| **Focus Management**    | Visible focus indicators, focus restoration after dynamic content changes |
| **Screen Readers**      | Live regions, announcements, accessible names and descriptions            |
| **Color Contrast**      | 4.5:1 for normal text, 3:1 for large text and UI components               |

## When to Use

- Implementing accessible components (forms, modals, tabs, menus).
- Auditing frontend code for a11y compliance.
- Building inclusive forms and interactive widgets.
- Reviewing code for WCAG violations.

## Connected Skills

- `tsh-implementing-frontend` — Component patterns and design system usage.
- `tsh-implementing-forms` — Accessible form patterns and validation.
- `tsh-reviewing-frontend` — Accessibility spot-checks during code review.
