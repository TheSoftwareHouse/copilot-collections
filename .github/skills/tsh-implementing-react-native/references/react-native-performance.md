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
- [JavaScript Engine](#javascript-engine)
- [Performance Checklist](#performance-checklist)
- [Anti-Patterns](#anti-patterns)

## Measure Before Optimizing

Never optimize without data. Before changing code, record:

- a baseline for the affected behavior, such as startup time, interaction latency, JS/UI frame pacing, memory, bundle size, or screen render time
- a representative workload, including realistic data volume, item variability, navigation path, image sizes, and interaction sequence
- the target device or device class, build mode, platform, engine, architecture setting, and other relevant target-project profile details
- a target measurement and an acceptable regression boundary agreed with the target project

Use the baseline to diagnose the limiting resource first. Tuning is optional: apply a change only when it addresses the diagnosed bottleneck, is compatible with the target manifest and exact installed versions, and has a measurable reason to exist. Re-run the same representative workload after each material change, compare against the baseline and target, and retain or revert the change based on the result. Validate both the optimized path and nearby behavior such as scrolling, navigation, memory pressure, startup error handling, and accessibility-relevant interactions when they are affected.

The tools below are examples of profiling approaches, not dependencies of this repository. Use the tools already available in the target project and follow their official documentation:

| Tool                           | What it measures                          | Platform |
| ------------------------------ | ------------------------------------------ | -------- |
| React DevTools Profiler        | Component render times, re-render reasons  | Both     |
| React Native DevTools          | JS/UI thread frame rates, component tree   | Both     |
| Expo Dev Tools                 | Performance monitoring, network inspector  | Expo projects when available |
| Xcode Instruments              | CPU, memory, energy, UI hangs              | iOS      |
| Android Studio Profiler        | CPU, memory, network, energy               | Android  |
| `react-native-performance`     | TTI, component render marks                | When installed and compatible |
| `performance.mark()/.measure()`| Custom operation timing                    | When supported by the target engine |
| React Native DevMenu performance monitor | Real-time JS/UI frame rate overlay | When available in the target build |

Do not claim device or native performance validation from this reference. Native profiling and device evidence must come from the target project's supported build and profiling setup.

## List Rendering

Long lists are the most common performance bottleneck in React Native apps.

### FlashList (conditional option)

Consider `@shopify/flash-list` only when profiling shows that the current list implementation is a bottleneck, the package is already installed or its addition is approved, and the exact installed version is compatible with the target React Native, renderer, architecture, and build profile. Check the package's official compatibility documentation before using it. `FlatList` remains the appropriate choice when it meets the target, when FlashList is unavailable, or when compatibility and migration cost outweigh a measured benefit.

If the target profile supports the selected FlashList version, measure a representative item and provide `estimatedItemSize` from that evidence. It is not a universal number or a reason to add FlashList by default. Re-measure variable-height items, headers, empty states, nested lists, and scrolling behavior after the change.

```typescript
import { FlashList } from '@shopify/flash-list';

const ProductList = ({ products, estimatedItemSize }: ProductListProps) => (
  <FlashList
    data={products}
    renderItem={({ item }) => <ProductCard product={item} />}
    estimatedItemSize={estimatedItemSize}
    keyExtractor={(item) => item.id}
  />
);
```

For a compatible FlashList version, follow its official guidance for item measurement, variable-height layouts, width, headers, footers, and empty states. Do not copy an API or prop recommendation across FlashList versions without checking that documentation.

### FlatList tuning (conditional option)

Use `FlatList` when it is sufficient or when a third-party list is unavailable or incompatible. Tune it only after profiling identifies list rendering, layout measurement, mount work, or memory as the limiting resource. Every prop below is a decision option, not a default:

```typescript
<FlatList
  data={items}
  renderItem={renderItem}
  keyExtractor={(item) => item.id}
  removeClippedSubviews={profileSupportsClipping && measuredClippingBenefit}
  maxToRenderPerBatch={profiledBatchSize}
  windowSize={profiledWindowSize}
  initialNumToRender={profiledInitialCount}
  getItemLayout={knownFixedLayout ? getItemLayout : undefined}
/>
```

Choose values from the representative workload and target device profile. Check the exact React Native version's documentation because clipping and render-window behavior can differ by platform and version. Verify blanking, responsiveness, memory, initial content, accessibility, and pagination after tuning. Use `getItemLayout` only when the layout is actually predictable; otherwise retain normal measurement.

### List rendering rules

| Rule                                  | Why                                                          |
| ------------------------------------- | ------------------------------------------------------------ |
| Extract `renderItem` to a component   | Makes render work easier to measure and reason about         |
| Consider `React.memo` for item components | Use only when profiling shows repeated unchanged renders and props can remain stable; confirm comparison cost is lower than the saved work |
| Use stable keys (IDs, not indices)    | Prevents unnecessary unmount/remount on data changes         |
| Avoid avoidable work in `renderItem`  | Reduces per-item render and layout cost when the workload shows it matters |
| Minimize item component depth         | Can reduce native layout work when the measured hierarchy is costly |

`React.memo`, `useMemo`, and `useCallback` are measured options. Do not add them to every list or component: compare render savings, dependency complexity, comparison cost, and memory behavior against the baseline.

## Image Optimization

### Image library (conditional option)

Consider `expo-image` or another image library only when the target manifest includes a compatible package, official documentation supports the exact installed versions and platform profile, and profiling shows that the current image path needs its capabilities. A library is not required for every project. Use the target project's core `Image` when it is sufficient or when a third-party image library is unavailable or incompatible.

For a compatible library, follow its exact installed-version API and measure image decode time, cache behavior, memory, layout stability, and scrolling. A core `Image` fallback can still use explicit dimensions and an appropriate loading or error state:

```typescript
import { Image } from 'react-native';

const Avatar = ({ uri }: AvatarProps) => (
  <Image
    source={{ uri }}
    resizeMode="cover"
    style={styles.avatar}
  />
);
```

Use placeholder, recycling, content-fit, format, and cache options only when supported by the selected image API and when measurement or product requirements justify them. Reserve the intended image space when the selected API and layout contract support it, size assets for the target density, and validate loading, error, memory, and recycled-list behavior.

### Image sizing

- Specify explicit `width` and `height` when the selected image API and layout contract do not otherwise provide dimensions; validate layout stability when dimensions are deferred.
- Serve images at the correct resolution for the device pixel density. A 100×100 pt image on a 3× display needs a 300×300 px source.
- For large images (hero banners, backgrounds), use progressive loading: show a low-resolution placeholder → load full resolution.

## Startup Time

### Cold start (diagnosis first)

Measure cold and warm startup separately, with the same build mode, device profile, initial route, data state, and readiness definition. Inspect the actual startup trace before changing imports, providers, splash behavior, or engine settings.

| Decision option                         | Apply when                                                                 | Fallback or validation                                      |
| --------------------------------------- | -------------------------------------------------------------------------- | ------------------------------------------------------------ |
| Reduce root-level imports               | The trace shows startup work from modules not needed by the first route    | Keep ordinary imports when they are small or needed; re-measure startup and error behavior |
| Inline `require()` for a heavy module   | The target bundler/module system supports it, the module is rarely needed, and deferred loading improves the measured path | Use simple static module loading when it is clearer, compatible, or not measurably slower |
| Router-provided lazy loading            | The selected router and exact installed version document and support it, and route loading is a measured bottleneck | Use the router's normal loading path or a supported project pattern; do not claim that a router lazy-loads routes without evidence |
| Splash-screen coordination              | The target profile includes a compatible splash API and the startup contract requires it | Use the existing platform/startup behavior when sufficient; validate readiness and failure paths |
| Reduce provider nesting                 | Profiling shows provider initialization or root renders contribute to startup | Preserve required providers; re-measure before and after |

Check the target manifest and official compatibility documentation before applying any router, splash, module-loading, or engine-specific recommendation.

## JS Bundle Optimization

### Bundle analysis

Analyze the bundle when startup, memory, or update size is a measured concern. Use an analyzer already supported by the target project, such as `react-native-bundle-visualizer` when its exact version and build profile are compatible. Profiling tools remain optional examples, not repository dependencies.

```bash
npx react-native-bundle-visualizer
```

This generates a treemap showing module sizes. Look for:
- Unexpectedly large dependencies
- Duplicate packages (different versions of the same library)
- Unused code that's imported transitively

Do not run a package command merely because it appears here; follow the target project's package manager and approved tooling.

### Code splitting with lazy imports

Use code splitting only when the selected router, bundler, and exact installed versions document support for the chosen mechanism and the baseline identifies startup or bundle cost. Do not assume a router loads each route lazily or that a route split is free; verify the generated bundle and runtime loading behavior.

For a compatible target profile, a heavy rarely used module may be deferred with the project's supported mechanism:

```typescript
const openChart = () => {
  const { ChartView } = require('./HeavyChartView');
  return ChartView;
};
```

Use simple static module loading when inline `require()` is not supported, complicates typing or error handling, or does not improve the target measurement. For a router-specific screen mechanism, follow the selected router's official docs instead of copying an Expo Router or React Navigation claim across profiles.

### Tree shaking

Use named imports and avoid unnecessary broad re-exports when bundle analysis shows they matter, but do not claim that this alone enables tree shaking. Check the target manifest, Metro configuration, exact Metro/RN/Expo versions, and official documentation before relying on tree shaking or changing a barrel. Preserve a simple direct import when it is clearer or when analysis shows no benefit.

## Memoization Patterns

Same React memoization APIs as web, but with mobile-specific considerations:

| Technique       | API                              | When to use in RN                                           |
| --------------- | -------------------------------- | ----------------------------------------------------------- |
| Component memo  | `React.memo(Component)`          | When profiling shows repeated unchanged renders and comparison cost is justified |
| Compute cache   | `useMemo(() => ..., [deps])`     | When expensive derived work dominates the measured path     |
| Stable callback | `useCallback(fn, [deps])`        | When callback identity causes measured downstream work      |

These APIs are optional. Compare the change with the baseline, including dependency maintenance, comparison cost, stale-value risk, and memory behavior. Do not wrap every list item or callback by default.

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
  estimatedItemSize={measuredItemSize}
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
| Large images cached in state    | Use the compatible image/cache path, or core `Image` and file paths; don't store base64 in state |
| Animation shared values          | Follow the selected animation API's lifecycle guidance and profile retained work |
| Closures capturing screen state | Avoid long-lived closures referencing screen-level vars     |

### Image and animation memory

- Avoid storing base64-encoded images in React state or persistent storage; use file system paths and the target project's supported cache path when they are available and appropriate.
- For image-heavy screens, measure memory during repeated navigation and scrolling. Use a compatible image library only when its cache behavior is appropriate for the target; otherwise use core `Image` and the project's existing asset/cache path.
- For animations, consider Reanimated only when it is installed or approved, compatible with the target React Native/architecture profile, and profiling shows JS-thread work is limiting animation. Core `Animated` is a valid fallback when it meets the target behavior or Reanimated is unavailable or incompatible. Check official documentation for the exact installed version.

### Monitoring

Use target-project tools such as Xcode Memory Graph Debugger or Android Studio Memory Profiler when available and supported. Look for:
- Retained components that should have unmounted
- Growing heap size during repeated navigation (push → pop → push cycles)
- Large image data held in JS memory

## JavaScript Engine

Treat Hermes as a profile-dependent engine choice, not a universal default or requirement. Check the target manifest, native configuration, exact installed engine, React Native, and Expo versions, build mode, and official compatibility documentation. If Hermes is enabled, use its supported profiling and build outputs when they help explain the baseline. If another supported engine is configured, profile that engine instead; do not migrate engines solely because this reference mentions Hermes.

Engine-specific profiling or bytecode analysis is an optional diagnostic path. Use tools such as a compatible Hermes profiler only when they are already available or approved by the target project. Do not infer startup, garbage collection, syntax support, or memory behavior from a different engine or version.

Avoid dynamic code evaluation as a general security and compatibility practice. Treat engine-specific claims about parsing, garbage collection, string operations, JSON, and syntax support as version-dependent and verify them against the configured target engine.

## Performance Checklist

```
Performance:
- [ ] Baseline recorded for the affected metric and representative workload
- [ ] Target device/profile, build mode, engine, architecture, and measurement target recorded
- [ ] Bottleneck diagnosed before optional tuning was selected
- [ ] Selected list implementation is compatible with the target manifest and exact installed versions
- [ ] FlashList and `estimatedItemSize` used only when supported and justified by measurement; otherwise FlatList remains sufficient
- [ ] FlatList props and values tuned only when the target profile and baseline justify them
- [ ] `React.memo`, `useMemo`, and `useCallback` used only when measured savings justify their cost
- [ ] Image library options such as `expo-image` used only when compatible and beneficial; core `Image` remains a valid fallback
- [ ] Image dimensions, loading, error, cache, and memory behavior validated for the target workload
- [ ] Startup imports, inline `require()`, router lazy loading, and splash behavior checked against the target tooling and measured
- [ ] Bundle analysis and Metro tree shaking claims checked against the target manifest, configuration, versions, and official documentation
- [ ] Hermes or another engine-specific option checked against the target engine profile and compatibility documentation
- [ ] Reanimated or core `Animated` selected based on compatibility, behavior, and measurement
- [ ] Effects, timers, listeners, requests, and retained image/animation state have appropriate cleanup
- [ ] No base64 images stored in state or persistent storage without a measured, justified exception
- [ ] The same representative workload was rerun after the change and regressions were checked against the baseline and target
- [ ] Native/device evidence is supplied by the target project when required; this collection does not claim to have executed it
```

## Anti-Patterns

| Anti-Pattern                                        | Why                                                  | Fix                                                        |
| --------------------------------------------------- | ---------------------------------------------------- | ---------------------------------------------------------- |
| `ScrollView` for a measured dynamic-list bottleneck | Renders all items; can increase work and memory      | Compare a compatible FlashList or FlatList against the baseline |
| Adding FlashList or a fixed `estimatedItemSize` without measurement | Can add dependency or incorrect layout assumptions | Measure first; use FlatList when sufficient               |
| Adding `React.memo` or callback memoization everywhere | Adds comparison and maintenance cost                 | Apply only to measured repeated work                       |
| Storing base64 images in state                      | Bloats JS heap and can increase memory pressure      | Use core `Image` or a compatible image/cache path and file references |
| Choosing Reanimated or core `Animated` by rule      | May be incompatible or unnecessary                  | Check the target profile, official docs, behavior, and measurements |
| Top-level import of a heavy library                 | May increase startup work                            | Use the target-supported loading mechanism only when measured |
| Adding `getItemLayout` without predictable layout   | Produces incorrect offsets                            | Use it only for a verified fixed or predictable layout     |
| Optimizing without profiling                        | Adds complexity without proven benefit               | Record a baseline and target, then re-measure              |
| Testing only on an unrepresentative device/workload | Hides target-specific regressions                   | Use the target project's representative profile and evidence |
