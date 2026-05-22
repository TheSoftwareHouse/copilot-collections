# Audit Report Example

Use this template when generating technical accessibility audit reports.

---

# Accessibility Audit Report

- **URL/Project:** [name or URL]
- **Audit Type:** External / Internal
- **Standard:** WCAG 2.2 Level AA
- **Date:** [date]

## 🔴 Critical Issues (Must Fix)

| # | Issue | WCAG SC | Location | Recommendation |
|---|-------|---------|----------|----------------|
| 1 | [Issue description] | [e.g., 1.1.1 Non-text Content] | [Element or page location] | [Specific fix recommendation] |

## 🟠 Serious Issues (Should Fix)

| # | Issue | WCAG SC | Location | Recommendation |
|---|-------|---------|----------|----------------|
| 1 | [Issue description] | [e.g., 1.4.3 Contrast (Minimum)] | [Element or page location] | [Specific fix recommendation] |

## 🟡 Moderate Issues

| # | Issue | WCAG SC | Location | Recommendation |
|---|-------|---------|----------|----------------|
| 1 | [Issue description] | [e.g., 1.3.1 Info and Relationships] | [Element or page location] | [Specific fix recommendation] |

## 🔵 Minor Issues

| # | Issue | WCAG SC | Location | Recommendation |
|---|-------|---------|----------|----------------|
| 1 | [Issue description] | [e.g., 3.1.2 Language of Parts] | [Element or page location] | [Specific fix recommendation] |

## 🟢 Passed Checks

- [List what passed, e.g., All images have descriptive alt text]
- [e.g., Keyboard navigation reaches all interactive elements]
- [e.g., Page has proper landmark regions]

## 📋 Manual Testing Required

- [Items that need human/AT testing, e.g., Screen reader flow verification]
- [e.g., Complex interaction pattern with drag-and-drop]

## Automated Tools Summary

- **pa11y:** [X] errors, [Y] warnings
- **axe:** [X] violations ([X] critical, [X] serious, [X] moderate, [X] minor)
- **Lighthouse:** accessibility score [X]/100
- **html-validate:** [X] errors
- **accessibility-checker:** [X] violations
