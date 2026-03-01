---
agent: "tsh-architect"
model: "Claude Opus 4.6"
description: "Perform a comprehensive code quality analysis: dead code, duplications, and improvement opportunities."
---

Your goal is to perform a thorough code quality analysis of the repository. The analysis should cover dead code detection, code duplication identification, and improvement proposals. The results must be saved to a markdown report file.

## Required Skills

Before starting, load and follow these skills:
- `codebase-analysing` - for the structured codebase analysis process only (note: this prompt's "Report Structure" section overrides any report/template instructions from the skill)
- `technical-context-discovering` - to understand project conventions, architecture patterns, and established practices
- `code-reviewing` - for code quality standards, best practices verification, and security considerations

## Workflow

### Phase 1: Context Discovery

1. Load and follow the `technical-context-discovering` skill to understand project conventions, coding standards, and existing patterns.
2. Identify the repository type (monorepo vs single system). If it is a monorepo, identify all apps, packages, and shared libraries. Each layer/app must be analyzed and reported separately.
3. Identify the tech stack, frameworks, and key dependencies for each layer/app.

### Phase 2: Codebase Analysis (use subagents)

Run `tsh-architect` subagents in parallel — one per layer/app identified. Each subagent should receive detailed instructions including:
- The specific layer/app path and tech stack to analyze
- What to search for (dead code, duplications, improvement areas)
- The skills to load (`codebase-analysing`, `code-reviewing`)
- To return structured findings in the format matching the report template

For each layer/app, the subagent should:

#### 2a. Dead Code Detection
- Search for unused imports across all source files.
- Search for unused exported functions, classes, types, interfaces, and constants that are never imported elsewhere.
- Search for unused components (frontend) that are not referenced in any route, page, or other component.
- Search for unreachable code paths (e.g., after return/throw statements, impossible conditions).
- Search for unused configuration files, environment variables, or feature flags.
- Search for deprecated code marked with `@deprecated` or similar annotations that is no longer referenced.
- Search for files that are not imported or required anywhere.
- Search for dead routes or endpoints that are defined but not reachable.
- Cross-reference test files: find code that is only imported in its own test file and nowhere else in production code.

#### 2b. Duplication Detection
- Search for duplicated functions or methods with identical or near-identical logic across different files.
- Search for duplicated UI components that render similar structures with minor variations.
- Search for duplicated API call patterns, data fetching logic, or error handling patterns.
- Search for duplicated validation logic, utility functions, or helper methods.
- Search for duplicated type definitions, interfaces, or schemas.
- Search for duplicated configuration or constant definitions across modules.
- Search for copy-pasted code blocks that differ only in variable names or string literals.
- Identify components/functions that are highly similar and can be merged into a single configurable version.

#### 2c. Improvement Opportunities
- Identify overly complex functions (high cyclomatic complexity, deeply nested logic).
- Identify functions or classes with too many responsibilities (SRP violations).
- Identify missing or inconsistent error handling patterns.
- Identify inconsistent naming conventions or coding styles.
- Identify missing TypeScript types or excessive use of `any`.
- Identify opportunities to extract shared logic into reusable utilities or hooks.
- Identify outdated patterns that could be modernized (e.g., callbacks to async/await, class components to functional).
- Identify missing or insufficient test coverage for critical paths.
- Identify potential performance issues (unnecessary re-renders, N+1 queries, missing indexes).
- Identify security concerns (exposed secrets, missing input validation, SQL injection risks).

### Phase 3: Architecture Review

Use the `tsh-architect` perspective to evaluate:
- Whether the current module/package boundaries are well-defined.
- Whether shared code is properly extracted and reusable.
- Whether the dependency graph between modules is clean (no circular dependencies).
- Whether the separation of concerns is properly maintained.
- Whether the current patterns are scalable and maintainable.

### Phase 4: Report Generation

1. Compile all findings from Phase 2 and Phase 3.
2. For monorepos, organize findings by layer/app with clear section headers.
3. Prioritize all findings into severity levels:
   - 🔴 **Critical** — Must be fixed; causes bugs, security issues, or significant maintenance burden
   - 🟡 **Important** — Should be fixed; improves quality, readability, or maintainability
   - 🟢 **Nice to Have** — Optional improvements; polish and optimization
4. Save the report as `code-quality-report.md` in the repository root.

## Report Structure

The report must follow this structure:

```markdown
# Code Quality Report - <repository-name>

## Overview

| Field | Value |
|---|---|
| Repository | <name> |
| Repository Type | Monorepo / Single System |
| Date | <date> |
| Layers/Apps Analyzed | <list> |

## Executive Summary

<2-3 paragraph summary of overall code health, major findings, and recommended priorities>

---

## Findings by Layer/App

### <Layer/App Name> (`<path>`)

#### Dead Code

| # | Severity | Type | Location | Description |
|---|---|---|---|---|
| 1 | 🔴/🟡/🟢 | <type> | `<file:line>` | <description> |

#### Duplications

| # | Severity | Type | Locations | Description | Recommendation |
|---|---|---|---|---|---|
| 1 | 🔴/🟡/🟢 | <type> | `<path1>`, `<path2>` | <description> | <action> |

#### Improvement Opportunities

| # | Severity | Category | Location | Description | Recommendation |
|---|---|---|---|---|---|
| 1 | 🔴/🟡/🟢 | <category> | `<file:line>` | <description> | <action> |

<!-- Repeat for each Layer/App -->

---

## Architecture Observations

<architectural-findings-and-recommendations>

## Summary

| Category | 🔴 Critical | 🟡 Important | 🟢 Nice to Have | Total |
|---|---|---|---|---|
| Dead Code | <count> | <count> | <count> | <count> |
| Duplications | <count> | <count> | <count> | <count> |
| Improvements | <count> | <count> | <count> | <count> |
| **Total** | <count> | <count> | <count> | <count> |

## Recommended Action Plan

### Immediate (Critical)
1. <action-item>

### Short-term (Important)
1. <action-item>

### Long-term (Nice to Have)
1. <action-item>
```

## Guidelines

- Be specific: always include file paths and line numbers when referencing findings.
- Be actionable: every finding must include a clear recommendation for how to fix it.
- Avoid false positives: verify that "unused" code is truly unused by checking all import paths, dynamic imports, and re-exports.
- For monorepos, clearly separate findings per layer/app — do not mix them.
- Use subagents efficiently: delegate file-level scanning work to subagents and focus on architectural assessment yourself.
- The final report must be self-contained and understandable without additional context.
