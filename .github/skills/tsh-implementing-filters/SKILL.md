---
name: tsh-implementing-filters
description: "Type-safe URL filter synchronization with clean path and query string routing. Headless filter logic — schema definition, bracket notation serialization, URL sync hooks, and navigation strategy patterns. Use when implementing filterable lists, search pages, faceted navigation, or any UI that persists filter state in the URL."
---

# Implementing Filters

Provides patterns for type-safe URL filter synchronization — schema definition, bracket notation serialization/deserialization, router-bound hooks, and push/replace navigation strategies.

## Table of Contents

- [Principles](#principles)
- [Filter Implementation Process](#filter-implementation-process)
- [Serialization Quick Reference](#serialization-quick-reference)
- [API Contract](#api-contract)
  - [Query Parameter Structure](#query-parameter-structure)
  - [Filter Logic](#filter-logic)
  - [Example API Response Envelope](#example-api-response-envelope)
  - [Backend Considerations](#backend-considerations)
- [Filter Quality Checklist](#filter-quality-checklist)
- [Anti-Patterns](#anti-patterns)
- [Framework-Specific Patterns](#framework-specific-patterns)
- [Connected Skills](#connected-skills)

<principles>

<url-is-the-source-of-truth>
Filter state lives in the URL, not in component state. The URL is the single source of truth — components derive their state by parsing the URL. This enables shareable links, back/forward navigation, and SSR hydration without state mismatch. Never store canonical filter state in `useState` or a store and then sync it to the URL — read from the URL, write to the URL.
</url-is-the-source-of-truth>

<path-vs-query-golden-rule>
If removing a parameter changes what page or resource you are looking at, it belongs in the path. If removing it just narrows or broadens the same list, it belongs in a query string. Path = identity; query string = modifier. Category hierarchies go in the path (`/products/shoes/running`). Filters, sort, pagination, and search terms go in query strings (`?filter[color]=blue&sort[price]=ASC&page=2`).
</path-vs-query-golden-rule>

<type-safe-serialization>
Define a TypeScript schema for every filter set. Parse URL params through the schema on read (deserialize), and serialize through the schema on write. Bracket notation (`filter[field]=value`) is the standard serialization format — it aligns with the backend API contract. Never pass raw `string | null` from `searchParams` into application code — always validate and coerce to the schema type. Invalid or missing values fall back to schema defaults.
</type-safe-serialization>

<api-first-serialization>
The URL serialization format must match the API it talks to. Bracket notation (`filter[field]=value`) is the default for TSH-owned APIs. When consuming an external API that uses a different convention (flat keys like `color=blue`, JSON-encoded params, comma-separated values, or any other format), adapt the serialization layer to that API's expected format. The filter schema, hook shape, and navigation strategy remain the same — only the serialize/deserialize functions change.
</api-first-serialization>

</principles>

## Filter Implementation Process

Use the checklist below and track progress:

```
Progress:
- [ ] Step 1: Define the filter schema
- [ ] Step 2: Choose the URL structure
- [ ] Step 3: Implement serialization/deserialization
- [ ] Step 4: Create the filter sync hook
- [ ] Step 5: Wire up navigation strategy
```

**Step 1: Define the filter schema**

Define a TypeScript type or interface for each filter set. Every filter parameter must have an explicit type and a default value.

Supported filter parameter types:

| Type           | Example                              | Serialized                                                          |
| -------------- | ------------------------------------ | ------------------------------------------------------------------- |
| Single value   | `color: string`                      | `filter[color]=blue`                                                |
| Multi-select   | `tags: string[]`                     | `filter[tags]=a&filter[tags]=b` (repeated bracket key)              |
| Range          | `priceMin: number; priceMax: number` | `filter[price_min]=10&filter[price_max]=50` (separate bracket keys) |
| Boolean toggle | `inStock: boolean`                   | `filter[in_stock]=true`                                             |
| Numeric        | `page: number`                       | `page=2` (top-level, not bracketed)                                 |

Rules:

- Filters use bracket notation: `filter[field_name]=value`. Range filters use separate bracket keys: `filter[price_min]=10&filter[price_max]=50`.
- Use `snake_case` for bracket key names — readable in URLs.
- Use `camelCase` for TypeScript property names.
- Define defaults for every param — defaults are used when a param is absent from the URL.

Example schema shape:

```typescript
interface ProductFilters {
  color: string; // default: ""       → filter[color]=blue
  tags: string[]; // default: []       → filter[tags]=a&filter[tags]=b
  priceMin: number; // default: 0        → filter[price_min]=0
  priceMax: number; // default: 10000    → filter[price_max]=10000
  inStock: boolean; // default: false    → filter[in_stock]=true
  sort: string; // default: "relevance" → sort[relevance]=ASC
  page: number; // default: 1        → page=1
}
```

**Step 2: Choose the URL structure**

Apply the path-vs-query golden rule to classify each piece of your URL:

| Element                 | URL part     | Example                               | Rationale                                        |
| ----------------------- | ------------ | ------------------------------------- | ------------------------------------------------ |
| Resource category       | Path segment | `/products/shoes`                     | Removing "shoes" changes what you are looking at |
| Subcategory / hierarchy | Path segment | `/products/shoes/running`             | Still defines identity                           |
| Filter (color, size)    | Query string | `?filter[color]=blue&filter[size]=10` | Removing it shows the same page, broader list    |
| Sort order              | Query string | `?sort[price]=ASC`                    | Display modifier, not identity                   |
| Pagination              | Query string | `?page=2&limit=20`                    | Display modifier                                 |
| Search term             | Query string | `?search=lightweight`                 | Display modifier                                 |

**API alignment rule**: The URL serialization must match the API it communicates with. For TSH-owned APIs, this means bracket notation (`filter[field]=value`). For external APIs with different conventions, adapt the serialize/deserialize functions to match the external format. Common external patterns:

| External API Pattern   | Example                    | Adaptation                                                          |
| ---------------------- | -------------------------- | ------------------------------------------------------------------- |
| Flat keys              | `color=blue&price_min=10`  | Serialize filters as top-level params without `filter[...]` wrapper |
| Comma-separated values | `colors=blue,red,green`    | Join arrays with commas instead of repeated keys                    |
| JSON-encoded           | `filters={"color":"blue"}` | JSON-stringify the filter object into a single param                |
| Custom prefix          | `f_color=blue&f_size=10`   | Use the API's prefix convention in serialize/deserialize            |

The filter schema, hook shape (`{ filters, updateFilters, resetFilters }`), and navigation strategy (push/replace) are API-agnostic — only the serialization layer changes per API.

**Step 3: Implement serialization/deserialization**

Build two functions tied to the filter schema: one to serialize the typed filter object into `URLSearchParams`, and one to deserialize `URLSearchParams` back into the typed filter object.

**Serialize** (typed object → `URLSearchParams`):

- Iterate over schema keys.
- Skip params whose value matches the default — keeps the URL clean.
- Wrap filter params in bracket notation: `filter[field_name]=value`. Use `snake_case` inside brackets.
- Ranges use separate bracket keys: `filter[price_min]=10&filter[price_max]=50`.
- Arrays use repeated bracket keys: `filter[tags]=a&filter[tags]=b`.
- Sort params use `sort[field]=direction` format.
- Booleans serialize as `"true"` / `"false"`.

**Deserialize** (`URLSearchParams` → typed object):

Deserialization is a two-phase pipeline:

1. **Extract bracket keys** — parse `filter[...]` and `sort[...]` keys from `URLSearchParams`, producing a flat key-value object with `camelCase` property names. Handle repeated bracket keys (`getAll()`) for multi-value filters and separate range keys (`filter[price_min]`, `filter[price_max]`). This phase is URL-format-aware but type-unaware.
2. **Validate and coerce** — pass the flat object through the filter schema. Coerce types (`Number()` for numerics, `=== 'true'` for booleans), apply defaults for missing params, and reject out-of-range or malformed values by falling back to schema defaults. Never propagate garbage into application code.

> **Prefer schema validation**: Use a library like [Zod](https://zod.dev) or [Valibot](https://valibot.dev) for phase 2 — define a schema that mirrors the filter interface, with `.default()` for fallbacks and `.coerce` for type conversions. The schema validates domain types (`color: string`, `priceMin: number`) without knowing anything about URL serialization format. Fall back to manual `Number()` / `=== 'true'` only when adding a validation library is not feasible.

Key rules:

- Bracket notation for all filter params: `filter[field]=value`.
- Repeated bracket keys for multi-value filters: `filter[field]=a&filter[field]=b`.
- Omit default values from URL — cleaner URLs, same result.
- Never trust raw URL params — always parse through the schema.

**Step 4: Create the filter sync hook**

Create a custom hook (e.g., `useFilters`) that connects the filter schema to the router. The hook:

1. Reads current URL search params via the router.
2. Deserializes them into the typed filter state using the schema.
3. Provides an `updateFilters(partial)` function that merges partial updates with current filters, serializes the result, and navigates.
4. Provides a `resetFilters()` function that navigates to the URL with all defaults (effectively clearing query params).

The hook accepts configuration:

- The filter schema defaults object.
- The serialization/deserialization functions.

The hook returns:

- `filters` — the current typed filter state, derived from the URL.
- `updateFilters(partial, options?)` — merges partial filter updates and navigates.
- `resetFilters()` — clears all filters back to defaults.

Framework binding:

| Framework        | Read params         | Navigate                               |
| ---------------- | ------------------- | -------------------------------------- |
| React Router v6+ | `useSearchParams()` | `setSearchParams()` or `useNavigate()` |

The hook must:

- Handle partial updates — merge incoming changes with current filter state, not replace entirely. Use flat properties for ranges (e.g., `priceMin`, `priceMax`) so that partial updates merge correctly with shallow spread.
- Be type-safe end-to-end — input partial → serialization → URL → deserialization → output typed.
- Derive state from the URL on every render — never cache filter state in local `useState`.

**Step 5: Wire up navigation strategy**

Choose `push` or `replace` navigation based on the type of filter change:

| Action                  | Strategy                                 | Rationale                                            |
| ----------------------- | ---------------------------------------- | ---------------------------------------------------- |
| Category toggle (major) | `push`                                   | User can press Back to undo                          |
| Sort change             | `push`                                   | Intentional user action, should be undoable          |
| Search-as-you-type      | `replace`                                | Don't flood history with every keystroke             |
| Pagination              | `push`                                   | User expects Back to go to previous page             |
| Filter toggle (facet)   | `push`                                   | User expects Back to undo filter                     |
| Debounced range slider  | `replace` during drag, `push` on release | Balance between history cleanliness and undo-ability |

The `updateFilters` function should accept an optional `{ replace?: boolean }` option. Default to `push`. Callers override to `replace` for as-you-type or continuous inputs.

```typescript
// Push (default) — for discrete filter actions
updateFilters({ color: "blue" });

// Replace — for as-you-type search input
updateFilters({ search: searchTerm }, { replace: true });
```

For debounced inputs (range sliders, search fields), use `replace` during rapid changes and `push` on the final committed value.

## Serialization Quick Reference

| TypeScript type                  | Serialized format                     | Deserialize with                |
| -------------------------------- | ------------------------------------- | ------------------------------- |
| `string`                         | `filter[key]=value`                   | Parse bracket key, `get()`      |
| `number`                         | `filter[key]=123`                     | Parse bracket key, `Number()`   |
| `boolean`                        | `filter[key]=true`                    | Parse bracket key, `=== 'true'` |
| `string[]`                       | `filter[key]=a&filter[key]=b`         | Parse bracket key, `getAll()`   |
| `keyMin: number; keyMax: number` | `filter[key_min]=1&filter[key_max]=9` | `Number()` for each key         |
| sort                             | `sort[field]=ASC`                     | Parse bracket key               |
| search                           | `search=text`                         | `get('search')`                 |
| pagination                       | `page=1&limit=20`                     | `get('page')`, `get('limit')`   |

## API Contract

The conventions below describe the **default TSH backend API contract**. When the API provider follows a different pattern (external APIs, third-party services, legacy backends), adapt the serialization layer to match that API's expected format — the filter schema and hook architecture remain unchanged.

### Query Parameter Structure

| Concern                   | Format                  | Example                                          |
| ------------------------- | ----------------------- | ------------------------------------------------ |
| Filters                   | `filter[field]=value`   | `filter[first_name]=Ewa`                         |
| Multi-value filter (OR)   | Repeated bracket key    | `filter[first_name]=Ewa&filter[first_name]=Adam` |
| Range filter              | Separate bracket keys   | `filter[price_min]=10&filter[price_max]=50`      |
| Partial-text match filter | Partial match value     | `filter[first_name]=Nowak`                       |
| Pagination                | Top-level keys          | `page=1&limit=100`                               |
| Sort                      | `sort[field]=direction` | `sort[last_name]=ASC`                            |
| Full-text search          | Top-level key           | `search=test`                                    |

### Filter Logic

- **Same field, multiple values → OR**: `filter[first_name]=Ewa&filter[first_name]=Adam` — same field with multiple values implies OR — the response includes items matching any of the values.
- **Different fields → AND**: `filter[first_name]=Ewa&filter[last_name]=Kowalska` — different fields imply AND — the response includes only items matching all field conditions.
- **Partial-text match filter**: `filter[first_name]=Nowak` — backend determines the matching strategy (e.g., prefix, contains, fuzzy).

### Example API Response Envelope

APIs vary — the following is one common envelope structure. Adapt to match your project's actual API response format:

```typescript
interface ApiResponse<T> {
  meta: {
    pagination: {
      page: number;
      total: number;
      limit: number;
      totalPages: number;
    };
    filter: Record<string, string | string[]>;
    sort: Record<string, "ASC" | "DESC">;
    search: string;
  };
  data: T[];
}
```

The `meta` object echoes back the applied filters, sort, search, and pagination — use it to verify that the URL state matches what the backend applied.

If your API echoes applied filters in the response meta, verify that it matches the deserialized URL state to ensure frontend-backend sync.

### Backend Considerations

- **Pagination resets**: When filters change, reset the page parameter to 1 to avoid requesting pages beyond the new result set.
- **Filter echoing**: If the API returns applied filters in the response (e.g., in a `meta` object), compare them against the URL state to detect sync issues.

## Filter Quality Checklist

```
Filter:
- [ ] Filter schema defined with TypeScript types and defaults
- [ ] URL structure follows path-vs-query golden rule
- [ ] Filters use bracket notation (filter[field]=value)
- [ ] Sort uses bracket notation (sort[field]=ASC|DESC)
- [ ] Serialization omits default values from URL
- [ ] Deserialization validates and coerces types
- [ ] Range filters use separate bracket keys (filter[price_min]=10&filter[price_max]=50)
- [ ] Multi-value filters use repeated bracket keys (OR logic)
- [ ] If external API, serialization adapted to match API's expected format
- [ ] Cross-field filters combine as AND
- [ ] Text search values contain only the raw search term — no backend-specific operators or wildcards
- [ ] Hook returns typed filter state, updateFilters, resetFilters
- [ ] Push/Replace strategy documented for each filter action
- [ ] Search-as-you-type inputs use Replace navigation
- [ ] No raw string params leak into application code
- [ ] Back/Forward navigation correctly restores filter state
- [ ] Shareable URL reproduces the exact filter state
- [ ] API response meta echoed back matches URL state
```

## Anti-Patterns

| Anti-Pattern                                                       | Instead Do                                                                                                            |
| ------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------- |
| Storing filter state in `useState` and syncing to URL              | Derive filter state FROM the URL — URL is the source of truth                                                         |
| Using flat keys for filters (`color=blue&price_min=10`)            | Use bracket notation (`filter[color]=blue&filter[price_min]=10`)                                                      |
| Hardcoding filter params as magic strings                          | Define a filter schema type and derive param names from it                                                            |
| Using `push` for search-as-you-type                                | Use `replace` to avoid flooding browser history                                                                       |
| Putting optional filters in path segments (`/products/color/blue`) | Put filters in query strings — path is for resource identity only                                                     |
| Serializing default values in URL (`?page=1&sort[relevance]=ASC`)  | Omit defaults — cleaner URLs, same behavior                                                                           |
| Parsing URL params without type coercion                           | Validate with a schema library (Zod, Valibot) or manually coerce: `Number()`, `=== 'true'`, with fallback to defaults |
| Building one monolithic filter hook for all pages                  | Create filter schemas per-page/per-feature, share the serialization utility                                           |
| Treating multi-value filter as AND                                 | Same-field repeated values are OR; different fields are AND                                                           |
| Ignoring API response `meta` object                                | Verify URL filter state matches what the backend echoed in `meta`                                                     |
| Using bracket notation when the external API expects flat keys     | Adapt serialization to match the API contract — bracket notation is the TSH default, not a universal rule             |

## Framework-Specific Patterns

The patterns above are framework-agnostic. For framework-specific implementation guidance, load the appropriate reference:

- **React Router v6+**: See `./references/react-patterns.md` — `useSearchParams`, `setSearchParams()` with functional updater, `useNavigate()` integration, hook binding.
- **Next.js App Router**: See `./references/nextjs-patterns.md` — `useSearchParams`, `usePathname`, `router.push()`/`router.replace()` integration, server component considerations.

## Connected Skills

- `tsh-implementing-frontend` — for component patterns that consume the headless filter logic
- `tsh-implementing-forms` — for form-based filter UIs that wire into the filter hook
- `tsh-writing-hooks` — for hook composition patterns and return shape conventions applicable to filter hooks
- `tsh-optimizing-frontend` — for rendering optimization for filter-heavy pages
- `tsh-ensuring-accessibility` — for accessible filter controls (keyboard navigation, ARIA attributes for active filters)
- `tsh-sql-and-database-understanding` — for backend query optimization behind the API contract
