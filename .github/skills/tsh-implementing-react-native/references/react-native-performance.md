# React Native Performance Patterns

Performance-specific patterns for the `tsh-implementing-react-native` skill. Load this reference when optimizing React Native app performance — list rendering, startup time, memory, animations, and bundle size.

## Table of Contents

- [Measure Before Optimizing](#measure-before-optimizing)
- [List Rendering](#list-rendering)
- [Image Optimization](#image-optimization)
- [Startup Time](#startup-time)
- [JS Bundle Optimization](#js-bundle-optimization)
- [Memoization Patterns](#memoization-patterns)
- [Memory Management](#memory-management)
- [Hermes Engine](#hermes-engine)
- [Performance Checklist](#performance-checklist)
- [Anti-Patterns](#anti-patterns)

## Measure Before Optimizing

Never optimize without data. Profile first:

| Tool                           | What it measures                          | Platform |
| ------------------------------ | ------------------------------------------ | -------- |
| React DevTools Profiler        | Component render times, re-render reasons  | Both     |
| React Native DevTools          | JS/UI thread frame rates, component tree   | Both     |
| Expo Dev Tools                 | Performance monitoring, network inspector  | Both     |
| Xcode Instruments              | CPU, memory, energy, UI hangs              | iOS      |
| Android Studio Profiler        | CPU, memory, network, energy               | Android  |
| `react-native-performance`     | TTI, component render marks                | Both     |
| `performance.mark()/.measure()`| Custom operation timing in Hermes          | Both     |
| React Native DevMenu → Perf Monitor | Real-time JS/UI frame rate overlay   | Both     |

Enable the Performance Monitor overlay (shake → "Perf Monitor") as a first check. Both JS and UI threads should consistently hit 60 fps (or 120 fps on ProMotion/high-refresh devices).

## List Rendering

Long lists are the most common performance bottleneck in React Native apps.

### FlashList (recommended)

`@shopify/flash-list` is the recommended replacement for `FlatList`. It recycles views (like native `RecyclerView` / `UICollectionView`) instead of unmounting and remounting them.

```typescript
import { FlashList } from '@shopify/flash-list';

const ProductList = ({ products }: { products: Product[] }) => (
  <FlashList
    data={products}
    renderItem={({ item }) => <ProductCard product={item} />}
    estimatedItemSize={120}      // Required — approximate height of each item
    keyExtractor={(item) => item.id}
  />
);
```

Key FlashList rules:
- Always provide `estimatedItemSize`. Measure a representative item height and use that value.
- `renderItem` components must have a deterministic height (or use `estimatedItemSize` + `overrideItemLayout` for variable heights).
- Items must fill the full width of the list. If items don't fill the width, FlashList recycling calculations break.
- Use `FlashList`'s built-in `ListHeaderComponent`, `ListFooterComponent`, `ListEmptyComponent` instead of wrapping in extra views.

### FlatList optimization

If using `FlatList` (legacy or when FlashList isn't available):

```typescript
<FlatList
  data={items}
  renderItem={renderItem}
  keyExtractor={(item) => item.id}
  // Performance tuning
  removeClippedSubviews={true}           // Unmount offscreen items (Android significant, iOS modest)
  maxToRenderPerBatch={10}               // Items per render batch (default: 10)
  windowSize={5}                         // Render window: 5 * visible area (default: 21 — reduce it)
  initialNumToRender={10}                // Items to render on first mount
  getItemLayout={(data, index) => ({     // Skip layout measurement if items are fixed height
    length: ITEM_HEIGHT,
    offset: ITEM_HEIGHT * index,
    index,
  })}
/>
```

### List rendering rules

| Rule                                  | Why                                                          |
| ------------------------------------- | ------------------------------------------------------------ |
| Extract `renderItem` to a component   | Prevents new function reference on every render              |
| Memoize list items (`React.memo`)     | Prevents re-rendering unchanged items during list scrolls    |
| Use stable keys (IDs, not indices)    | Prevents unnecessary unmount/remount on data changes         |
| Avoid inline functions in `renderItem`| New closure reference defeats item memoization               |
| Minimize item component depth         | Fewer views = faster native layout                           |

## Image Optimization

### expo-image (recommended)

`expo-image` provides a high-performance image component with disk/memory caching, blurhash placeholders, and format negotiation:

```typescript
import { Image } from 'expo-image';

const Avatar = ({ uri, blurhash }: AvatarProps) => (
  <Image
    source={{ uri }}
    placeholder={{ blurhash }}
    contentFit="cover"
    transition={200}
    style={styles.avatar}
    recyclingKey={uri}          // Helps with recycling in lists
  />
);
```

Key rules:
- Always provide `placeholder` (blurhash or thumbhash) for network images to prevent layout shift and improve perceived performance.
- Set `recyclingKey` when images are used in recycled list items (FlashList / FlatList) to prevent stale image flashes.
- Use `contentFit` instead of `resizeMode` (Expo Image uses CSS-standard naming).
- Prefer WebP format for remote images — smaller file size with equivalent quality.

### Image sizing

- Always specify explicit `width` and `height` on images. Without dimensions, the layout engine cannot allocate space until the image loads, causing layout shifts.
- Serve images at the correct resolution for the device pixel density. A 100×100 pt image on a 3× display needs a 300×300 px source.
- For large images (hero banners, backgrounds), use progressive loading: show a low-resolution placeholder → load full resolution.

## Startup Time

### Cold start optimization

| Technique                                 | Impact    | Details                                                    |
| ----------------------------------------- | --------- | ---------------------------------------------------------- |
| Hermes bytecode compilation               | High      | Default in all Expo projects. Hermes compiles JS to bytecode at build time, eliminating parse cost at startup. |
| Reduce root-level imports                 | High      | Only import what's needed for the first screen. Heavy modules (charts, editors) should be lazy-loaded. |
| Inline `require()` for heavy modules     | Medium    | Use `require()` inside functions instead of top-level `import` for modules not needed at startup. |
| Splash screen management                  | Medium    | Use `expo-splash-screen` to keep the splash visible until the first screen is rendered and data is ready. |
| Minimize provider nesting in root         | Low-Med   | Each context provider is a component — excessive nesting at root adds render overhead at startup. |

### expo-splash-screen pattern

In Expo Router projects, manage the splash screen in the root layout:

```typescript
// app/_layout.tsx
import * as SplashScreen from 'expo-splash-screen';
import { useFonts } from 'expo-font';
import { Stack } from 'expo-router';
import { useEffect } from 'react';

SplashScreen.preventAutoHideAsync();

const RootLayout = () => {
  const [fontsLoaded] = useFonts({
    'Inter-Regular': require('../assets/fonts/Inter-Regular.ttf'),
  });

  useEffect(() => {
    if (fontsLoaded) {
      SplashScreen.hideAsync();
    }
  }, [fontsLoaded]);

  if (!fontsLoaded) return null;

  return <Stack />;
};

export default RootLayout;
```

## JS Bundle Optimization

### Bundle analysis

Use `react-native-bundle-visualizer` to analyze the JS bundle:

```bash
npx react-native-bundle-visualizer
```

This generates a treemap showing module sizes. Look for:
- Unexpectedly large dependencies
- Duplicate packages (different versions of the same library)
- Unused code that's imported transitively

### Code splitting with lazy imports

**Expo Router handles screen-level lazy loading automatically** — each route file is only loaded when the user navigates to it. This is the primary code splitting mechanism in Expo projects and requires no extra work.

For non-screen heavy modules, use inline `require()` to defer loading:

```typescript
// Heavy module loaded only when needed
const openChart = () => {
  const { ChartView } = require('./HeavyChartView');
  // Use ChartView
};
```

With React Navigation (legacy projects), screens are not lazy by default. Use `React.lazy()` for screens that are rarely accessed:

```typescript
const RareScreen = React.lazy(() => import('./screens/RareScreen'));

<Stack.Screen name="Rare">
  {() => (
    <Suspense fallback={<LoadingScreen />}>
      <RareScreen />
    </Suspense>
  )}
</Stack.Screen>
```

### Tree shaking

- Use named imports: `import { format } from 'date-fns'` — not `import * as dateFns from 'date-fns'`.
- Check that `metro.config.js` has tree shaking enabled (enabled by default in modern Expo SDK / Metro 0.81+).
- Avoid barrel files that re-export large modules. Import directly from the source file when specific components are needed.

## Memoization Patterns

Same React memoization APIs as web, but with mobile-specific considerations:

| Technique       | API                              | When to use in RN                                           |
| --------------- | -------------------------------- | ----------------------------------------------------------- |
| Component memo  | `React.memo(Component)`          | List item components rendered in `FlatList` / `FlashList`   |
| Compute cache   | `useMemo(() => ..., [deps])`     | Filtering/sorting large arrays, derived data                |
| Stable callback | `useCallback(fn, [deps])`        | Callbacks passed to memoized list items                     |

**Critical for lists**: Every `renderItem` component in a list should be wrapped in `React.memo`. Without it, all visible items re-render when the parent state changes — this is the #1 cause of scrolling jank.

```typescript
type ItemProps = { item: Product; onPress: (id: string) => void };

const ProductCard = React.memo(({ item, onPress }: ItemProps) => (
  <Pressable onPress={() => onPress(item.id)}>
    <Text>{item.name}</Text>
  </Pressable>
));

// In parent — stabilize the callback
const handlePress = useCallback((id: string) => {
  navigation.navigate('Detail', { id });
}, [navigation]);

<FlashList
  data={products}
  renderItem={({ item }) => <ProductCard item={item} onPress={handlePress} />}
  estimatedItemSize={80}
/>
```

## Memory Management

Mobile devices have constrained memory. Memory leaks cause OS-level kills (OOM).

### Common leak sources

| Source                          | Prevention                                                  |
| ------------------------------- | ----------------------------------------------------------- |
| Event listeners not cleaned up  | Return cleanup in `useEffect`: `return () => sub.remove()`  |
| Timers not cleared              | `clearTimeout` / `clearInterval` in effect cleanup          |
| In-flight network requests      | `AbortController` in effect cleanup                         |
| Large images cached in state    | Use `expo-image` disk cache, don't store base64 in state    |
| Reanimated shared values        | Shared values are GC'd with the component — no leak risk    |
| Closures capturing screen state | Avoid long-lived closures referencing screen-level vars     |

### Image memory

- Use `expo-image` — it manages memory caches with eviction policies and is actively maintained.
- Never store base64-encoded images in React state or AsyncStorage. Use file system paths and disk caching.
- For image-heavy screens (galleries, feeds), verify memory doesn't grow unbounded during scrolling — recycled list items should release image memory.

### Monitoring

Use Xcode Memory Graph Debugger (iOS) or Android Studio Memory Profiler to detect leaks. Look for:
- Retained components that should have unmounted
- Growing heap size during repeated navigation (push → pop → push cycles)
- Large image data held in JS memory

## Hermes Engine

Hermes is the default JS engine for all modern React Native and Expo projects. Key characteristics:

- **Bytecode compilation**: JS is compiled to Hermes bytecode (`.hbc`) at build time. No parsing at runtime → faster startup.
- **Garbage collection**: Hermes uses a generational GC. Short-lived objects (typical in React renders) are collected efficiently.
- **ES2015+ support**: Supports most modern JS features natively. `Proxy`, `Reflect`, `WeakRef`, and other advanced features are fully supported in current Hermes versions.
- **Debugging**: Use React Native DevTools (Chrome-based) for runtime debugging and profiling. The `hermes-profile-transformer` converts Hermes profiler output to Chrome trace format for deeper analysis.

Hermes-specific considerations:
- Avoid `eval()` and `new Function()` — Hermes does not support dynamic code evaluation (this is also a security best practice).
- Large string concatenation is more expensive in Hermes than V8. Use `Array.join()` for building large strings.
- `JSON.parse()` is optimized in Hermes — prefer it over manual object construction for large data payloads.

## Performance Checklist

```
Performance:
- [ ] Measured baseline (JS/UI frame rates, startup time)
- [ ] FlashList used for long lists (with estimatedItemSize)
- [ ] List item components wrapped in React.memo
- [ ] Callbacks to list items stabilized with useCallback
- [ ] expo-image used with placeholders and recyclingKey
- [ ] Image dimensions explicitly set (no layout shift)
- [ ] Startup: only first-screen imports at top level
- [ ] Splash screen held until initial data ready
- [ ] Animations use Reanimated (UI thread, not JS thread)
- [ ] No inline style objects — StyleSheet.create() or Reanimated
- [ ] Effects clean up: timers, listeners, abort controllers
- [ ] No base64 images stored in state — use disk cache
- [ ] Bundle analyzed — no unexpected large dependencies
- [ ] Named imports only — no wildcard imports
- [ ] Verified on low-end devices (not just latest flagship)
```

## Anti-Patterns

| Anti-Pattern                                        | Why                                                  | Fix                                                        |
| --------------------------------------------------- | ---------------------------------------------------- | ---------------------------------------------------------- |
| `ScrollView` for dynamic lists                      | Renders all items, memory explosion                   | `FlashList` or `FlatList`                                  |
| `FlatList` without `React.memo` on items            | All visible items re-render on any state change       | Wrap `renderItem` component in `React.memo`                |
| Missing `estimatedItemSize` on FlashList             | Recycling calculations wrong, layout jumps           | Measure and provide item height estimate                   |
| Inline function in `renderItem`                     | New function ref every render, defeats memo           | Extract to `useCallback` or component                      |
| Storing base64 images in state                      | Bloats JS heap, causes OOM on image-heavy screens    | Use `expo-image` with disk caching                         |
| `Animated` API from `react-native` core             | JS thread animations, frame drops under load         | Use `react-native-reanimated`                              |
| Top-level import of heavy libraries                 | Blocks startup — all code parsed before first render | Inline `require()` for rarely-used heavy modules           |
| No `getItemLayout` on fixed-height FlatList         | Layout measurement on each item during scroll        | Provide `getItemLayout` when item height is known          |
| Optimizing without profiling                        | Adds complexity without proven benefit               | Measure first — Perf Monitor, DevTools, Instruments        |
| Testing only on high-end devices                    | Hides perf issues that affect most users             | Profile on mid-range and low-end devices                   |
| `windowSize={21}` (FlatList default)                | Renders 21× visible area — wasteful on large lists   | Reduce to `5` (renders 5× visible area)                    |
| `removeClippedSubviews={false}` on Android          | Keeps offscreen views in memory                      | Set to `true` for long lists on Android                    |
