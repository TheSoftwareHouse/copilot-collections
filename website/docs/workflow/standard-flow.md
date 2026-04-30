---
sidebar_position: 2
title: Standard Flow
---

# Standard Flow

The standard workflow is used for backend and fullstack tasks. The Engineering Manager orchestrates the full cycle: research → plan → implement → review.

## Step-by-Step Command Sequence

### 1. Implement

```text
/tsh-implement <JIRA_ID or task description>
```

The Engineering Manager automatically handles the full development cycle:

#### Research Phase (internal)

- **Delegated to:** Context Engineer
- **What it does:** Gathers all available information about the task from the codebase, Jira, Confluence, Figma, and other sources.
- **What it produces:** A `.research.md` file with task summary, assumptions, open questions, and suggested next steps.
- **Your action:** Review the generated research document. Verify accuracy. The Engineering Manager asks for confirmation before proceeding.

#### Planning Phase (internal)

- **Delegated to:** Architect
- **What it does:** Creates a multi-step implementation plan grouped into phases and tasks aligned with your repo structure.
- **What it produces:** A `.plan.md` file with checklist-style phases that can be executed by specialized agents.
- **Your action:** Review the implementation plan. Confirm scope, phases, and acceptance criteria.

#### Implementation Phase

- **Delegated to:** Software Engineer, Prompt Engineer, DevOps Engineer, E2E Engineer (based on task type)
- **What it does:** Executes the plan by delegating to specialized agents. Tracks progress and runs quality checks after each task.
- **What it produces:** Concrete code modifications applied by delegated agents.
- **Your action:** Review code changes after each phase. Test functionality. Verify against the plan.

:::tip
If a `.research.md` or `.plan.md` file already exists for the task, the Engineering Manager skips that phase and proceeds directly to the next step.
:::

### 2. Review

```text
/tsh-review <JIRA_ID or task description>
```

- **Agent:** Code Reviewer
- **What it does:** Reviews the final implementation against the plan and requirements. Highlights security, reliability, performance, and maintainability concerns.
- **What it produces:** Structured review with clear pass/blockers/suggestions.
- **Your action:** Review findings and recommendations. Address all blockers before merging.

## Example End-to-End Usage

```text
1⃣️ /tsh-implement <JIRA_ID or task description>
   ↳ 🔍 Engineering Manager delegates to Context Engineer for research
   ↳ 📖 Review the generated research document
   ↳ ✅ Confirm to proceed to planning
   ↳ 🧱 Engineering Manager delegates to Architect for planning
   ↳ 📖 Review the implementation plan
   ↳ ✅ Confirm scope, phases, and acceptance criteria
   ↳ 💻 Engineering Manager delegates implementation to specialized agents
   ↳ 📖 Review code changes after each phase
   ↳ ✅ Test functionality, verify against plan

2⃣️ /tsh-review   <JIRA_ID or task description>
   ↳ 📖 Review findings and recommendations
   ↳ ✅ Address blockers before merging
```

## Input Flexibility

You can run the same flow with either:

- A **Jira ticket ID** (e.g., `PROJ-123`) — the agent will pull context from Jira automatically via the Atlassian MCP.
- A **free-form task description** (e.g., `"Add pagination to the user list API"`) — the agent will work from the description and codebase analysis.

## Task Labeling: CREATE / MODIFY / REUSE

Every task in an implementation plan is labeled with one of three action types. This helps developers understand the scope and impact of each task at a glance:

| Label | Meaning | Example |
|---|---|---|
| **CREATE** | New code that doesn't exist yet | "Create a new `UserService` class" |
| **MODIFY** | Change existing code | "Update the `getUsers` endpoint to support pagination" |
| **REUSE** | Use existing code as-is, no changes needed | "Reuse the existing `AuthMiddleware` for the new route" |

These labels are assigned during the **Plan** phase by the Architect agent. During the **Implement** phase, the Software Engineer agent uses them to understand what needs to be built from scratch, what needs careful modification of existing logic, and what can be leveraged without changes.
