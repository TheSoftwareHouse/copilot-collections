---
sidebar_position: 6
title: /review
---

# /review

**Agent:** Code Reviewer  
**File:** `.github/prompts/review.prompt.md`

Performs a structured code review against the implementation plan and feature context.

## Usage

```text
/review <JIRA_ID or task description>
```

## What It Does

1. **Understands context** — Loads `.research.md` and `.plan.md` files, reviews `*.instructions.md` for project guidelines.
2. **Reviews implementation** — Focuses on correctness, code quality, security, testing, and documentation.
3. **Verifies definition of done** — Checks each item from the plan's task definitions; marks completed items.
4. **Verifies acceptance criteria** — Checks each item from the plan's acceptance criteria checklist.
5. **Summarizes findings** — Provides a summary with issues and recommendations.
6. **Documents results** — Adds a "Code Review Findings" section to the plan file.
7. **Updates changelog** — Records that code review was performed.

## Skills Loaded

- `code-review` — Structured review covering correctness, quality, security, testing, best practices, scalability.
- `implementation-gap-analysis` — Compare implementation against the plan for completeness.
- `technical-context-discovery` — Understand project conventions and coding standards.
- `sql-and-database` — When reviewing database-related changes.

## Output

- Updated plan file with checked definition-of-done and acceptance criteria items.
- "Code Review Findings" section added to the plan file.
- Changelog entry indicating code review was performed.

## Review Categories

| Category | What It Covers |
|---|---|
| **Correctness** | Code functions as intended, meets requirements |
| **Code Quality** | Clean, efficient, maintainable, follows standards |
| **Security** | No vulnerabilities, proper security measures |
| **Testing** | Appropriate tests covering necessary scenarios |
| **Documentation** | Well-documented code with comments |
| **Acceptance Criteria** | Each item verified individually |
