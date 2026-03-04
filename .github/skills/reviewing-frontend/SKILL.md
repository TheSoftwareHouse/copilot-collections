---
name: reviewing-frontend
description: "Frontend-specific code review criteria, component anti-patterns, hooks quality, rendering correctness, accessibility and performance spot-checks, and module organization issues. Use when reviewing frontend pull requests, auditing component quality, or identifying UI-specific code smells beyond general code review."
---

# Reviewing Frontend

Provides frontend-specific review criteria for evaluating component quality, hooks correctness, rendering behavior, accessibility compliance, and performance — to be used alongside the general `code-reviewing` skill.

<principles>

<frontend-lens>
This skill supplements, not replaces, general code review. Apply these checks after (or alongside) the general review process. Focus on issues that are unique to frontend — rendering correctness, visual regression risk, accessibility compliance, and client-side performance.
</frontend-lens>

<severity-over-style>
A missed keyboard trap in a modal matters more than a slightly non-standard prop name. Prioritize correctness and accessibility issues over style preferences. Use findings severity: critical (must fix), warning (should fix), suggestion (consider).
</severity-over-style>

</principles>

## Frontend Review Process

Use the checklist below and track your progress:

```
Review progress:
- [ ] Step 1: Review component structure
- [ ] Step 2: Review hooks quality
- [ ] Step 3: Review rendering correctness
- [ ] Step 4: Spot-check accessibility
- [ ] Step 5: Spot-check performance
- [ ] Step 6: Produce findings report
```

**Step 1: Review component structure**

Check each component for:

- **Single responsibility**: Does the component do one thing clearly? A component handling data fetching, transformation, AND presentation is doing too much. Signs of violation: file exceeds 300 lines, component name uses "And" or "With" (e.g., `FetchAndDisplayUsers`), multiple unrelated state variables.
- **Props design**: Are props well-typed, minimal, with sensible defaults? Is there prop sprawl (>7 props)? If so, the component likely needs decomposition or a compound component pattern. Check for boolean prop armies (`isLoading`, `isDisabled`, `isExpanded`, `isSelected`) — consider a `status` enum instead.
- **Composition**: Are children/slots used where appropriate, or is the component inflexible? Look for components that accept large config objects instead of composing smaller pieces. A component rendering hardcoded layout that consumers can't customize needs a composition redesign.
- **State location**: Is state as close as possible to where it's consumed? Is there unnecessary lifting? State shared by only one child should live in that child. State consumed by distant siblings may belong in a shared context or store — not drilled through intermediate components.
- **Error handling**: Does the component handle loading, error, and empty states? Every data-dependent component needs all three. A component that renders nothing during loading or shows a blank screen on error is incomplete.
- **Naming**: Does the component name describe what it renders? `UserProfileCard` is clear; `DataDisplay` is not. Avoid generic names like `Wrapper`, `Container`, `Handler` unless the component's sole purpose is layout containment.
- **Export**: Named export? No default exports. Default exports create inconsistent import names across consumers and make automated refactoring harder.

Signs a component needs splitting:

| Signal | Threshold |
|---|---|
| File length | > 300 lines |
| Props count | > 7 props |
| State variables | > 5 state declarations |
| Effects | > 3 side effect hooks/watchers |
| Nested conditions | > 2 levels of ternary/conditional rendering |
| Mixed concerns | Fetching + transforming + rendering in one component |

**Step 2: Review hooks quality**

For every custom hook in the changeset:

- **Naming**: Does the name start with `use` and describe behavior? `useDebounce` is good; `useHelper` is vague. The name should answer "what does calling this hook give me?" without reading the implementation.
- **Single responsibility**: Does the hook do one thing, or is it overloaded with 5+ config options? Overloaded hooks should be decomposed into smaller hooks that compose together. A hook that manages form state AND validation AND submission AND error display is doing too much.
- **Dependency tracking**: Are all reactive values included? Any lint suppressions for dependency tracking? Each suppression is a potential stale closure bug — flag as warning. The fix is usually to restructure the effect, not to suppress the lint.
- **Effect cleanup**: Do all effects clean up timers, listeners, subscriptions, and abort controllers? Missing cleanup is an automatic critical finding — it causes memory leaks. Check for:
  - `setTimeout` / `setInterval` without `clearTimeout` / `clearInterval` in cleanup
  - `addEventListener` without `removeEventListener`
  - `AbortController` not aborted on unmount
  - WebSocket / EventSource connections not closed
- **Return shape**: Does the hook return an object with stable references? Are callbacks wrapped to maintain referential stability? Tuple returns are acceptable for simple 2-value hooks (`useToggle` → `[value, toggle]`) but objects are preferred for 3+ values to avoid positional confusion.
- **Side effects in render phase**: Any fetch, write, or mutation outside the framework's effect/lifecycle mechanism? This is an automatic critical — it causes unpredictable behavior and potential infinite loops. Writing to `localStorage`, calling `fetch`, or dispatching events during render are all violations.

**Step 3: Review rendering correctness**

Check for:

- **Key usage**: Stable, unique keys in lists — not array indices unless the list is static and never reordered. Index keys on dynamic lists cause rendering bugs and state mix-ups. Prefer entity IDs. If no natural key exists, generate a stable ID at data creation time — not at render time.
- **Memoization correctness**: Is memoization/caching applied where benefit exists (expensive computations, props passed to memoized children)? Is it over-applied on trivial computations where it adds complexity without benefit? Memoizing a string concatenation or a simple boolean adds overhead without gain.
- **Object stability**: Are inline object or array literals passed as props to memoized children? Each render creates a new reference, defeating memoization and causing unnecessary re-renders. Common violations:
  - `style={{ margin: 8 }}` — lift to a constant or use a styling solution
  - `options={[{ value: 'a' }, { value: 'b' }]}` — lift to module scope or memoize
  - `onChange={(e) => setValue(e.target.value)}` — stabilize the reference if child is memoized
- **Conditional rendering**: Are conditional renders clean? No nested ternaries beyond 2 levels. Deep nesting should be extracted into sub-components or early returns. Prefer early return pattern for guard clauses:
  ```
  if (isLoading) return <Spinner />;
  if (error) return <ErrorMessage error={error} />;
  if (!data.length) return <EmptyState />;
  return <DataList data={data} />;
  ```
- **Ref misuse**: Are mutable refs used to hold state that should trigger re-renders? Is reactive state used for values that should NOT trigger re-renders (e.g., timer IDs, previous values for comparison)? Each is the wrong tool for the job.
- **Derived state**: Is there state that could be computed from existing state or props? Storing derived values in reactive state creates synchronization bugs. Compute inline or cache with the framework's memoization primitive.

**Step 4: Spot-check accessibility**

Quick checks — not a full audit. Defer to `ensuring-accessibility` for comprehensive coverage.

- **Interactive elements**: `<button>` for actions, `<a>` for navigation links? Or `<div onClick>` / `<span onClick>` anti-pattern? Non-semantic interactive elements break keyboard and screen reader access — automatic critical. The `<div>` with an `onClick` has no keyboard support, no role, no focus indicator by default.
- **Labels**: Do form fields have visible `<label>` elements associated via `htmlFor`/`id`? Placeholder text as the only label is a warning — the label disappears on input. `aria-label` is acceptable for icon-only buttons but not as a substitute for visible labels on text inputs.
- **Headings**: Logical hierarchy maintained? Heading levels skipped (e.g., `<h1>` to `<h3>` with no `<h2>`)? Skipped levels break document outline for assistive technology. Each page should have exactly one `<h1>`.
- **Keyboard access**: Can custom interactive widgets (dropdowns, modals, tabs) be reached and activated via keyboard? Tab order logical? Look for `tabIndex` values greater than 0 — they disrupt natural tab order and should almost never be used.
- **Focus management**: Is focus moved to the modal/dialog on open? Is focus returned to the trigger on close? Missing focus management traps keyboard users. Check that focus is not moved to non-interactive elements without `tabIndex="-1"`.
- **Color-only indicators**: Any state relying on color alone (red border for error, green for success)? Must include a secondary indicator (icon, text, pattern). Check error messages — do they exist as text, or are they conveyed only by a red outline?
- **ARIA usage**: Are ARIA attributes used correctly? `aria-hidden="true"` on interactive elements removes them from the accessibility tree. `role="button"` on a `<div>` requires `tabIndex="0"` and `onKeyDown` handler — prefer `<button>` instead.

**Step 5: Spot-check performance**

Quick checks — not a full audit. Defer to `optimizing-frontend` for deep analysis.

- **Bundle impact**: Will new imports significantly increase bundle size? Flag heavy library additions (charting, date, rich text) that could be lazy-loaded or replaced with lighter alternatives. Check for full-library imports (`import _ from 'lodash'`) where named imports (`import { debounce } from 'lodash/debounce'`) would suffice.
- **Lazy loading**: Are new routes and heavy components lazy-loaded? Top-level route components should use dynamic imports. Components only visible after user interaction (modals, drawers, tabs beyond the first) are lazy-loading candidates.
- **Barrel imports**: Does a new or modified barrel file (`index.ts`) pull unused exports into the bundle? Wildcard re-exports (`export *`) break tree shaking. Named re-exports (`export { Button } from './Button'`) are the safe pattern.
- **Rendering**: Obvious unnecessary re-renders? Missing memo on frequently-rendered list items whose parent re-renders often? Check for context providers with unstable value props — a provider passing `value={{ user, setUser }}` creates a new object every render, re-rendering all consumers.
- **Large lists**: Are lists of 100+ items virtualized? Rendering hundreds of DOM nodes degrades scroll performance. Flag unvirtualized large lists as a warning.

**Step 6: Produce findings report**

Group findings by severity. Each finding must include: file + line range, issue description, and recommended fix.

**Critical** — Must fix before merge:
- Accessibility blockers (keyboard traps, missing labels on critical flows, non-semantic interactive elements)
- Rendering bugs (missing/index keys on dynamic lists, side effects in render phase)
- Memory leaks (effects without cleanup)
- Security issues (XSS vectors, unsafe raw HTML insertion without sanitization)

**Warning** — Should fix, may defer with justification:
- Props design issues (sprawl, missing types, unclear naming)
- Missing error, loading, or empty states
- Hook quality concerns (suppressed lint rules, overloaded hooks, unstable return shapes)
- Placeholder-as-only-label, skipped heading levels
- Derived state stored in reactive state instead of computed

**Suggestion** — Consider for improvement:
- Style improvements (conditional rendering cleanup, naming tweaks)
- Composition opportunities (extract sub-component, use children pattern)
- Minor optimizations (memoize prop objects, add memo to list items)
- Default export usage (convert to named export)

Format each finding consistently:

```
[SEVERITY] file/path.tsx#L10-L25
Issue: <description>
Fix: <recommended action>
```

Example findings:

```
[CRITICAL] components/Modal.tsx#L45-L52
Issue: <div onClick={onClose}> used as close button — no keyboard access, no role, no focus indicator.
Fix: Replace with <button onClick={onClose} aria-label="Close modal">.

[WARNING] hooks/useUserData.ts#L18
Issue: Dependency tracking lint rule suppressed — potential stale closure.
Fix: Restructure effect to include all dependencies, or extract a stable callback.

[SUGGESTION] components/OrderList.tsx#L33
Issue: Inline style object `style={{ padding: 16 }}` passed to memoized child — defeats memo.
Fix: Lift to module-level constant or use styling solution.
```

## Frontend Review Checklist

```
Frontend Review:
- [ ] Components follow single responsibility
- [ ] Props are typed, minimal, with defaults
- [ ] Named exports (no default exports)
- [ ] Loading, error, and empty states handled
- [ ] Custom hooks/composables: proper naming, SRP, complete deps, cleanup
- [ ] Keys are stable and unique (not array indices)
- [ ] No inline object/array props without memoization
- [ ] No derived state in reactive state (compute instead)
- [ ] Interactive elements use semantic HTML
- [ ] Form fields have visible labels
- [ ] Focus managed on modal/dialog open/close
- [ ] No color-only state indicators
- [ ] ARIA attributes used correctly
- [ ] New routes/heavy components lazy-loaded
- [ ] No wildcard imports or bloated barrel files
- [ ] Conditional rendering is readable (no deep ternary nesting)
- [ ] Large lists (100+) virtualized
```

## Common Frontend Anti-Patterns

| Anti-Pattern | Severity | Why |
|---|---|---|
| `<div onClick>` instead of `<button>` | Critical | Breaks keyboard + screen reader access |
| Missing key or index-as-key on dynamic list | Critical | Causes rendering bugs, state mix-ups |
| Effect/watcher without cleanup (timers/listeners) | Critical | Memory leak |
| Side effect in render phase | Critical | Unpredictable behavior, infinite loops |
| Raw HTML insertion without sanitization | Critical | XSS vulnerability |
| Placeholder used as only label | Warning | Accessibility: label disappears on input |
| 300+ line component | Warning | Hard to maintain, likely violates SRP |
| Hook with suppressed dependency tracking | Warning | Hidden stale closure bug |
| Missing loading/error state | Warning | Broken UX for slow/failed requests |
| Derived state in reactive state | Warning | Synchronization bugs, stale data |
| Context/provider with unstable value | Warning | All consumers re-render every time |
| Inline object as prop to memo child | Suggestion | Causes unnecessary re-render |
| Deeply nested ternary (3+ levels) | Suggestion | Hard to read, extract component instead |
| Default export | Suggestion | Inconsistent imports, harder refactoring |
| Full-library import | Suggestion | Bundle bloat from unused code |

## Framework-Specific Patterns

The review criteria above are framework-agnostic. For framework-specific anti-patterns and API checks, load the appropriate reference:

- **React**: See `./references/react-patterns.md` — React-specific hooks review, `dangerouslySetInnerHTML`, `exhaustive-deps`, memoization API checks.

## Connected Skills

- `code-reviewing` — the general review process; this skill provides the frontend-specific checks
- `implementing-frontend` — the patterns being reviewed against
- `implementing-forms` — for form-specific patterns (validation schemas, field composition, multi-step flows) being reviewed against
- `ensuring-accessibility` — for comprehensive accessibility audits beyond spot-checks
- `optimizing-frontend` — for deep performance analysis beyond spot-checks
- `writing-hooks` — for detailed hook quality patterns being reviewed against
