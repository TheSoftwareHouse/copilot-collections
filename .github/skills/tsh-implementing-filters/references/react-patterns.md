# React Filter Patterns

React Router v6+-specific patterns for the `tsh-implementing-filters` skill. Load this reference when the project uses React Router.

## Table of Contents

- [Reading Search Params](#reading-search-params)
- [Navigation (Push/Replace)](#navigation-pushreplace)
- [Hook Binding](#hook-binding)
- [Bracket Notation Parsing](#bracket-notation-parsing)
- [Anti-Patterns](#anti-patterns)

## Reading Search Params

| API                        | Usage                                     | Notes                                                                  |
| -------------------------- | ----------------------------------------- | ---------------------------------------------------------------------- |
| `useSearchParams()`        | Returns `[searchParams, setSearchParams]` | Read-write tuple. `searchParams` is a `URLSearchParams` instance.      |
| `searchParams.get(key)`    | Single value                              | Returns `string \| null`                                               |
| `searchParams.getAll(key)` | Multi-value (arrays)                      | Returns `string[]` — use for repeated bracket keys like `filter[tags]` |
| `searchParams.toString()`  | Full query string                         | For URL construction                                                   |

Key difference from Next.js: React Router's `useSearchParams()` returns a **read-write** tuple — you can use `setSearchParams()` directly to update the URL without constructing a full URL string.

## Navigation (Push/Replace)

**Approach 1: `setSearchParams()` (preferred for filter updates)**

```typescript
import { useSearchParams } from "react-router-dom";

const useFilterNavigation = () => {
  const [searchParams, setSearchParams] = useSearchParams();

  const navigate = (
    newParams: URLSearchParams,
    options?: { replace?: boolean },
  ) => {
    setSearchParams(newParams, { replace: options?.replace });
  };

  return { navigate, searchParams };
};
```

`setSearchParams` also supports a functional updater for deriving from the previous params:

```typescript
setSearchParams(
  (prev) => {
    const next = new URLSearchParams(prev);
    next.set("filter[color]", "blue");
    return next;
  },
  { replace: true },
);
```

**Approach 2: `useNavigate()` (when path + search need to change together)**

```typescript
import { useNavigate, useSearchParams } from "react-router-dom";

const useFilterNavigation = () => {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();

  const navigateWithFilters = (
    newParams: URLSearchParams,
    options?: { replace?: boolean; pathname?: string },
  ) => {
    navigate(
      { pathname: options?.pathname ?? ".", search: newParams.toString() },
      { replace: options?.replace },
    );
  };

  return { navigateWithFilters, searchParams };
};
```

Use `setSearchParams()` when only filters change. Use `useNavigate()` when both the path segment and query string need to update simultaneously (e.g., changing category + resetting filters). `setSearchParams()` with `{ replace: true }` maps directly to the skill's navigation strategy — use it for search-as-you-type, omit it (defaults to push) for discrete filter actions.

## Hook Binding

Concrete React Router binding for the generic `useFilters` hook described in SKILL.md Step 4:

```typescript
import { useSearchParams } from "react-router-dom";

const useFilters = <T extends Record<string, unknown>>({
  defaults,
  serialize,
  deserialize,
}: {
  defaults: T;
  serialize: (filters: T) => URLSearchParams;
  deserialize: (params: URLSearchParams) => T;
}) => {
  const [searchParams, setSearchParams] = useSearchParams();

  const filters = deserialize(searchParams);

  const updateFilters = (
    partial: Partial<T>,
    options?: { replace?: boolean },
  ) => {
    setSearchParams(
      (prev) => {
        const current = deserialize(prev);
        const next = { ...current, ...partial };
        return serialize(next);
      },
      { replace: options?.replace },
    );
  };

  const resetFilters = () => {
    setSearchParams(serialize(defaults));
  };

  return { filters, updateFilters, resetFilters };
};
```

The hook reads `searchParams` for the current filter state and uses `setSearchParams` with a functional updater for writes. No `useEffect` or `useState` needed.

Note: `{ ...filters, ...partial }` is a shallow merge. Use flat properties for ranges (e.g., `priceMin`, `priceMax` instead of nested `{ price: { min, max } }`) so that partial updates merge correctly.

## Bracket Notation Parsing

React Router does not parse bracket notation (`filter[color]=blue`) into structured objects — the `searchParams` instance treats `filter[color]` as a literal key string. The deserialization function must parse bracket keys manually. This logic is framework-agnostic. See SKILL.md Step 3 for the serialization/deserialization pattern.

```typescript
// searchParams.get('filter[color]') → 'blue'
// searchParams.getAll('filter[tags]') → ['a', 'b']
// Parse bracket keys to extract field names and structure
```

## Anti-Patterns

| Anti-Pattern                                                        | Instead Do                                                                  |
| ------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| Using `useNavigate()` when only filters change                      | Use `setSearchParams()` — simpler, doesn't require path construction        |
| Mutating the `searchParams` object directly and expecting re-render | Create new `URLSearchParams` via `serialize()`, pass to `setSearchParams()` |
| Using `setSearchParams` with string instead of `URLSearchParams`    | Pass `URLSearchParams` object for type safety and correct encoding          |
| Wrapping `setSearchParams` in `useEffect` to sync state             | Call `setSearchParams` directly in event handlers — no effect sync needed   |
| Using `navigate(-1)` to "undo" filter changes                       | Rely on browser Back button — push navigation already handles this          |
