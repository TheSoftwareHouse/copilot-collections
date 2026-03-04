# React Optimization Patterns

React-specific patterns for the `optimizing-frontend` skill. Load this reference when the project uses React.

## Table of Contents

- [Memoization APIs](#memoization-apis)
- [Code Splitting](#code-splitting)
- [Refs for Non-Reactive Values](#refs-for-non-reactive-values)
- [Common Render Waste Patterns](#common-render-waste-patterns)

## Memoization APIs

| Generic concept (from skill) | React API                              | Syntax                                                            |
| ---------------------------- | -------------------------------------- | ----------------------------------------------------------------- |
| Component memoization        | `React.memo(Component)`                | Wraps component; skips re-render when props are shallowly equal   |
| Custom comparison            | `React.memo(Component, areEqual)`      | `areEqual(prevProps, nextProps)` returns `true` to skip re-render |
| Cache computation            | `useMemo(() => compute(data), [deps])` | Recomputes only when a dependency changes                         |
| Stabilize callback           | `useCallback(fn, [deps])`              | Returns stable function reference until deps change               |
| Mutable ref                  | `useRef(initialValue)`                 | `.current` is mutable, does not trigger re-render                 |

**Dependency arrays**: All memoization hooks use `[deps]` for tracking. Include all reactive values. The `exhaustive-deps` ESLint rule enforces completeness — do not suppress it.

## Code Splitting

React uses `lazy()` + `Suspense` for code splitting:

```typescript
import { lazy, Suspense } from 'react';

const HeavyChart = lazy(() => import('./HeavyChart'));

const Dashboard = () => (
  <Suspense fallback={<ChartSkeleton />}>
    <HeavyChart data={data} />
  </Suspense>
);
```

- Place `Suspense` boundaries at route level and around heavy on-demand components (modals, charts, editors).
- The `fallback` prop renders while the chunk loads — use a skeleton or spinner.
- Nested `Suspense` boundaries allow independent loading states for different page regions.

## Refs for Non-Reactive Values

Use `useRef` for values that must persist across renders without causing re-renders.

> **Pitfall**: Do NOT read or write `ref.current` during rendering. React expects component bodies to be pure functions. Reading or writing refs during render breaks this expectation and can cause unpredictable behavior. Only access refs in **event handlers** or **effects**. The sole exception is lazy initialization: `if (!ref.current) ref.current = new Thing()`.

```typescript
// Timer ID — don't store in useState (re-render is wasteful)
const timerRef = useRef<number>();

// Start/stop timer — ref read/write happens in event handlers, NOT during render
const handleStart = () => {
  timerRef.current = window.setInterval(tick, 1000);
};
const handleStop = () => {
  clearInterval(timerRef.current);
};
```

### Tracking previous render values

If you need a previous value **during render** (e.g., to detect prop changes), use `useState` — not `useRef`:

```typescript
const [prevItems, setPrevItems] = useState(items);
if (items !== prevItems) {
  setPrevItems(items);
  // React to the change (e.g., reset selection)
}
```

This pattern is documented in the React docs under "Storing information from previous renders". React re-renders the component immediately (before children) when state is set during render, so children never see stale values.

## Common Render Waste Patterns

| Pattern                                     | Problem                                     | React fix                                                |
| ------------------------------------------- | ------------------------------------------- | -------------------------------------------------------- |
| `style={{ margin: 8 }}` in JSX              | New object every render                     | Lift to module constant: `const style = { margin: 8 }`   |
| `options={[1, 2, 3]}` in JSX                | New array every render                      | Lift to module constant or `useMemo`                     |
| `onChange={(e) => set(e.target.value)}`     | New function every render                   | `useCallback` if child is `React.memo`                   |
| Context provider `value={{ a, b }}`         | New object re-renders all consumers         | `useMemo` the value: `useMemo(() => ({ a, b }), [a, b])` |
| Missing `React.memo` on list item component | Parent list re-render re-renders every item | Wrap item component in `React.memo`                      |
