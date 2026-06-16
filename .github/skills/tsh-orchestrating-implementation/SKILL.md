---
name: tsh-orchestrating-implementation
description: Owns the canonical implementation orchestration workflow for feature implementation, including flow selection, planning readiness, delegated execution routing, todo control, and review gates. Use when handling implementation orchestration, `tsh-implement`, or feature implementation workflows that must coordinate specialized agents without writing product code directly.
user-invocable: false
---

# Orchestrating Implementation

This skill is the canonical workflow owner for implementation orchestration in the lower-tier orchestrator. It selects the right flow, prepares execution context, routes delegated work, and closes quality gates without writing product code itself.

<principles>
<canonical-source-of-truth>
This skill is the single canonical source of truth for the implementation-orchestration workflow. Keep flow selection, planning readiness, task routing, todo protocol, execution-plan steps, and review gates here rather than duplicating them in agents or prompts.
</canonical-source-of-truth>

<never-writes-product-code>
This skill never writes product code itself. It orchestrates delegation, validation, review, and escalation.
</never-writes-product-code>

<todo-role>
The todo list is the progress-control surface. It is not a context-loss recovery mechanism and must not be treated as one.
</todo-role>
</principles>

## Workflow

Use the checklist below and keep it synchronized with the todo list:

```text
Implementation orchestration progress:
- [ ] Step 0: Create flow-start todos
- [ ] Step 1: Select Quick Flow or Full Flow
- [ ] Step 2: Plan the task order
- [ ] Step 3: Run the selected flow
- [ ] Step 4: Close validation and review gates
```

### Step 0 - Start with todos

- Create todos at the start of the selected flow.
- In Quick Flow, create one todo per orchestration action.
- In Full Flow, create one todo per plan task, per review loop, per `[REUSE]` UI verification item, and per final gate.
- Consult the todo list before each action.
- Mark the matching todo complete immediately after the action finishes.
- If scope changes, update the execution plan first, then synchronize the todo list.

### Step 1 - Assess complexity and recommend a flow

Use the following decision rules before any delegation.

**Quick Flow is allowed only when every check below passes:**

| Check | Quick Flow pass condition |
| --- | --- |
| Scope width | Narrow, single-domain change with one clear implementation owner (any domain qualifies — app code, CI/CD, infra/Terraform, Kubernetes/deploy, observability, LLM prompts, E2E, etc.) |
| Solution clarity | Solution path is obvious from the task, approved plan, or existing context |
| File impact | Likely to touch 3 files or fewer |
| Ambiguity | No major ambiguity, contradiction, or unresolved tradeoff |
| Planning readiness | No missing research gap and no missing plan gap for the work being attempted |
| UI/Figma involvement | No Figma reference, no `[REUSE]` UI verification task, and no UI-verification requirement |

**Full Flow is required when any check below is true:**

| Trigger | Full Flow condition |
| --- | --- |
| Cross-domain work | Work spans multiple domains, multiple agents, or architectural boundaries |
| Ambiguity | Requirements, constraints, or acceptance criteria are incomplete or unclear |
| Research gap | Required context is missing or no complete `*.research.md` exists |
| Plan gap | No actionable `*.plan.md` exists for the current task |
| Larger scope | Likely to touch more than 3 files or requires phased execution |
| UI/Figma involvement | Any Figma involvement or UI-verification involvement exists |

**Hard exclusion:** any Figma or UI-verification involvement immediately disqualifies Quick Flow.

Use `vscode/askQuestions` to recommend Quick Flow or Full Flow, give a short reason, and allow the user to override the recommendation.

### Step 2 - Plan the task order

Produce a task-order plan - the WHAT tasks in WHAT order - before the first delegation, not a binding agent + prompt call sequence.

- Do this immediately after flow selection.
- In Full Flow, do it again after plan approval and before execution starts.
- List every planned task in order, covering each delegation, review, validation checkpoint, and UI verification item.
- Do not bind an agent or prompt to each task here; the agent + prompt per task is implied at execution time by the Execution routing table.
- Share the intended flow on chat with an explicit note that it may change as execution proceeds.
- Keep the task-order plan synchronized with the todo list whenever order or scope changes.

## Task-to-Owner Routing

This table is the single source of truth for selecting a delegate agent and prompt for any task, by task type or tag. Both Quick Flow and Full Flow consult this table — it is not duplicated elsewhere in this skill.

| Task type or tag | Delegate to | Prompt to use | Notes |
| --- | --- | --- | --- |
| app code | `tsh-software-engineer` | `tsh-implement-common-task.prompt.md` | The internal prompt should be used for standard implementation work |
| UI with Figma | `tsh-software-engineer` | `tsh-implement-ui-common-task.prompt.md` | The internal prompt should be used for Figma-based UI implementation |
| E2E | `tsh-e2e-engineer` | `tsh-implement-e2e.prompt.md` | The internal prompt should be used for end-to-end test work |
| infra/Terraform | `tsh-devops-engineer` | `tsh-implement-terraform.prompt.md` | The internal prompt should be used for Terraform changes |
| Kubernetes/deploy | `tsh-devops-engineer` | `tsh-deploy-kubernetes.prompt.md` | The internal prompt should be used for deployment or Kubernetes work |
| CI/CD | `tsh-devops-engineer` | `tsh-implement-pipeline.prompt.md` | The internal prompt should be used for pipeline work |
| observability | `tsh-devops-engineer` | `tsh-implement-observability.prompt.md` | The internal prompt should be used for logging, metrics, or tracing work |
| LLM prompts | `tsh-prompt-engineer` | `tsh-engineer-prompt.prompt.md` | The internal prompt should be used for prompt-engineering tasks |
| `[REUSE]` UI verification | `tsh-ui-reviewer` | `tsh-review-ui.prompt.md` | Review each UI item individually; do not batch |
| `[REUSE]` other | per the task definition | — | Execute as defined in the task definition; delegate to the matching implementer only when new product code is required |

Note: Quick Flow's hard UI/Figma exclusion (Step 1) means the "UI with Figma" and "`[REUSE]` UI verification" rows never apply inside Quick Flow — they are reachable only from Full Flow.

## Quick Flow

Use Quick Flow only if Step 1 passed every Quick criterion and the user selected or accepted it.

1. **Delegate implementation** - Identify the task's type or tag and delegate using the Task-to-Owner Routing table above. For a plain app-code task this is `tsh-software-engineer` with `tsh-implement-common-task.prompt.md`; for CI/CD, infra/Terraform, Kubernetes/deploy, observability, LLM-prompt, or E2E tasks, delegate to the matching owner and prompt from the table instead.
2. **Run validation checks** - After implementation, run the appropriate checks for the affected area.
3. **Delegate code review** - Delegate review to `tsh-code-reviewer` via `tsh-review.prompt.md`.
4. **Handle review results explicitly:**
   - If review passes with no required changes, complete the flow.
   - If review requests changes, ask for confirmation before changing the reviewed solution.
   - After confirmation, route fixes back to the same owner selected in Step 1, run affected validation again, and re-run review when the fix is material.
5. **Abort Quick Flow if hidden complexity appears** - If ambiguity, cross-domain work, plan gaps, or any Figma/UI-verification need appears during execution, stop Quick Flow, rewrite the execution plan, and restart in Full Flow.

## Full Flow

### Planning readiness

Check the current state before creating or executing any plan.

| Artifact or signal | Treat as ready when | If not ready |
| --- | --- | --- |
| `*.research.md` | It exists for the current task and contains enough context to explain scope, constraints, requirements, and referenced inputs or links | Route to `tsh-context-engineer` with `tsh-research.prompt.md` |
| `*.plan.md` | It exists for the current task and contains ordered, actionable tasks that can be delegated | Route to `tsh-architect` with `tsh-plan.prompt.md` |
| Open questions gate | It exists and contains no `❓ Open` rows in `## Open Questions`, so unresolved questions are not blocking execution readiness | Route to `tsh-architect` with `tsh-plan.prompt.md` |
| Technical Context | The plan has a populated `Technical Context` section with conventions, patterns, stack, and testing guidance relevant to implementation | Route to `tsh-architect` with `tsh-review-codebase.prompt.md` |
| Plan approval state | The current plan is already reviewed, approved, and unchanged since approval | Route to `tsh-architect` with `tsh-plan.prompt.md` to return a finished reviewed plan |

### Planning sequence

1. **Check for existing research and plan files** - Inspect current `*.research.md` and `*.plan.md` state first.
2. **Fill missing context when needed** - If research is missing or incomplete, delegate to `tsh-context-engineer` with `tsh-research.prompt.md`.
3. **Create or refresh the reviewed plan when needed** - If the plan is missing, stale, not actionable, or not already reviewed and approved, delegate to `tsh-architect` with `tsh-plan.prompt.md`. The architect owns producing a finished reviewed plan, including any nested `tsh-plan-reviewer` loop and its maximum of 3 review iterations. The plan MUST be authored following the `tsh-creating-implementation-plans` skill — it owns the plan template and structure rules.
4. **Create execution todos from the plan** - Create todos per plan task, not just per phase.
5. **Capture UI inventory early** - Find every `[REUSE]` UI task and every Figma URL in the plan and research files.
6. **Ask for the dev server URL when UI tasks exist** - If the UI inventory is non-empty, use `vscode/askQuestions` to get the dev server URL before execution starts.
7. **Apply the Technical Context rule** - If the plan already contains populated Technical Context, use it and skip rediscovery; otherwise delegate to `tsh-architect` with `tsh-review-codebase.prompt.md`.
8. **Use a conditional confirmation gate before execution** - Ask for confirmation before moving from planning to execution only when the plan was newly created, materially changed, escalated, or not yet approved for execution in the current thread.
9. **Rewrite the task-order plan after approval** - Refresh the ordered task list from the approved plan before the first implementation task starts; the agent + prompt for each task is resolved at execution time by the Execution routing table.

### Execution routing

Process tasks in plan order. Consult the todo list before each task and update the plan and todo list after each completed task. Use the Task-to-Owner Routing table above to select the delegate agent and prompt for each task — it is not repeated here.

### Execution rules and gates

1. **Stay inside the approved plan** - If execution requires a material deviation from the approved plan, stop and get confirmation before changing direction.
2. **Delegate by route, not by instinct** - Use the Task-to-Owner Routing table for each task and pass the plan section, technical context, and latest outputs.
3. **Update after every task** - After each task, update the plan status, update the matching todo, and run the appropriate checks for that task type.
4. **Run checks after every task** - Use the validation set that matches the changed area, such as lint, build, unit tests, integration tests, E2E checks, or infrastructure validation.
5. **Handle `[REUSE]` UI verification as a per-item loop:**
   - Process each `[REUSE]` UI verification task one item at a time in plan order.
   - Delegate each item to `tsh-ui-reviewer` with `tsh-review-ui.prompt.md`, passing the Figma URL, dev server URL, and component or section name.
   - Use `tsh-implement-ui.prompt.md` as the workflow reference for the verify-fix loop rather than duplicating that loop here.
   - Mark each item individually as **PASSED** or **ESCALATED**.
   - Never batch multiple UI verification items into one review step.
6. **Enforce the UI verification gate** - Do not start code review until every `[REUSE]` UI verification item has been individually passed or individually escalated.
7. **Run code review after the UI gate clears** - Delegate to `tsh-code-reviewer` with `tsh-review.prompt.md` only after the UI verification gate passes or is explicitly escalated per item.
8. **Confirm before changing a reviewed solution** - If code review finds issues that require changes, ask for confirmation before changing the reviewed solution.
9. **Route review fixes back through the correct implementer** - After confirmation, delegate fixes through the same routing rules, run affected checks again, and re-run review when needed.
10. **Treat direct implementation as a workflow violation** - If the orchestrator starts writing product code directly, stop that path, return to delegated execution, and continue only through the correct owner.
11. **Record solution changes in the plan Changelog** - When the approved solution changes during implementation, or when a workflow deviation occurs, document it in the plan file's Changelog section with timestamps after the change is confirmed.

### Preservation coverage

Keep the workflow traceable to the plan's preserved branches:

| Coverage area | Preserved checklist items |
| --- | --- |
| Step 0 flow selection | 1-4 |
| Quick Flow delegation and review | 5-8 |
| Full Flow planning, reviewed-plan handoff, and context handling | 9-14 |
| Execution routing and quality gates | 15-26 |
| UI verification enforcement loop | 40-44 |

## Connected Skills

- `tsh-technical-context-discovering` - defines when existing Technical Context is sufficient and when discovery should be skipped or delegated.
- `tsh-code-reviewing` - strengthens the final review gate and keeps implementation quality checks explicit.
- `tsh-ui-verifying` - provides the verification standard behind the per-item UI review gate.
- `tsh-task-analysing` - helps determine whether research context is complete before planning starts.
- `tsh-task-quality-reviewing` - complements planning quality by reinforcing explicit gaps, edge cases, and task completeness.
- `tsh-creating-implementation-plans` - owns the plan template and plan-structure rules used in the planning sequence.
