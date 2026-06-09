# Next.js Filter Patterns

Next.js App Router-specific patterns for the tsh-implementing-filters skill. Load this reference when the project uses Next.js.

## Table of Contents

- [Reading Search Params](#reading-search-params)
- [Navigation (Push/Replace)](#navigation-pushreplace)
- [Server Component Constraints](#server-component-constraints)
- [Bracket Notation with Next.js](#bracket-notation-with-nextjs)
- [Anti-Patterns](#anti-patterns)

## Reading Search Params

Next.js App Router provides different APIs for reading URL search params depending on the context:

| Context          | API                                                                             | Notes                                                                   |
| ---------------- | ------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| Client Component | `useSearchParams()` from `next/navigation`                                      | Returns `ReadonlyURLSearchParams`. Only available in Client Components. |
| Server Component | `searchParams` prop from page/layout (async in Next.js 15+ — must be `await`ed) | Passed as a prop to `page.tsx`. Access `searchParams.filter` etc.       |
| Route Handler    | `request.nextUrl.searchParams`                                                  | In `route.ts` handlers.                                                 |

Key difference from React Router: `useSearchParams()` returns a **read-only** object. You cannot call `setSearchParams()` — you must construct a new URL and navigate.

## Navigation (Push/Replace)

How to navigate with updated filters in Next.js App Router:

```typescript
import { useRouter, usePathname, useSearchParams } from "next/navigation";

const useFilterNavigation = () => {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();

  const navigate = (
    newParams: URLSearchParams,
    options?: { replace?: boolean },
  ) => {
    const url = `${pathname}?${newParams.toString()}`;
    if (options?.replace) {
      router.replace(url);
    } else {
      router.push(url);
    }
  };

  return { navigate, searchParams, pathname };
};
```

`router.push()` and `router.replace()` use **soft navigation** by default — no full page reload, which is the desired behavior for filter changes.

## Server Component Constraints

- Server Components **cannot** use `useSearchParams()` — they receive `searchParams` as a page prop.
- Deserialization logic (bracket notation parsing, type coercion) works identically in both contexts — only the source of raw params differs.
- Pattern: Define serialization/deserialization as plain functions (not hooks). The `useFilters` hook wraps them for Client Components. Server Components call the deserialization function directly.

```typescript
// Shared — works in both contexts
const deserializeFilters = (params: URLSearchParams): ProductFilters => {
  /* ... */
};

// Client Component — via hook
const useFilters = (defaults: ProductFilters) => {
  const searchParams = useSearchParams();
  const filters = deserializeFilters(
    new URLSearchParams(searchParams.toString()),
  );
  // ...
};

// Server Component — direct call
export default async function ProductsPage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | string[]>>;
}) {
  const resolvedParams = await searchParams;
  const params = new URLSearchParams();
  // Convert resolvedParams record to URLSearchParams...
  const filters = deserializeFilters(params);
  // ...
}
```

## Bracket Notation with Next.js

Next.js does not natively parse bracket notation (`filter[color]=blue`) into structured objects. The `searchParams` prop gives flat key-value pairs where the key is the literal string `filter[color]`.

The deserialization function must parse bracket keys manually. This logic is framework-agnostic — identical to the React Router approach. Only the source of `URLSearchParams` differs.

```typescript
// searchParams in Next.js page: { "filter[color]": "blue", "filter[tags]": ["a", "b"] }
// Parse bracket keys to extract field names
```

## Anti-Patterns

| Anti-Pattern                                                             | Instead Do                                                                                                   |
| ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------ |
| Using `useSearchParams()` in Server Components                           | Use the `searchParams` page prop in Server Components                                                        |
| Calling `setSearchParams()` like React Router                            | Construct new URL string, use `router.push()` / `router.replace()`                                           |
| Wrapping entire page in Client Component for filter access               | Keep filter display in Server Components via `searchParams` prop; only filter controls need Client Component |
| Using `router.push()` with full URL including origin                     | Use pathname-relative URLs: `` `${pathname}?${params}` ``                                                    |
| Using nested objects for range filters (e.g., `{ price: { min, max } }`) | Use flat properties (`priceMin`, `priceMax`) so partial updates with shallow spread merge correctly          |

> **Note:** When composing filter update functions, use flat properties for ranges (e.g., `priceMin`, `priceMax` instead of nested `{ price: { min, max } }`) so that partial updates with shallow spread merge correctly.
