# Product Designer Agent — Diagnosis Report

| Field      | Value                                                                                                   |
| ---------- | ------------------------------------------------------------------------------------------------------- |
| Date       | 27 April 2026                                                                                           |
| Figma File | <https://www.figma.com/design/22nz9vu56J6kWMzvoRViQ4/Product-designer-tests---plant-sensor?node-id=0-1> |
| Context    | Plant Sensor Dashboard — full MVP prototype                                                             |
| Iterations | 2 fix iterations after initial prototype + 3 UX reviews                                                 |

## Executive Summary

The `tsh-product-designer` agent created a structurally complete Figma prototype (8 pages, 16 components, 32+ screens, 46 variables) but with critical quality gaps: **color variables were defined but never bound to fills**, **text styles were created but never applied**, **desktop frames were 340px instead of 1440px**, and **emoji characters were used as icons**. These issues required 2 full fix iterations and were only partially resolved.

The root causes are **not agent model limitations** — they are **gaps in the skill files, prompt instructions, and agent definition** that fail to provide concrete technical guidance on HOW to use Figma primitives correctly.

---

## Problem 1: Color Variables Defined But Not Bound

### What Happened

Agent created 46 variables (29 colors, 10 spacing, 7 radii) but used hardcoded hex values (`rgba(45,106,79)`) on all component fills instead of binding them to the `primary/default` variable.

### Root Causes

| Source File                                           | Gap                                                                                                                                                                                                   |
| ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `tsh-figma-designing/SKILL.md` — Step 4               | Says "Bind all visual properties to design system variables" — **one-sentence bullet without technical HOW**. No example of Figma Plugin API call (`setBoundVariable`). No per-component enforcement. |
| `tsh-figma-designing/SKILL.md` — Step 5               | Says "Verify all color fills/strokes use variables" — but this is **post-hoc validation**, not in-process enforcement. Agent creates → doesn't bind → moves on → forgets to validate.                 |
| `tsh-prototyping-from-requirements/SKILL.md` — Step 5 | Says "Bind all visual properties to design system variables — no hardcoded color values" — again **one-sentence bullet without HOW**.                                                                 |
| `tsh-design-prototype-task.prompt.md` — Step 5        | Says "using design system components, variables, and auto-layout" — no explicit "bind ALL fills to variables" step.                                                                                   |
| `tsh-product-designer.agent.md`                       | Says "Use real Figma primitives (components, variables, auto-layout)" — doesn't enforce that **every fill MUST be variable-bound before moving to next component**.                                   |

### Fix Recommendation

**In `tsh-figma-designing/SKILL.md`** — Add a new section "Variable Binding Rules":

- "Every fill color MUST be bound to a color variable. NEVER use hardcoded hex/rgba."
- "After creating EACH component, verify all fills are bound before proceeding."
- "When setting a fill, ALWAYS use the variable binding API, not direct color assignment."
- Include a concrete validation checklist per component.

**In `tsh-product-designer.agent.md`** — Add to Hard Rules:

- "NEVER create a fill with a hardcoded hex value — ALWAYS bind to a variable."

---

## Problem 2: Desktop Frames 340px Instead of 1440px (Broken Layouts)

### What Happened

All 13 desktop frames across Dashboard, Analytics, Alerts, Settings were 340px wide (sidebar 240px + main-content 100px). Mobile frames were 100px tall. All layouts completely broken — content clipped, text overflowing, unusable.

### Root Causes

| Source File                                           | Gap                                                                                                                                                                              |
| ----------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `tsh-figma-designing/SKILL.md`                        | **No section on responsive frame sizing.** No rules for: "Desktop frames MUST be [breakpoint]px wide", "main-content MUST use `layoutSizingHorizontal: FILL`".                   |
| `tsh-prototyping-from-requirements/SKILL.md` — Step 4 | Says "Create a new frame in Figma for each screen" — **doesn't define frame dimensions**. No mention of fixed width for top-level frames.                                        |
| `tsh-design-prototype-task.prompt.md`                 | Mentions breakpoints (1440, 768, 375) in the design brief but **no explicit frame sizing instruction**. Agent created frames with auto-layout HUG sizing instead of fixed width. |
| All skills                                            | **No rules about FILL vs HUG sizing.** Agent doesn't know that in a sidebar+content layout, the content child MUST be FILL, not HUG.                                             |

### Fix Recommendation

**In `tsh-figma-designing/SKILL.md`** — Add a new section "Frame Sizing Rules":

- "Top-level screen frames MUST have fixed width matching the target breakpoint (e.g., 1440px for desktop, 375px for mobile)."
- "Mobile frames MUST be minimum [width]×812px (iPhone standard viewport)."
- "In sidebar + content layouts: sidebar = fixed width, content area = `layoutSizingHorizontal: FILL`."
- "NEVER use HUG horizontal sizing on main content containers in full-page layouts."
- "Content containers inside fixed-width frames should use FILL to stretch to available space."

**In `tsh-prototyping-from-requirements/SKILL.md`** — Expand Step 4:

- "4a: Create frame at EXACT breakpoint dimensions (e.g., 1440×900 for desktop, 375×812 for mobile)."
- "4b: Set top-level frame to fixed width, auto-height or fixed height."
- "4c: Content areas MUST use FILL horizontal sizing."

---

## Problem 3: Text Styles Created But Never Applied (48% Coverage)

### What Happened

9 text styles created (H1–H4, Body/L-S, Label, Caption) but `textStyleId` was `"(none)"` on every text node. After fix iteration, only 48% coverage achieved.

### Root Causes

| Source File                                           | Gap                                                                                                                                                                                                               |
| ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `tsh-figma-designing/SKILL.md` — Step 5               | Says "Verify typography uses text styles" — **validation step, not creation instruction**. No: "After creating text, IMMEDIATELY apply text style."                                                               |
| `tsh-prototyping-from-requirements/SKILL.md` — Step 5 | Says "Bind all visual properties to design system variables" — but text styles ≠ variables. **Different Figma mechanism, not distinguished in the skill.**                                                        |
| All skills                                            | **No explicit distinction** between variable bindings (for colors/spacing/radii) and text style application (for typography). Agent treats "use styles" as "create styles" not "apply styles to every text node." |

### Fix Recommendation

**In `tsh-figma-designing/SKILL.md`** — Add a new section "Typography Rules":

- "Every text node MUST have a text style applied. NEVER set fontSize/fontWeight directly without a corresponding text style."
- "Text styles and variable bindings are DIFFERENT mechanisms: colors/spacing → variables, typography → text styles. Both MUST be applied."
- "After creating ANY text node, immediately apply the matching text style."

**In `tsh-prototyping-from-requirements/SKILL.md`** — Expand Step 5:

- "5d: Apply text styles to ALL text nodes (page titles → Heading/H1-H2, section titles → H3-H4, body → Body/Default, labels → Label, captions → Caption)."
- Separate sub-step from variable bindings to avoid conflation.

---

## Problem 4: Components Don't Use Instances of Other Components

### What Happened

Sidebar recreated NavItem from scratch. EmptyState, ErrorState, AlertCard each recreated button-like elements instead of using Button component instances. Zero component nesting.

### Root Causes

| Source File                     | Gap                                                                                                                                                                                           |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `tsh-figma-designing/SKILL.md`  | "Use component instances from the library (never recreate from scratch)" — but this talks about **using library components on screens**, not **composing components from other components**.  |
| `tsh-product-designer.agent.md` | "Always search the design system library first before creating new components" — focuses on **not creating duplicate components**, not **using existing components INSIDE other components**. |

### Fix Recommendation

**In `tsh-figma-designing/SKILL.md`** — Add to "Component Creation Rules":

- "When building a component that contains an element matching an existing component, ALWAYS use `createInstance()` of the existing component."
- "Before adding any interactive element (button, input, link) inside a component, CHECK if a matching component exists. If yes, use an instance."
- "Sidebar MUST use NavItem instances. Any CTA in EmptyState/ErrorState MUST use Button instances. Form containers MUST use FormInput instances."

---

## Problem 5: Emoji Characters Used as Icons

### What Happened

All icons (🏠, 📊, 🔔, ⚙️, 🌿, 🌱, ❌, ⚠️) across NavItem, Sidebar, AlertBanner, EmptyState, ErrorState, WeatherWidget, BottomTabBar were emoji text nodes.

### Root Causes

| Source File                           | Gap                                                                                                                                                                             |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| All skills                            | **Zero mentions of icon handling.** No section on how to add icons in Figma. No rules about vector vs emoji.                                                                    |
| `tsh-design-prototype-task.prompt.md` | Design brief mentions "outlined icon set (Lucide, Phosphor)" — but this is **requirements context**, not **agent instruction**. Agent has no icon files and fallbacks to emoji. |
| Figma MCP tools                       | `upload_assets` tool exists but no skill instructs the agent to use it for icons. No guidance on alternatives (vector shapes, built-in Figma icons).                            |

### Fix Recommendation

**In `tsh-figma-designing/SKILL.md`** — Add a new section "Icon Rules":

- "NEVER use emoji characters as icons. Emojis render inconsistently across platforms and cannot be styled."
- "For icons, use one of these approaches in priority order: (1) Use existing icon components from the design system library, (2) Use `upload_assets` to import SVG icons, (3) Create simple vector shapes as geometric placeholders."
- "If no icon source is available, use solid circles/rectangles as placeholders — never emoji."

**In `tsh-product-designer.agent.md`** — Add to Hard Rules:

- "NEVER use emoji as icons — ALWAYS use vector/SVG or geometric placeholders."

---

## Problem 6: Missing Interaction States (AlertBanner Dismiss, NavItem Hover/Focus)

### What Happened

AlertBanner had no close/dismiss button. NavItem had only 3 states (Default, Active, Badge) — no Hover or Focus.

### Root Causes

| Source File                                               | Gap                                                                                                                                                      |
| --------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `tsh-figma-designing/SKILL.md` — Component Creation Rules | "Use component properties (boolean, text, instance-swap) over nested variants" — but **no checklist of required interaction states per component type**. |
| `tsh-prototyping-from-requirements/SKILL.md` — Step 5     | Lists "Default, hover, active, disabled" states — but as **general guidance**, not as a **mandatory checklist** enforced per component.                  |

### Fix Recommendation

**In `tsh-figma-designing/SKILL.md`** — Add "Required Interaction States" table:

| Component Type     | Required States                          |
| ------------------ | ---------------------------------------- |
| Button             | Default, Hover, Pressed, Focus, Disabled |
| NavItem / Link     | Default, Hover, Active, Focus            |
| Input              | Default, Focus, Filled, Error, Disabled  |
| Tab                | Active, Inactive, Hover                  |
| Banner / Alert     | Must include dismiss/close affordance    |
| Card (interactive) | Default, Hover                           |

---

## Problem 7: Component Descriptions All Empty

### What Happened

All 16 components had empty `description` fields.

### Root Causes

| Source File                                               | Gap                                                                                                                                                                 |
| --------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `tsh-figma-designing/SKILL.md` — Component Creation Rules | "Add component description and link to design specs" — listed as a rule but **no enforcement in the workflow steps**. Step 4 and Step 5 don't mention descriptions. |

### Fix Recommendation

**In `tsh-figma-designing/SKILL.md`** — Add to Step 4 (Build):

- "After creating each component, set its `description` field with: purpose (1 sentence), when to use, key variants."

---

## Summary: Patterns Across All Problems

| Pattern                                                                             | Frequency    | Fix Strategy                                                            |
| ----------------------------------------------------------------------------------- | ------------ | ----------------------------------------------------------------------- |
| **"WHAT without HOW"** — Skills say what to do but not technically how              | 5/7 problems | Add concrete API-level instructions and examples                        |
| **Post-hoc validation instead of inline enforcement**                               | 4/7 problems | Move validation into creation steps ("do X, then immediately verify X") |
| **Missing topics entirely**                                                         | 3/7 problems | Add new sections: Frame Sizing, Icon Rules, Required States             |
| **Ambiguous scope** — "use instances" means on screens, not inside components       | 2/7 problems | Clarify scope with specific examples                                    |
| **No distinction between Figma mechanisms** — variables vs text styles vs instances | 2/7 problems | Separate instructions per mechanism                                     |

## Files To Update

| File                                                           | Changes Needed                                                                                                                                                                    |
| -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `.github/skills/tsh-figma-designing/SKILL.md`                  | Add sections: Variable Binding Rules, Frame Sizing Rules, Typography Rules, Icon Rules, Required Interaction States. Expand Component Creation Rules. Add descriptions to Step 4. |
| `.github/skills/tsh-prototyping-from-requirements/SKILL.md`    | Expand Step 4 (frame sizing), Step 5 (sub-steps for bindings, styles, instances, validation).                                                                                     |
| `.github/internal-prompts/tsh-design-prototype-task.prompt.md` | Add "Mandatory Quality Gates" section. Add explicit frame sizing constraint. Add "Hard Rules" that override soft guidance.                                                        |
| `.github/agents/tsh-product-designer.agent.md`                 | Add "Hard Rules" section with NEVER/ALWAYS rules for: hex colors, emoji icons, text styles, HUG sizing, component composition.                                                    |
