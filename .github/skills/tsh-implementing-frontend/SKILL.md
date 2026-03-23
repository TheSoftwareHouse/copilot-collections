---
name: tsh-implementing-frontend
description: Frontend component patterns, composition, design token integration, barrel file organization, error handling, and Figma-to-code workflow. Use when implementing UI components, translating Figma designs into code, managing component state, or integrating with a design system.
---

# Implementing Frontend

Provides patterns for building reusable, composable frontend components with design system integration and a structured Figma-to-code workflow.

<principles>

<declarative-over-imperative>
Define what the UI should look like based on state, not how to manipulate the DOM. Describe the desired outcome through components and state declarations. Let the framework handle reconciliation and updates. Compose complex UIs from simple, predictable building blocks rather than writing step-by-step mutation sequences.
</declarative-over-imperative>

<composition-over-complexity>
Build complex UIs by composing small, focused components rather than creating monolithic ones. Each component should have a single clear responsibility. Prefer children, slots, and compound component patterns over deep prop trees.
</composition-over-complexity>

<design-system-first>
Always use design tokens (colors, spacing, typography) from the project's design system. Never hardcode visual values. Map Figma specs to existing tokens. If no exact token match exists, find the closest and document the deviation — do not invent tokens without approval.
</design-system-first>

<never-guess>
If design context, tokens, or specifications are missing or unclear, stop and ask the user. Do not proceed with assumptions about visual implementation. Missing information produces wrong UI — asking produces correct UI.
</never-guess>

</principles>

## Implementation Process

Use the checklist below and track progress:

```
Progress:
- [ ] Step 1: Gather design context
- [ ] Step 2: Identify and prepare design assets
- [ ] Step 3: Plan component structure
- [ ] Step 4: Implement components
- [ ] Step 5: Organize modules
- [ ] Step 6: Verify implementation
```

**Step 1: Gather design context**

- Extract specs from Figma (via MCP tool if available). Identify components, spacing, typography, colors, and interaction states.
- Map every Figma value to an existing design token in the codebase:
  1. Extract the raw value from Figma (e.g., `#3B82F6`, `16px`).
  2. Search the codebase for a matching token.
  3. If a token exists — use it.
  4. If no exact match — find the closest existing token and document the deviation.
  5. If truly new — flag it and ask the user before creating.
- Identify all states the design implies: default, hover, focus, active, disabled, loading, error, empty.
- Identify responsive breakpoints from the design. Check how the component should adapt across screen sizes — layout shifts, hidden/shown elements, typography scaling. Map breakpoints to the project's existing responsive tokens or media queries.

**Step 2: Identify and prepare design assets**

Before planning or writing any code, identify all visual assets in the Figma design that must be used as files — not recreated in code. This step is **mandatory** when implementing from Figma designs.

- Using the Figma MCP server, scan the design for nodes that represent visual assets:
  - **Icons**: Vector nodes, boolean operation groups, or components with names containing `icon`, `ico`, `ic/`, or similar naming patterns.
  - **Illustrations**: Complex vector groups, decorative graphics, or multi-colored SVG compositions.
  - **Images**: Nodes with image fills (photographs, product images, avatars, hero banners).
  - **Logos and brand marks**: Logo components or brand-specific graphics.
- For each identified asset, determine:
  1. **Does it already exist in the project?** Search the codebase asset directories (e.g., `public/`, `src/assets/`, `static/`) for a matching file.
  2. **Is it from an icon library?** Check if the icon matches a library already used in the project (e.g., `lucide-react`, `heroicons`, `material-icons`). If yes, use the library import — no export needed.
  3. **Is it a custom asset?** If not found in the project or an icon library, it must be exported from Figma.
- For any assets that need to be exported, **stop and ask the user** to export them from Figma before proceeding. Provide specific guidance:
  - List each asset that needs export by name/description and its location in the Figma design.
  - Recommend export format: **SVG** for icons, illustrations, and logos; **PNG @2x** or **WebP** for photographs and raster images.
  - Suggest a target directory in the project following existing conventions (e.g., `src/assets/icons/`, `public/images/`).

**Step 3: Plan component structure**

- Decide component boundaries: what is a reusable component vs. page-specific layout.
- Identify the props interface for each component — typed, with sensible defaults.
- Determine state needs using the State Decision Framework table below.
- Search the codebase for existing similar components. Extend or compose existing components rather than duplicating.
- Sketch the component tree: parent → children relationships, data flow direction, and where state lives.

**Step 4: Implement components**

Follow these patterns for every component:

- **Composition**: Use composition patterns — content projection (children/slots), render delegation, compound components — to keep components flexible. Avoid prop sprawl — if a component accepts more than ~7 props, it likely needs decomposition.
- **Typed props**: Define explicit TypeScript types for all props. Never use `any`. Co-locate types in `ComponentName.types.ts`.
- **Named exports only**: Use `export { ComponentName }` — no default exports. This ensures consistent imports and simplifies refactoring.
- **Error handling wrappers**: Wrap data-dependent sections with the framework's error boundary mechanism for graceful failure. See the framework reference for the specific API.
- **Three UI states**: Every data-dependent component must handle loading (progress indicator), error (meaningful message + recovery action), and empty (helpful message when no data).
- **Design tokens**: All visual values (colors, spacing, typography, shadows, radii) must come from the design system. Zero hardcoded values.

**Step 5: Organize modules**

Apply barrel file rules from the Barrel File Guidelines table below:

- Create `index.ts` barrel files at public API boundaries — folders whose exports are consumed by other modules.
- Use named re-exports only: `export { Button } from './Button'`.
- Skip barrels for internal utility folders that serve a single parent component.
- Verify the barrel doesn't re-export unused internals that bloat the bundle.

**Step 6: Verify implementation**

- If a calling workflow provides a verification loop (e.g., the Engineering Manager runs `tsh-ui-reviewer` automatically during `/tsh-implement`), defer to that workflow — do not duplicate verification here.
- If no verification workflow is active, use the `ui-verifying` skill directly to compare the implementation against the Figma design.
- Walk through each interaction state (hover, focus, disabled, error, loading, empty) and verify correctness.
- Iterate on differences until the implementation matches the design within acceptable tolerances.

## State Decision Framework

| State type   | When to use                 | Example                               |
| ------------ | --------------------------- | ------------------------------------- |
| Local state  | UI-only, single component   | Modal open/close, input value         |
| Lifted state | Shared between 2-3 siblings | Filter applied to a sibling list      |
| Context / DI | Deeply nested consumption   | Theme, locale, auth status            |
| Global store | Complex cross-cutting state | Multi-step form wizard, shopping cart |
| Server cache | Remote data with caching    | API responses, paginated lists        |

## Barrel File Guidelines

| Rule               | Description                                                        |
| ------------------ | ------------------------------------------------------------------ |
| Create barrel when | Folder exports are consumed by OTHER modules (public API boundary) |
| Avoid barrel when  | Internal utils serving a single parent component — import directly |
| Re-export style    | Named re-exports only: `export { Button } from './Button'`         |
| Never wildcard     | Avoid `export * from` — breaks tree shaking, hides API surface     |
| Keep flat          | One level deep — no barrel importing another barrel                |
| Test with build    | Verify barrel doesn't pull unused code into bundle                 |

## Component Checklist

```
Component:
- [ ] Single responsibility — one clear purpose
- [ ] Typed props — explicit types, sensible defaults
- [ ] Named export — no default exports
- [ ] Design tokens — no hardcoded visual values
- [ ] Error state — handles failure gracefully
- [ ] Loading state — shows progress indicator
- [ ] Empty state — meaningful message when no data
- [ ] Composition — uses children/slots, not prop sprawl
- [ ] Assets — uses exported files, no recreated icons/images
```

## Anti-Patterns

| Anti-Pattern                                 | Instead Do                                                         |
| -------------------------------------------- | ------------------------------------------------------------------ |
| Hardcoded colors/spacing (`#3B82F6`, `16px`) | Use design tokens (`var(--color-primary-500)`, `theme.spacing(2)`) |
| Monolithic component (300+ lines)            | Split into composed sub-components                                 |
| Props drilling through 4+ levels             | Use context or composition pattern                                 |
| Duplicating existing component               | Extend existing with variants                                      |
| Inline styles for theming                    | Use design system's styling approach                               |
| `export default`                             | Named exports for consistency and refactoring                      |
| `any` type for props                         | Explicit type definitions                                          |
| Barrel file for internal utils               | Direct imports for single-consumer folders                         |
| Recreating Figma icons/images in code (inline SVG paths, CSS shapes) | Export assets from Figma, save to project asset directory, reference via `<img>` or component import |

## Framework-Specific Patterns

The patterns above are framework-agnostic. For framework-specific implementation guidance, load the appropriate reference:

- **React**: See `./references/react-patterns.md` — hooks, JSX composition, error boundaries, memoization patterns.

## Connected Skills

- `tsh-ui-verifying` - for verifying implementation against Figma designs
- `tsh-technical-context-discovering` - for understanding project conventions before implementing
- `tsh-ensuring-accessibility` — to ensure components meet WCAG 2.1 AA standards
- `tsh-optimizing-frontend` — for performance considerations during component implementation
- `tsh-implementing-forms` — for form-specific component patterns and validation
- `tsh-writing-hooks` — for custom hook patterns used within components
- `tsh-reviewing-frontend` — for frontend-specific code review of implemented components
