# React Back Navigation Patterns

React Router v6+-specific patterns for the `tsh-implementing-back-navigation` skill. Load this reference when the project uses React Router.

## Table of Contents

- [Navigation API](#navigation-api)
- [The useGoBack Hook](#the-usegoback-hook)
- [Scroll Restoration](#scroll-restoration)
- [Dirty-State Guard](#dirty-state-guard)
- [Modal with Query Params](#modal-with-query-params)
- [Anti-Patterns](#anti-patterns)

## Navigation API

| API                   | Usage                                           | Notes                          |
| --------------------- | ----------------------------------------------- | ------------------------------ |
| `useNavigate()`       | `const navigate = useNavigate(); navigate(-1);` | Programmatic back navigation   |
| `<Link to="/parent">` | Declarative link                                | For known destinations         |
| `useLocation()`       | Access current location + state                 | Can pass return path via state |

## The `useGoBack` Hook

Full implementation for React Router:

```typescript
import { useNavigate } from "react-router-dom";

interface UseGoBackOptions {
  fallbackPath: string;
}

const useGoBack = ({ fallbackPath }: UseGoBackOptions) => {
  const navigate = useNavigate();

  const goBack = () => {
    if (window.history.length > 2) {
      navigate(-1);
    } else {
      navigate(fallbackPath, { replace: true });
    }
  };

  return { goBack };
};
```

## Scroll Restoration

Use `<ScrollRestoration />` to automatically restore scroll position when navigating back via browser history:

```typescript
import { ScrollRestoration } from 'react-router-dom';

function App() {
  return (
    <>
      <Outlet />
      <ScrollRestoration />
    </>
  );
}
```

`<ScrollRestoration />` must be rendered inside a router context. Add it once in the root layout — it covers all routes automatically.

## Dirty-State Guard

### Router-level blocker with `useBlocker`

```typescript
import { useBlocker } from "react-router-dom";

const useNavigationGuard = (isDirty: boolean) => {
  const blocker = useBlocker(
    ({ currentLocation, nextLocation }) =>
      isDirty && currentLocation.pathname !== nextLocation.pathname,
  );

  return blocker;
};
```

### Browser-level guard with `beforeunload`

Handles browser back button and tab close — does not cover in-app navigation. Same hook shape as the Next.js reference:

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

Combine both guards for complete coverage: `useBlocker` for in-app navigation, `beforeunload` for browser-level navigation.

## Modal with Query Params

Tie modal open state to URL query parameters so "back" closes the modal naturally. When opening a modal, push a query param (e.g., `?modal=settings`). When the user navigates back, the param is popped, closing the modal without leaving the page.

```typescript
// Opening: push query param
setSearchParams((prev) => {
  const next = new URLSearchParams(prev);
  next.set("modal", "settings");
  return next;
});

// The modal reads its state from the URL
const isOpen = searchParams.has("modal");

// Closing: "back" or removing the param closes the modal
// navigate(-1) naturally pops the query param
```

## Anti-Patterns

| Anti-Pattern                                             | Instead Do                                                          |
| -------------------------------------------------------- | ------------------------------------------------------------------- |
| Using `window.history.back()` instead of `navigate(-1)`  | `navigate(-1)` ensures React Router lifecycle events fire correctly |
| Using `useBlocker` without checking `isDirty`            | Only block when form has actual changes                             |
| Forgetting `<ScrollRestoration />` in the root layout    | Add it once in the root, covers all routes                          |
| Using `window.history.state` to determine previous route | Use React Router's location state or `navigate(-1)` with fallback   |
