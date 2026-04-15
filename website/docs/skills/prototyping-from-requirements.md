---
sidebar_position: 14
title: Prototyping from Requirements
---

# Prototyping from Requirements

**Folder:** `.github/skills/tsh-prototyping-from-requirements/`  
**Used by:** Product Designer

Guides the end-to-end workflow from client requirements to Figma prototypes. Transforms user stories, PRDs, and feature descriptions into structured designs built with design system components.

## 7-Step Prototyping Process

1. **Analyze requirements** — Parse input, extract user goals, flows, data entities, and edge cases.
2. **Define information architecture** — Map screen hierarchy, content structure, navigation patterns, and user flows.
3. **Inspect the design system** — Catalog available components, variables, and patterns via Figma MCP.
4. **Build wireframe structure** — Create auto-layout frames with placeholder elements. Focus on hierarchy, not polish.
5. **Build high-fidelity prototype** — Replace placeholders with design system components. Bind all properties to variables.
6. **Add interaction and flow** — Set up prototype connections, interaction states, and transitions.
7. **Validate and present** — Run UX review, verify design system compliance, present to user.

## Edge Case States

Every screen should account for these states:

| State          | When                           | What to Show                      |
| -------------- | ------------------------------ | --------------------------------- |
| **Default**    | Normal data, normal conditions | Standard UI                       |
| **Loading**    | Data being fetched             | Skeleton screens or spinners      |
| **Empty**      | No data exists yet             | Helpful empty state with CTA      |
| **Error**      | Operation failed               | Clear message + recovery action   |
| **Partial**    | Some data loaded, some failed  | Loaded data + error indicator     |
| **Overflow**   | Too much data/text             | Truncation, pagination, or scroll |
| **First-time** | User's first encounter         | Onboarding hint or guided tour    |

## Connected Skills

- `tsh-figma-designing` — Team Figma conventions used during the build phase (steps 4-6).
- `tsh-ux-reviewing` — Validating the completed prototype (step 7).
- `tsh-task-analysing` — Deeper task analysis when requirements are complex.
- `tsh-ensuring-accessibility` — Accessibility considerations during the build phase.
