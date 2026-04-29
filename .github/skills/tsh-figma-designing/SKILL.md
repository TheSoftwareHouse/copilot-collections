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
- After creating each component, set its `description` field (purpose, usage, key variants)
- After setting any fill/stroke, immediately verify it is bound to a variable — do not proceed with unbound properties
- When building components that contain interactive sub-elements (buttons, inputs, links), use instances of existing components — never recreate them

**Step 5: Validate the design**

- Verify all layers are named following conventions (no "Frame 427", "Group 12" etc.)
- Verify all color fills/strokes use variables (no hardcoded hex values)
- Verify spacing uses spacing variables
- Verify typography uses text styles
- Verify all component instances are connected to library (no detached instances)
- Run a UX heuristics check (delegate to `tsh-ux-reviewing` skill)
- Verify every text node has a text style applied (not just fontSize/fontWeight set manually)
- Verify no emoji characters are used as icons — all icons must be vectors, SVGs, or geometric placeholders
- Verify all interactive components have required interaction states (see Required Interaction States table)
- Verify all component descriptions are filled in (not empty)
- Verify top-level frames have correct fixed dimensions matching target breakpoints (see Frame Sizing Rules)

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

| Rule                  | Description                                                                                                                                                                                   |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| When to create        | Only when no existing library component serves the need AND the element will be reused                                                                                                        |
| Variant structure     | Use component properties (boolean, text, instance-swap) over nested variants where possible                                                                                                   |
| Auto-layout           | Every component MUST use auto-layout internally                                                                                                                                               |
| Constraints           | Set responsive constraints for all child layers                                                                                                                                               |
| Naming                | Follow `Category/Subcategory/Variant` naming                                                                                                                                                  |
| Variables             | Bind all colors, spacing, radii to design system variables                                                                                                                                    |
| Documentation         | Add component description and link to design specs                                                                                                                                            |
| Component composition | When a component contains an element matching an existing component (button, input, icon), ALWAYS use `createInstance()` of the existing component. Never recreate sub-elements from scratch. |
| Description required  | After creating each component, set its `description` field with: purpose (1 sentence), when to use, key variants. Never leave description empty.                                              |

## Variable Binding Rules

Every visual property MUST be bound to a design system variable. No exceptions.

| Rule               | Description                                                                                                                                                          |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Fill colors        | NEVER set fill with hardcoded hex/rgba. ALWAYS bind to a color variable using the variable binding mechanism.                                                        |
| Stroke colors      | NEVER set stroke with hardcoded color. ALWAYS bind to a color variable.                                                                                              |
| Spacing            | ALWAYS use spacing variables for padding and gap values. NEVER use arbitrary pixel values.                                                                           |
| Border radius      | ALWAYS use radius variables. NEVER hardcode corner radius values.                                                                                                    |
| Inline enforcement | After setting ANY visual property on a component, immediately verify it is variable-bound before proceeding to the next element. Do NOT batch validation to the end. |

**Per-component validation**: After completing EACH component, verify:

- [ ] All fill colors are bound to color variables
- [ ] All stroke colors are bound to color variables
- [ ] Padding and gap use spacing variables
- [ ] Border radius uses radius variables
- [ ] No hardcoded hex/rgba values remain

## Frame Sizing Rules

Top-level screen frames MUST have explicit fixed dimensions matching the target breakpoint.

| Rule                      | Description                                                                                                                                                       |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Desktop frames            | Fixed width of 1440px (or project-specific breakpoint). NEVER use HUG horizontal sizing on top-level desktop frames.                                              |
| Tablet frames             | Fixed width of 768px (or project-specific breakpoint).                                                                                                            |
| Mobile frames             | Fixed width of 375px, minimum height of 812px (iPhone viewport). NEVER create mobile frames under 600px tall.                                                     |
| Sidebar + content layouts | Sidebar = fixed width (e.g., 240px–280px). Content area = `layoutSizingHorizontal: FILL` to stretch to remaining space. NEVER use HUG on main content containers. |
| Content containers        | Inside fixed-width frames, content containers MUST use FILL horizontal sizing to stretch to available space.                                                      |
| Auto-height               | Top-level frames may use auto-height (grow with content) but MUST have fixed width.                                                                               |

## Typography Rules

Text styles and variable bindings are DIFFERENT Figma mechanisms. Both MUST be applied.

- **Variables** → bind colors, spacing, border radius
- **Text styles** → apply to text nodes for font family, size, weight, line height

| Rule              | Description                                                                                                                                                                       |
| ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Every text node   | MUST have a text style applied. NEVER set fontSize/fontWeight directly without a corresponding text style.                                                                        |
| Apply immediately | After creating ANY text node, immediately apply the matching text style before proceeding. Do NOT batch style application to the end.                                             |
| Style mapping     | Page titles → Heading/H1-H2. Section titles → Heading/H3-H4. Body text → Body/Default. Labels → Label. Captions → Caption. Adjust based on available styles in the design system. |
| Color on text     | Text color MUST also be bound to a color variable, in addition to having a text style applied.                                                                                    |

## Icon Rules

NEVER use emoji characters (🏠, 📊, 🔔, ⚙️, etc.) as icons. Emojis render inconsistently across platforms and cannot be styled or resized properly.

Use icons in this priority order:

1. **Existing icon components** from the design system library — search first
2. **SVG imports** via `upload_assets` tool — import from the project's icon set (Lucide, Phosphor, etc.)
3. **Simple vector shapes** as geometric placeholders — solid circles, rounded rectangles, or basic shapes that communicate the icon's intent
4. **Framed text placeholders** — a small frame with a short text label (e.g., "ico") as a last resort

Never proceed with emoji. If no icon source is available, use geometric placeholder shapes.

## Required Interaction States

Every interactive component MUST include the following states as variants or component properties. Do not ship components with only a Default state.

| Component Type     | Required States                                                |
| ------------------ | -------------------------------------------------------------- |
| Button             | Default, Hover, Pressed, Focus, Disabled                       |
| NavItem / Link     | Default, Hover, Active, Focus                                  |
| Input / Select     | Default, Focus, Filled, Error, Disabled                        |
| Tab                | Active, Inactive, Hover                                        |
| Banner / Alert     | Must include a dismiss/close affordance (close button or icon) |
| Card (interactive) | Default, Hover                                                 |
| Toggle / Checkbox  | Off, On, Hover, Disabled                                       |
| Tooltip            | Shown, Hidden                                                  |

If the design system already defines states for a component type, use those. Only create additional states when the existing set doesn't cover the interaction needs.

## Connected Skills

- `tsh-ux-reviewing` - for validating designs against UX laws and usability heuristics after creation
- `tsh-prototyping-from-requirements` - for the end-to-end flow from requirements to Figma prototype, which uses this skill's conventions during the build phase
- `tsh-ensuring-accessibility` - for verifying accessibility aspects of designs (color contrast, touch targets, semantic structure)
- `tsh-ui-verifying` - for verifying that implementations match the designs created with this skill
