---
sidebar_position: 29
title: Implementing Filters
---

# Implementing Filters

**Folder:** `.github/skills/tsh-implementing-filters/`  
**Used by:** Software Engineer

Type-safe URL filter synchronization with clean path and query string routing. Headless filter logic — schema definition, bracket notation serialization, URL sync hooks, and navigation strategy patterns.

## Key Areas

| Area                    | Coverage                                                                                 |
| ----------------------- | ---------------------------------------------------------------------------------------- |
| **Filter Schema**       | TypeScript types, defaults, supported param types (single, multi-select, range, boolean) |
| **URL Structure**       | Path-vs-query golden rule, bracket notation (`filter[field]=value`)                      |
| **Serialization**       | Serialize/deserialize functions, bracket notation, snake_case keys, default omission     |
| **Filter Sync Hook**    | `useFilters` hook — typed state from URL, `updateFilters`, `resetFilters`                |
| **Navigation Strategy** | Push vs replace per action type, debounced inputs, search-as-you-type                    |
| **API Contract**        | TSH bracket notation default, external API adaptation, response envelope                 |

## When to Use

- Implementing filterable lists, search pages, or faceted navigation
- Persisting filter state in the URL for shareable links and back/forward navigation
- Building filter sync hooks that derive state from URL search params
- Adapting serialization for external APIs with non-bracket conventions

## Connected Skills

- `tsh-implementing-frontend` — component patterns that consume headless filter logic
- `tsh-implementing-forms` — form-based filter UIs
- `tsh-writing-hooks` — hook composition patterns for the filter sync hook
