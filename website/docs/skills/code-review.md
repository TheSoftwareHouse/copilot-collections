---
sidebar_position: 3
title: Code Review
---

# Code Review

**Folder:** `.github/skills/code-review/`  
**Used by:** Code Reviewer

Provides a structured 9-step code review process covering correctness, quality, security, testing, and scalability.

## 9-Step Review Checklist

1. **Understand the task** — Read research and plan files.
2. **Compare to plan** — Verify implementation matches the plan.
3. **Review implementation** — Check correctness, code quality, adherence to standards.
4. **Verify tests** — Ensure critical paths are covered.
5. **Run tests** — Execute test suite, verify passing.
6. **Best practices** — Check SOLID, SRP, DDD, DRY, KISS principles.
7. **Static analysis** — Run linters, formatters, type checks.
8. **Security** — Validate against OWASP TOP10.
9. **Scalability** — Assess horizontal scaling, statelessness, computational complexity.

## Review Focus Areas

| Area | What It Covers |
|---|---|
| **Correctness** | Code functions as intended, meets requirements |
| **Code Quality** | Clean, efficient, maintainable, low cognitive complexity |
| **Security** | OWASP TOP10 validation, no vulnerabilities |
| **Testing** | Critical paths covered, tests pass |
| **Scalability** | Horizontal scaling, statelessness, Big O analysis |
| **Acceptance Criteria** | Each item from the plan verified individually |

## Connected Skills

- `implementation-gap-analysis` — Compare implementation against the plan.
- `technical-context-discovery` — Review against project conventions.
- `sql-and-database` — Review database-related code quality.
