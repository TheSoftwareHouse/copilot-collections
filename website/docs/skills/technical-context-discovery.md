---
sidebar_position: 10
title: Technical Context Discovery
---

# Technical Context Discovery

**Folder:** `.github/skills/technical-context-discovery/`  
**Used by:** Architect, Code Reviewer, Software Engineer, E2E Engineer

Provides a systematic process for understanding project context before any code changes. Enforces a strict priority hierarchy to ensure consistency.

## Priority Hierarchy

```
1. Project instructions (*.instructions.md)     ← HIGHEST
2. Existing codebase patterns
3. External documentation (context7, OWASP, etc.)
4. General best practices                        ← LOWEST
```

:::warning Critical Rule
Never introduce new patterns unless explicitly requested by the user. Always replicate existing conventions.
:::

## Process

### Step 1: Discover Copilot Instructions

Search for instruction files:

- `.github/copilot-instructions.md` — Global project instructions.
- `*.instructions.md` — Feature or module-specific instructions.
- `.copilot/` — Additional configuration directory.

### Step 2: Analyse Codebase Patterns

Identify established patterns for:

| Area | What to Look For |
|---|---|
| **Architecture** | Folder structure, module boundaries, layering |
| **Code Style** | Naming conventions, formatting, imports |
| **Error Handling** | Error types, try/catch patterns, error responses |
| **Validation** | Input validation, schema validation, sanitization |
| **Testing** | Test framework, patterns, naming, coverage |
| **Database** | ORM usage, migration patterns, query styles |
| **API** | Endpoint structure, middleware, response format |
| **Configuration** | Environment variables, config files |

### Step 3: Consult External Documentation

Use Context7 tool for framework-specific documentation. Reference OWASP, SOLID, and industry standards.

### Step 4: Apply Decision Hierarchy

| Situation | Source of Truth |
|---|---|
| Instructions exist for this case | Follow instructions |
| No instructions, but pattern exists | Replicate the pattern |
| No instructions or patterns | Follow skill best practices |
| Conflict between sources | Instructions > Patterns > Best practices |

## Connected Skills

- `architecture-design` — Design solutions following discovered conventions.
- `codebase-analysis` — Deep analysis of existing patterns.
- `sql-and-database` — Database-specific context discovery.
