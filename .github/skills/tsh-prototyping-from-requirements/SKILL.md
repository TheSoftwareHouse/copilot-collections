---
name: tsh-prototyping-from-requirements
description: "End-to-end prototyping workflow from client requirements to Figma designs. Covers requirements analysis, information architecture, wireframe planning, and high-fidelity prototype creation using the design system. Use when creating new designs from scratch based on client requirements, user stories, PRDs, or feature descriptions."
---

# Prototyping from Requirements

Guides the end-to-end workflow from client requirements to Figma prototypes. Transforms user stories, PRDs, and feature descriptions into structured designs built with design system components.

<principles>

<requirements-first>
Never start designing before fully understanding the requirements. Analyze what the user needs, identify edge cases, and map user flows before touching Figma. Missing requirements lead to wasted design iterations.
</requirements-first>

<progressive-fidelity>
Move from low to high fidelity — structure first (information architecture), then layout (wireframes), then polish (high-fidelity with design system). Never jump to pixel-perfect design without validating structure.
</progressive-fidelity>

<component-driven>
Build prototypes using existing design system components. The prototype should be a composition of real components, not a pixel drawing. This ensures designs are implementable and consistent.
</component-driven>

</principles>

## Prototyping Process

Use the checklist below and track your progress:

```
Progress:
- [ ] Step 1: Analyze requirements
- [ ] Step 2: Define information architecture
- [ ] Step 3: Inspect the design system
- [ ] Step 4: Build wireframe structure
- [ ] Step 5: Build high-fidelity prototype
- [ ] Step 6: Add interaction and flow
- [ ] Step 7: Validate and present
```

**Step 1: Analyze requirements**

Read and parse the provided requirements (user stories, PRD, feature description, client brief).

Extract the following from the input:

- Primary user goals — what the user is trying to accomplish
- Key user flows — the main paths through the feature
- Data entities involved — what objects/data the UI displays or manipulates
- Edge cases — empty states, error states, loading states, overflow, first-time use

Identify what is explicitly stated vs what needs to be assumed. Flag assumptions clearly.

Use `sequential-thinking` for complex multi-flow features to break down interdependencies.

Ask the user to clarify ambiguities before proceeding — do not guess on critical requirements.

Output: structured requirements summary containing goals, flows, entities, and states.

**Step 2: Define information architecture**

Map the screen hierarchy — determine how many screens or views are needed and how they relate.

For each screen, define the content structure:

- What information appears on the screen
- Content priority and visual hierarchy
- Grouping of related elements

Identify navigation patterns appropriate for the feature (sidebar, tabs, breadcrumbs, modal flows, etc.).

Map user flows between screens:

- Happy path (primary flow)
- Error paths (validation failures, API errors, permission denied)
- Alternative paths (cancel, back, skip)

Output: screen list with content hierarchy and flow map.

**Step 3: Inspect the design system**

Use `figma/*` tools to read the target design system library.

Identify available components for each category:

- Navigation (navbar, sidebar, tabs, breadcrumbs)
- Layout (containers, grids, cards, sections)
- Forms (inputs, selects, checkboxes, date pickers)
- Data display (tables, lists, stats, charts)
- Feedback (alerts, toasts, modals, empty states)

Map requirements to existing components — determine which components serve which needs.

Identify gaps where new components or patterns are needed. Flag these for discussion.

Note available design tokens: colors, spacing scale, typography scale, elevation levels.

**Step 4: Build wireframe structure**

Create a new frame in Figma for each screen, following `tsh-figma-designing` layer naming conventions.

Use auto-layout to establish the content hierarchy defined in Step 2.

Place placeholder elements for content areas — grey rectangles, text placeholders, icon placeholders.

Keep it low-fidelity: focus on spacing, hierarchy, and flow — not colors or polish.

Verify the wireframe covers:

- All screens identified in Step 2
- All user flows (happy path + error paths)
- Responsive breakpoints (if applicable)

Get user feedback and approval on the structure before proceeding to high-fidelity.

**Step 5: Build high-fidelity prototype**

Replace placeholder elements with actual design system components from Step 3.

Bind all visual properties to design system variables — no hardcoded color values, spacing, or typography.

Add real or realistic placeholder content (not "Lorem ipsum" — use contextually appropriate text).

Handle all states for each component and screen:

- Default, hover, active, disabled
- Loading (skeleton screens or spinners)
- Empty (helpful message with CTA)
- Error (clear message with recovery action)

Ensure responsive behavior is configured where applicable.

Follow all `tsh-figma-designing` conventions: naming, sections, auto-layout, component usage.

**Step 6: Add interaction and flow**

Set up prototype connections between screens for the defined user flows.

Add interaction states:

- Hover effects on interactive elements
- Pressed/active states on buttons and links
- Focus states on form fields

Define transition animations — keep them simple and purposeful:

- Page transitions (slide, fade)
- Modal open/close
- Dropdown/popover reveal

Test the prototype flow end-to-end: walk through every defined user flow and verify transitions work correctly.

**Step 7: Validate and present**

Run UX review — delegate to `tsh-ux-reviewing` skill for heuristic evaluation.

Verify design system compliance:

- No detached components
- No hardcoded values (all bound to variables)
- Consistent use of design tokens

Verify all edge case states are covered (use the reference table below).

Present the prototype to the user with a summary of:

- Design decisions made and their rationale
- Assumptions that were made
- Known gaps or areas needing further discussion

## Quick Reference: Edge Case States

Every screen and component should account for these states:

| State      | When                                | What to show                                   |
| ---------- | ----------------------------------- | ---------------------------------------------- |
| Default    | Normal data, normal conditions      | Standard UI                                    |
| Loading    | Data is being fetched               | Skeleton screens or spinners                   |
| Empty      | No data exists yet                  | Helpful empty state with CTA                   |
| Error      | Operation failed                    | Clear message + recovery action                |
| Partial    | Some data loaded, some failed       | Loaded data + error indicator for failed parts |
| Overflow   | Too much data or text               | Truncation, pagination, or scroll              |
| First-time | User's first encounter with feature | Onboarding hint or guided tour                 |

## Connected Skills

- `tsh-figma-designing` - for team Figma conventions used during the build phase (steps 4-6)
- `tsh-ux-reviewing` - for validating the completed prototype against UX laws and heuristics (step 7)
- `tsh-task-analysing` - for deeper task analysis techniques when requirements are complex or ambiguous
- `tsh-ensuring-accessibility` - for accessibility considerations during the build phase
