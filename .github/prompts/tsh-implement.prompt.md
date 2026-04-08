---
agent: "tsh-engineering-manager"
model: "Claude Opus 4.6"
description: "Implement feature according to the plan."
---

Your goal is to implement the feature according to the provided implementation plan and feature context.

## Workflow

1. **Review the current state of the task** - Check what's already done and decide whether you have enough context and information to start the implementation or if you need to delegate to `tsh-context-engineer` agent to gather more context and requirements before starting the implementation. If the plan is missing, delegate to `tsh-architect` agent to create a detailed implementation plan based on the feature context and requirements.

2. **Review the plan** — Read the implementation plan and feature context thoroughly. Identify every task, its type (`[CREATE]`, `[MODIFY]`, `[REUSE]`), and which agent should handle it. Create a **todo for every task** in the plan — not one per phase. Each task gets its own todo.

   **Inventory UI verification tasks** — Scan the entire plan for `[REUSE]` tasks that involve `tsh-ui-reviewer` or Figma verification. Also scan the plan — and the research file (`*.research.md`) if one exists — for all Figma URLs. Build an explicit list of UI components that require verification. You will use this inventory as a checklist — every item must be verified before code review.

3. **Confirm dev server URL** — If your UI verification inventory from step 2 contains ANY tasks, use `vscode/askQuestions` **now** to ask the user for the dev server URL (e.g., "What URL is the frontend app running at?"). Do not defer this — you need the confirmed URL before any UI verification can start. Do not guess from running processes or port scans. Store the confirmed URL for all subsequent verifications.

4. **Confirm with user before implementation** — Confirm with the user before proceeding to the implementation phase after research and planning phases using `vscode/askQuestions` tool.

5. **Delegate codebase analysis** — Use `tsh-architect` agent to perform codebase analysis and technical context discovery to establish project conventions, coding standards, architecture patterns, and existing codebase patterns before implementing any feature. This will help you identify which agents to delegate specific tasks to during implementation.

6. **Process each task in plan order.** For each task, based on its type:
   - **`[CREATE]` or `[MODIFY]`** → delegate to the appropriate agent (`tsh-software-engineer` for application code, `tsh-devops-engineer` for infrastructure, `tsh-prompt-engineer` for LLM prompts). After the agent completes, run quality checks (tsc, lint, build).

   - **`[REUSE]` — UI verification tasks** → These tasks MUST be processed — do NOT skip them. Delegate each one to `tsh-ui-reviewer` via `runSubagent` with [tsh-review-ui.prompt.md](tsh-review-ui.prompt.md), passing: the Figma URL (for `figma` — to extract design specs), the confirmed dev server URL from step 3 (for `playwright` — to capture actual implementation), and the component/section name. For the complete verification workflow (fix→verify iteration loop, confidence handling, escalation rules, verification gate), follow [tsh-implement-ui.prompt.md](../internal-prompts/tsh-implement-ui.prompt.md).

   - **`[REUSE]` — other tasks** → execute as described in the task definition — the task specifies which agent to delegate to and what context to pass.

7. **After each task**, update the relevant plan to reflect progress by checking the box for the completed task step and:
   - Review the implementation against the plan and feature context to ensure all requirements are met.
   - Run static code analysis, build the project, and run unit and integration tests to verify that the implementation works as expected and does not introduce new issues.

8. **UI Verification Gate — MANDATORY before code review** — Before delegating code review, verify that **every** `[REUSE]` UI verification task from your step 2 inventory has been processed. Check each item:
   - Was it delegated to `tsh-ui-reviewer`?
   - Did it receive a PASS, or was it escalated to the user with explicit approval to skip?

   If ANY UI verification task was not processed, go back and process it now. Do NOT proceed to code review with unverified UI components. If verification cannot be completed (tool errors, missing Figma links), document it in the plan's Changelog and get explicit user approval before continuing.

9. **Delegate code review** — Delegate to `tsh-code-reviewer` agent via [tsh-review.prompt.md](tsh-review.prompt.md). Include E2E test execution as part of the review. The code reviewer runs all quality gates (unit, integration, E2E tests, linting, build).

10. **Before making any changes** to the original solution during implementation, ask for confirmation. Document changes in the plan file's Changelog section with timestamps.

Ensure to write clean, efficient, and maintainable code following best practices and coding standards for the project.
