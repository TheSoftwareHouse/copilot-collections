---
name: tsh-creating-implementation-plans
description: "Creates implementation plan documents (*.plan.md) that break a designed solution into phases and verifiable tasks. Owns the plan template (plan.example.md), plan structure rules, and task definition-of-done rules. Use when authoring, revising, or structuring an implementation plan for any feature or task."
user-invocable: false
---

# Creating Implementation Plans

This skill turns a designed solution into a phased, verifiable implementation plan document.

<principles>
<plan-structure-ownership>This skill is the single owner of the plan template (`./plan.example.md`), the plan-structure procedure, and the definition-of-done rules for implementation plans. Other skills and agents MUST reference this skill instead of duplicating plan-structure rules.</plan-structure-ownership>
<goal-hierarchy>Every plan defines one Wildly Important Goal, stated explicitly as the single most important outcome the whole plan must achieve. Every phase defines a Goal that clearly advances the Wildly Important Goal, followed by a Description that explains the broader why for reviewers and implementors. The plan itself, after the Wildly Important Goal, also includes a description of the overall approach.</goal-hierarchy>
<no-real-code>The plan must not contain real implementation code. Pseudo-code is allowed only to explain genuinely complicated algorithms or ideas. Diagrams, explanations, and the Technical Context chapter content are allowed and encouraged.</no-real-code>
</principles>

## Plan Creation Process

1. Confirm inputs: a designed solution, typically from `tsh-architecture-designing`, plus task research and context. Do not design the solution here; this skill structures an already-designed solution into a plan.
2. Define the Wildly Important Goal and the plan description.
3. Divide the work into small phases. Each phase must have a Goal, a Description, and a list of tasks with checkboxes to mark finished tasks later. After each phase is finished, only fast-running tests and quality checks should be run to verify the implementation is on track: unit tests, integration tests, static code analysis, linters, formatting checks, and project build.
4. Define each task. Each task must have a Description, a Definition of Done as a checkbox list, and optional Clues that help the implementor (file paths, line ranges, reference patterns, gotchas).
5. Add the mandatory cross-cutting tasks required by the plan rules.
6. Save the plan as a document following the `./plan.example.md` template. Do not add or remove any sections from the template. Follow the structure and naming conventions strictly.

<definition-of-done-rules>
Each task must include a definition of done as a checkbox list.
Definition of done must not include deployment steps.
Definition of done must not include manual QA steps.
Definition of done must not include steps that cannot be verified by a code reviewer during code review.
Example: do not require checking whether tests were failing before the change, because that cannot be verified during code review.
</definition-of-done-rules>

<mandatory-plan-content>
- The plan must include a code review phase at the end, fully done by `tsh-code-reviewer` using [`tsh-review.prompt.md`](../../prompts/tsh-review.prompt.md). Pass e2e execution to that agent as part of the prompt; do not run those tests from the plan author level.
- For features with UI components based on Figma designs, each UI implementation task should be followed by a `[REUSE]` UI verification task delegated to `tsh-ui-reviewer` using [`tsh-review-ui.prompt.md`](../../prompts/tsh-review-ui.prompt.md). Include the Figma URL in every verification task. Do not run UI verification from the software engineer level — let the engineering manager orchestrate the verify-fix loop.
- For features involving LLM application prompts (system prompts, RAG templates, tool-calling instructions, classification/extraction prompts), add a `[REUSE]` prompt engineering task delegated to `tsh-prompt-engineer` using [`tsh-engineer-prompt.prompt.md`](../../internal-prompts/tsh-engineer-prompt.prompt.md). Separate prompt design from application code — the software engineer implements the integration code, the prompt engineer designs the prompt content. Include the use case, target model, and any existing prompt drafts in the task description.
- Do not provide deployment plans, code pushing instructions, or repository code review instructions.
</mandatory-plan-content>

<plan-content-rules>
- The plan must capture security considerations relevant to the implementation.
- Save the plan as `specifications/{task-name-or-id}/{task-name}.plan.md`.
- For bug-fix work, the plan must include issue reproduction, root-cause analysis, and a fix verified by tests.
- Plan only the current task. Record prerequisite work, follow-up work, and out-of-scope items in `Improvements` instead of expanding the implementation scope.
- Reuse or modify existing code whenever possible. Consult `Current Implementation Analysis` before planning new components, functions, or utilities.
</plan-content-rules>

## Connected Skills

- `tsh-architecture-designing` - designs the solution this skill turns into a plan
- `tsh-implementation-gap-analysing` - verifies what was already implemented before planning new work
- `tsh-technical-context-discovering` - populates the plan's Technical Context section
