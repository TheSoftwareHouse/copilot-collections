---
agent: "tsh-software-engineer"
model: "Claude Opus 4.6"
description: "Commit staged changes with semantic messages, optionally split and push."
---

Your goal is to guide the user through committing their current changes with well-structured, semantic commit messages — splitting commits when appropriate, suggesting feature branches when needed, and optionally pushing to the remote.

## Required Skills

Before starting, load and follow these skills:
- `tsh-committing-code` — for commit message conventions, splitting strategies, branch naming, and pre-commit checks

## Workflow

1. **Detect commit convention** — Follow the convention detection process from `tsh-committing-code`. Check for commitlint config, commitizen config, `CONTRIBUTING.md`, and recent git history patterns. Report which convention will be used (project-specific or semantic commit default).

2. **Assess current state** — Run `git status` and `git diff --stat` to understand what has changed. If nothing is staged, run `git diff` to show unstaged changes. Summarize the changes for the user in a concise overview.

3. **Check current branch** — Run `git branch --show-current` and `git remote show origin` (or `git symbolic-ref refs/remotes/origin/HEAD`) to determine the default branch. If the user is on the default branch (main/master/develop) or a shared branch:
   - Suggest creating a feature branch using the naming conventions from `tsh-committing-code`.
   - Use `vscode/askQuestions` to ask: "You're on `{branch}`. Want to create a feature branch first?" with suggested branch name(s) as options and an option to stay on the current branch.
   - If the user agrees, create the branch with `git checkout -b <branch-name>`.

4. **Analyze changes for splitting** — Review the diff content and apply the splitting rules from `tsh-committing-code`. Determine if the changes should be split into multiple commits. If splitting is recommended:
   - Present the proposed split: list each commit with its type, message, and included files.
   - Use `vscode/askQuestions` to ask: "I suggest splitting into N commits — proceed with this split, or commit everything together?" with options for each approach.
   - If the user agrees to split, stage and commit each group sequentially.

5. **Compose commit message(s)** — For each commit (or the single commit):
   - Draft the commit message following the detected convention.
   - If the change is non-trivial, include a body with additional context.
   - Present the proposed message to the user using `vscode/askQuestions`: "Proposed commit message — accept, edit, or regenerate?" with the message shown.

6. **Run pre-commit checks** — Before executing the commit, follow the pre-commit checks from `tsh-committing-code`:
   - Run linter, type checker, and relevant tests based on the project setup.
   - If any check fails, report the issue and ask whether to fix it, skip the check, or abort.
   - Scan staged files for potential secrets or credentials.

7. **Execute the commit(s)** — Stage files (if not already staged) and run `git commit` with the approved message(s). For split commits, execute them in the planned order.

8. **Ask about pushing** — After committing, use `vscode/askQuestions` to ask: "Push to remote?" with options:
   - "Yes, push now" — run `git push` (or `git push -u origin <branch>` if the branch is new).
   - "No, I'll push later" — skip pushing.
   - "Force push (rewrite)" — only if the user explicitly requests it; confirm with a warning before executing.

9. **Summary** — Display a brief summary of what was done: branch name, commit(s) made (with hashes), and push status.

<constraints>
- Never force-push without explicit user confirmation and a warning about consequences.
- Never commit files containing secrets, tokens, or credentials without flagging them first.
- Never amend published commits without asking the user.
- Always show the proposed commit message before executing `git commit`.
- If `git push` fails due to diverged branches, explain the situation and offer options (pull + rebase, pull + merge, or abort) instead of force-pushing.
</constraints>
