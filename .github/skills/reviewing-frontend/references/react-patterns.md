# React Review Patterns

React-specific review criteria for the `reviewing-frontend` skill. Load this reference when reviewing React code.

## Table of Contents

- [Hooks Review Specifics](#hooks-review-specifics)
- [React-Specific Anti-Patterns](#react-specific-anti-patterns)
- [Memoization Review](#memoization-review)
- [Security: dangerouslySetInnerHTML](#security-dangerouslysetinnerhtml)

## Hooks Review Specifics

When reviewing React hooks, check these React-specific concerns in addition to the generic hook review in the skill:

| Check                              | What to look for                                                         | Severity                                |
| ---------------------------------- | ------------------------------------------------------------------------ | --------------------------------------- |
| `exhaustive-deps` suppression      | `// eslint-disable-next-line react-hooks/exhaustive-deps`                | Warning — potential stale closure       |
| Rules of hooks violation           | Hook called inside condition, loop, or nested function                   | Critical — breaks React's hook ordering |
| `useEffect` without cleanup return | Timer, listener, or subscription created but no `return () => cleanup()` | Critical — memory leak                  |
| `useEffect` for derived state      | State set in effect that could be computed during render                 | Warning — unnecessary render cycle      |
| `useState` for non-reactive value  | Timer ID, previous value, or ref stored in state                         | Warning — causes unnecessary re-renders |

### Dependency Array Checklist

```
- [ ] All reactive values included in dependency arrays
- [ ] No eslint-disable for exhaustive-deps
- [ ] Objects/arrays in deps are memoized or lifted to module scope
- [ ] No function/object literals created in deps position
```

## React-Specific Anti-Patterns

| Anti-Pattern                                           | Severity   | Fix                                                 |
| ------------------------------------------------------ | ---------- | --------------------------------------------------- |
| `dangerouslySetInnerHTML={{ __html: userInput }}`      | Critical   | Sanitize with DOMPurify or similar before injection |
| `dangerouslySetInnerHTML` on user-controllable content | Critical   | Prefer rendering structured data; avoid raw HTML    |
| Index as key on dynamic list (`key={index}`)           | Critical   | Use stable unique ID (entity ID, UUID)              |
| Class component in new code                            | Suggestion | Convert to functional component with hooks          |
| Default export on component                            | Suggestion | Use named export for consistency                    |

## Memoization Review

When reviewing memoization in React code:

| Pattern                            | Check                                                                    | Fix if wrong                                              |
| ---------------------------------- | ------------------------------------------------------------------------ | --------------------------------------------------------- |
| `React.memo(Component)`            | Is the component actually re-rendered with same props frequently?        | Remove if parent rarely re-renders or props always change |
| `useMemo(() => val, [deps])`       | Is the computation genuinely expensive (1000+ items, complex transform)? | Remove for trivial computations                           |
| `useCallback(fn, [deps])`          | Is the callback passed to a `React.memo`-wrapped child?                  | Remove if handler is not passed down                      |
| Missing `useMemo` on context value | Does `<Provider value={{ a, b }}>` create a new object each render?      | Wrap value in `useMemo`                                   |

## Security: dangerouslySetInnerHTML

React's `dangerouslySetInnerHTML` is the primary XSS vector in React applications:

- **Never** pass unsanitized user input to `__html`.
- If raw HTML is required, sanitize with a library (DOMPurify, sanitize-html) before injection.
- Prefer rendering structured data (component composition) over raw HTML injection.
- Flag every `dangerouslySetInnerHTML` usage for manual security review — even if it looks safe now, future data changes may introduce risk.
