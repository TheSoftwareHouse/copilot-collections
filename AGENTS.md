# 🤖 Agents & Handoffs

This document describes the available agents and how they hand off work to each other.

## 📋 Available Agents

| Agent | Description |
|-------|-------------|
| `tsh-business-analyst` | Analyzes requirements and gathers business context |
| `tsh-architect` | Creates implementation plans and technical designs |
| `tsh-software-engineer` | Implements backend/full-stack solutions |
| `tsh-frontend-software-engineer` | Implements UI components and frontend solutions |
| `tsh-code-reviewer` | Performs structured code reviews |
| `tsh-ui-reviewer` | Verifies UI implementation against Figma designs |
| `tsh-git-committer` | Creates branches and commits changes following project conventions |

---

## 🔄 Handoff Flows

### Standard Implementation Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           STANDARD FLOW                                      │
└─────────────────────────────────────────────────────────────────────────────┘

                         ┌─────────────────────┐
                         │    JIRA / Ticket    │
                         └──────────┬──────────┘
                                    │
                                    ▼
                    ┌───────────────────────────────┐
                    │     tsh-business-analyst      │
                    │         /research             │
                    └───────────────┬───────────────┘
                                    │
                                    ▼
                    ┌───────────────────────────────┐
                    │       tsh-architect           │
                    │          /plan                │
                    └───────────────┬───────────────┘
                                    │
                ┌───────────────────┴───────────────────┐
                │                                       │
                ▼                                       ▼
┌───────────────────────────┐           ┌───────────────────────────┐
│   tsh-software-engineer   │           │ tsh-frontend-software-    │
│        /implement         │           │ engineer  /implement      │
└─────────────┬─────────────┘           └─────────────┬─────────────┘
              │                                       │
              │                                       ▼
              │                         ┌───────────────────────────┐
              │                         │    tsh-ui-reviewer        │
              │                         │      /verify-figma        │
              │                         └─────────────┬─────────────┘
              │                                       │
              └────────────┬──────────────────────────┘
                           │
                           ▼
              ┌───────────────────────────┐
              │    tsh-code-reviewer      │
              │        /review            │
              └─────────────┬─────────────┘
                            │
              ┌─────────────┴─────────────┐
              │                           │
              ▼                           ▼
    ┌─────────────────┐         ┌─────────────────┐
    │   Has issues?   │         │    APPROVED     │
    │                 │         │                 │
    │   Back to       │         │                 │
    │   software-     │         │                 │
    │   engineer      │         │                 │
    └────────┬────────┘         └────────┬────────┘
             │                           │
             └─────────┬─────────────────┘
                       │
                       ▼
              ┌───────────────────────────┐
              │     tsh-git-committer     │
              │    /commit-changes        │
              └─────────────┬─────────────┘
                            │
                            ▼
              ┌───────────────────────────┐
              │   ✅ Ready for Push       │
              │                           │
              │   git push → PR → CI/CD   │
              └───────────────────────────┘
```

---

## 🔗 Handoff Details by Agent

### tsh-software-engineer

| Handoff | Target Agent | Prompt | Description |
|---------|--------------|--------|-------------|
| Perform Code Review | `tsh-code-reviewer` | `/review` | Request code review after implementation |
| Commit Implementation Changes | `tsh-git-committer` | `/commit-changes` | Create branch and commit changes |

### tsh-frontend-software-engineer

| Handoff | Target Agent | Prompt | Description |
|---------|--------------|--------|-------------|
| Verify UI against Figma | `tsh-ui-reviewer` | `/verify-figma` | Verify implementation matches Figma design |
| Perform Code Review | `tsh-code-reviewer` | `/review` | Request code review after implementation |
| Commit Implementation Changes | `tsh-git-committer` | `/commit-changes` | Create branch and commit changes |

### tsh-code-reviewer

| Handoff | Target Agent | Prompt | Description |
|---------|--------------|--------|-------------|
| Implement changes after code review | `tsh-software-engineer` | `/implement` | Return to engineer to fix review issues |

### tsh-git-committer

| Handoff | Target Agent | Prompt | Description |
|---------|--------------|--------|-------------|
| Fix pre-commit errors | `tsh-software-engineer` | `/implement` | Return to engineer to fix pre-commit hook failures (lint, tsc, tests) |

---

## 📖 Usage Examples

### Example 1: Full Backend Feature

```bash
# 1. Research the task
@tsh-business-analyst /research PROJ-123

# 2. Create implementation plan
@tsh-architect /plan

# 3. Implement the feature
@tsh-software-engineer /implement

# 4. Click [Handoff] "Perform Code Review"
#    → tsh-code-reviewer reviews the code

# 5. If issues found: Click [Handoff] "Implement changes after code review"
#    → Back to tsh-software-engineer

# 6. Click [Handoff] "Commit Implementation Changes"
#    → tsh-git-committer creates branch and commits
```

### Example 2: Frontend Feature with Design

```bash
# 1. Research the task
@tsh-business-analyst /research PROJ-456

# 2. Create implementation plan
@tsh-architect /plan

# 3. Implement the UI
@tsh-frontend-software-engineer /implement

# 4. Click [Handoff] "Verify UI against Figma"
#    → tsh-ui-reviewer checks design compliance

# 5. Click [Handoff] "Perform Code Review"
#    → tsh-code-reviewer reviews the code

# 6. Click [Handoff] "Commit Implementation Changes"
#    → tsh-git-committer creates branch and commits
```

### Example 3: Direct Commit (already reviewed)

```bash
# If code is already reviewed and ready
@tsh-git-committer /commit-changes
```

---

## ⚙️ Git Committer Behavior

The `tsh-git-committer` agent follows these rules:

1. **Checks current branch** before creating a new one
   - If already on a feature/fix branch → uses existing branch
   - If on `main`/`master`/`develop` → creates new branch

2. **Analyzes project conventions** by checking:
   - `.commitlintrc`, `commitlint.config.js`
   - `.husky/` hooks
   - `CONTRIBUTING.md`, `README.md`
   - Recent commit history (`git log`)
   - Existing branch names (`git branch -a`)

3. **Creates commits** following detected conventions
   - Falls back to Conventional Commits if no convention found
   - Example: `feat(auth): implement OAuth login flow`

4. **Does NOT auto-push** - you control when to push

---

## 📝 Notes

- All handoffs have `send: false` - you click the button to trigger them
- Agents respect project-specific conventions and configurations
- The flow can be started at any point if you have the necessary context
