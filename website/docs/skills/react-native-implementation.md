---
sidebar_position: 32
title: React Native Implementation
---

# React Native Implementation

**Folder:** `.github/skills/tsh-implementing-react-native/`  
**Used by:** Software Engineer

Provides comprehensive React Native guidelines covering component design, platform-specific code, design system integration, navigation, gestures, animations, and performance optimization for mobile apps.

## Component Design Principles

- **Composition over complexity** — Build complex screens from small, focused components.
- **Platform-aware, not platform-split** — Write shared code by default; introduce platform-specific behavior only when platforms genuinely differ.
- **Design tokens** — All visual values come from a centralized theme. Zero hardcoded colors, spacing, or typography in `StyleSheet.create()`.
- **Pressable standard** — Use `Pressable` for all touchable elements. Deprecated `TouchableOpacity` / `TouchableHighlight` are not permitted.

## Implementation Process

A 5-step workflow mirrors the frontend implementation skill, adapted for mobile:

1. **Gather design context** — Extract specs from Figma, map values to tokens, identify platform differences and touch target sizes.
2. **Plan component structure** — Define boundaries, props interfaces, state ownership, and platform-branching strategy.
3. **Implement components** — Build with typed props, `StyleSheet.create()`, composition patterns, three UI states (loading/error/empty), safe areas, and proper touch feedback.
4. **Organize modules** — Barrel files at public boundaries, named exports only.
5. **Verify implementation** — Test on both iOS and Android, verify touch targets, check with VoiceOver and TalkBack.

## Platform-Specific Code

| Divergence Level | Strategy |
|---|---|
| Single value differs (shadow, spacing) | `Platform.select()` inline |
| A few lines differ | `Platform.OS === 'ios'` conditional |
| 30%+ of component differs | Separate `.ios.tsx` / `.android.tsx` files |
| Entirely different native API | Separate files + shared types/hook |

## Styling Patterns

| Pattern | Approach |
|---|---|
| **Static styles** | `StyleSheet.create()` — validates at creation, enables native optimizations |
| **Dynamic styles** | Style arrays: `[styles.base, { opacity: disabled ? 0.5 : 1 }]` |
| **Variants** | Map variants to pre-created stylesheet entries |
| **Responsive** | Flexbox by default; `useWindowDimensions()` for screen-relative sizing |
| **Tokens** | Centralized theme object with colors, spacing, typography, radii |

## Navigation

**Expo Router is the standard** for all Expo projects:

| Library | Model | When to use |
|---|---|---|
| **Expo Router 4+** | File-based | **Default** — all new Expo projects |
| **React Navigation 7+** | Imperative | Legacy projects already using it |

Key patterns: typed routes, native stack (not JS stack), `useFocusEffect` for data refresh, deep linking configuration.

## Performance Guidelines

| Area | Approach |
|---|---|
| **Lists** | `FlashList` with `estimatedItemSize`; `React.memo` on all list items |
| **Images** | `expo-image` with blurhash placeholders and `recyclingKey` |
| **Animations** | `react-native-reanimated` (UI thread); never `Animated` from core |
| **Gestures** | `react-native-gesture-handler` (native thread) |
| **Startup** | Minimize root imports; inline `require()` for heavy modules; `expo-splash-screen` |
| **Bundle** | Named imports only; analyze with `react-native-bundle-visualizer` |

## Anti-Patterns

| Anti-Pattern | Correction |
|---|---|
| Inline style objects | Use `StyleSheet.create()` |
| `TouchableOpacity` | Use `Pressable` with platform feedback |
| `Animated` from react-native core | Use `react-native-reanimated` |
| `PanResponder` | Use `react-native-gesture-handler` |
| `ScrollView` for long lists | Use `FlashList` or `FlatList` |
| Hardcoded colors/spacing | Use design tokens from theme |
| Missing touch target sizes | Minimum 44×44 pt (iOS) / 48×48 dp (Android) |
| `@react-navigation/stack` (JS stack) | Use `@react-navigation/native-stack` |
| Base64 images in state | Use `expo-image` disk cache |

## References

The skill includes detailed reference files:

- **Core patterns** — Component composition, styling, platform code, Pressable, safe areas, gestures, animations, New Architecture.
- **Navigation** — React Navigation and Expo Router patterns, deep linking, typed routes, screen organization.
- **Performance** — List optimization, image handling, startup time, bundle size, memoization, memory management, Hermes engine.

## Connected Skills

- `tsh-ui-verifying` — Verification criteria and tolerances.
- `tsh-technical-context-discovering` — Project conventions.
- `tsh-ensuring-accessibility` — WCAG compliance on both platforms.
- `tsh-implementing-forms` — Schema-based validation for mobile forms.
- `tsh-writing-hooks` — Custom hook patterns.
- `tsh-reviewing-frontend` — Code review for components.

:::warning Never Guess — Always Ask
If a design specification is unclear, a token is missing, or behavior is ambiguous, stop and ask. Do not guess or make assumptions about design intent.
:::
