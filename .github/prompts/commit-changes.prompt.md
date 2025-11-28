```prompt
---
agent: "tsh-git-committer"
model: "Claude Opus 4.5 (Preview)"
description: "Create a new branch and commit implementation changes."
---

Your goal is to create a new branch and commit the implementation changes following the project's conventions.

Before proceeding, gather information about the project's conventions:

1. **Branch naming convention**: Look for branch naming patterns in:
   - Project documentation (README.md, CONTRIBUTING.md, docs/)
   - Git configuration files (.github/, .gitlab/)
   - Existing branches in the repository (use `git branch -a` to list all branches)
   - Common patterns include: `feature/`, `feat/`, `fix/`, `bugfix/`, `hotfix/`, `chore/`, `refactor/`

2. **Commit message convention**: Look for commit conventions in:
   - Project documentation (README.md, CONTRIBUTING.md)
   - Commitlint configuration (.commitlintrc, .commitlintrc.js, .commitlintrc.json, commitlint.config.js)
   - Husky hooks (.husky/)
   - Package.json (look for commitizen, conventional-changelog, or similar tools)
   - Existing commit history (use `git log --oneline -20` to see recent commits)
   - Common conventions: Conventional Commits (feat:, fix:, chore:, refactor:, docs:, test:, style:, perf:, ci:, build:)

Follow these steps in your workflow:

1. **Check current branch status**:
   - Run `git branch` to see the current branch
   - Determine if the current branch is appropriate for the implementation:
     - If you are already on a feature/fix branch that matches the work being done, **do not create a new branch** - continue using the existing one
     - If you are on `main`, `master`, `develop`, or another protected/shared branch, you must create a new branch
   - Check for uncommitted changes using `git status`

2. **Analyze project conventions** (only if a new branch is needed):
   - Search for and read any configuration files related to git conventions
   - Review recent commit history to understand the existing patterns
   - Review existing branch names to understand the naming pattern
   - If no explicit convention is found, follow Conventional Commits standard

3. **Create a descriptive branch name** (only if not already on an appropriate branch):
   - Use the identified branch naming convention
   - Include relevant context (feature name, ticket number if available)
   - Keep it concise but descriptive
   - Example formats:
     - `feature/JIRA-123-add-user-authentication`
     - `feat/implement-search-functionality`
     - `fix/resolve-login-redirect-issue`

4. **Stage and commit changes**:
   - Review the changes to be committed using `git status` and `git diff`
   - Stage all relevant changes
   - Write a commit message following the project's convention
   - Include a clear, concise subject line
   - Add a body if the changes require more explanation
   - Reference any related issues or tickets

5. **Verify the commit**:
   - Ensure all intended changes are included
   - Verify the commit message follows the convention
   - Check that no unintended files are committed

Example workflow commands:
```bash
# Check current branch and status
git status
git branch

# Analyze existing conventions
git log --oneline -20
git branch -a | head -20

# Create and switch to new branch (ONLY if on main/master/develop)
git checkout -b <branch-name>

# Stage changes
git add .
# Or stage specific files
git add <file1> <file2>

# Commit with message
git commit -m "<type>(<scope>): <description>"
# Or for multi-line commit message
git commit -m "<type>(<scope>): <description>" -m "<body>"
```

Important notes:
- Never force push or rewrite history on shared branches
- Do not push the branch automatically unless explicitly instructed
- If pre-commit hooks fail, address the issues before committing
- Keep commits atomic and focused on a single logical change
- If the implementation spans multiple logical changes, consider creating multiple commits

After completing the commit, provide a summary including:
- The created branch name
- The commit message used
- List of files included in the commit
- Any issues encountered during the process

```
