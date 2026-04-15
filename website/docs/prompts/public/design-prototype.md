---
sidebar_position: 13
title: /tsh-design-prototype
---

# /tsh-design-prototype

**Agent:** Product Designer  
**File:** `.github/prompts/tsh-design-prototype.prompt.md`

Creates a Figma prototype from client requirements, user stories, or feature descriptions. Analyzes requirements, inspects the design system, and builds a high-fidelity prototype following team conventions.

## Usage

```text
/tsh-design-prototype <requirements, user story, or feature description>
```

## What It Does

1. **Analyzes input** — Parses requirements, extracts user goals, flows, data entities, and edge cases.
2. **Identifies target file** — Asks for the Figma file URL or creates a new file.
3. **Inspects design system** — Reads connected library components, variables, and patterns via Figma MCP.
4. **Plans design structure** — Defines information architecture, screen list, navigation, and user flows.
5. **Builds prototype** — Creates screens using design system components, auto-layout, and variables.
6. **Validates** — Runs UX review, verifies design system compliance, presents results.

## Skills Loaded

- `tsh-prototyping-from-requirements` — End-to-end prototyping workflow.
- `tsh-figma-designing` — Team Figma conventions and design system usage.
- `tsh-ux-reviewing` — UX validation against Laws of UX and Nielsen's heuristics.

## Key Behaviors

- Gets user approval on information architecture before building high-fidelity.
- All designs use the connected design system — no detached components or hardcoded values.
- Asks for the Figma file URL if not provided.
