# React Native Implementation Patterns

React Native-specific patterns for the `tsh-implementing-react-native` skill. Load this reference after discovering the consuming project's profile; it is not an Expo application standard or a package catalogue.

## Table of Contents

- [Target Profile and Compatibility](#target-profile-and-compatibility)
- [Project Structure](#project-structure)
- [Component Composition](#component-composition)
- [Styling Patterns](#styling-patterns)
- [Platform-Specific Code](#platform-specific-code)
- [Pressable and Touch Feedback](#pressable-and-touch-feedback)
- [Safe Areas and Layout](#safe-areas-and-layout)
- [Images and Media](#images-and-media)
- [Gestures and Animations](#gestures-and-animations)
- [New Architecture and Expo Modules](#new-architecture-and-expo-modules)
- [Verification Boundary](#verification-boundary)
- [Anti-Patterns](#anti-patterns)

## Target Profile and Compatibility

Before recommending an import, package, API, or migration, inspect and record the target project's evidence:

- package manager, manifest, and lockfile
- framework mode: Expo managed, Expo prebuild/dev client, or bare React Native
- exact React Native and React versions, plus the Expo SDK version when Expo is present
- selected router and version, if any
- JavaScript engine and New Architecture setting
- installed packages and native configuration relevant to the requested behavior
- presence and current state of native `ios/` and `android/` directories, including whether a dev build or prebuild workflow is used
- available build, test, capture, and native accessibility tooling

Check the official installation and compatibility documentation for the exact discovered versions before giving package or API advice. A package name, an Expo SDK, a React Native version, or a native API in an example is not evidence that it is installed or compatible.

Keep two kinds of guidance separate:

- **Project conventions:** facts observed in the target repository, such as an existing safe-area wrapper, touchable abstraction, router, or design-token API. Preserve them unless the task explicitly changes the convention.
- **Recommendations:** conditional options evaluated against the profile, official compatibility documentation, native build state, and a measured or demonstrated need. Do not present a recommendation as a required dependency.

## Project Structure

There is no universal Expo or bare React Native layout. Follow the target project's existing structure and router. An illustrative organization is useful only when it matches the discovered profile:

```
src/
├── app/                  # Use only when the selected router uses file-based routes
├── screens/              # Use when the selected router keeps screens separate
├── components/           # Reusable design system and feature components
├── hooks/                # Custom hooks
├── services/             # API clients, storage, analytics
├── stores/               # State modules already used by the project
├── theme/                # Design tokens and theme provider
├── types/                # Shared TypeScript types
└── utils/                # Pure utility functions
```

Project conventions to preserve when present:
- Co-locate component types: `Button.types.ts` next to `Button.tsx`.
- Co-locate component styles: `Button.styles.ts` next to `Button.tsx` for complex components, or use `StyleSheet.create()` in the component file for simpler components.
- Keep one component per file when that matches the repository's organization. The filename should match the component name.

## Component Composition

React Native implements the generic composition patterns as follows:

| Generic Pattern     | React Native Implementation                                                             |
| ------------------- | --------------------------------------------------------------------------------------- |
| Content projection  | `children` prop — renders child components inside a container `View`                    |
| Render delegation   | Render props: `renderItem={(item) => <ListItem data={item} />}`                         |
| Compound components | Shared context between parent and sub-components (`Select` + `Select.Option`)           |
| Slots               | Named props accepting `ReactNode`: `leftIcon`, `rightIcon`, `header`, `footer`          |

Prefer `children` for single content projection. Use named `ReactNode` props (slots) when multiple projection points are needed — this is very common in RN for list headers, footers, empty states, and icon slots. Use compound components for tightly coupled UI groups (tabs, accordion, select).

### Text must always be in `<Text>`

In React Native, all text content MUST be wrapped in a `<Text>` component. Unlike web, you cannot place raw strings inside `<View>`. This is the most common mistake for web developers transitioning to RN.

```typescript
// WRONG — crashes at runtime
<View>Hello world</View>

// CORRECT
<View><Text>Hello world</Text></View>
```

This applies to conditional text too — `{count > 0 && <Text>{count}</Text>}` not `{count > 0 && count}`.

### Typed component pattern

```typescript
import { type ReactNode } from 'react';
import { View, StyleSheet } from 'react-native';

type CardProps = {
  children: ReactNode;
  header?: ReactNode;
  footer?: ReactNode;
  variant?: 'elevated' | 'outlined' | 'filled';
};

const Card = ({ children, header, footer, variant = 'elevated' }: CardProps) => (
  <View style={[styles.container, styles[variant]]}>
    {header && <View style={styles.header}>{header}</View>}
    <View style={styles.body}>{children}</View>
    {footer && <View style={styles.footer}>{footer}</View>}
  </View>
);

export { Card };
export type { CardProps };
```

## Styling Patterns

### StyleSheet.create()

Always use `StyleSheet.create()`. It validates style keys at creation time and enables optimizations on the native side.

```typescript
const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: theme.spacing.md,
    backgroundColor: theme.colors.background,
  },
  title: {
    ...theme.typography.heading2,
    color: theme.colors.textPrimary,
  },
});
```

### Theme and design tokens

Centralize tokens in a theme object. Access them via a theme hook or direct import — match the project's existing pattern.

```typescript
// theme/tokens.ts
const tokens = {
  colors: {
    primary500: '#3B82F6',
    primary600: '#2563EB',
    background: '#FFFFFF',
    surface: '#F8FAFC',
    textPrimary: '#0F172A',
    textSecondary: '#64748B',
    error: '#EF4444',
    success: '#22C55E',
  },
  spacing: {
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
    xxl: 48,
  },
  radii: {
    sm: 4,
    md: 8,
    lg: 16,
    full: 9999,
  },
  typography: {
    heading1: { fontSize: 32, lineHeight: 40, fontWeight: '700' as const },
    heading2: { fontSize: 24, lineHeight: 32, fontWeight: '600' as const },
    body: { fontSize: 16, lineHeight: 24, fontWeight: '400' as const },
    caption: { fontSize: 12, lineHeight: 16, fontWeight: '400' as const },
  },
} as const;
```

### Dynamic / conditional styles

Combine static styles with dynamic values using style arrays. Keep the static base in `StyleSheet.create()` and overlay dynamic parts:

```typescript
<View style={[styles.container, { opacity: disabled ? 0.5 : 1 }]} />
```

For variant-based styling, map variants to pre-created stylesheet entries rather than computing styles inline:

```typescript
const variantStyles = StyleSheet.create({
  elevated: { elevation: 4, shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 4 },
  outlined: { borderWidth: 1, borderColor: theme.colors.border },
  filled: { backgroundColor: theme.colors.surface },
});

// Usage — compose base + variant
<View style={[styles.container, variantStyles[variant]]} />
```

### Responsive sizing

React Native uses density-independent pixels. Avoid percentage-based layouts as default — prefer Flexbox:

| Need                              | Approach                                                     |
| --------------------------------- | ------------------------------------------------------------ |
| Fill available space              | `flex: 1`                                                    |
| Distribute children evenly        | `flex: 1` on each child inside a flex container              |
| Responsive columns                | `flexDirection: 'row'`, `flexWrap: 'wrap'`, fixed item width |
| Screen-relative sizing (rare)     | `useWindowDimensions()` hook                                 |
| Tablet / foldable layout adaption | `useWindowDimensions()` + breakpoint constants               |

## Platform-Specific Code

### Platform.select()

For small, value-level differences:

```typescript
import { Platform, StyleSheet } from 'react-native';

const styles = StyleSheet.create({
  shadow: Platform.select({
    ios: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.1,
      shadowRadius: 4,
    },
    android: {
      elevation: 4,
    },
    default: {},
  }),
});
```

### Platform file extensions

For larger divergence (different component trees, different native APIs), use file extensions:

```
StatusBarManager.tsx          # Shared logic, if any
StatusBarManager.ios.tsx      # iOS-specific implementation
StatusBarManager.android.tsx  # Android-specific implementation
```

Metro bundler automatically resolves the correct file. Both files must export the same public API (same named exports and types).

### Decision guide

| Divergence level                       | Strategy                              |
| -------------------------------------- | ------------------------------------- |
| Single value differs (shadow, spacing) | `Platform.select()` inline            |
| A few lines differ                     | `Platform.OS === 'ios'` conditional   |
| 30%+ of component differs             | Separate `.ios.tsx` / `.android.tsx`   |
| Entirely different native API          | Separate files + shared types/hook    |

## Pressable and Touch Feedback

Treat the touch primitive as a profile and project-convention decision. When the target React Native version supports core `Pressable` and the project has no established abstraction, it provides pressed-state styling and accessibility props without adding a package. If the target version or project uses another supported touchable, retain that API and check its official documentation before changing it; do not infer a deprecation or migration requirement from this reference.

When core `Pressable` is supported, an actionable control should provide a sufficient hit area and communicate its state:

```typescript
import { Pressable, StyleSheet } from 'react-native';

const ActionButton = ({ onPress, label, disabled }: ActionButtonProps) => (
  <Pressable
    onPress={onPress}
    disabled={disabled}
    style={({ pressed }) => [
      styles.button,
      pressed && styles.buttonPressed,
      disabled && styles.buttonDisabled,
    ]}
    accessibilityRole="button"
    accessibilityLabel={label}
    accessibilityState={{ disabled }}
  >
    <Text style={styles.buttonText}>{label}</Text>
  </Pressable>
);

const styles = StyleSheet.create({
  button: {
    minHeight: 48,
    minWidth: 48,
    paddingHorizontal: theme.spacing.lg,
    paddingVertical: theme.spacing.md,
    borderRadius: theme.radii.md,
    backgroundColor: theme.colors.primary500,
    alignItems: 'center',
    justifyContent: 'center',
  },
  buttonPressed: {
    backgroundColor: theme.colors.primary600,
  },
  buttonDisabled: {
    opacity: 0.5,
  },
  buttonText: {
    ...theme.typography.body,
    color: theme.colors.onPrimary,
    fontWeight: '600',
  },
});
```

Actionable controls should meet the target platform's touch guidance, commonly at least 44x44 pt on iOS and 48x48 dp on Android. Provide the role, accessible name, and state through the API supported by the target profile. Add platform-specific feedback, such as `android_ripple`, only when the selected API, design system, and target React Native version support it.

## Safe Areas and Layout

First inspect the target project's existing safe-area provider and screen composition. Use an installed, compatible safe-area package only when the profile, native configuration, and official installation documentation support it. A package is not included or guaranteed merely because the project uses Expo.

For a project whose target React Native version supports the core component and whose platform requirements fit its documented behavior, the core `SafeAreaView` is a valid fallback:

```typescript
import { SafeAreaView } from 'react-native';

const SettingsScreen = () => (
  <SafeAreaView style={styles.screen}>
    {/* Screen content */}
  </SafeAreaView>
);
```

- Apply safe-area handling at the screen or scroll-content boundary, not indiscriminately to every component.
- Use the selected provider's documented inset API when a screen needs only selected edges or custom padding.
- Do not wrap `FlatList` or `ScrollView` in an additional safe-area wrapper when the selected provider already applies those insets. Use the provider's content-container or inset values to avoid double padding.
- Verify behavior on the target project's supported iOS and Android builds; browser screenshots cannot establish native inset behavior.

### Keyboard avoidance

Start with the core keyboard APIs supported by the target React Native version and the project's existing form pattern. `KeyboardAvoidingView` is a valid baseline when its documented `behavior` and screen layout meet the target requirements:

```typescript
import { KeyboardAvoidingView, Platform } from 'react-native';

const FormScreen = () => (
  <KeyboardAvoidingView
    behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    style={styles.screen}
  >
    {/* Form fields */}
  </KeyboardAvoidingView>
);
```

Consider a package such as `react-native-keyboard-controller` only when it is already installed or the target owner approves it, the exact React Native/Expo and native build profile is compatible, and its official installation documentation has been checked. Use it for a demonstrated focus, scrolling, or animation requirement; do not make it a default replacement for the core API. Any worklet-based keyboard example also requires a compatible installed animation/runtime setup.

## Images and Media

Use the core `Image` API when the target requirements fit its documented loading, caching, and rendering behavior:

```typescript
import { Image } from 'react-native';

<Image source={{ uri: imageUri }} style={styles.image} accessibilityLabel={imageLabel} />;
```

Consider `expo-image` or another image library only when the target profile includes the compatible framework, the package is installed or explicitly approved, and the official installation and compatibility documentation supports the project's native state. Compare the needed caching, formats, placeholders, transitions, and memory behavior with the core API before introducing a replacement. Do not state that an image package is included or required for every Expo or React Native project.

## Gestures and Animations

Choose the simplest API that satisfies the interaction and matches the target profile. Core touch handlers and `PanResponder` can be sufficient for simple interactions. Consider `react-native-gesture-handler` when the target project already uses it or has a demonstrated need for its gesture model, and only after checking its exact React Native/Expo, router, native build, and New Architecture compatibility.

If the selected gesture library is installed and compatible, its API may be paired with the project's installed animation library:

```typescript
import { Gesture, GestureDetector } from 'react-native-gesture-handler';

const panGesture = Gesture.Pan()
  .onUpdate((event) => {
    translateX.value = event.translationX;
  })
  .onEnd(() => {
    translateX.value = withSpring(0);
  });

<GestureDetector gesture={panGesture}>
  <Animated.View style={animatedStyle} />
</GestureDetector>
```

Use `react-native-reanimated` only when it is installed or approved for the target project and the official installation, Babel/native setup, and compatibility documentation match the discovered profile. It is not a universal requirement for animation. The core `Animated` API is a supported fallback when its performance and interaction requirements are sufficient.

When Reanimated is the compatible project choice, keep shared values and animated styles inside the API's documented worklet boundaries. Do not read a shared value during render, and use the target version's documented mechanism when a worklet must call JavaScript. Treat layout-animation and entering/exiting APIs as version-sensitive; check the installed version before using them.

For any animation path:
- Define the intended motion and reduced-motion behavior in the project convention.
- Measure responsiveness on the target build before replacing a core API.
- Keep accessibility state and interaction completion independent from visual animation.
- Verify gestures and animation on target iOS and Android builds when native evidence is available.

## New Architecture and Expo Modules

Inspect the target project's actual New Architecture setting rather than inferring it from a React Native or Expo version. Before adding or changing a native module, check the exact React Native, React, Expo SDK, library, and JavaScript engine versions, native directories or prebuild/dev-build state, and the module's official compatibility and installation documentation.

When New Architecture is enabled, confirm that each relevant native dependency supports the target renderer, module system, and code-generation requirements. When it is disabled, do not enable it or migrate libraries as part of an unrelated UI task. Any Codegen or native-module advice is conditional on a target project that owns the native build and has an approved implementation path.

Expo modules are conditional options, not collection-wide dependencies. Use an `expo-*` import only when the target profile includes Expo, the package is installed or explicitly approved, the native build/prebuild state supports it, and the official Expo/package documentation confirms compatibility with the exact SDK and React Native versions. Otherwise keep the project's current implementation or use a supported core API where one meets the requirement.

| Need | Candidate, only when compatible | Core or existing-project fallback |
| --- | --- | --- |
| Image display | `expo-image` | `Image` from `react-native` |
| Image selection | `expo-image-picker` | Existing project integration or a target-approved native module |
| Camera | `expo-camera` | Existing project integration or a target-approved native module |
| File access | `expo-file-system` | Existing project storage or native integration |
| Haptics | `expo-haptics` | Existing platform API or omit when not required |
| Secure storage | `expo-secure-store` | Existing project storage integration; do not substitute an insecure store for secrets |

The table lists possible choices for a discovered Expo profile; it does not select a dependency for an unknown consumer. Do not infer that an Expo module is installed, bundled, maintained at a particular version, or compatible with the target's architecture without checking the manifest and official documentation.

## Verification Boundary

This collection cannot execute native simulators or devices, native builds, VoiceOver, or TalkBack. Native claims about safe areas, keyboard behavior, navigation, touch and gestures, animation, rendering, or accessibility require evidence from the target project's supported build and tooling.

The collection's browser and Figma artifacts, including Playwright screenshots or accessibility snapshots, apply only to web-compatible workflows. They cannot close native React Native verification. When target-project evidence is unavailable, record the native verification as a prerequisite or limitation rather than claiming it was verified.

## Anti-Patterns

| Pattern | Profile-aware response |
| --- | --- |
| Assuming Expo, a router, or a package is present | Inspect the manifest, lockfile, native state, and exact versions before choosing an API. |
| Replacing an existing core or project API because a third-party library is popular | Keep the supported API when it meets the requirement; replace it only for a demonstrated need and verified compatibility. |
| Inline style objects for repeated static styles | Use `StyleSheet.create()` and the target project's design tokens where that matches project conventions. |
| Wrapping a list in an extra safe-area provider | Use the selected provider's documented content-container or inset handling to avoid double padding. |
| Reading an animation shared value during render | Follow the installed animation library's documented worklet and event boundaries. |
| Choosing a gesture or animation library without native setup evidence | Check installed packages, native directories, build mode, New Architecture setting, and official installation documentation first. |
| Scattered platform conditionals | Use `Platform.select()` or platform files when the target project supports them and the divergence is real. |
| Hardcoded visual values | Reference the target project's design tokens; ask before inventing a token. |
| Raw text outside `<Text>` | Wrap text content in `<Text>` components because React Native does not render raw strings inside a `View`. |
