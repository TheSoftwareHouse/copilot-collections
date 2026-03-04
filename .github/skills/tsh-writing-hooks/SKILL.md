---
name: tsh-writing-hooks
description: "Custom hook and composable patterns — naming, composition, stable return shapes, lifecycle cleanup, and testing strategies. Use when writing reusable logic units (React hooks, Vue composables), refactoring logic into hooks, debugging hook behavior, or reviewing hook implementations."
---

# Writing Hooks

Provides patterns for writing composable, testable custom hooks with stable APIs, proper effect lifecycle management, and clear responsibility boundaries.

> This skill uses "hook" to refer to any reusable, composable logic unit — React hooks, Vue composables, or equivalent framework abstractions. Adapt naming conventions and specific APIs to the project's framework.

<principles>

<single-responsibility>
Each hook does one thing. Compose complex behavior by calling multiple hooks, not by adding optional parameters to a single hook. A hook with 5+ configuration options is a sign it needs decomposition.
</single-responsibility>

<stable-api-surface>
Return an object (not a tuple) with stable references. Memoize callbacks and derived values using the framework's memoization primitives when consumers may pass them to memoized children. The hook's return shape is its public API — treat it as a contract.
</stable-api-surface>

<cleanup-everything>
Every subscription, timer, event listener, or async operation created in an effect must have a corresponding cleanup. Leaked resources cause memory leaks and stale state bugs that are hard to diagnose.
</cleanup-everything>

</principles>

## Hook Development Process

Use the checklist below and track progress:

```
Progress:
- [ ] Step 1: Define the hook's contract
- [ ] Step 2: Classify the hook tier
- [ ] Step 3: Implement with lifecycle discipline
- [ ] Step 4: Test the hook
```

**Step 1: Define the hook's contract**

Define the hook's public API before writing implementation code.

**Naming**: Follow the project's framework convention for reusable logic units. In React and Vue, the convention is `use` prefix + descriptive verb or noun. The name reflects behavior, not implementation details.

| Pattern        | Example                        | Use case                            |
| -------------- | ------------------------------ | ----------------------------------- |
| `use` + noun   | `useDebounce`, `useMediaQuery` | Returns a derived or observed value |
| `use` + verb   | `useToggle`, `useFetch`        | Returns value + action(s)           |
| `use` + domain | `useAuth`, `useCart`           | Domain-specific composition hook    |

Good: `useLocalStorage` — describes what it does.
Bad: `useBrowserEffect` — describes how it works.

**Inputs**: Prefer a single options object when the hook accepts 3+ parameters. This makes the API extensible without breaking existing call sites.

```typescript
// Prefer — single options object
const useDebounce = ({ value, delay, leading }: UseDebounceOptions) => {
  // ...
};

// Avoid — positional args are fragile past 2 params
const useDebounce = (value: string, delay: number, leading?: boolean) => {
  // ...
};
```

**Outputs**: Return an object with clear field names. Document what the hook returns and when it triggers effects.

```typescript
interface UseAsyncReturn<T> {
  data: T | undefined;
  error: Error | null;
  isPending: boolean;
  refetch: () => void;
}
```

**Step 2: Classify the hook tier**

Determine where the hook fits in the dependency hierarchy. This classification constrains what a hook may depend on and prevents circular or inappropriate coupling.

| Tier     | Name               | Scope                                                | Dependencies                                              | Examples                                    |
| -------- | ------------------ | ---------------------------------------------------- | --------------------------------------------------------- | ------------------------------------------- |
| Atom     | UI hooks           | Local state, DOM events, media queries, keyboard     | No remote data. No data-fetching libraries.               | `useToggle`, `useMediaQuery`, `useKeyPress` |
| Molecule | Coordination hooks | Compose atom hooks with light coordination logic     | Other atom hooks only. No remote data.                    | `useFormField`, `usePagination`             |
| Organism | Data hooks         | Wrap data-fetching/mutation libraries. Domain logic. | May call UI hooks internally. Interact with server cache. | `useUserProfile`, `useSearchResults`        |

Rules:

- Atom hooks must never import data-fetching or state management libraries.
- Molecule hooks compose atoms — they do not call data hooks.
- Organism hooks may call any tier but are the only tier that touches remote data.

**Composability example** — molecule hook composing atoms:

```typescript
// Atom: single-purpose, no data fetching
const useDebounce = (value: string, delay: number) => {
  /* ... */
};
const useLocalStorage = <T>(key: string, initial: T) => {
  /* ... */
};

// Molecule: composes atoms into a higher-level behavior
const useDebouncedSearch = (storageKey: string) => {
  const { value, setValue } = useLocalStorage(storageKey, "");
  const debouncedValue = useDebounce(value, 300);
  return { query: value, setQuery: setValue, debouncedQuery: debouncedValue };
};
```

**Step 3: Implement with lifecycle discipline**

Follow these rules during implementation:

**Call rules**:

- Call hooks/composables at the top level only — never inside conditions, loops, or nested functions.
- Ensure all reactive dependencies are properly tracked — whether through explicit dependency arrays or automatic reactivity tracking, depending on the framework. Suppressing framework lint rules for dependency tracking is a last resort, not a shortcut.
- Avoid object or array literals in dependency declarations — they create new identities every render/update cycle. Lift constants to module scope or memoize them.

**Lifecycle cleanup** — every effect that creates a resource must clean it up:

| Resource        | Setup                                               | Required cleanup                      |
| --------------- | --------------------------------------------------- | ------------------------------------- |
| Timer           | `setTimeout(cb, delay)`                             | `clearTimeout(id)`                    |
| Event listener  | `addEventListener(event, handler)`                  | `removeEventListener(event, handler)` |
| Async operation | Cancellable operation with `AbortController` signal | `controller.abort()`                  |
| Subscription    | `source.subscribe(handler)`                         | `subscription.unsubscribe()`          |

The cleanup must execute when the hook unmounts or when dependencies change. See the framework reference for the exact cleanup syntax.

**Error handling**:

- Never throw from the render/setup phase — surface errors via the return value (`{ error }`).
- Catch async errors inside effects and store them in state.

**Conditional execution**:

- Data hooks should support an `enabled` flag to prevent wasteful operations when preconditions are not met.

```typescript
const useUserProfile = ({ userId, enabled = true }: Options) => {
  // Skip data fetching when disabled — delegate to data fetching library's enabled/skip option
  // Return idle state: { data: undefined, isPending: false, error: null }
};
```

**Step 4: Test the hook**

Use the framework's hook/composable testing utility. Structure tests around four areas:

1. **Initial state** — Verify the hook returns the expected default values on first render.
2. **State transitions** — Trigger actions and assert the return value updates correctly.
3. **Effect cleanup** — Unmount the hook and verify all resources are released (timers cleared, listeners removed, subscriptions cancelled).
4. **Error states** — Simulate failures and verify the hook surfaces errors via its return value.

For data hooks: wrap the test in required providers (query client, context providers) and mock network responses.

For timer-dependent hooks: use fake timers to control time progression without real delays.

```typescript
it("cleans up the timer on unmount", () => {
  // Enable fake timers (syntax varies by test runner)
  // Render the hook using the framework's testing utility
  // Unmount
  // Advance all pending timers — verify no leaked side effects
  // Restore real timers after test
});
```

## Return Shape Guidelines

| Return type                | When                                | Example                                        |
| -------------------------- | ----------------------------------- | ---------------------------------------------- |
| Single value               | Hook computes one thing             | `useDebounce(value, delay)` → `debouncedValue` |
| Object                     | Multiple related values or actions  | `{ data, error, isPending, refetch }`          |
| Object (prefer over tuple) | Readability and evolvability matter | `{ count, increment, decrement, reset }`       |

Prefer objects over tuples for hooks returning more than one value. Objects are self-documenting, allow consumers to destructure only what they need, and evolve without breaking existing call sites.

## Anti-Patterns

| Anti-Pattern                                     | Instead Do                                    |
| ------------------------------------------------ | --------------------------------------------- |
| Tuple return `[value, setter]` for complex hooks | Object return `{ value, setValue, reset }`    |
| Effect with suppressed dependency tracking       | Include all deps; restructure if cycle occurs |
| New object/array identity every render           | Memoize or lift to module scope               |
| Side effects in render phase                     | Move to lifecycle effect or event handler     |
| Swallowing errors silently                       | Return `{ error }` so consumer can handle     |
| One mega-hook with 10 options                    | Compose from smaller single-purpose hooks     |
| Timer without cleanup                            | Always `return () => clearTimeout(id)`        |
| Data hook without `enabled` flag                 | Support conditional fetching to avoid waste   |

## Hook Quality Checklist

```
Hook:
- [ ] Name follows framework convention (e.g., `use` prefix), describes behavior (not implementation)
- [ ] Single responsibility — does one thing well
- [ ] Inputs: single options object for 3+ params
- [ ] Output: object with stable references (memoized where framework supports it)
- [ ] All dependency tracking complete — no linting suppression
- [ ] Effects clean up: timers, listeners, subscriptions, abort controllers
- [ ] Errors surfaced via return value, never thrown from render
- [ ] Tested: initial state, transitions, cleanup, error states
```

## Framework-Specific Patterns

The patterns above are framework-agnostic. For framework-specific hook/composable syntax, load the appropriate reference:

- **React**: See `./references/react-patterns.md` — `useEffect`, `useMemo`, `useCallback`, dependency arrays, rules of hooks.

## Connected Skills

- `tsh-implementing-frontend` — hooks are used within components; this skill covers component patterns
- `tsh-optimizing-frontend` — for memoization strategies and performance patterns in hooks
- `tsh-reviewing-frontend` — for hook-specific code review criteria
- `tsh-implementing-forms` — for form-related custom hooks (field state, validation triggers)
