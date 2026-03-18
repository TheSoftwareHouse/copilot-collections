---
sidebar_position: 4
title: /tsh-implement
---

# /tsh-implement

**Agent:** Engineering Manager  
**File:** `.github/prompts/tsh-implement.prompt.md`

Orchestrates the implementation of a feature by delegating tasks from the plan to specialized agents.

## Usage

```text
/tsh-implement <JIRA_ID or task description>
```

## What It Does

1. Reviews the implementation plan and feature context thoroughly.
2. Creates a **todo for every task** in the plan — each task gets its own tracked item.
3. Delegates codebase analysis to the **Architect** agent to establish project conventions and patterns.
4. Processes each task in plan order, delegating based on task type:
   - **`[CREATE]` / `[MODIFY]`** → delegates to **Software Engineer** (app code), **DevOps Engineer** (infrastructure), or **E2E Engineer** (tests).
   - **`[REUSE]`** → executes as described in the task definition (e.g., UI verification via **UI Reviewer**).
5. After each task, updates plan checkboxes and runs quality checks (tsc, lint, build).
6. Asks for confirmation before deviating from the plan.
7. Documents all changes in the plan's Changelog section.
8. **Automatically runs Code Reviewer** at the end if no review phase is defined.

## How Delegation Works

The Engineering Manager automatically delegates each task to the right agent based on the plan:

| Task Type | Agent |
|---|---|
| Backend / general code | Software Engineer |
| Frontend with Figma | Software Engineer |
| E2E tests | E2E Engineer |
| Infrastructure (Kubernetes, Terraform, CI/CD, observability) | DevOps Engineer |
| UI verification | UI Reviewer |

## Key Behaviors

- **Orchestrates, never implements** — Delegates all coding to specialized agents.
- **Strictly follows the plan** — No deviations unless explicitly approved.
- **Tracks progress with todos** — Each plan task gets its own tracked item.
- **Runs quality checks after each task** — Ensures nothing breaks as implementation progresses.
- **Auto-triggers Code Reviewer** — Ensures every implementation gets reviewed.

## Output

- Code changes applied by delegated agents as specified in the plan.
- Updated plan checkboxes showing completion status.
- Changelog entries for any modifications.
- Code review findings from the automatic `tsh-code-reviewer` run.
