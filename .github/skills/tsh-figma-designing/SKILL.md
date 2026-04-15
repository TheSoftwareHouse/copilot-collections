---
name: tsh-figma-designing
description: "Figma design creation patterns, team conventions, layer naming, section organization, component creation and reuse rules, auto-layout standards, and variable usage. Use when creating or modifying designs in Figma, building new components, extending the design system, or ensuring designs follow team practices."
---

# Designing in Figma

Guides the creation and modification of Figma designs following established team conventions. Ensures designs use real Figma primitives (components, variables, auto-layout) connected to the design system.

<principles>

<design-system-first>
Always search the design system library before creating anything new. Reuse existing components and variables. Only create new elements when nothing suitable exists — and then follow the design system's patterns for naming, variants, and token usage.
</design-system-first>

<real-primitives>
Every design must use real Figma primitives — components, component instances, variables, auto-layout. Never create flat groups, detached instances, or unnamed layers. Designs must be structured for developer handoff from day one.
</real-primitives>

<figma-mcp-workflow>
All design operations go through the Figma MCP server's `use_figma` tool. Always invoke the `figma-use` foundational skill before calling `use_figma`. Always pass `skillNames: "tsh-figma-designing"` for logging.
</figma-mcp-workflow>

</principles>

## Design Creation Process

Use the checklist below and track your progress:

```
Progress:
- [ ] Step 1: Understand the context
- [ ] Step 2: Inspect the design system
- [ ] Step 3: Plan the design structure
- [ ] Step 4: Build the design
- [ ] Step 5: Validate the design
```

**Step 1: Understand the context**

- Read client requirements, user stories, or feature descriptions
- Identify the target Figma file (ask user if not provided)
- Determine if this is a new design or modification of existing one

**Step 2: Inspect the design system**

- Use `figma/*` tools to read the design system library
- Catalog available components, variants, and properties
- Identify relevant variables (colors, spacing, typography, etc.)
- Note any existing patterns that apply to the current task
- If the file has no connected design system, ask the user which library to use

**Step 3: Plan the design structure**

- Define the page/frame hierarchy following team conventions (see Layer Naming Conventions below)
- Map requirements to existing components where possible
- Identify gaps where new components or modifications are needed
- Use `sequential-thinking` for complex layouts with multiple sections

**Step 4: Build the design**

- Create frames using auto-layout (never absolute positioning for content flows)
- Use component instances from the library (never recreate from scratch)
- Bind all visual properties to design system variables (colors, spacing, typography)
- Follow layer naming conventions (see reference table)
- Apply proper constraints and responsive behavior

**Step 5: Validate the design**

- Verify all layers are named following conventions (no "Frame 427", "Group 12" etc.)
- Verify all color fills/strokes use variables (no hardcoded hex values)
- Verify spacing uses spacing variables
- Verify typography uses text styles
- Verify all component instances are connected to library (no detached instances)
- Run a UX heuristics check (delegate to `tsh-ux-reviewing` skill)

> **Note**: The tables below contain example conventions. Replace them with your team's actual practices using the questionnaire in `references/team-figma-practices-template.md`.

## Layer Naming Conventions

<!-- PLACEHOLDER: Replace with your team's actual naming conventions. These are examples. -->

| Element            | Convention                                | Example                                        |
| ------------------ | ----------------------------------------- | ---------------------------------------------- |
| Pages              | PascalCase, descriptive                   | `Homepage`, `UserProfile`, `Settings`          |
| Top-level frames   | kebab-case, max-width noted               | `homepage-desktop-1440`, `login-mobile-390`    |
| Sections           | UPPERCASE prefix + descriptive            | `HERO/hero-section`, `NAV/navbar`              |
| Components         | PascalCase with slash-separated hierarchy | `Button/Primary/Large`, `Input/Text/Default`   |
| Component variants | Property=Value pairs                      | `State=Default`, `Size=Large`, `Type=Primary`  |
| Layers (inner)     | lowercase-kebab-case                      | `icon-chevron`, `text-label`, `container-main` |
| Auto-layout frames | Prefix with `_` for layout wrappers       | `_row-actions`, `_col-content`                 |
| Spacing tokens     | `spacing/{size}`                          | `spacing/xs`, `spacing/md`, `spacing/xl`       |

## Section Organization

<!-- PLACEHOLDER: Replace with your team's actual section organization rules. These are examples. -->

| Section            | Purpose                                     | Naming Pattern              |
| ------------------ | ------------------------------------------- | --------------------------- |
| Cover              | File cover page with project info           | `_cover`                    |
| Components (local) | File-specific components not yet in library | `_local-components`         |
| Screens            | Actual design screens                       | Page-level grouping by flow |
| Prototyping        | Interactive flows                           | `_prototype-{flow-name}`    |
| Archive            | Deprecated/old versions                     | `_archive`                  |

## Component Creation Rules

<!-- PLACEHOLDER: Replace with your team's actual component creation rules. These are examples. -->

| Rule              | Description                                                                                 |
| ----------------- | ------------------------------------------------------------------------------------------- |
| When to create    | Only when no existing library component serves the need AND the element will be reused      |
| Variant structure | Use component properties (boolean, text, instance-swap) over nested variants where possible |
| Auto-layout       | Every component MUST use auto-layout internally                                             |
| Constraints       | Set responsive constraints for all child layers                                             |
| Naming            | Follow `Category/Subcategory/Variant` naming                                                |
| Variables         | Bind all colors, spacing, radii to design system variables                                  |
| Documentation     | Add component description and link to design specs                                          |

## Connected Skills

- `tsh-ux-reviewing` - for validating designs against UX laws and usability heuristics after creation
- `tsh-prototyping-from-requirements` - for the end-to-end flow from requirements to Figma prototype, which uses this skill's conventions during the build phase
- `tsh-ensuring-accessibility` - for verifying accessibility aspects of designs (color contrast, touch targets, semantic structure)
- `tsh-ui-verifying` - for verifying that implementations match the designs created with this skill
