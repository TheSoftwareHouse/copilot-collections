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

## Workflow

1. **Read and load all required skills** before proceeding.
2. **Analyze provided requirements**: Review the design brief, requirements, and any reference materials from the calling orchestrator.
3. **Inspect existing design system**: Use `figma/*` tools to identify the target Figma file and inspect the existing design system (components, variables, tokens).
4. **Build wireframe structure**: Build wireframe structure in Figma following `tsh-figma-designing` conventions (correct layer naming, sections, auto-layout).
5. **Build high-fidelity prototype**: Build high-fidelity prototype using design system components, variables, and auto-layout.
6. **Validate accessibility**: Check color contrast ratios (WCAG AA), touch target sizes (44x44px minimum), text hierarchy.
7. **Return summary**: Return a summary of what was created: screens list, components used/created, key design decisions.

## Constraints

- All design operations MUST use `figma/*` tools — never describe designs textually.
- Always reuse existing design system components before creating new ones.
- If Figma MCP is unavailable, stop and report the issue — do not proceed without it.
- If the Figma file URL is not provided, ask the user immediately — do not guess.
- Do not implement code — design only.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-design-prototype-task:v2 -->
