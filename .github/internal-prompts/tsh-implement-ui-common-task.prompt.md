---
agent: "tsh-software-engineer"
model: "Claude Opus 4.6"
description: "Implement UI feature according to the plan with frontend-specific setup and design reference handling."
---

> **PREREQUISITE**: This prompt extends [tsh-implement-common-task.prompt.md](./tsh-implement-common-task.prompt.md). You MUST read and follow **all steps** from that base workflow first. This prompt adds UI-specific behaviors on top — it does not remove or replace any base workflow steps.

Implement the UI feature according to the **research context** and **implementation plan**, using Figma designs as the source of truth for visual implementation.

## Required Skills

In addition to the skills required by the base workflow, load and follow these skills before starting:

- `tsh-implementing-frontend` — for component patterns, design system usage, composition, and performance guidelines
- `tsh-ensuring-accessibility` — for WCAG 2.1 AA compliance, semantic HTML, ARIA, and automated axe-core verification
- `tsh-technical-context-discovering` — to establish project conventions before implementing

---

## Design References from Research & Plan

Always treat the **research** and **plan** files as the single source of truth for design links:

- Before starting implementation (during step 1–2 of the base workflow):
  - Open the **research file** (`*.research.md`) and look for:
    - Figma URLs in the `Relevant Links` section.
    - Any specific component/node links mentioned in `Gathered Information`.
  - Open the **plan file** (`*.plan.md`) and look for:
    - Figma URLs and design references in `Task details`.
    - If present, a structured "Design References" subsection mapping views/components to Figma URLs or node IDs.
- Use these Figma URLs as the **default source** for all `figma` calls during implementation.

### When Figma link is missing

If you cannot find a Figma URL for the component/section you are about to implement:

1. **Stop** — do not proceed with that component
2. **Ask the user** to provide the Figma link for the specific section
3. **Wait for the link** before proceeding with implementation
4. **Add the link** to the plan file once provided (in `Task details` or `Design References`)

Do NOT:

- Skip implementation because the link is missing
- Guess what the design should look like
- Proceed with implementation without a Figma reference

When you discover missing or updated design links during implementation, add them to the appropriate sections in the **plan** under `Task details` (and, if needed, note them in the Changelog).

---

## Additional Setup (before starting implementation)

Before step 6 of the base workflow (starting implementation), ensure:

- The local development server is running.
- You can access the page you're implementing (authenticated if needed).
- You have identified all relevant Figma URLs from the research/plan files.
- You understand the design system tokens and components available in the project.

---

## UI Verification Note

**UI verification against Figma is NOT your responsibility.** The `tsh-engineering-manager` handles the verify-fix loop by delegating to `tsh-ui-reviewer`. Focus only on implementing the UI according to the plan and design references. If you receive a verification report with issues to fix, apply the fixes and report back.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-implement-ui-common-task:v1 -->
