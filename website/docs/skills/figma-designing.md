---
sidebar_position: 12
title: Figma Designing
---

# Figma Designing

**Folder:** `.github/skills/tsh-figma-designing/`  
**Used by:** Product Designer

Guides the creation and modification of Figma designs following established team conventions. Ensures designs use real Figma primitives (components, variables, auto-layout) connected to the design system.

## Core Principles

- **Design System First** — Always search the design system library before creating anything new. Reuse existing components and variables.
- **Real Primitives** — Every design must use components, variables, and auto-layout. Never create flat groups, detached instances, or unnamed layers.
- **Figma MCP Workflow** — All design operations go through the Figma MCP server's `use_figma` tool.

## 5-Step Design Creation Process

1. **Understand the context** — Read requirements, identify target Figma file, determine if new design or modification.
2. **Inspect the design system** — Catalog available components, variants, variables, and patterns.
3. **Plan the design structure** — Define frame hierarchy following team conventions. Map requirements to existing components.
4. **Build the design** — Create using auto-layout, component instances, and design system variables. Follow naming conventions.
5. **Validate the design** — Verify naming, variable usage, component connections, and UX compliance.

## Conventions Reference

The skill includes reference tables for:

| Convention                   | What It Covers                                                      |
| ---------------------------- | ------------------------------------------------------------------- |
| **Layer Naming**             | Pages, frames, sections, components, inner layers, spacing tokens   |
| **Section Organization**     | Cover, local components, screens, prototyping, archive              |
| **Component Creation Rules** | When to create, variant structure, auto-layout requirements, naming |

:::info Customization Required
The reference tables ship with example conventions. Replace them with your team's actual practices using the questionnaire at `references/team-figma-practices-template.md`.
:::

## Connected Skills

- `tsh-ux-reviewing` — Validating designs against UX laws and usability heuristics after creation.
- `tsh-prototyping-from-requirements` — End-to-end flow from requirements to Figma prototype.
- `tsh-ensuring-accessibility` — Accessibility aspects of designs (color contrast, touch targets).
- `tsh-ui-verifying` — Verifying implementations match designs created with this skill.
