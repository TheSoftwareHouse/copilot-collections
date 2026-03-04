---
name: tsh-optimizing-frontend
description: Frontend rendering optimization, code splitting, memoization strategies, bundle size control, asset optimization, and memory management. Use when optimizing component rendering, reducing bundle size, debugging performance issues, implementing lazy loading, or reviewing code for performance regressions.
---

# Optimizing Frontend

Provides optimization strategies for frontend rendering performance, bundle size reduction, and memory management to maintain fast, responsive user interfaces.

<principles>

<measure-before-optimizing>
Never optimize without data. Profile first using browser devtools, bundle analysis tools, or runtime performance APIs. Premature optimization adds complexity without proven benefit. Identify the actual bottleneck before writing optimization code.
</measure-before-optimizing>

<less-is-more>
The most effective optimization is shipping less code. Lazy-load routes and heavy components. Tree-shake unused exports. Avoid pulling in large libraries for small tasks. Every kilobyte costs users time.
</less-is-more>

<memoization-is-not-free>
Component memoization, computed value caching, and callback stabilization have overhead — memory for cached values and comparison cost on every render. Only memoize when: the computation is expensive, the component re-renders frequently with the same props, or reference stability matters for downstream consumers. Over-memoizing is a code smell.
</memoization-is-not-free>

</principles>

## Optimization Process

Use the checklist below and track your progress:

```
Progress:
- [ ] Step 1: Measure current performance
- [ ] Step 2: Optimize bundle size
- [ ] Step 3: Optimize rendering
- [ ] Step 4: Optimize assets and DOM
- [ ] Step 5: Manage memory
- [ ] Step 6: Verify improvement
```

**Step 1: Measure current performance**

Before optimizing anything, establish baselines:

- Run bundle analysis (bundler-specific analyzer tool) to identify large chunks and their contents.
- Use browser devtools Performance tab to record and identify slow renders, long tasks, and layout thrashing.
- Check Core Web Vitals:
  - **LCP** (Largest Contentful Paint) — how fast the main content appears.
  - **CLS** (Cumulative Layout Shift) — how much the layout moves unexpectedly.
  - **INP** (Interaction to Next Paint) — how fast the UI responds to user input.
- Use `performance.mark()` / `performance.measure()` for custom timing of specific operations.
- Document baseline metrics — without baselines, you cannot prove improvement.

**Step 2: Optimize bundle size**

Reduce what ships to the user:

- **Code split at route level**: Lazy-load routes so users download only the code they need. Use the framework's lazy-loading mechanism (dynamic imports) with loading boundaries at each route entry point.
- **Split heavy components**: Large modals, charts, rich text editors, and data visualization components should load on demand when the user triggers them, not at initial page load.
- **Named imports only**: Always use `import { Button } from 'lib'` — never `import * as Lib from 'lib'`. Wildcard imports defeat tree shaking and pull in the entire module.
- **Barrel file awareness**: Barrel files (`index.ts`) that re-export everything from a folder can prevent tree shaking. For large libraries, prefer direct file imports (e.g., `import { Button } from 'lib/components/Button'`) over barrel imports.
- **Audit dependencies**: Run dependency audit tools (`depcheck` or equivalent) regularly. Remove unused packages. Before adding a new dependency, check its bundle impact — a small utility should not cost 50KB.
- **Analyze duplicate dependencies**: Multiple versions of the same library inflate the bundle. Check the bundle analyzer output for duplicates and resolve version conflicts.
- **Consider rendering strategy**: Before optimizing client-side rendering, evaluate whether the page needs to render on the client at all. Server-side rendering (SSR) improves LCP by delivering ready HTML — the browser doesn't wait for JS to build the page. Static generation (SSG/prerendering) is even faster when content doesn't change per-request. If the framework supports streaming SSR, use it to send HTML chunks progressively rather than waiting for the full render. Reserve client-side rendering for highly interactive, user-specific UI that cannot be pre-rendered.

**Step 3: Optimize rendering**

Reduce unnecessary re-render work:

- **Component memoization**: Mark pure presentational components for memoization when they receive complex props and their parent re-renders frequently. Use a custom comparison function when props include objects that are structurally equal but referentially different. See the framework reference for the specific memoization API.
- **Callback memoization**: Stabilize event handler references when passed as props to memoized children. Skip stabilization for handlers that are not passed down — the overhead provides no benefit. See the framework reference for the specific API.
- **Computed value memoization**: Cache expensive computations — sorting or filtering large lists (1000+ items), complex data transformations, derived state calculations. Skip caching for trivial computations like simple arithmetic or string concatenation. See the framework reference for the specific API.
- **Avoid object/array literals in the render path**: Inline object/array expressions in the render path create a new reference every render cycle, defeating memoization on child components. Lift static values to module scope or cache dynamic ones.
- **State granularity**: Keep state as close to where it is consumed as possible. Broad state at the top of the tree causes cascading re-renders. If your state management solution supports selective subscriptions or slices, use them to minimize re-render scope.
- **Key stability**: Use stable, unique keys for list items (database IDs, UUIDs). Never use array indices as keys — index keys cause unnecessary unmount/remount when items are reordered, added, or removed.
- **Virtualize long lists**: For lists with hundreds or thousands of items, use a virtualization technique (windowing) to render only the visible items. This reduces DOM node count and re-render cost dramatically.

**Step 4: Optimize assets and DOM**

- **Images**: Use modern formats (WebP, AVIF) with fallbacks. Always provide explicit `width` and `height` attributes to prevent layout shift. Lazy-load images below the fold using native `loading="lazy"` or an intersection observer.
- **CSS and animations**: Avoid layout thrashing — batch DOM reads before DOM writes. Use `transform` and `opacity` for animations (GPU-composited) instead of `top`, `left`, `width`, or `height` (trigger layout recalculation). Use `will-change` sparingly and only on elements that are about to animate — leaving it on permanently increases memory usage.
- **DOM depth**: Keep the DOM tree shallow. Avoid unnecessary wrapper elements that exist only for styling — use CSS alternatives. Deep DOM trees increase style calculation, layout, and paint costs.
- **Font loading**: Use `font-display: swap` or `font-display: optional` to prevent invisible text during font load. Preload critical fonts. Subset fonts to include only the characters actually used.
- **Third-party scripts**: Load third-party scripts (analytics, tracking, chat widgets) with `async` or `defer` to prevent blocking the main thread. `async` downloads and executes as soon as ready (non-blocking, out of order). `defer` executes after HTML parsing in document order. For critical third-party origins, add `<link rel="preconnect">` to reduce connection setup time. Lazy-load non-essential third-party resources (video embeds, social widgets) until the user scrolls to them or interacts. Audit third-party script count — set a resource budget (e.g., max 10 third-party requests) and enforce it.

**Step 5: Manage memory**

Prevent leaks that degrade performance over time:

- **Event listeners**: Every `addEventListener` must have a corresponding `removeEventListener` in the component's cleanup phase. Forgetting cleanup causes listeners to accumulate on long-lived pages.
- **Timers**: Every `setTimeout` needs `clearTimeout` and every `setInterval` needs `clearInterval` in cleanup. Leaked intervals continue executing after the component is gone.
- **In-flight requests**: Use `AbortController` to cancel pending network requests when the component unmounts. Responses arriving after unmount can cause state updates on unmounted components.
- **Refs for non-rendering values**: Use mutable refs (non-reactive references) for values that should not trigger re-renders — previous values, callback refs, accumulated counters, DOM element references.
- **Subscriptions**: WebSocket connections, event bus subscriptions, and observable subscriptions must all be unsubscribed in cleanup. The pattern is always: subscribe in the effect body, unsubscribe in the cleanup return.

**Step 6: Verify improvement**

After applying optimizations, close the loop:

- **Bundle size**: Run the project's build command and bundle analyzer. Compare chunk sizes against the baselines from Step 1. Flag any chunk still over 200KB gzipped.
- **Lighthouse audit**: Run a Lighthouse audit against the application. Use `vscode/askQuestions` to gather two inputs from the user:
  1. **URL to audit** — local dev server, staging/preview deployment, or production URL.
  2. **Expected thresholds** (optional) — custom performance score or Core Web Vitals targets. If the user has no preference, use the defaults below.

  Default thresholds (based on web.dev/Google recommendations):

  | Metric                          | Good    | Needs Improvement | Poor    |
  | ------------------------------- | ------- | ----------------- | ------- |
  | Lighthouse Performance Score    | ≥ 90    | 50–89             | < 50    |
  | LCP (Largest Contentful Paint)  | ≤ 2.5s  | 2.5s–4.0s         | > 4.0s  |
  | INP (Interaction to Next Paint) | ≤ 200ms | 200ms–500ms       | > 500ms |
  | CLS (Cumulative Layout Shift)   | ≤ 0.1   | 0.1–0.25          | > 0.25  |

  Execution steps:
  1. If the URL is local, verify the server is running (or start it using the project's dev/preview command from `package.json`).
  2. Run `npx lighthouse <URL> --output=json --output-path=./lighthouse-report.json --chrome-flags="--headless"`.
  3. Parse the JSON report — extract performance score, LCP, INP, CLS values.
  4. Compare each metric against the user's custom thresholds or the defaults above. Flag any metric in the "Needs Improvement" or "Poor" range.
  5. If a local server was started in step 1, stop it after the audit completes.

- **Quantify the delta**: Every claimed improvement needs a number — e.g., "main chunk reduced from 280KB to 140KB gzipped", "LCP improved from 3.2s to 1.8s". If no measurable improvement, the optimization was either targeting the wrong bottleneck or introduced regression elsewhere — revert and re-profile.
- **Document results**: Record post-optimization metrics alongside the baselines from Step 1 for future reference.

## Memoization Decision Guide

| Situation                                       | Memoize?                  | Why                                             |
| ----------------------------------------------- | ------------------------- | ----------------------------------------------- |
| Expensive computation (sort/filter 1000+ items) | Yes (cache computation)   | Saves CPU on re-renders                         |
| Handler passed to memoized child                | Yes (stabilize reference) | Preserves referential equality                  |
| Simple arithmetic or string concat              | No                        | Memo overhead exceeds computation cost          |
| Component with static or rarely-changing props  | Maybe (component memo)    | Profile first — often unnecessary               |
| Inline object passed as prop                    | Yes (lift or cache)       | New identity each render causes child re-render |
| Top-level handler (not passed down)             | No                        | Nothing benefits from a stable reference        |

## Bundle Size Red Flags

| Red Flag                                | Action                                                     |
| --------------------------------------- | ---------------------------------------------------------- |
| Single chunk over 200KB (gzipped)       | Code split — lazy-load routes or heavy features            |
| Heavy date library (e.g., `moment.js`)  | Replace with lightweight alternative (`date-fns`, `dayjs`) |
| Wildcard import (`import * as`)         | Switch to named imports for tree shaking                   |
| Barrel re-exports pulling unused code   | Import directly from source file                           |
| Unused dependencies in `package.json`   | Run audit tool and remove unused                           |
| CSS framework loaded fully (not purged) | Enable CSS purging in build configuration                  |
| Polyfills for widely-supported features | Remove or conditionally load based on browser targets      |

## Performance Checklist

```
Performance:
- [ ] Bundle analyzed — no unexpected large chunks
- [ ] Routes lazy-loaded with loading boundaries/fallbacks
- [ ] Heavy components (modals, charts) loaded on demand
- [ ] Rendering strategy evaluated (SSR/SSG where applicable)
- [ ] Named imports only — no wildcard imports
- [ ] Memoization/caching applied where measured benefit exists
- [ ] No object/array literals created in render path
- [ ] State subscriptions are selective (not full-store)
- [ ] Images optimized (modern format, width/height, lazy-load)
- [ ] Animations use transform/opacity (not layout properties)
- [ ] All effects clean up: timers, listeners, abort controllers
- [ ] Long lists virtualized when item count exceeds visible area
- [ ] Third-party scripts loaded async/defer, non-essential ones lazy-loaded
- [ ] Baseline metrics documented for comparison
- [ ] Post-optimization metrics compared against baselines
```

## Anti-Patterns

| Anti-Pattern                                        | Instead Do                                                                 |
| --------------------------------------------------- | -------------------------------------------------------------------------- |
| Optimizing without profiling                        | Measure first, optimize second                                             |
| Memoizing every component                           | Profile; only memoize components with frequent re-renders and stable props |
| Caching trivial computation                         | Skip — overhead exceeds benefit                                            |
| Unstable handler reference passed to memoized child | Stabilize the handler reference to preserve referential equality           |
| Inline `style={{}}` objects                         | Lift to module scope or memoize                                            |
| Loading entire library synchronously                | Code-split and lazy-load heavy modules                                     |
| Effect without cleanup                              | Always return a cleanup function for subscriptions and timers              |
| Over-relying on `will-change`                       | Use sparingly — permanent use increases memory consumption                 |
| Using array index as list key                       | Use stable unique identifiers (database IDs)                               |
| Global state for component-local concerns           | Keep state close to where it is consumed                                   |

## Framework-Specific Patterns

The patterns above are framework-agnostic. For framework-specific optimization APIs, load the appropriate reference:

- **React**: See `./references/react-patterns.md` — `React.memo`, `useMemo`, `useCallback`, `React.lazy`, `Suspense`.

## Connected Skills

- `tsh-implementing-frontend` — for component patterns that support performant rendering
- `tsh-writing-hooks` — for memoization and cleanup patterns within custom hooks
- `tsh-reviewing-frontend` — for performance-focused code review spot-checks
- `tsh-ensuring-accessibility` — to verify optimizations (lazy-loading, virtualization) don't break keyboard navigation or screen reader access
