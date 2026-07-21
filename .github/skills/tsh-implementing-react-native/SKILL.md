---
name: tsh-implementing-react-native
description: "React Native component patterns, platform-specific code, native styling with design tokens, navigation structure, gesture handling, and Figma-to-native workflow. Use when implementing mobile UI components, translating Figma designs into React Native code, managing component state in mobile apps, or integrating with a design system in React Native."
---

# Implementing React Native

Provides patterns for building reusable, composable React Native components with design system integration, platform-aware code, and a structured Figma-to-native workflow.

<target-project-profile-gate>
Before applying any Expo, router, package, version, or API guidance, inspect and record the target project's profile:

- framework mode: Expo managed, Expo prebuild/dev client, or bare React Native, as applicable
- React Native, React, and Expo SDK versions, when Expo is present
- router and its version, if any
- JavaScript engine and New Architecture setting
- installed packages relevant to the requested work
- whether native `ios/` and `android/` directories are present
- package manager
- available build, test, capture, and verification tooling

Treat this discovered profile and the corresponding official compatibility documentation as authoritative. Do not assume Expo, a router, a package, a version, an API, or a package manager; do not add a dependency unless the target profile and compatibility documentation support it. Load the existing references for detailed compatibility and fallback guidance after this gate.
</target-project-profile-gate>

<ownership-and-routing>
Rendered React Native screens, components, navigation, layouts, styling, gestures, animations, and accessibility-facing UI route to the existing `tsh-ui-engineer`, which loads this skill. React Native business logic, state, data, services, integrations, and other non-UI work remain on the existing non-UI route. Do not create or name a new mobile agent or prompt.
</ownership-and-routing>

<router-and-export-policy>
Route and layout files follow the required export contract of the selected router. Ordinary React Native components keep the repository's named-export convention. Do not apply the ordinary-component export rule to route or layout files without checking the selected router.
</router-and-export-policy>

<verification-boundary>
Collection-supported browser and Figma verification applies only to web-compatible artifacts and workflows. Playwright or other browser artifacts do not verify native React Native UI. Simulator/device builds, native accessibility checks, and native E2E evidence are owned by the target project and only apply when its tooling provides them. Use connected guidance platform-neutrally only where it remains valid, and exclude web-only criteria from native React Native files.
</verification-boundary>

<principles>

<declarative-over-imperative>
Define what the UI should look like based on state, not how to manipulate native views. Describe the desired outcome through components and state declarations. Let React Native and the Fabric renderer handle view reconciliation. Compose complex screens from simple, predictable building blocks.
</declarative-over-imperative>

<composition-over-complexity>
Build complex screens by composing small, focused components rather than creating monolithic ones. Each component should have a single clear responsibility. Prefer children, slots, and compound component patterns over deep prop trees. Mobile screens have more layout constraints — leverage composition to handle platform variations without branching logic inside components.
</composition-over-complexity>

<design-system-first>
Always use design tokens (colors, spacing, typography, radii) from the project's design system. Never hardcode visual values. Map Figma specs to existing tokens. If no exact token match exists, find the closest and document the deviation — do not invent tokens without approval. In React Native this means referencing a shared theme object or token constants — never inline raw numbers or hex colors in `StyleSheet.create()`.
</design-system-first>

<platform-aware-not-platform-split>
Write shared code by default. Introduce platform-specific behavior only when the platforms genuinely differ (e.g., status bar handling, haptic feedback, platform-specific APIs). Use `Platform.select()` or `.ios.tsx` / `.android.tsx` file extensions for targeted divergence. If more than ~30% of a component is platform-specific, split into separate platform files rather than littering the component with conditionals.
</platform-aware-not-platform-split>

<never-guess>
If design context, tokens, or specifications are missing or unclear, stop and ask the user. Do not proceed with assumptions about visual implementation. Missing information produces wrong UI — asking produces correct UI.
</never-guess>

</principles>

## Implementation Process

Use the checklist below and track progress:

```
Progress:
- [ ] Step 0: Discover the target-project profile
- [ ] Step 1: Gather design context
- [ ] Step 2: Plan component structure
- [ ] Step 3: Implement components
- [ ] Step 4: Organize modules
- [ ] Step 5: Verify implementation
```

**Step 1: Gather design context**

- Extract specs from Figma (via MCP tool if available). Identify components, spacing, typography, colors, hit areas, and interaction states.
- Map every Figma value to an existing design token in the codebase:
  1. Extract the raw value from Figma (e.g., `#3B82F6`, `16`).
  2. Search the codebase for a matching token (theme file, token constants, or a design system package).
  3. If a token exists — use it.
  4. If no exact match — find the closest existing token and document the deviation.
  5. If truly new — flag it and ask the user before creating.
- Identify all states the design implies: default, pressed, focused, disabled, loading, error, empty.
- Identify platform-specific design differences. Check if the design has separate iOS and Android frames. Note where platform conventions diverge (e.g., back navigation, status bar style, bottom sheet behavior).
- Check touch target sizes — minimum 44×44 points on iOS, 48×48 dp on Android (Material Design guideline).

**Step 2: Plan component structure**

- Decide component boundaries: what is a reusable component vs. screen-specific layout.
- Identify the props interface for each component — typed, with sensible defaults.
- Determine state needs using the State Decision Framework table below.
- Search the codebase for existing similar components. Extend or compose existing components rather than duplicating.
- Sketch the component tree: parent → children relationships, data flow direction, and where state lives.
- Identify which components need platform-specific rendering and decide the branching strategy (inline `Platform.select`, separate files, or a wrapper component).

**Step 3: Implement components**

Follow these patterns for every component:

- **Composition**: Use composition patterns — content projection (`children`), render delegation, compound components — to keep components flexible. Avoid prop sprawl — if a component accepts more than ~7 props, it likely needs decomposition.
- **Typed props**: Define explicit TypeScript types for all props. Never use `any`. Co-locate types in `ComponentName.types.ts`.
- **Exports by file role**: Use named exports for ordinary React Native components. Route and layout files must follow the selected router's required export contract, including a default export when that router requires one.
- **StyleSheet.create()**: Always use `StyleSheet.create()` for styles. It validates style properties at creation time and enables native-side optimizations. Never pass raw style objects repeatedly.
- **Three UI states**: Every data-dependent component must handle loading (skeleton or activity indicator), error (meaningful message + recovery action), and empty (helpful message when no data).
- **Error boundaries**: Wrap screen-level or feature-level components with the error-boundary approach already supported by the target profile. Use an installed, compatible library or the project's custom `ErrorBoundary`; do not add `react-native-error-boundary` or `expo-error-recovery` solely from this skill. Error boundaries do NOT catch errors in event handlers, async code, or native crashes — handle those separately.
- **Design tokens**: All visual values (colors, spacing, typography, shadows, radii) must come from the design system theme. Zero hardcoded values in style definitions.
- **Platform touch feedback**: Use the touch API supported by the target React Native version and project conventions. Configure platform-appropriate feedback only when the selected API and profile support it; do not replace existing touchables or add a package without a compatibility check.
- **Safe areas**: Use the safe-area API supported by the target profile for screens near device edges. Use an installed, compatible safe-area package only when the project already supports it or the target owner approves adding it; otherwise use the supported core fallback.

For framework-specific patterns (React Native with Expo, React Navigation, Reanimated), load the appropriate reference from `./references/`.

**Step 4: Organize modules**

Apply barrel file rules from the Barrel File Guidelines table below:

- Create `index.ts` barrel files at public API boundaries — folders whose exports are consumed by other modules.
- Use named re-exports only: `export { Button } from './Button'`.
- Skip barrels for internal utility folders that serve a single parent component.
- Verify the barrel doesn't re-export unused internals. In React Native projects, unused re-exports still increase the JS bundle parsed by Hermes.

**Step 5: Verify implementation**

- If a calling workflow provides a verification loop (e.g., the Engineering Manager runs `tsh-ui-reviewer` automatically during `/tsh-implement`), defer to that workflow — do not duplicate verification here.
- If no verification workflow is active, use the `tsh-ui-verifying` skill only for collection-supported web/Figma browser verification of web-compatible artifacts. For native React Native UI, use target-project-owned simulator/device evidence when available; do not represent browser artifacts as native verification.
- Walk through each interaction state (pressed, focused, disabled, error, loading, empty) and verify correctness on both platforms.
- When the target project provides native build and test tooling, validate on its supported iOS and Android targets — styles that look correct on one platform may differ on the other (shadows, elevation, font rendering, status bar overlaps). The collection does not execute or claim this native verification.
- Verify touch targets meet minimum size requirements (44×44 pt iOS / 48×48 dp Android).
- Check with platform-specific accessibility tools supplied by the target project (VoiceOver on iOS, TalkBack on Android); browser accessibility artifacts do not establish native accessibility behavior.

## State Decision Framework

| State type   | When to use                 | Example                                     |
| ------------ | --------------------------- | ------------------------------------------- |
| Local state  | UI-only, single component   | Modal visibility, input value, toggle state |
| Lifted state | Shared between 2-3 siblings | Filter applied to a sibling list            |
| Context / DI | Deeply nested consumption   | Theme, locale, auth status                  |
| Global store | Complex cross-cutting state | Multi-step form wizard, shopping cart       |
| Server cache | Remote data with caching    | API responses, paginated lists              |

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
- [ ] Export contract — named export for ordinary components; selected router contract for route/layout files
- [ ] Design tokens — no hardcoded visual values
- [ ] Error state — handles failure gracefully
- [ ] Loading state — shows skeleton or activity indicator
- [ ] Empty state — meaningful message when no data
- [ ] Composition — uses children/slots, not prop sprawl
- [ ] StyleSheet.create() — no inline style objects
- [ ] Touch API — follows the target profile and compatibility documentation
- [ ] Safe areas — respects notches and system bars
- [ ] Touch targets — minimum 44×44 pt (iOS) / 48×48 dp (Android)
- [ ] Platform tested — verified with the target project's supported iOS and Android tooling, when available
```

## Anti-Patterns

| Anti-Pattern                                     | Instead Do                                                                          |
| ------------------------------------------------ | ----------------------------------------------------------------------------------- |
| Hardcoded colors/spacing (`#3B82F6`, `16`)       | Use design tokens (`theme.colors.primary500`, `theme.spacing.md`)                   |
| Monolithic screen component (300+ lines)         | Split into composed sub-components                                                  |
| Props drilling through 4+ levels                 | Use context or composition pattern                                                  |
| Duplicating existing component                   | Extend existing with variants                                                       |
| Inline style objects (`style={{ padding: 16 }}`) | Use `StyleSheet.create()` and reference by key                                      |
| Default export on an ordinary component         | Named exports for consistency; follow the selected router for route/layout files     |
| `any` type for props                             | Explicit type definitions                                                           |
| Barrel file for internal utils                   | Direct imports for single-consumer folders                                          |
| Replacing a target-supported touch API blindly  | Check the target profile and compatibility documentation before changing touch APIs  |
| `Platform.OS === 'ios' ? ... : ...` everywhere   | Use `Platform.select()` or platform-specific file extensions for cleaner separation |
| Raw `View` as touchable with `onPress`           | Use `Pressable` — raw `View` has no accessibility role or touch feedback            |
| Percentage-based dimensions for everything       | Use flex layout; reserve percentages for specific layout needs                      |

## Framework-Specific Patterns

The patterns above are framework-agnostic. Load the references below for detailed framework, router, and performance guidance. Apply Expo-specific tooling and library details only when the discovered profile includes compatible Expo support:

- **Expo + React Native Core**: See `./references/react-native-patterns.md` — Expo modules, New Architecture, styling patterns, platform-specific code, gestures, animations, keyboard handling.
- **Navigation (selected router)**: See `./references/react-native-navigation.md` — apply Expo Router, React Navigation, or another router's file, deep-linking, and screen-organization patterns only when selected by the target profile.
- **Performance**: See `./references/react-native-performance.md` — FlashList/FlatList optimization, Hermes, memory management, startup time, bundle analysis.

## Connected Skills

- `tsh-ui-verifying` — for collection-supported web/Figma browser verification; target projects own native simulator/device and accessibility evidence
- `tsh-technical-context-discovering` — for understanding project conventions before implementing
- `tsh-ensuring-accessibility` — to ensure components meet accessibility standards on both platforms
- `tsh-optimizing-frontend` — for platform-neutral performance considerations where they remain valid for the target profile
- `tsh-implementing-forms` — for form-specific component patterns and validation (schema-first validation applies in RN)
- `tsh-writing-hooks` — for custom hook patterns used within components
- `tsh-reviewing-frontend` — for platform-neutral component review; exclude its web-only criteria from native React Native files
