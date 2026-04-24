---
name: tsh-implementing-back-navigation
description: "Safe backwards navigation patterns with history fallback, state preservation, dirty-state guards, and modal/overlay awareness. Framework-agnostic navigation logic — router-native methods, scroll restoration, and declarative vs imperative navigation strategies. Use when implementing back buttons, return-to-previous flows, undo navigation, or any UI that navigates the user to a previous page."
---

# Implementing Back Navigation

Provides patterns for implementing safe, predictable backwards navigation in React and Next.js applications — covering history fallback, state preservation, dirty-state guards, and modal/overlay awareness.

## Table of Contents

- [Principles](#principles)
- [Back Navigation Implementation Process](#back-navigation-implementation-process)
- [Back Navigation Quality Checklist](#back-navigation-quality-checklist)
- [Anti-Patterns](#anti-patterns)
- [Framework-Specific Patterns](#framework-specific-patterns)
- [Connected Skills](#connected-skills)

## Principles

<principles>

<router-native-first>
Always use the framework router's native back method (`navigate(-1)` for React Router, `router.back()` for Next.js) instead of raw `window.history.back()`. Router methods ensure framework lifecycle events (route cache, loaders, component unmounting) fire correctly, preventing blank screens or stale data.
</router-native-first>

<always-have-a-fallback>
The most common backwards navigation bug: user lands directly via URL or new tab → history stack is empty → "go back" does nothing or ejects the user from the app. Always check `window.history.length` and provide a logical fallback route (e.g., parent page, dashboard). This is the golden rule. Example pattern: `if (window.history.length > 2) { navigate(-1); } else { navigate('/dashboard'); }`
</always-have-a-fallback>

<preserve-previous-state>
When navigating backward, the previous page must look exactly as the user left it — scroll position, data, and form state. Use the framework's scroll restoration mechanism. Use a data caching layer so the user sees instant data on back navigation instead of loading spinners. Persist multi-step form state outside component local state so it survives unmount/remount cycles.
</preserve-previous-state>

<guard-dirty-state>
If the current page has unsaved changes (forms, editors), intercept backward navigation and prompt confirmation before losing work. Use router-level blockers for in-app navigation and the native `beforeunload` event listener for browser-level navigation (back button, tab close).
</guard-dirty-state>

</principles>

## Back Navigation Implementation Process

Use the checklist below and track your progress:

```
Progress:
- [ ] Step 1: Choose the navigation method
- [ ] Step 2: Implement the history fallback
- [ ] Step 3: Configure state preservation
- [ ] Step 4: Add dirty-state guards
- [ ] Step 5: Handle modals and overlays
```

**Step 1: Choose the navigation method**

Decide between declarative and imperative navigation:

| Scenario                                | Approach                      | Example                                        |
| --------------------------------------- | ----------------------------- | ---------------------------------------------- |
| Static "back to parent" link            | Declarative `<Link>`          | `<Link to="/products">Back to Products</Link>` |
| Dynamic "return to where you came from" | Imperative `navigate(-1)`     | Back button after viewing item details         |
| Programmatic redirect after action      | Imperative with specific path | After form submit, navigate to list            |

Rule: Use declarative `<Link>` when the destination is known and fixed. Use imperative `navigate(-1)` only for dynamic "return to previous" scenarios. Declarative links allow hover previews, right-click context menus, and are better for SEO and accessibility.

**Step 2: Implement the history fallback**

Create a `useGoBack` hook that wraps the router's back method with a history length check:

- Accept a `fallbackPath` parameter — the route to navigate to when history is empty.
- Check `window.history.length > 2` (browsers handle this differently, but ≤2 typically means no previous app page).
- If history exists: call router's native back method.
- If no history: navigate to the fallback path.

The hook should return a `goBack()` function that components call without knowing the implementation details.

TypeScript example of the hook shape:

```typescript
interface UseGoBackOptions {
  fallbackPath: string;
}

interface UseGoBackReturn {
  goBack: () => void;
}
```

**Step 3: Configure state preservation**

Ensure backward navigation restores the previous page state:

| State Type               | Preservation Strategy                                       | Notes                                                           |
| ------------------------ | ----------------------------------------------------------- | --------------------------------------------------------------- |
| Scroll position          | `<ScrollRestoration />` (React Router) / built-in (Next.js) | React Router requires explicit component                        |
| API data                 | React Query (recommended) or SWR                            | Instant cache hit on back, background revalidation              |
| Form inputs (multi-step) | `sessionStorage`                                            | Simplest; use global state (Zustand) for complex flows          |
| Component local state    | N/A — lost on unmount                                       | Move to `sessionStorage` or global state if preservation needed |

Key rule: Don't rely solely on `useEffect` data fetching — it causes loading spinners on every back navigation. Use a caching layer to serve stale-while-revalidate data.

**Step 4: Add dirty-state guards**

If the page contains unsaved changes, intercept navigation:

- Use router-specific blockers (see framework references).
- Add `beforeunload` event listener for browser back button and tab close.
- Show a confirmation dialog: "You have unsaved changes. Are you sure you want to leave?"
- Only block when the form state is actually dirty (has changes).

Important: `beforeunload` only works for browser-level navigation (browser back button, closing tab). For in-app navigation (clicking a back button component), use router-level blockers.

**Step 5: Handle modals and overlays**

When a modal/drawer/lightbox is open, "go back" should close the overlay, not navigate away from the underlying page:

- Tie modal open state to URL query parameters (e.g., `?modal=settings`, `?preview=image-123`).
- When the user triggers "back", the query parameter is popped from the URL, closing the modal naturally.
- Only perform page-level back navigation if no modal query params are present.

Pattern: Push a query param when opening a modal (`navigate('?modal=settings')`). Browser back / `navigate(-1)` removes it automatically, closing the modal without leaving the page.

## Back Navigation Quality Checklist

```
Back Navigation:
- [ ] Router-native method used (not raw window.history.back())
- [ ] History fallback implemented for direct URL access
- [ ] Fallback path is a logical parent or default page
- [ ] Scroll position restored on back navigation
- [ ] API data cached — no loading spinner on back
- [ ] Multi-step form state preserved across navigation
- [ ] Dirty-state guard implemented for unsaved changes
- [ ] beforeunload listener added for browser back/tab close
- [ ] Confirmation dialog shown only when form is actually dirty
- [ ] Modals/overlays tied to URL query parameters
- [ ] "Back" closes modal before navigating away from page
- [ ] Declarative <Link> used for known destinations
- [ ] Imperative navigate(-1) used only for dynamic "return" flows
```

## Anti-Patterns

| Anti-Pattern                                             | Instead Do                                                      |
| -------------------------------------------------------- | --------------------------------------------------------------- |
| Using `window.history.back()` directly                   | Use router-native method (`navigate(-1)`, `router.back()`)      |
| No fallback for empty history                            | Check `window.history.length > 2`, navigate to fallback path    |
| Relying on `useEffect` data fetching for back navigation | Use caching library (React Query, SWR) for instant data on back |
| Storing "previous page" in component state               | Rely on browser history stack or pass via URL/route state       |
| Using `navigate(-1)` for static parent links             | Use declarative `<Link to="/parent">`                           |
| Ignoring dirty form state on navigation                  | Use `useBlocker` + `beforeunload` to warn about unsaved changes |
| Full-screen modal without URL query param                | Tie modal state to URL (`?modal=name`) so "back" closes it      |
| Hardcoding fallback path deep in components              | Accept `fallbackPath` as a hook parameter or config             |
| Using `navigate(-2)` or other numeric offsets            | Only use `navigate(-1)` — deeper offsets are unpredictable      |
| Blocking navigation when form is clean                   | Only activate blocker when `isDirty === true`                   |

## Framework-Specific Patterns

The patterns above are framework-agnostic. For framework-specific implementation guidance, load the appropriate reference:

- **React Router v6+**: See `./references/react-patterns.md` — `useNavigate()`, `useBlocker`, `<ScrollRestoration />`, hook binding for `useGoBack`.
- **Next.js App Router**: See `./references/nextjs-patterns.md` — `useRouter()`, `router.back()`, router adapter pattern, client/server component considerations.

## Connected Skills

- `tsh-implementing-frontend` — for component patterns that consume the navigation logic
- `tsh-implementing-forms` — for form dirty-state detection that integrates with navigation guards
- `tsh-writing-hooks` — for hook composition patterns applicable to the `useGoBack` hook
- `tsh-ensuring-accessibility` — for accessible back button implementation (focus management, screen reader announcements)
