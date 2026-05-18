---
sidebar_position: 33
title: Committing Code
---

# Committing Code

**Folder:** `.github/skills/tsh-committing-code/`  
**Used by:** Software Engineer

Provides standards for writing semantic commit messages, strategies for splitting changes into logical commits, branch naming conventions, and pre-commit verification checks.

## Key Principles

| Principle                  | Description                                                                      |
| -------------------------- | -------------------------------------------------------------------------------- |
| **Convention First**       | Always check for an existing project commit convention before applying defaults. |
| **Semantic Types**         | Every commit starts with a type prefix (`feat`, `fix`, `docs`, etc.).            |
| **Atomic Commits**         | Each commit represents a single logical change.                                  |
| **Clean History**          | Split unrelated changes; keep related changes together.                          |

## Commit Convention Detection

The skill checks for project-specific conventions in this order:

1. Commitlint config files (`.commitlintrc`, `commitlint.config.js`, etc.)
2. Commitizen config (`.czrc`, `package.json` → `config.commitizen`)
3. `CONTRIBUTING.md` or `COMMIT_CONVENTION.md`
4. Recent git history patterns (`git log --oneline -20`)

If no convention is found, the **Semantic Commit Messages** format is used as default.

## Semantic Commit Types

| Type       | Purpose                                                |
| ---------- | ------------------------------------------------------ |
| `feat`     | New feature for the user                               |
| `fix`      | Bug fix for the user                                   |
| `docs`     | Documentation-only changes                             |
| `style`    | Formatting, whitespace (no logic changes)              |
| `refactor` | Restructuring code without changing behavior           |
| `test`     | Adding or updating tests                               |
| `chore`    | Build scripts, CI config, dependencies, tooling        |

## Commit Splitting Strategy

**Split when** changes span multiple unrelated concerns — e.g., a bug fix bundled with a new feature, or a refactor mixed with behavioral changes.

**Keep together when** all changes serve a single logical purpose and each file change directly supports the same goal.

## Branch Naming Convention

```
<type>/<short-description>          # e.g., feat/user-avatar-upload
<type>/<TICKET-ID>-<short-description>  # e.g., fix/PROJ-142-session-expiry
```

## Pre-Commit Checks

Before committing, the skill verifies: lint, type check, relevant tests, build integrity, and scans for accidentally staged secrets or credentials.

## Connected Skills

- [tsh-implementing-ci-cd](./ci-cd-implementation) — CI/CD pipelines that enforce commit conventions.
- [tsh-code-reviewing](./code-review) — Review standards that inform good commit boundaries.
