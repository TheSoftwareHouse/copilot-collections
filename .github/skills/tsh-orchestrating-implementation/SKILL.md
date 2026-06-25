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

<never-edits-files-directly>
This skill never edits any file directly; it always delegates every file change to the owning specialist. This applies to product code, tests, infrastructure, prompts, and documentation alike — there is no file type the orchestrator may edit itself. It orchestrates delegation, validation, review, and escalation only.
</never-edits-files-directly>

<read-search-routing-only>
The `read` and `search` tools are used only to validate routing and delegation decisions, never to research or solve the task directly. Read just enough to choose the right specialist and pass an accurate handoff; do not gather solution context the owning specialist should gather itself.
</read-search-routing-only>

<last-resort-stop-or-ask>
If no suitable specialist agent exists for a required file change, stop and ask the user instead of self-executing the edit. Self-execution is never the fallback.
</last-resort-stop-or-ask>

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

| Check                | Quick Flow pass condition                                                                                                                                                            |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Scope width          | Narrow, single-domain change with one clear implementation owner (any domain qualifies — app code, CI/CD, infra/Terraform, Kubernetes/deploy, observability, LLM prompts, E2E, etc.) |
| Solution clarity     | Solution path is obvious from the task, approved plan, or existing context                                                                                                           |
| File impact          | Likely to touch 3 files or fewer                                                                                                                                                     |
| Ambiguity            | No major ambiguity, contradiction, or unresolved tradeoff                                                                                                                            |
| Planning readiness   | No missing research gap and no missing plan gap for the work being attempted                                                                                                         |
| UI/Figma involvement | No Figma reference, no `[REUSE]` UI verification task, and no UI-verification requirement                                                                                            |

**Full Flow is required when any check below is true:**

| Trigger              | Full Flow condition                                                         |
| -------------------- | --------------------------------------------------------------------------- |
| Cross-domain work    | Work spans multiple domains, multiple agents, or architectural boundaries   |
| Ambiguity            | Requirements, constraints, or acceptance criteria are incomplete or unclear |
| Research gap         | Required context is missing or no complete `*.research.md` exists           |
| Plan gap             | No actionable `*.plan.md` exists for the current task                       |
| Larger scope         | Likely to touch more than 3 files or requires phased execution              |
| UI/Figma involvement | Any Figma involvement or UI-verification involvement exists                 |

**Hard exclusion:** any Figma or UI-verification involvement immediately disqualifies Quick Flow. UI-verification involvement is broad: ANY change to rendered UI on a Figma-backed screen — layout, spacing, sizing, width/height caps, flex/grid, alignment, typography, colors, or component structure — counts as UI-verification work, even when no `[REUSE]` task or Figma URL is currently in hand. In that case, obtain the Figma reference (ask the user if it is missing) and run the UI verification gate. Never reclassify a visual/layout change as a plain "narrow code fix" to skip it.

**Repository-documentation requests** — when the work only touches repository documentation (README, CHANGELOG, in-repo `/docs`, or the published documentation site) — are recognized as a first-class documentation work type and routed to `tsh-technical-writer` via the Execution routing table, never improvised or self-executed.

Use `vscode/askQuestions` to recommend Quick Flow or Full Flow, give a short reason, and allow the user to override the recommendation.

If the selected execution path would proceed without an approved plan, use `vscode/askQuestions` to confirm the user wants no-plan execution before delegating any implementation work.

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

| Task type or tag              | Delegate to             | Prompt to use                            | Notes                                                                                                                                                                                                                                                 |
| ----------------------------- | ----------------------- | ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| app code (plan task)          | `tsh-plan-implementor`  | `tsh-implement-common-task.prompt.md`    | DEFAULT route in both Quick Flow and Full Flow for approved, actionable, low-risk plan seams that must be executed exactly as written                                                                                                                 |
| app code (complex or no-plan) | `tsh-software-engineer` | `tsh-implement-common-task.prompt.md`    | EXCEPTION route for complex non-UI work, or for no-plan non-UI execution after the no-plan confirmation gate; choose `GPT-5.3-Codex` for medium-reasoning precision on complex work, or `Gemini 3.5 Flash` for fast, low-cost, large-context analysis |
| UI with Figma                 | `tsh-ui-engineer`       | `tsh-implement-ui-common-task.prompt.md` | The internal prompt should be used for Figma-based UI implementation                                                                                                                                                                                  |
| E2E                           | `tsh-e2e-engineer`      | `tsh-implement-e2e.prompt.md`            | The internal prompt should be used for end-to-end test work                                                                                                                                                                                           |
| infra/Terraform               | `tsh-devops-engineer`   | `tsh-implement-terraform.prompt.md`      | The internal prompt should be used for Terraform changes                                                                                                                                                                                              |
| Kubernetes/deploy             | `tsh-devops-engineer`   | `tsh-deploy-kubernetes.prompt.md`        | The internal prompt should be used for deployment or Kubernetes work                                                                                                                                                                                  |
| CI/CD                         | `tsh-devops-engineer`   | `tsh-implement-pipeline.prompt.md`       | The internal prompt should be used for pipeline work                                                                                                                                                                                                  |
| observability                 | `tsh-devops-engineer`   | `tsh-implement-observability.prompt.md`  | The internal prompt should be used for logging, metrics, or tracing work                                                                                                                                                                              |
| LLM prompts                   | `tsh-prompt-engineer`   | `tsh-engineer-prompt.prompt.md`          | The internal prompt should be used for prompt-engineering tasks                                                                                                                                                                                       |
| documentation                 | `tsh-technical-writer`  | `tsh-write-documentation.prompt.md`      | The internal prompt should be used for repository documentation work across all targets — README, CHANGELOG, `/docs`, and the published documentation site                                                                                            |
| `[REUSE]` UI verification     | `tsh-ui-reviewer`       | `tsh-review-ui.prompt.md`                | Review each UI item individually; do not batch                                                                                                                                                                                                        |
| `[REUSE]` other               | per the task definition | —                                        | Execute as defined in the task definition; delegate to the matching implementer only when new product code is required                                                                                                                                |

Note: Quick Flow's hard UI/Figma exclusion (Step 1) means the "UI with Figma" and "`[REUSE]` UI verification" rows never apply inside Quick Flow — they are reachable only from Full Flow. Apply the app-code decision rule consistently in both flows: `tsh-plan-implementor` is the DEFAULT route for approved, actionable, low-risk plan seams, while `tsh-software-engineer` is the EXCEPTION route for complex non-UI work or no-plan non-UI execution after the no-plan confirmation gate.

## Quick Flow

Use Quick Flow only if Step 1 passed every Quick criterion and the user selected or accepted it.

1. **Delegate implementation** - Identify the task's type or tag and delegate using the Task-to-Owner Routing table above. For a plain app-code task, use `tsh-plan-implementor` with `tsh-implement-common-task.prompt.md` when an approved, actionable, low-risk plan seam already exists; otherwise route to `tsh-software-engineer` with the same prompt after the no-plan confirmation gate. For CI/CD, infra/Terraform, Kubernetes/deploy, observability, LLM-prompt, or E2E tasks, delegate to the matching owner and prompt from the table instead. Quick Flow does NOT cover visual/layout UI changes on Figma-backed screens — those carry a UI-verification requirement and must run in Full Flow with the live-capture + Figma verification gate; never treat a layout/CSS/sizing change as a plain narrow code change to keep it in Quick Flow.
2. **Run validation checks** - After implementation, run the appropriate checks for the affected area. These checks (type checks, build, unit/integration tests) confirm the code is sound; they do NOT verify the UI against Figma and are never a substitute for the UI verification gate. "It compiles" and "the slice is type-clean" do not mean the layout matches the design.
3. **Delegate code review** - Delegate review to `tsh-code-reviewer` via `tsh-review.prompt.md`.
4. **Handle review results explicitly:**
   - If review passes with no required changes, complete the flow.
   - If review requests changes, ask for confirmation before changing the reviewed solution.
   - After confirmation, route fixes back through the same app-code decision rule used in Step 1, run affected validation again, and re-run review when the fix is material.
5. **Abort Quick Flow if hidden complexity appears** - If ambiguity, cross-domain work, plan gaps, or any Figma/UI-verification need appears during execution, stop Quick Flow, rewrite the execution plan, and restart in Full Flow.

## Full Flow

### Planning readiness

Check the current state before creating or executing any plan.

| Artifact or signal  | Treat as ready when                                                                                                                     | If not ready                                                                          |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| `*.research.md`     | It exists for the current task and contains enough context to explain scope, constraints, requirements, and referenced inputs or links  | Route to `tsh-context-engineer` with `tsh-research.prompt.md`                         |
| `*.plan.md`         | It exists for the current task and contains ordered, actionable tasks that can be delegated                                             | Route to `tsh-architect` with `tsh-plan.prompt.md`                                    |
| Open questions gate | It exists and contains no `❓ Open` rows in `## Open Questions`, so unresolved questions are not blocking execution readiness           | Route to `tsh-architect` with `tsh-plan.prompt.md`                                    |
| Technical Context   | The plan has a populated `Technical Context` section with conventions, patterns, stack, and testing guidance relevant to implementation | Route to `tsh-architect` with `tsh-review-codebase.prompt.md`                         |
| Plan approval state | The current plan is already reviewed, approved, and unchanged since approval                                                            | Route to `tsh-architect` with `tsh-plan.prompt.md` to return a finished reviewed plan |

### Planning sequence

1. **Check for existing research and plan files** - Inspect current `*.research.md` and `*.plan.md` state first.
2. **Fill missing context when needed** - If research is missing or incomplete, delegate to `tsh-context-engineer` with `tsh-research.prompt.md`.
3. **Create or refresh the reviewed plan when needed** - If the plan is missing, stale, not actionable, or not already reviewed and approved, delegate to `tsh-architect` with `tsh-plan.prompt.md`. The architect owns producing a finished reviewed plan, including any nested `tsh-plan-reviewer` loop and its maximum of 3 review iterations. The plan MUST be authored following the `tsh-creating-implementation-plans` skill — it owns the plan template and structure rules.
4. **Create execution todos from the plan** - Create todos per plan task, not just per phase.
5. **Capture UI inventory early** - Find every `[REUSE]` UI task and every Figma URL in the plan and research files.
6. **Ask for the dev server URL when UI tasks exist** - If the UI inventory is non-empty, use `vscode/askQuestions` to get the exact user-confirmed full dev server URL before execution starts. Treat it as a pinned session input and forward it unchanged through every reviewer and capture delegation.
7. **Apply the Technical Context rule** - If the plan already contains populated Technical Context, use it and skip rediscovery; otherwise delegate to `tsh-architect` with `tsh-review-codebase.prompt.md`.
8. **Use a conditional confirmation gate before execution** - Ask for confirmation before moving from planning to execution only when the plan was newly created, materially changed, escalated, or not yet approved for execution in the current thread.
9. **Rewrite the task-order plan after approval** - Refresh the ordered task list from the approved plan before the first implementation task starts; the agent + prompt for each task is resolved at execution time by the Execution routing table.

### Execution routing

Process tasks in plan order. Consult the todo list before each task and update the plan and todo list after each completed task. Use the Task-to-Owner Routing table above to select the delegate agent and prompt for each task — it is not repeated here. Apply the app-code decision rule consistently during execution and follow-up fixes: `tsh-plan-implementor` is the DEFAULT route for approved, actionable, low-risk plan seams, while `tsh-software-engineer` is the EXCEPTION route for complex non-UI work or no-plan non-UI execution after the no-plan confirmation gate.

### Execution rules and gates

1. **Stay inside the approved plan** - If execution requires a material deviation from the approved plan, stop and get confirmation before changing direction.
2. **Gate no-plan execution explicitly** - If the selected route would proceed without an approved plan, confirm the user wants no-plan execution with `vscode/askQuestions` before delegating the work.
3. **Delegate by route with an explicit handoff contract** - Use the routing table for each task and hand off a bounded task slice, the relevant technical context, and a targeted summary of the prior worker's actionable output. Do not dump raw prior output or unscoped context; give the specialist exactly the slice they own plus the context they need to execute it.
4. **Update after every task** - After each task, update the plan status, update the matching todo, and run the appropriate checks for that task type.
5. **Run checks after every task** - Use the validation set that matches the changed area, such as lint, build, unit tests, integration tests, E2E checks, or infrastructure validation.
6. **Handle `[REUSE]` UI verification as a per-item loop:**
   - Process each `[REUSE]` UI verification task one item at a time in plan order.
   - First delegate each item to `tsh-ui-capture-worker`, passing the pinned user-confirmed full dev server URL unchanged and the current iteration artifact directory.
   - **Hard ordering gate (do not skip):** You must not invoke `tsh-ui-reviewer` until a `tsh-ui-capture-worker` pass has completed for the current iteration AND you have confirmed that `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml` exist in the iteration artifact directory. Invoking the reviewer without these artifacts is a process error — the reviewer will return `VERIFICATION NOT RUN` and no comparison happens.
   - **Never assume capture is unavailable.** `tsh-ui-capture-worker` is loaded in agent discovery and is invocable with `runSubagent` exactly like every other worker you delegate to. Do not claim, infer, or tell the reviewer that the capture worker is unavailable, missing, or not exposed unless an actual `runSubagent` invocation of `tsh-ui-capture-worker` has failed. A belief about availability is never a reason to skip capture or to delegate review without artifacts.
   - Then delegate the same item to `tsh-ui-reviewer` with `tsh-review-ui.prompt.md`, passing the Figma URL, the same pinned full dev server URL unchanged, the component or section name, and the exact artifact directory produced by `tsh-ui-capture-worker`.
   - This delegated capture-plus-review sequence is mandatory. The orchestrator/main agent must never perform the UI verification step itself, never collect EXPECTED/ACTUAL as a fallback, and never substitute code review, compile/typecheck results, or ad hoc browser inspection for a real `tsh-ui-capture-worker` pass followed by a real `tsh-ui-reviewer` pass.
   - The orchestrator/main agent must not infer a Figma MCP blocker from its own tool access. Once a valid Figma URL exists, delegate to `tsh-ui-reviewer` and let the reviewer runtime determine whether `figma` is actually unavailable.
   - **Authentication and access gates are user-owned blockers.** Neither the orchestrator nor any capture or review worker may bypass, fake, seed, inject, or otherwise work around a login or access/permission gate by any means. If capture escalates that the target requires authentication or a specific access level, surface it to the user through `vscode/askQuestions` (not plain assistant text) and let the user specify how authentication must be performed (credentials, an already-authenticated session, or a manual login). Never accept or perform a self-authenticated workaround, and never run verification against a fabricated signed-in state. If capture flags the gate as trivially bypassable (a potential security vulnerability), relay that warning to the user in the same `vscode/askQuestions` call so they can note it and plan remediation.
   - Every UI verification item requires fresh live-capture artifacts from `tsh-ui-capture-worker` (`actual.png`, `computed-styles.json`, `a11y-snapshot.yml`) before the reviewer can issue a verdict. If any artifact is missing, run capture first; a code-only or artifact-less assessment is invalid and cannot mark the item PASSED or ESCALATED.
   - If `tsh-ui-reviewer` cannot be invoked, if `figma` is unavailable to the reviewer, or if `tsh-ui-capture-worker` cannot be invoked by the caller, the item remains `VERIFICATION NOT RUN` and returns to blocker resolution. Tool or subagent unavailability is not permission for the orchestrator to self-execute the verification step.
   - Ask the user to enable Figma MCP or provide an exported Figma reference image only after a delegated `tsh-ui-reviewer` pass explicitly reports a Figma-side blocker. Do not raise that blocker from caller-side assumptions.
   - `VERIFICATION NOT RUN` remains a distinct non-terminal tracking state while a capture or review blocker is unresolved. Treat it as a pre-verification blocker path that returns the item to blocker resolution, not to the post-budget escalation gate. It cannot close the item, cannot be treated as PASSED or ESCALATED, and cannot open code review.
   - If a UI finding leads to a fix, return that item to NOT-VERIFIED and run a fresh capture plus a fresh `tsh-ui-reviewer` pass on the new artifacts before the item can be marked PASSED. Never close the item on a pre-fix verification.
   - When the 5-iteration budget is exhausted with remaining gaps, route through the structured `vscode/askQuestions` gate defined in `tsh-implement-ui.prompt.md` rather than improvising a local escalation path.
   - ESCALATED is narrow: it means a genuine blocker that the user has explicitly acknowledged, such as unresolved auth, ambiguous or intentional design intent, or a capability limit after the maximum verify-fix iterations. After max iterations, `ESCALATED` requires the user's explicit stop or acknowledgement choice from that structured gate. Missing capture, fixed-but-not-reverified, and partial code-only review are incomplete verifications, not valid escalations.
   - Use `tsh-implement-ui.prompt.md` as the workflow reference for the verify-fix loop rather than duplicating that loop here.
   - Mark each item individually as **PASSED** or **ESCALATED**.
   - Never batch multiple UI verification items into one review step.
7. **Enforce the UI verification gate** - Do not start code review until every UI/visual/layout change on a Figma-backed screen has cleared the live-capture + Figma verification loop (`tsh-ui-capture-worker` artifacts compared by `tsh-ui-reviewer`, iterated up to 5) and is individually PASSED or individually ESCALATED. This applies to every visual/layout change, not only to changes that happen to carry a `[REUSE]` task. Type checks, build, unit/integration tests, and code review are NOT UI verification and can never substitute for it — "it compiles" and "code review passed" do not mean the UI matches Figma.
8. **Run code review after the UI gate clears** - Delegate to `tsh-code-reviewer` with `tsh-review.prompt.md` only after the UI verification gate passes or is explicitly escalated per item.
   - Treat UI verification and code review as separate gates with separate owners and separate outputs. Do not communicate or batch them as one combined step, and report UI verification status separately from code review status.
9. **Confirm before changing a reviewed solution** - If code review finds issues that require changes, ask for confirmation before changing the reviewed solution.
10. **Route review fixes back through the correct implementer** - After confirmation, package the review findings as a structured follow-up list (one actionable item per finding, scoped to its owner) and delegate the fixes through the same routing rules rather than dumping raw review commentary; run affected checks again, and re-run review when needed.
11. **Treat any direct file edit as a workflow violation** - The orchestrator never edits any file directly; always delegates every file change to the owning specialist. If the orchestrator starts editing any file itself, stop that path, return to delegated execution, and continue only through the correct owner. If no suitable specialist exists, stop and ask the user.
12. **Record solution changes in the plan Changelog** - When the approved solution changes during implementation, or when a workflow deviation occurs, document it in the plan file's Changelog section with timestamps after the change is confirmed.

### Preservation coverage

Keep the workflow traceable to the plan's preserved branches:

| Coverage area                                                   | Preserved checklist items |
| --------------------------------------------------------------- | ------------------------- |
| Step 0 flow selection                                           | 1-4                       |
| Quick Flow delegation and review                                | 5-8                       |
| Full Flow planning, reviewed-plan handoff, and context handling | 9-14                      |
| Execution routing and quality gates                             | 15-26                     |
| UI verification enforcement loop                                | 40-44                     |

## Connected Skills

- `tsh-technical-context-discovering` - defines when existing Technical Context is sufficient and when discovery should be skipped or delegated.
- `tsh-code-reviewing` - strengthens the final review gate and keeps implementation quality checks explicit.
- `tsh-ui-verifying` - provides the verification standard behind the per-item UI review gate.
- `tsh-task-analysing` - helps determine whether research context is complete before planning starts.
- `tsh-task-quality-reviewing` - complements planning quality by reinforcing explicit gaps, edge cases, and task completeness.
- `tsh-creating-implementation-plans` - owns the plan template and plan-structure rules used in the planning sequence.
