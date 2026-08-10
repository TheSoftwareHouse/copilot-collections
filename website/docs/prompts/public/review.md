---
sidebar_position: 6
title: /tsh-review
---

# /tsh-review

**Agent:** Code Reviewer  
**File:** `.github/prompts/tsh-review.prompt.md`

Performs a structured code review against the implementation plan and feature context.

## Usage

```text
/tsh-review <JIRA_ID or task description>
```

## Review Scope

`/tsh-review` targets the delivered reviewable implementation artifacts in a change set — application/product source code, automated tests, infrastructure/CI/CD/observability code, and LLM application prompts delivered as product artifacts. A `*.plan.md` file is required comparison context for scope, Definition of Done, and acceptance criteria, but it is never a review target: plan wording, structure, and bookkeeping are out of scope. A planning-artifact-only request (no reviewable implementation artifacts delivered) is reported as not applicable and redirected to the plan-quality owners — `tsh-plan-reviewer` and the Architect.

The plan writes listed under [What It Does](#what-it-does) below — checked Definition of Done and acceptance criteria items, the "Code Review Findings" section, and the Changelog entry — are permitted bookkeeping and do not themselves constitute a review of the plan.

## What It Does

1. **Understands context** — Loads `.research.md` and `.plan.md` files, reviews `*.instructions.md` for project guidelines.
2. **Reviews implementation** — Focuses on correctness, code quality, security, testing, and documentation.
3. **Verifies definition of done** — Checks each item from the plan's task definitions; marks completed items.
4. **Verifies acceptance criteria** — Checks each item from the plan's acceptance criteria checklist.
5. **Summarizes findings** — Provides a summary with issues and recommendations.
6. **Documents results** — Adds a "Code Review Findings" section to the plan file.
7. **Updates changelog** — Records that code review was performed.

## Skills Loaded

- `tsh-code-reviewing` — Structured review covering correctness, quality, security, testing, best practices, scalability.
- `tsh-implementation-gap-analysing` — Compare implementation against the plan for completeness.
- `tsh-technical-context-discovering` — Understand project conventions and coding standards.
- `tsh-sql-and-database-understanding` — When reviewing database-related changes.

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
