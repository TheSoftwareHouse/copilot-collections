---
sidebar_position: 5
title: /tsh-commit
---

# /tsh-commit

**Agent:** Software Engineer  
**File:** `.github/prompts/tsh-commit.prompt.md`

Guides you through committing changes with semantic messages, optional commit splitting, branch creation, and pushing.

## Usage

```text
/tsh-commit
```

No arguments required — the prompt inspects the current git state automatically.

## What It Does

1. **Detects commit convention** — Checks for commitlint, commitizen, `CONTRIBUTING.md`, and recent git history to determine which message format to follow. Falls back to [Semantic Commit Messages](https://sparkbox.com/foundry/semantic_commit_messages) if no convention is found.
2. **Assesses current state** — Runs `git status` and `git diff --stat` to summarize what changed.
3. **Suggests a feature branch** — If you're on the default branch (main/master/develop), suggests creating a feature branch with a properly named branch before committing.
4. **Analyzes changes for splitting** — Reviews the diff to determine if changes should be split into multiple atomic commits. Presents the proposed split and lets you choose.
5. **Composes commit message(s)** — Drafts semantic commit messages following the detected convention. Shows the message for approval before committing.
6. **Runs pre-commit checks** — Linter, type checker, relevant tests, and secret scanning based on the project setup.
7. **Executes the commit(s)** — Stages and commits with the approved messages.
8. **Asks about pushing** — Offers to push now, push later, or (with explicit confirmation) force push.
9. **Displays summary** — Shows branch, commit hash(es), and push status.

## Skills Loaded

- `tsh-committing-code` — Semantic commit types, splitting rules, branch naming conventions, pre-commit checks.

## Interactive Decisions

The prompt asks the user at each key decision point:

| Decision Point | Options |
|---|---|
| Feature branch creation | Create suggested branch / Stay on current branch / Custom name |
| Commit splitting | Accept proposed split / Commit everything together |
| Commit message | Accept / Edit / Regenerate |
| Push to remote | Push now / Push later / Force push (with warning) |

## Safety Guarantees

- Never force-pushes without explicit confirmation and a warning.
- Never commits files containing detected secrets or credentials without flagging.
- Never amends published commits without asking.
- Shows every commit message before executing.
- If push fails due to diverged branches, explains the situation and offers pull+rebase, pull+merge, or abort.
