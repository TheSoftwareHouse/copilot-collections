---
sidebar_position: 5
title: Product Designer
---

# Product Designer Agent

**File:** `.github/agents/tsh-product-designer.agent.md`

The Product Designer agent creates and reviews Figma designs following team conventions, UX laws, and usability heuristics. It works exclusively through the Figma MCP server to produce real design artifacts — never describing designs textually.

## Responsibilities

- Creating prototypes from client requirements, user stories, and feature descriptions.
- Building and extending design system components using Figma primitives (components, variables, auto-layout).
- Ensuring design consistency across screens and flows.
- Applying UX laws and Nielsen's usability heuristics to every design decision.
- Reviewing existing designs for usability issues and convention violations.

## Key Behaviors

- **Design system first** — Always searches the design system library before creating new elements. Reuses existing components and variables.
- **Real Figma primitives** — Creates designs using components, variables, and auto-layout. Never creates flat groups, detached instances, or unnamed layers.
- **UX-validated** — Validates every design against Laws of UX and Nielsen's heuristics using the `tsh-ux-reviewing` skill.
- **Progressive fidelity** — Moves from structure (information architecture) to layout (wireframes) to polish (high-fidelity). Gets approval at each stage.
- **No code** — Never writes code or implementation instructions. Hands off to the Software Engineer for implementation.

## Tool Access

| Tool                    | Usage                                                                                                 |
| ----------------------- | ----------------------------------------------------------------------------------------------------- |
| **Figma**               | Creating, modifying, and inspecting designs. Reading design system components, variables, and tokens. |
| **Sequential Thinking** | Complex layout decisions, information architecture, component variant planning.                       |
| **Read**                | Reading team practice documents, design system documentation, client requirements.                    |
| **Search**              | Finding existing design patterns, skill files, and project conventions.                               |
| **Ask Questions**       | Clarifying ambiguous requirements or team conventions not documented in skills.                       |
| **Todo**                | Tracking design task progress with structured checklists.                                             |

## Skills Loaded

- `tsh-figma-designing` — Team Figma conventions (naming, layers, sections, component patterns), design system usage rules, and design creation workflow. **Always loaded first.**
- `tsh-ux-reviewing` — UX review against Laws of UX and Nielsen's 10 usability heuristics.
- `tsh-prototyping-from-requirements` — End-to-end prototyping workflow from requirements analysis to Figma prototype.
- `tsh-ensuring-accessibility` — WCAG compliance, color contrast, touch targets, and semantic structure in designs.

## Handoffs

After completing design work, the Product Designer can hand off to:

- **UI Reviewer** → `/tsh-review-ui` (verify implementation matches the Figma design)
- **Software Engineer** → `/tsh-implement` (implement the design from Figma)
