---
agent: "tsh-product-designer"
model: "Claude Opus 4.6"
description: "Create a Figma prototype from provided requirements and design context. Used by tsh-design-manager to delegate prototyping work."
---

Build a high-fidelity Figma prototype from the provided requirements, design brief, and reference materials.

## Required Skills

Before starting, load and follow these skills:

- `tsh-prototyping-from-requirements` — end-to-end prototyping workflow
- `tsh-figma-designing` — team Figma conventions and design system usage
- `tsh-ensuring-accessibility` — WCAG color contrast and touch target checks

## Reference Materials

When designing, consult these references if they are relevant to the task:

- **animate-ui.com** ([https://animate-ui.com/docs](https://animate-ui.com/docs)) — animation patterns and micro-interactions for interactive components. Inspiration for motion design only — not a component library.
- **Laws of UX** ([https://lawsofux.com/](https://lawsofux.com/)) — collection of UX best practices: Fitts's Law, Hick's Law, Miller's Law, Jakob's Law, and others. Apply these principles when making layout and interaction decisions.
- **Nielsen's 10 Usability Heuristics** ([https://www.nngroup.com/articles/ten-usability-heuristics/](https://www.nngroup.com/articles/ten-usability-heuristics/)) — foundational heuristics for interaction design. Use as a quality lens during prototyping.

If installed in the project, also leverage these community skills for enhanced design quality:

- `emilkowalski/skill` — practical advice on design details, motion, and interface polish (based on Emil Kowalski's articles)
- `jakubkrehel/make-interfaces-feel-better` — refinements like cleaner alignment, smoother motion, softer shadows, and better spacing
- `anthropics/frontend-design` — design systems, reusable UI patterns, responsive layouts, and scalable components
- `nextlevelbuilder/ui-ux-pro-max-skill@ui-ux-pro-max` — visual hierarchy, color choices, interaction patterns, and product context

## Fix Mode

When the orchestrator specifies UX review findings to fix, skip steps 1–3 (skills are already loaded, design system is already inspected) and apply targeted changes to the existing prototype. Then re-validate accessibility on changed components only.

## Hard Rules

These rules are non-negotiable and override any softer guidance from skills:

- **NEVER** use hardcoded hex/rgba for fills or strokes — ALWAYS bind to a color variable
- **NEVER** use emoji characters as icons — use vector/SVG or geometric placeholders
- **NEVER** create text without immediately applying a text style
- **NEVER** use HUG horizontal sizing on top-level screen frames — always set fixed width matching the target breakpoint (1440px desktop, 768px tablet, 375px mobile)
- **NEVER** recreate a sub-element from scratch when a matching component exists — use `createInstance()`
- **NEVER** leave a component `description` field empty
- **ALWAYS** verify variable bindings per-component BEFORE moving to the next component

## Workflow

1. **Read and load all required skills** before proceeding.
2. **Analyze provided requirements**: Review the design brief, requirements, and any reference materials from the calling orchestrator.
3. **Inspect existing design system**: Use `figma/*` tools to identify the target Figma file and inspect the existing design system (components, variables, tokens).
4. **Build wireframe structure**: Create frames at EXACT breakpoint dimensions (1440×900 desktop, 375×812 mobile, or as specified). Set top-level frames to fixed width. Content areas MUST use FILL horizontal sizing. Follow `tsh-figma-designing` conventions (layer naming, sections, auto-layout).
5. **Build high-fidelity prototype**: Build using design system components, variables, auto-layout, and text styles. For each component: bind all fills/strokes to color variables, apply text styles to all text nodes, use instances of existing components for sub-elements, set component description, and verify all bindings BEFORE moving to the next component. Follow Hard Rules strictly.
6. **Validate accessibility**: Check color contrast ratios (WCAG AA), touch target sizes (44x44px minimum), text hierarchy.
7. **Return summary**: Return a summary of what was created: screens list, components used/created, key design decisions.

## Constraints

- All design operations MUST use `figma/*` tools — never describe designs textually.
- Always reuse existing design system components before creating new ones.
- If Figma MCP is unavailable, stop and report the issue — do not proceed without it.
- If the Figma file URL is not provided, ask the user immediately — do not guess.
- Do not implement code — design only.

## Mandatory Quality Gates — Final Sweep

These checks are a safety net — the Hard Rules above require per-component enforcement during build. These gates catch anything that slipped through. Before returning the summary, run these checks on EVERY component and screen:

1. **Variable bindings**: Scan all fills and strokes — every one must be bound to a variable. Zero hardcoded hex/rgba.
2. **Text styles**: Scan all text nodes — every one must have a `textStyleId` set. Zero unstyled text.
3. **Frame dimensions**: Every top-level screen frame must have correct fixed width (1440/768/375px).
4. **No emoji icons**: Scan for emoji unicode characters in text nodes that serve as icons. Zero emoji.
5. **Component descriptions**: Every created component must have a non-empty `description`.
6. **Interaction states**: Every interactive component (button, input, nav item, tab) must have the required state variants per `tsh-figma-designing` Required Interaction States table.
7. **Component composition**: Components that contain buttons, inputs, or links must use instances of existing components, not recreated elements.

If ANY gate fails, fix it before returning. Do not report completion with known quality issues.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-design-prototype-task:v3 -->
