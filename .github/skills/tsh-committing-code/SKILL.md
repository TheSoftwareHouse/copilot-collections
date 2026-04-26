---
name: tsh-committing-code
description: "Semantic commit message standards, commit splitting strategies, branch naming conventions, and push workflows. Use when committing changes, crafting commit messages, deciding whether to split commits, creating feature branches, or pushing code to remote repositories."
---

# Committing Code

Provides standards for writing semantic commit messages, strategies for splitting changes into logical commits, branch naming conventions, and an interactive push workflow.

## When to Use

- Committing staged or unstaged changes
- Crafting commit messages that follow project or team conventions
- Deciding whether changes should be split into multiple commits
- Creating or suggesting feature branches
- Pushing commits to a remote repository

## Commit Message Convention Detection

Before composing any commit message, check for an existing convention in the repository:

<convention-detection>

1. Check for config files in this order:
   - `.commitlintrc`, `.commitlintrc.json`, `.commitlintrc.yml`, `.commitlintrc.js`, `commitlint.config.js`, `commitlint.config.ts`
   - `package.json` → `commitlint` key
   - `.czrc`, `.cz.json`, `package.json` → `config.commitizen` key
   - `.conventional-changelog` config files
   - `CONTRIBUTING.md` or `COMMIT_CONVENTION.md` for documented rules

2. Check recent git history for patterns:
   - Run `git log --oneline -20` to inspect the last 20 commit messages
   - Identify a dominant pattern (e.g., Conventional Commits, Jira-prefixed, Angular-style)

3. If a project convention is found → follow it strictly.
4. If no convention is found → use the **Semantic Commit Messages** format below.

</convention-detection>

## Semantic Commit Messages (Default)

When no project convention exists, use this format based on [Sparkbox Semantic Commit Messages](https://sparkbox.com/foundry/semantic_commit_messages):

```
<type>: <summary in present tense>
```

### Types

| Type       | Purpose                                                |
| ---------- | ------------------------------------------------------ |
| `feat`     | New feature for the user (not build scripts)           |
| `fix`      | Bug fix for the user (not build scripts)               |
| `docs`     | Documentation-only changes                             |
| `style`    | Formatting, missing semicolons, whitespace (no logic)  |
| `refactor` | Restructuring code without changing external behavior  |
| `test`     | Adding or updating tests (no production code change)   |
| `chore`    | Build scripts, CI config, dependencies, tooling        |

### Rules

- **Summary** is in present tense, lowercase start, no period at end.
- **Keep it under 72 characters** on the subject line.
- Add a blank line + body for details when the change is non-trivial.
- Reference issue/ticket IDs in the body or footer when available.

### Examples

```
feat: add user avatar upload endpoint
fix: prevent crash when session token is expired
docs: update README with deployment instructions
style: format files with prettier
refactor: extract validation logic into shared module
test: add integration tests for payment flow
chore: upgrade eslint to v9
```

### Body and Footer (Optional)

```
feat: add email verification flow

Sends a verification email on signup with a 24h expiry token.
Adds a /verify endpoint that validates the token and activates
the account.

Closes #142
```

## Commit Splitting Strategy

<splitting-rules>

Analyze the staged/unstaged changes and determine if they should be split:

**Split when:**
- Changes span multiple unrelated concerns (e.g., a bug fix + a new feature)
- A refactor is mixed with behavioral changes
- Test additions are bundled with production code changes that are independently reviewable
- Documentation updates are mixed with code changes
- Multiple files are modified for different purposes

**Keep together when:**
- All changes serve a single logical purpose
- Test files are directly testing the production code being changed
- A fix requires both the code change and its test

When splitting is recommended, suggest specific groupings:
1. List each proposed commit with its type, message, and which files it includes
2. Order commits so each one leaves the codebase in a valid state
3. Ensure no commit introduces broken tests or build failures

</splitting-rules>

## Branch Naming Conventions

<branch-naming>

When changes are on the default branch (main/master/develop) or a shared branch, suggest creating a feature branch before committing.

**Default pattern:**
```
<type>/<short-description>
```

**With ticket ID:**
```
<type>/<TICKET-ID>-<short-description>
```

**Examples:**
```
feat/user-avatar-upload
fix/PROJ-142-session-expiry-crash
chore/upgrade-eslint-v9
refactor/extract-validation-module
```

**Rules:**
- Use the same type prefixes as commit messages
- Use lowercase kebab-case for the description
- Keep under 50 characters total when possible
- Include ticket/issue ID when available

</branch-naming>

## Pre-Commit Checks

<pre-commit-checks>

Before committing, verify:

1. **Lint** — Run the project linter if configured (`npm run lint`, `yarn lint`, etc.)
2. **Type check** — Run type checking if applicable (`tsc --noEmit`, `mypy`, etc.)
3. **Tests** — Run relevant tests for the changed files
4. **Build** — Verify the project builds successfully if the change could affect the build
5. **Sensitive data** — Scan staged files for secrets, tokens, API keys, or credentials that should not be committed

Only run checks that are relevant to the scope of the change. Skip checks that are clearly unrelated (e.g., skip E2E tests for a docs-only change).

</pre-commit-checks>

## Connected Skills

- `tsh-implementing-ci-cd` — CI/CD pipeline patterns that enforce commit conventions
- `tsh-code-reviewing` — Code review standards that inform what makes a good commit boundary
