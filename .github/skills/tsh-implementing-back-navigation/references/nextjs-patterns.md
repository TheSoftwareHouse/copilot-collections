# Next.js Back Navigation Patterns

Next.js App Router-specific patterns for the `tsh-implementing-back-navigation` skill. Load this reference when the project uses Next.js.

## Table of Contents

- [Navigation API](#navigation-api)
- [The useGoBack Hook](#the-usegoback-hook)
- [Client vs Server Component Constraints](#client-vs-server-component-constraints)
- [Dirty-State Guard in Next.js](#dirty-state-guard-in-nextjs)
- [Modal with Query Params](#modal-with-query-params)
- [Scroll Restoration](#scroll-restoration)
- [Anti-Patterns](#anti-patterns)

## Navigation API

| API                                  | Usage                | Notes                                                           |
| ------------------------------------ | -------------------- | --------------------------------------------------------------- |
| `useRouter()` from `next/navigation` | `router.back()`      | Client Component only. Uses soft navigation.                    |
| `usePathname()`                      | Get current pathname | For constructing fallback URLs                                  |
| `useSearchParams()`                  | Read query params    | For modal/overlay query param patterns                          |
| `redirect()`                         | Server-side redirect | Not for back navigation — use only in Server Components/actions |

## The useGoBack Hook

The primary pattern for back navigation in Next.js. Wraps `router.back()` with a history-length fallback.

```typescript
import { useRouter } from "next/navigation";

interface UseGoBackOptions {
  fallbackPath: string;
}

const useGoBack = ({ fallbackPath }: UseGoBackOptions) => {
  const router = useRouter();

  const goBack = () => {
    if (window.history.length > 2) {
      router.back();
    } else {
      router.replace(fallbackPath);
    }
  };

  return { goBack };
};
```

### Shared Library Pattern: Router Adapter

When building a shared UI library consumed by projects with different routers (React Router, Next.js, etc.), abstract navigation behind an adapter interface. This is NOT needed for single-router projects.

```typescript
// Shared library — framework-agnostic interface
interface NavigationAdapter {
  goBack: () => void;
  navigateTo: (path: string, options?: { replace?: boolean }) => void;
}

interface UseAdapterGoBackOptions {
  fallbackPath: string;
  adapter: NavigationAdapter;
}

const useGoBack = ({ fallbackPath, adapter }: UseAdapterGoBackOptions) => {
  const goBack = () => {
    if (window.history.length > 2) {
      adapter.goBack();
    } else {
      adapter.navigateTo(fallbackPath, { replace: true });
    }
  };

  return { goBack };
};
```

```typescript
// Next.js adapter — passed to the shared useGoBack
import { useRouter } from "next/navigation";

const useNextNavigationAdapter = (): NavigationAdapter => {
  const router = useRouter();
  return {
    goBack: () => router.back(),
    navigateTo: (path, options) => {
      if (options?.replace) {
        router.replace(path);
      } else {
        router.push(path);
      }
    },
  };
};
```

## Client vs Server Component Constraints

- `router.back()` is only available in Client Components (`'use client'`).
- Server Components cannot trigger back navigation — the back button must be a Client Component.
- Pattern: Create a Client Component that calls the `useGoBack` hook and renders a button — then embed that component in Server Component layouts where back navigation is needed.

## Dirty-State Guard in Next.js

Next.js App Router does NOT have a `useBlocker` equivalent. This is a known limitation — there is no first-party API for blocking in-app navigation.

Workarounds:

- Use `beforeunload` for browser-level navigation (back button, tab close):

```typescript
import { useEffect } from "react";

const useBeforeUnloadGuard = (isDirty: boolean) => {
  useEffect(() => {
    if (!isDirty) return;

    const handler = (e: BeforeUnloadEvent) => {
      e.preventDefault();
    };

    window.addEventListener("beforeunload", handler);
    return () => window.removeEventListener("beforeunload", handler);
  }, [isDirty]);
};
```

- For browser back button interception, `popstate` event listeners can be used but come with significant trade-offs: they require pushing sentinel history entries that persist even after `isDirty` becomes false, causing phantom "empty" back-presses. Consider whether `beforeunload` alone provides sufficient coverage before implementing popstate interception.

- For in-app link clicks, wrap navigation in a guard function that checks `isDirty` and shows a confirmation dialog before proceeding.

## Modal with Query Params

Tie modal open state to URL query parameters so "back" closes the modal naturally. When opening a modal, push a query param. Unlike React Router, Next.js requires constructing the full URL string.

```typescript
// Opening: push query param
const params = new URLSearchParams(searchParams.toString());
params.set("modal", "settings");
router.push(`${pathname}?${params.toString()}`);

// The modal reads its state from the URL
const isOpen = searchParams.has("modal");

// Closing: navigate back naturally pops the query param
// router.back() removes the param, closing the modal
```

## Scroll Restoration

Next.js App Router handles scroll restoration automatically for back/forward navigation. No additional setup needed. This differs from React Router which requires an explicit `<ScrollRestoration />` component.

## Anti-Patterns

| Anti-Pattern                                             | Instead Do                                                          |
| -------------------------------------------------------- | ------------------------------------------------------------------- |
| Using `window.history.back()` instead of `router.back()` | `router.back()` preserves App Router cache and layout state         |
| Using `router.back()` in Server Components               | Create a Client Component wrapper (`BackButton`)                    |
| Using `router.push()` with full URL including origin     | Use pathname-relative URLs: `` `${pathname}?${params}` ``           |
| Expecting `useBlocker` to exist like React Router        | Use `beforeunload` + custom popstate handler for dirty-state guards |
| Using `router.back()` when destination is known          | Use `<Link href="/parent">` for known destinations                  |
