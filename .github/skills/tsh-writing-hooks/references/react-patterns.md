# React Hook Patterns

React-specific patterns for the `tsh-writing-hooks` skill. Load this reference when the project uses React.

## Table of Contents

- [Rules of Hooks](#rules-of-hooks)
- [Dependency Arrays](#dependency-arrays)
- [Effect Cleanup Syntax](#effect-cleanup-syntax)
- [Memoization APIs](#memoization-apis)
- [Testing with renderHook](#testing-with-renderhook)

## Rules of Hooks

React enforces two rules that constrain hook usage:

1. **Only call hooks at the top level** — never inside conditions, loops, or nested functions. React relies on call order to associate state with the correct hook.
2. **Only call hooks from React functions** — functional components or other custom hooks.

The `eslint-plugin-react-hooks` enforces these rules. Never suppress `react-hooks/rules-of-hooks`.

## Dependency Arrays

React effects and memoization hooks use dependency arrays to track reactive values:

| Hook                         | Dependency array behavior                      |
| ---------------------------- | ---------------------------------------------- |
| `useEffect(fn, [deps])`      | Re-runs `fn` when any dep changes by reference |
| `useMemo(() => val, [deps])` | Recomputes when any dep changes                |
| `useCallback(fn, [deps])`    | Returns stable reference until deps change     |

**Rules**:

- Include ALL reactive values (props, state, derived values) in the array.
- The `exhaustive-deps` ESLint rule catches missing dependencies — do not suppress it.
- Object and array dependencies compare by reference, not value. Lift stable objects to module scope or memoize them.

## Effect Cleanup Syntax

React cleanup runs via the return function from `useEffect`:

```typescript
// Timer cleanup
useEffect(() => {
  const id = setTimeout(callback, delay);
  return () => clearTimeout(id);
}, [callback, delay]);

// Event listener cleanup
useEffect(() => {
  window.addEventListener("resize", handler);
  return () => window.removeEventListener("resize", handler);
}, [handler]);

// Abort controller for cancellable async operations
useEffect(() => {
  const controller = new AbortController();
  // Pass signal to cancellable operations (NOT for data fetching — use a data fetching library instead)
  longRunningOperation({ signal: controller.signal });
  return () => controller.abort();
}, [longRunningOperation]);

// Subscription cleanup
useEffect(() => {
  const subscription = source.subscribe(handler);
  return () => subscription.unsubscribe();
}, [source, handler]);
```

Cleanup runs before the next effect execution and on component unmount.

> **Note**: Do NOT use `useEffect` for data fetching. Use a dedicated data fetching library (TanStack Query, SWR, or your framework's data layer) which handles caching, deduplication, loading/error states, and cleanup automatically. `useEffect` for fetch is a common anti-pattern that leads to race conditions, missing error handling, and no caching.

## Memoization APIs

| Generic concept (from skill) | React API                              | Usage                                                                               |
| ---------------------------- | -------------------------------------- | ----------------------------------------------------------------------------------- |
| Memoize callback             | `useCallback(fn, [deps])`              | Stable handler reference for memoized children                                      |
| Memoize computed value       | `useMemo(() => compute(data), [deps])` | Expensive derivations from state/props                                              |
| Memoize component            | `React.memo(Component)`                | Skip re-render when props unchanged                                                 |
| Non-rendering mutable ref    | `useRef(initialValue)`                 | Timer IDs, DOM refs — access only in effects or event handlers, never during render |
| Conditional state            | `useState` / `useReducer`              | `useReducer` for complex state transitions                                          |

**When NOT to memoize**:

- Trivial computations (simple arithmetic, string concat) — memo overhead exceeds benefit.
- Handlers not passed to memoized children — `useCallback` provides no value.
- Components that always receive new props — `React.memo` comparison runs but never saves a render.

## Testing with renderHook

React hooks are tested using `renderHook` from `@testing-library/react` (v13+):

```typescript
import { renderHook, act } from "@testing-library/react";

it("returns initial state", () => {
  const { result } = renderHook(() => useCounter({ initial: 5 }));
  expect(result.current.count).toBe(5);
});

it("updates state via actions", () => {
  const { result } = renderHook(() => useCounter({ initial: 0 }));
  act(() => result.current.increment());
  expect(result.current.count).toBe(1);
});

it("cleans up on unmount", () => {
  const { unmount } = renderHook(() =>
    useDebounce({ value: "test", delay: 500 }),
  );
  unmount();
  // Advance timers — verify no leaked side effects
});
```

For hooks that need providers (query client, context), wrap in a `wrapper` option:

```typescript
const wrapper = ({ children }) => (
  <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
);
const { result } = renderHook(() => useUserProfile(1), { wrapper });
```
