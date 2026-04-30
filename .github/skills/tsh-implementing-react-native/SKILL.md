---
name: tsh-implementing-react-native
description: "React Native component patterns, platform-specific code, native styling with design tokens, navigation structure, gesture handling, and Figma-to-native workflow. Use when implementing mobile UI components, translating Figma designs into React Native code, managing component state in mobile apps, or integrating with a design system in React Native."
---

# Implementing React Native

Provides patterns for building reusable, composable React Native components with design system integration, platform-aware code, and a structured Figma-to-native workflow.

<principles>

<declarative-over-imperative>
Define what the UI should look like based on state, not how to manipulate native views. Describe the desired outcome through components and state declarations. Let React Native and the Fabric renderer handle view reconciliation. Compose complex screens from simple, predictable building blocks.
</declarative-over-imperative>

<composition-over-complexity>
Build complex screens by composing small, focused components rather than creating monolithic ones. Each component should have a single clear responsibility. Prefer children, slots, and compound component patterns over deep prop trees. Mobile screens have more layout constraints — leverage composition to handle platform variations without branching logic inside components.
</composition-over-complexity>

<design-system-first>
Always use design tokens (colors, spacing, typography, radii) from the project's design system. Never hardcode visual values. Map Figma specs to existing tokens. If no exact token match exists, find the closest and document the deviation — do not invent tokens without approval. In React Native this means referencing a shared theme object or token constants — never inline raw numbers or hex colors in style definitions, regardless of the styling approach used (StyleSheet, Unistyles, NativeWind, Styled Components, Tamagui, Restyle, etc.).
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
- **Named exports only**: Use `export { ComponentName }` — no default exports. This ensures consistent imports and simplifies refactoring.
- **Consistent styling**: Follow the project's established styling approach (e.g., `StyleSheet.create()`, Unistyles, NativeWind/Tailwind, Styled Components, Tamagui, Restyle). Discover the styling pattern by checking existing components before writing new styles. Never mix multiple styling approaches in the same project unless there is a documented migration path. Avoid passing inline style object literals repeatedly — use the project's pattern for reusable style definitions.
- **Three UI states**: Every data-dependent component must handle loading (skeleton or activity indicator), error (meaningful message + recovery action), and empty (helpful message when no data).
- **Error boundaries**: Wrap screen-level or feature-level components with an error boundary to catch JS rendering errors gracefully. Use `react-native-error-boundary` or a custom `ErrorBoundary` class component. For Expo projects, `expo-error-recovery` can restore state after fatal JS errors. Note: error boundaries do NOT catch errors in event handlers, async code, or native crashes — handle those separately.
- **Design tokens**: All visual values (colors, spacing, typography, shadows, radii) must come from the design system theme. Zero hardcoded values in style definitions.
- **Platform touch feedback**: Use `Pressable` as the standard touchable component. Configure `android_ripple` for Material ripple on Android and opacity/highlight feedback on iOS. Avoid deprecated `TouchableOpacity`, `TouchableHighlight`, `TouchableWithoutFeedback`.
- **Safe areas**: Use `SafeAreaView` or equivalent safe area hooks from `react-native-safe-area-context` for screens that render near device edges (notches, home indicators, status bars).

For framework-specific patterns (React Native with Expo, React Navigation, Reanimated), load the appropriate reference from `./references/`.

**Step 4: Organize modules**

Apply barrel file rules from the Barrel File Guidelines table below:

- Create `index.ts` barrel files at public API boundaries — folders whose exports are consumed by other modules.
- Use named re-exports only: `export { Button } from './Button'`.
- Skip barrels for internal utility folders that serve a single parent component.
- Verify the barrel doesn't re-export unused internals. In React Native projects, unused re-exports still increase the JS bundle parsed by Hermes.

**Step 5: Verify implementation**

- If a calling workflow provides a verification loop (e.g., the Engineering Manager runs `tsh-ui-reviewer` automatically during `/tsh-implement`), defer to that workflow — do not duplicate verification here.
- If no verification workflow is active, use `./references/react-native-ui-verification.md` to compare the implementation against the Figma design.
- Walk through each interaction state (pressed, focused, disabled, error, loading, empty) and verify correctness on both platforms.
- Test on both iOS and Android — styles that look correct on one platform may differ on the other (shadows, elevation, font rendering, status bar overlaps).
- Verify touch targets meet minimum size requirements (44×44 pt iOS / 48×48 dp Android).
- Verify accessibility using `./references/react-native-accessibility.md` — test with VoiceOver (iOS) and TalkBack (Android).
- Check with platform-specific accessibility tools (VoiceOver on iOS, TalkBack on Android).

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
- [ ] Named export — no default exports
- [ ] Design tokens — no hardcoded visual values
- [ ] Error state — handles failure gracefully
- [ ] Loading state — shows skeleton or activity indicator
- [ ] Empty state — meaningful message when no data
- [ ] Composition — uses children/slots, not prop sprawl
- [ ] Consistent styling — follows project's styling system, no ad-hoc inline literals
- [ ] Pressable — uses Pressable, not deprecated Touchable*
- [ ] Safe areas — respects notches and system bars
- [ ] Touch targets — minimum 44×44 pt (iOS) / 48×48 dp (Android)
- [ ] Platform tested — verified on both iOS and Android
```

## Anti-Patterns

| Anti-Pattern                                     | Instead Do                                                                          |
| ------------------------------------------------ | ----------------------------------------------------------------------------------- |
| Hardcoded colors/spacing (`#3B82F6`, `16`)       | Use design tokens (`theme.colors.primary500`, `theme.spacing.md`)                   |
| Monolithic screen component (300+ lines)         | Split into composed sub-components                                                  |
| Props drilling through 4+ levels                 | Use context or composition pattern                                                  |
| Duplicating existing component                   | Extend existing with variants                                                       |
| Inline style object literals (`style={{ padding: 16 }}`) | Use the project's styling system (StyleSheet, Unistyles, NativeWind, etc.)           |
| `export default`                                 | Named exports for consistency and refactoring                                       |
| `any` type for props                             | Explicit type definitions                                                           |
| Barrel file for internal utils                   | Direct imports for single-consumer folders                                          |
| `TouchableOpacity` / `TouchableHighlight`        | Use `Pressable` with platform-appropriate feedback                                  |
| `Platform.OS === 'ios' ? ... : ...` everywhere   | Use `Platform.select()` or platform-specific file extensions for cleaner separation |
| Raw `View` as touchable with `onPress`           | Use `Pressable` — raw `View` has no accessibility role or touch feedback            |
| Percentage-based dimensions for everything       | Use flex layout; reserve percentages for specific layout needs                      |

## Framework-Specific Patterns

The patterns above are framework-agnostic. All projects use Expo — load the references below for Expo-specific tooling and library details:

- **Expo + React Native Core**: See `./references/react-native-patterns.md` — Expo modules, New Architecture, styling patterns, platform-specific code, gestures, animations, keyboard handling.
- **Navigation (Expo Router)**: See `./references/react-native-navigation.md` — Expo Router file-based routing (default), React Navigation patterns (legacy projects), deep linking, screen organization.
- **Performance**: See `./references/react-native-performance.md` — FlashList/FlatList optimization, Hermes, memory management, startup time, bundle analysis.

## Connected Skills

- `tsh-technical-context-discovering` — fully applicable; for understanding project conventions before implementing
- `tsh-writing-hooks` — fully applicable; hook patterns (naming, cleanup, dependency tracking, testing) work identically in React Native
- `tsh-reviewing-frontend` — use Steps 1-3 only (component structure, hooks quality, rendering correctness); skip Steps 4-5 (web-specific accessibility/performance spot-checks) — use `./references/react-native-accessibility.md` and `./references/react-native-performance.md` instead
- `tsh-implementing-forms` — schema-first validation, type inference, multi-step flow logic, and validation timing apply; ignore HTML-specific markup (`<form>`, `novalidate`, `for`/`id` labels, `role="alert"`, Enter-key submission)
- `tsh-optimizing-frontend` — memoization, key stability, memory cleanup, and state granularity apply; ignore web metrics (LCP/CLS/INP, Lighthouse), DOM depth, CSS animations, `will-change`, font loading, SSR/SSG — use `./references/react-native-performance.md` instead
- `tsh-ensuring-accessibility` — NOT applicable for React Native; the skill covers web-only patterns (semantic HTML, ARIA, axe-core, keyboard Tab navigation) — use `./references/react-native-accessibility.md` instead
- `tsh-ui-verifying` — NOT applicable for React Native; the skill requires Playwright and browser dev server — use `./references/react-native-ui-verification.md` instead
