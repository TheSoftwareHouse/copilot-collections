---
sidebar_position: 31
title: Writing Hooks
---

# Writing Hooks

**Folder:** `.github/skills/tsh-writing-hooks/`  
**Used by:** Software Engineer

Provides patterns for writing composable, testable custom hooks (React hooks, Vue composables) with stable APIs, proper effect lifecycle management, and clear responsibility boundaries.

## Key Principles

| Principle                 | Description                                                             |
| ------------------------- | ----------------------------------------------------------------------- |
| **Single Responsibility** | Each hook does one thing. Compose complex behavior from multiple hooks. |
| **Stable API Surface**    | Prefer objects over tuples for multi-value returns. Memoize callbacks.  |
| **Cleanup Everything**    | Every subscription, timer, listener, or async op must have cleanup.     |

## Hook Development Process

1. **Define contract** — Name, parameters, return shape (before writing implementation).
2. **Classify tier** — State hook, data hook, or composition hook.
3. **Implement with lifecycle discipline** — Dependency tracking, cleanup, error handling.
4. **Test** — Initial state, state transitions, effect cleanup, error states.

## Return Shape Guidelines

| Return Type                | When                         | Example                                        |
| -------------------------- | ---------------------------- | ---------------------------------------------- |
| Single value               | Hook computes one thing      | `useDebounce(value, delay)` → `debouncedValue` |
| Object                     | Multiple values or actions   | `{ data, error, isPending, refetch }`          |
| Object (prefer over tuple) | Readability and evolvability | `{ count, increment, decrement, reset }`       |

## Reference Files

- `references/react-patterns.md` — React-specific hook patterns and examples.

## Connected Skills

- `tsh-implementing-frontend` — Component patterns that consume hooks.
- `tsh-optimizing-frontend` — Memoization and rendering optimization in hooks.
- `tsh-reviewing-frontend` — Hook quality review criteria.
