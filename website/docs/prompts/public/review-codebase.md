---
sidebar_position: 9
title: /tsh-review-codebase
---

# /tsh-review-codebase

**Agent:** Architect  
**File:** `.github/prompts/tsh-review-codebase.prompt.md`

Performs a comprehensive code quality analysis covering dead code, duplications, and improvement opportunities.

## Usage

```text
/tsh-review-codebase
```

## What It Does

### Phase 1: Context Discovery

- Loads project conventions from `tsh-technical-context-discovering` skill.
- Identifies repository type (monorepo vs single system).
- Identifies tech stack, frameworks, and dependencies per layer/app.

### Phase 2: Codebase Analysis

Runs parallel subagents per layer/app to detect:

**Dead Code:**
- Unused imports, exports, components, routes, and endpoints.
- Unreachable code paths.
- Deprecated code no longer referenced.
- Files not imported anywhere.
- Code only imported in its own test file.

**Duplications:**
- Duplicated functions, UI components, API patterns.
- Duplicated validation logic, utilities, type definitions.
- Copy-pasted code blocks differing only in variable names.

**Improvement Opportunities:**
- High cyclomatic complexity, deeply nested logic.
- Single Responsibility Principle violations.
- Missing or inconsistent error handling.
- Excessive use of `any` in TypeScript.
- Outdated patterns that could be modernized.
- Performance issues and security concerns.

### Phase 3: Architecture Review

- Module/package boundary evaluation.
- Shared code extraction assessment.
- Dependency graph analysis (circular dependencies).
- Separation of concerns verification.

### Phase 4: Report Generation

All findings are prioritized:
- 🔴 **Critical** — Must be fixed (bugs, security issues, maintenance burden).
- 🟡 **Important** — Should be fixed (quality, readability, maintainability).
- 🟢 **Nice to Have** — Optional (polish, optimization).

## Skills Loaded

- `tsh-codebase-analysing` — Structured analysis process.
- `tsh-technical-context-discovering` — Project conventions and architecture patterns.
- `tsh-code-reviewing` — Code quality standards and security considerations.

## Output

A `code-quality-report.md` file saved to the repository root, containing:

- Executive summary of overall code health.
- Findings organized by layer/app.
- Dead code, duplications, and improvement tables with file paths and line numbers.
- Architecture observations.
- Summary counts by severity.
- Recommended action plan (immediate, short-term, long-term).
