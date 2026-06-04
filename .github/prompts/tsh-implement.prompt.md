---
agent: "tsh-engineering-manager"
model: "GPT-5.4"
description: "Implement feature according to the plan."
---

Your goal is to implement the feature according to the provided task description or implementation plan.

## Workflow

### Step 0: Assess Complexity & Select Flow

Before starting any work, perform a quick assessment of the task:

1. **Scan the task** — Read the task description, any linked issues, or user instructions. Consider:
   - How many files are likely affected?
   - Is it a well-understood change (bug fix, small feature, config change) or something ambiguous/cross-cutting?
   - Are there unknowns that require research or architectural decisions?
   - Does it involve UI changes requiring Figma verification?

2. **Recommend a flow** — Based on your assessment, use `vscode/askQuestions` to present your recommendation:
   - **Full Implementation Flow** (recommended for: multi-component features, unclear requirements, architectural changes, UI work with Figma designs, tasks touching >3 files across different domains)
   - **Quick Implementation Flow** (recommended for: bug fixes, small self-contained features, config changes, adding tests, straightforward CRUD, tasks where the solution is obvious)

   Present your reasoning briefly (1-2 sentences) and let the user confirm or override your recommendation.

---

### Quick Implementation Flow

If the Quick flow is selected, follow these streamlined steps:

1. **Delegate implementation** — Delegate directly to `tsh-software-engineer` agent with the task description and any available context. The software engineer implements the solution following project conventions.

2. **Run quality checks** — After implementation, run static code analysis, build the project, and run tests to verify correctness.

3. **Delegate code review** — Delegate to `tsh-code-reviewer` agent via [tsh-review.prompt.md](tsh-review.prompt.md). The code reviewer runs all quality gates (unit, integration, E2E tests, linting, build).

4. **Before making any changes** to the original solution during review fixes, ask for confirmation.

---

### Full Implementation Flow

If the Full flow is selected, follow the complete workflow below:

1. **Review the current state of the task** - Check what's already done and decide whether you have enough context and information to start the implementation or if you need to delegate to `tsh-context-engineer` agent to gather more context and requirements before starting the implementation. If the plan is missing, delegate to `tsh-architect` agent to create a detailed implementation plan based on the feature context and requirements.

2. **Validate the plan** — After the architect produces or updates the `.plan.md`, delegate to `tsh-plan-reviewer` agent via [tsh-review-plan.prompt.md](../internal-prompts/tsh-review-plan.prompt.md) to validate the plan's correctness, feasibility, and simplicity. If the reviewer returns REVISIONS NEEDED with BLOCKER findings, send the review report back to the architect for corrections and re-validate (max 3 iterations — then escalate to user). If the plan is already approved and unchanged since the last review, skip re-validation. Once approved, present the plan and review summary to the user for implementation confirmation. Only proceed once the plan is APPROVED and the user confirms.

3. **Review the plan** — Read the implementation plan and feature context thoroughly. Identify every task, its type (`[CREATE]`, `[MODIFY]`, `[REUSE]`), and which agent should handle it. Create a **todo for every task** in the plan — not one per phase. Each task gets its own todo.

   **Inventory UI verification tasks** — Scan the entire plan for `[REUSE]` tasks that involve `tsh-ui-reviewer` or Figma verification. Also scan the plan — and the research file (`*.research.md`) if one exists — for all Figma URLs. Build an explicit list of UI components that require verification. You will use this inventory as a checklist — every item must be verified before code review.

4. **Confirm dev server URL** — If your UI verification inventory from step 3 contains ANY tasks, use `vscode/askQuestions` **now** to ask the user for the dev server URL (e.g., "What URL is the frontend app running at?"). Do not defer this — you need the confirmed URL before any UI verification can start. Do not guess from running processes or port scans. Store the confirmed URL for all subsequent verifications.

5. **Delegate codebase analysis (if needed)** — Check if the plan file (`*.plan.md`) contains a populated **"Technical Context"** section. If it does, skip this step — the context was already captured during planning. If the section is missing or empty, use `tsh-architect` agent to perform codebase analysis and technical context discovery to establish project conventions, coding standards, architecture patterns, and existing codebase patterns before implementing any feature. This will help you identify which agents to delegate specific tasks to during implementation.

6. **Confirm with user before implementation** — Confirm with the user before proceeding to the implementation phase after research and planning phases using `vscode/askQuestions` tool.

7. **Process each task in plan order.** For each task, based on its type:
   - **`[CREATE]` or `[MODIFY]`** → delegate to the appropriate agent (`tsh-software-engineer` for application code, `tsh-devops-engineer` for infrastructure, `tsh-prompt-engineer` for LLM prompts). After the agent completes, run quality checks (tsc, lint, build).

   - **`[REUSE]` — UI verification tasks** → These tasks MUST be processed — do NOT skip them. Delegate each one to `tsh-ui-reviewer` via `runSubagent` with [tsh-review-ui.prompt.md](tsh-review-ui.prompt.md), passing: the Figma URL (for `figma` — to extract design specs), the confirmed dev server URL from step 4 (for `playwright` — to capture actual implementation), and the component/section name. For the complete verification workflow (fix→verify iteration loop, confidence handling, escalation rules, verification gate), follow [tsh-implement-ui.prompt.md](../internal-prompts/tsh-implement-ui.prompt.md).

   - **`[REUSE]` — other tasks** → execute as described in the task definition — the task specifies which agent to delegate to and what context to pass.

8. **After each task**, update the relevant plan to reflect progress by checking the box for the completed task step and:
   - Review the implementation against the plan and feature context to ensure all requirements are met.
   - Run static code analysis, build the project, and run unit and integration tests to verify that the implementation works as expected and does not introduce new issues.

9. **UI Verification Gate — MANDATORY before code review** — Before delegating code review, verify that **every** `[REUSE]` UI verification task from your step 3 inventory has been processed. Check each item:
   - Was it delegated to `tsh-ui-reviewer`?
   - Did it receive a PASS, or was it escalated to the user with explicit approval to skip?

   If ANY UI verification task was not processed, go back and process it now. Do NOT proceed to code review with unverified UI components. If verification cannot be completed (tool errors, missing Figma links), document it in the plan's Changelog and get explicit user approval before continuing.

10. **Delegate code review** — Delegate to `tsh-code-reviewer` agent via [tsh-review.prompt.md](tsh-review.prompt.md). Include E2E test execution as part of the review. The code reviewer runs all quality gates (unit, integration, E2E tests, linting, build).

11. **Before making any changes** to the original solution during implementation, ask for confirmation. Document changes in the plan file's Changelog section with timestamps.

Ensure to write clean, efficient, and maintainable code following best practices and coding standards for the project.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-implement:v1 -->
