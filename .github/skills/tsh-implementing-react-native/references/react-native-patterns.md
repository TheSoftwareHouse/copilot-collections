# React Native Implementation Patterns

React Native-specific patterns for the `tsh-implementing-react-native` skill. Load this reference when working with React Native in Expo projects.

## Table of Contents

- [Project Structure](#project-structure)
- [Component Composition](#component-composition)
- [Styling Patterns](#styling-patterns)
- [Platform-Specific Code](#platform-specific-code)
- [Pressable and Touch Feedback](#pressable-and-touch-feedback)
- [Safe Areas and Layout](#safe-areas-and-layout)
- [Gestures and Animations](#gestures-and-animations)
- [New Architecture and Expo Modules](#new-architecture-and-expo-modules)
- [Anti-Patterns](#anti-patterns)

## Project Structure

All projects use Expo as the standard framework. Follow the project's existing structure. If starting fresh, use this layout:

```
src/
├── app/                  # Expo Router file-based routes (or screens/ for React Navigation)
├── components/
│   ├── ui/               # Reusable design system primitives (Button, Text, Card)
│   └── features/         # Feature-specific composed components
├── hooks/                # Custom hooks
├── services/             # API clients, storage, analytics
├── stores/               # Global state (Zustand, Jotai, etc.)
├── theme/                # Design tokens, theme provider
│   ├── tokens.ts         # Colors, spacing, typography, radii
│   └── index.ts          # Theme provider and hooks
├── types/                # Shared TypeScript types
└── utils/                # Pure utility functions
```

Key conventions:
- Co-locate component types: `Button.types.ts` next to `Button.tsx`.
- Co-locate component styles: `Button.styles.ts` next to `Button.tsx` (for complex components), or inline `StyleSheet.create()` at the bottom of the component file (for simpler components).
- One component per file. The filename matches the component name.

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

`Pressable` is the standard touchable primitive. It replaces the deprecated `TouchableOpacity`, `TouchableHighlight`, `TouchableNativeFeedback`, and `TouchableWithoutFeedback`.

```typescript
import { Pressable, StyleSheet } from 'react-native';

const ActionButton = ({ onPress, label, disabled }: ActionButtonProps) => (
  <Pressable
    onPress={onPress}
    disabled={disabled}
    android_ripple={{ color: theme.colors.primary500 + '33', borderless: false }}
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

Key rules:
- Always set `minHeight` and `minWidth` to meet touch target minimums (44 pt iOS / 48 dp Android).
- Always provide `accessibilityRole` and `accessibilityLabel` on pressable elements.
- Use `android_ripple` for Material Design feedback on Android.
- Use the `pressed` state from the style function for iOS feedback (opacity change, background change).

## Safe Areas and Layout

Use `react-native-safe-area-context` (included in Expo) for safe area management:

```typescript
import { SafeAreaView } from 'react-native-safe-area-context';

// Screen-level wrapper — pads content away from notches, status bar, home indicator
const SettingsScreen = () => (
  <SafeAreaView style={styles.screen} edges={['top', 'bottom']}>
    {/* Screen content */}
  </SafeAreaView>
);
```

- Use `SafeAreaView` at the screen level, not on every component.
- Specify `edges` explicitly when you only need specific safe areas (e.g., `['top']` on screens with a bottom tab bar that already handles the bottom inset).
- For finer-grained control, use the `useSafeAreaInsets()` hook to read inset values and apply them as padding to specific views.
- Do NOT wrap `FlatList` / `ScrollView` in `SafeAreaView` — use `contentContainerStyle` padding with inset values instead, to avoid double-padding issues.

### Keyboard avoidance

Use `react-native-keyboard-controller` (included in Expo) for keyboard handling. It provides Reanimated-powered smooth animations and works reliably on both platforms — unlike the built-in `KeyboardAvoidingView` which has known inconsistencies on Android.

```typescript
import { KeyboardAwareScrollView } from 'react-native-keyboard-controller';

const FormScreen = () => (
  <KeyboardAwareScrollView bottomOffset={theme.spacing.lg}>
    {/* Form fields — automatically scroll into view when keyboard appears */}
  </KeyboardAwareScrollView>
);
```

For fine-grained control, use the `useKeyboardHandler` hook to react to keyboard events with worklet callbacks:

```typescript
import { useKeyboardHandler } from 'react-native-keyboard-controller';
import { useSharedValue } from 'react-native-reanimated';

const height = useSharedValue(0);

useKeyboardHandler({
  onMove: (event) => {
    'worklet';
    height.value = event.height;
  },
});
```

> **Fallback**: If `react-native-keyboard-controller` cannot be used, the built-in `KeyboardAvoidingView` with `behavior={Platform.OS === 'ios' ? 'padding' : 'height'}` works as a basic alternative.

## Gestures and Animations

### React Native Gesture Handler

Use `react-native-gesture-handler` for all gesture recognition. It runs gestures on the native thread, avoiding JS thread bottlenecks.

```typescript
import { Gesture, GestureDetector } from 'react-native-gesture-handler';

const panGesture = Gesture.Pan()
  .onUpdate((event) => {
    // Runs on UI thread with Reanimated worklets
    translateX.value = event.translationX;
  })
  .onEnd(() => {
    translateX.value = withSpring(0);
  });

<GestureDetector gesture={panGesture}>
  <Animated.View style={animatedStyle} />
</GestureDetector>
```

### React Native Reanimated

Use `react-native-reanimated` for animations. It runs animations on the UI thread via worklets, keeping 60/120 fps even when the JS thread is busy.

```typescript
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withSpring,
  withTiming,
} from 'react-native-reanimated';

const opacity = useSharedValue(0);

// Trigger animation
opacity.value = withTiming(1, { duration: 300 });

// Derive animated style
const animatedStyle = useAnimatedStyle(() => ({
  opacity: opacity.value,
}));

<Animated.View style={[styles.container, animatedStyle]} />
```

Key patterns:
- Use `useSharedValue` instead of `useRef` or `useState` for animated values.
- Use `useAnimatedStyle` to derive styles from shared values — runs on the UI thread.
- Use `withSpring`, `withTiming`, `withDecay` for animation drivers.
- Use `runOnJS` to call JS thread functions from worklets (e.g., updating React state after an animation completes).
- Never read `sharedValue.value` in the component render body — only in worklets or event handlers.

### Layout animations

Reanimated provides `entering` and `exiting` props for declarative mount/unmount animations:

```typescript
import Animated, { FadeIn, FadeOut, SlideInRight } from 'react-native-reanimated';

{isVisible && (
  <Animated.View entering={FadeIn.duration(200)} exiting={FadeOut.duration(150)}>
    <NotificationBanner />
  </Animated.View>
)}
```

## New Architecture and Expo Modules

React Native New Architecture (Fabric + TurboModules) is the default since RN 0.76+. Key implications:

- **Fabric renderer**: Synchronous and concurrent-capable rendering. Layout is computed synchronously when needed, eliminating layout "flashes" from async bridge communication.
- **TurboModules**: Native modules are lazily loaded and use JSI (JavaScript Interface) for synchronous, typesafe communication — no serialized JSON bridge.
- **Codegen**: TypeScript specs generate native interfaces. When writing native modules, define types in TypeScript and let Codegen produce the native bindings.

For Expo developers, the New Architecture is transparent — it's enabled by default since Expo SDK 52. Be aware of:

- Third-party libraries must support New Architecture. Check compatibility before adding dependencies. Expo provides a [directory](https://reactnative.directory/) with compatibility indicators.
- If a library doesn't support New Architecture, the interop layer handles most cases automatically, but performance-sensitive native modules may need updates.

### Expo modules

When native functionality is needed, prefer Expo modules over community packages when available:

| Need               | Expo Module                 | Notes                                      |
| ------------------ | --------------------------- | ------------------------------------------ |
| Camera             | `expo-camera`               |                                            |
| File system        | `expo-file-system`          |                                            |
| Image picker       | `expo-image-picker`         |                                            |
| Image display      | `expo-image`                | Replaces `Image` from RN core             |
| Haptics            | `expo-haptics`              |                                            |
| Secure storage     | `expo-secure-store`         |                                            |
| Local auth (bio)   | `expo-local-authentication` |                                            |
| Notifications      | `expo-notifications`        |                                            |
| Location           | `expo-location`             |                                            |
| Video              | `expo-video`                |                                            |
| Audio              | `expo-audio`                | Replaces deprecated `expo-av` for audio    |
| Splash screen      | `expo-splash-screen`        |                                            |
| Fonts              | `expo-font`                 | Load custom fonts at startup               |
| Constants          | `expo-constants`            | App config, device info                    |
| OTA updates        | `expo-updates`              | Over-the-air JS bundle updates             |
| Linking / URLs     | `expo-linking`              | Deep link handling, URL opening            |
| In-app browser     | `expo-web-browser`          | Open URLs in system browser / auth flows   |
| Navigation         | `expo-router`               | File-based routing (see navigation ref)    |

Expo modules use the New Architecture natively and are maintained as part of the Expo SDK. Always prefer an Expo module over a community alternative when one exists — it guarantees compatibility with the current SDK and New Architecture.

## Anti-Patterns

| Anti-Pattern                                          | Why                                                 | Fix                                                                   |
| ----------------------------------------------------- | --------------------------------------------------- | --------------------------------------------------------------------- |
| Inline style objects `style={{ padding: 16 }}`        | New object every render, skips native optimizations  | Use `StyleSheet.create()`                                             |
| `TouchableOpacity` / `TouchableHighlight`             | Deprecated, inconsistent cross-platform              | Use `Pressable`                                                       |
| Animated API from `react-native` core                 | Runs on JS thread, drops frames under load           | Use `react-native-reanimated`                                         |
| `PanResponder` for gestures                           | JS thread gesture handling, laggy                    | Use `react-native-gesture-handler`                                    |
| `ScrollView` for long dynamic lists                   | Renders all items, memory explosion                  | Use `FlatList` or `FlashList`                                         |
| `useEffect` + `Animated.timing` for animations        | Extra render cycle, JS thread animation              | `useSharedValue` + `withTiming` from Reanimated                       |
| Reading `sharedValue.value` during render              | Breaks UI thread isolation, stale values             | Read only in `useAnimatedStyle` worklets or event handlers            |
| Wrapping `FlatList` in `SafeAreaView`                  | Double padding, content hidden below safe area       | Use `contentContainerStyle` with `useSafeAreaInsets()` padding        |
| `Platform.OS === 'ios' ? ... : ...` in 10+ places     | Scattered conditionals, hard to maintain             | Use `Platform.select()`, or split into platform-specific files        |
| Hardcoded pixel values                                 | No design consistency, hard to update                | Reference theme tokens                                                |
| `setTimeout` for animation sequencing                  | Unreliable timing, can't be cancelled properly       | Use `withDelay`, `withSequence` from Reanimated                       |
| Raw string outside `<Text>`                            | Runtime crash — RN requires all text in `<Text>`     | Always wrap text content in `<Text>` components                       |
