---
sidebar_position: 2
title: Standard Flow
---

# Standard Flow

The standard workflow is used for backend and fullstack tasks. It follows the full 4-phase cycle: Research → Plan → Implement → Review.

## Step-by-Step Command Sequence

### 1. Research

```text
/tsh-research <JIRA_ID or task description>
```

- **Agent:** Context Engineer
- **What it does:** Gathers all available information about the task from the codebase, Jira, Confluence, Figma, and other sources.
- **What it produces:** A `.research.md` file with task summary, assumptions, open questions, and suggested next steps.
- **Your action:** Review the generated research document. Verify accuracy. Iterate if needed.

### 2. Plan

```text
/tsh-plan <JIRA_ID or task description>
```

- **Agent:** Architect
- **What it does:** Creates a multi-step implementation plan grouped into phases and tasks aligned with your repo structure.
- **What it produces:** A `.plan.md` file with checklist-style phases that can be executed by the Software Engineer agent.
- **Your action:** Review the implementation plan. Confirm scope, phases, and acceptance criteria.

### 3. Implement

```text
/tsh-implement <JIRA_ID or task description>
```

- **Agent:** Engineering Manager
- **What it does:** Orchestrates the implementation by delegating tasks from the plan to specialized agents (Software Engineer for code, DevOps Engineer for infrastructure, E2E Engineer for tests).
- **What it produces:** Concrete code modifications applied by delegated agents, with quality checks after each task.
- **Your action:** Review code changes after each phase. Test functionality. Verify against the plan.

### 4. Review

```text
/tsh-review <JIRA_ID or task description>
```

- **Agent:** Code Reviewer
- **What it does:** Reviews the final implementation against the plan and requirements. Highlights security, reliability, performance, and maintainability concerns.
- **What it produces:** Structured review with clear pass/blockers/suggestions.
- **Your action:** Review findings and recommendations. Address all blockers before merging.

## Example End-to-End Usage

```text
1⃣️ /tsh-research <JIRA_ID or task description>
   ↳ 📖 Review the generated research document
   ↳ ✅ Verify accuracy, iterate if needed

2⃣️ /tsh-plan     <JIRA_ID or task description>
   ↳ 📖 Review the implementation plan
   ↳ ✅ Confirm scope, phases, and acceptance criteria

3⃣️ /tsh-implement <JIRA_ID or task description>   ↳ 📖 Engineering Manager delegates to specialized agents   ↳ 📖 Review code changes after each phase
   ↳ ✅ Test functionality, verify against plan

4⃣️ /tsh-review   <JIRA_ID or task description>
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
