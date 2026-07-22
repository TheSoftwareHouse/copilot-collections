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

Use the following decision rules before any delegation. Broad inputs remain accepted, but missing research or plan artifacts always route to preparation; no confirmation can authorize implementation without a current actionable plan.

**Quick Flow is allowed only when every check below passes:**

| Check                | Quick Flow pass condition                                                                                                                                                            |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Scope width          | Narrow, single-domain change with one clear implementation owner (any domain qualifies — app code, CI/CD, infra/Terraform, Kubernetes/deploy, observability, LLM prompts, E2E, etc.) |
| Solution clarity     | Solution path is obvious from the task, Human-approved plan, or existing context                                                                                                    |
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

If research or a plan is missing, route to the preparation sequence in Full Flow before selecting an implementation owner. Do not offer or authorize no-plan implementation.

### Step 2 - Plan the task order

Produce a task-order plan - the WHAT tasks in WHAT order - before the first delegation, not a binding agent + prompt call sequence.

- Do this immediately after flow selection.
- In Full Flow, do it again after Human approval and before execution starts.
- List every planned task in order, covering each delegation, review, validation checkpoint, and UI verification item.
- Do not bind an agent or prompt to each task here; the agent + prompt per task is implied at execution time by the Execution routing table.
- Share the intended flow on chat with an explicit note that it may change as execution proceeds.
- Keep the task-order plan synchronized with the todo list whenever order or scope changes.

## Task-to-Owner Routing

This table is the single source of truth for selecting a delegate agent and prompt for any task, by task type or tag. Both Quick Flow and Full Flow consult this table — it is not duplicated elsewhere in this skill.

| Task type or tag              | Delegate to             | Prompt to use                            | Notes                                                                                                                                                                                                                                                 |
| ----------------------------- | ----------------------- | ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| app code (plan task)          | `tsh-plan-implementor`  | `tsh-implement-common-task.prompt.md`    | DEFAULT route in both Quick Flow and Full Flow for a Human-approved plan revision's actionable, low-risk plan seams that must be executed exactly as written                                                                                          |
| app code (complex)            | `tsh-software-engineer` | `tsh-implement-common-task.prompt.md`    | EXCEPTION route for complex non-UI work; choose `GPT-5.3-Codex` for medium-reasoning precision on complex work, or `Gemini 3.5 Flash` for fast, low-cost, large-context analysis |
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

Note: Quick Flow's hard UI/Figma exclusion (Step 1) means the "UI with Figma" and "`[REUSE]` UI verification" rows never apply inside Quick Flow — they are reachable only from Full Flow. Apply the app-code decision rule consistently in both flows: `tsh-plan-implementor` is the DEFAULT route for actionable, low-risk plan seams, while `tsh-software-engineer` is the EXCEPTION route for complex non-UI work.

## Material Revision Handling

This rule is universal: it applies identically inside Quick Flow and Full Flow, and at any point before implementation completion — including execution discovery, a workflow deviation, a `Request changes` response, or a review-driven solution change.

Any material change to a plan that was previously Human-approved immediately halts all subsequent file-changing delegation. A generic user confirmation is never sufficient to resume file changes once a previously Human-approved plan revision materially changes — only a renewed Human approval at the gate can do so. Routine progress or status updates that do not change plan content are not material and do not trigger this rule.

When a material revision occurs:

1. `tsh-architect` increments the Plan Revision, sets `Human Decision=PENDING`, clears `Approved Revision`, and records the reason in the plan file's Changelog section.
2. Mandatory automated re-review by `tsh-plan-reviewer` follows, with NO low-risk exemption. The only low-risk automated-review exemption anywhere in this workflow is initial preparation before any Human approval has ever been recorded; it never applies once a plan has been Human-approved at least once.
3. `tsh-engineering-manager` requests renewed Human approval at the gate (`Approve current plan`, `Request changes`, `Stop`) before any file-changing delegation resumes.

## Quick Flow

Use Quick Flow only if Step 1 passed every Quick criterion and the user selected or accepted it.

1. **Pass the Human approval gate** - Before the first file-changing delegation, confirm reviewer readiness separately from Human approval readiness. Before any Human approval has ever been recorded for this plan, reviewer readiness is satisfied by either (a) `tsh-plan-reviewer` Reviewer approval `APPROVED` documented in a plan-review report/path, or (b) an explicitly recorded valid low-risk automated-review exemption for initial plan preparation from `tsh-architect`. Then present the exact current plan path, the plan's current contents, the current Plan Revision, and the review path when present. When readiness rests on the exemption instead of a review report, state plainly that no reviewer report exists because the initial-preparation exemption is the documented readiness basis; never let the exemption substitute for Human approval itself. Offer exactly: `Approve current plan`, `Request changes`, `Stop`. `Approve current plan` authorizes every unchanged task in that plan revision, not only the next delegation. `Request changes` returns to `tsh-architect`; `Stop` ends without implementation.
2. **Delegate implementation** - Identify the task's type or tag and delegate using the Task-to-Owner Routing table above. For a plain app-code task, use `tsh-plan-implementor` with `tsh-implement-common-task.prompt.md` for an actionable, low-risk plan seam; use `tsh-software-engineer` only for complex non-UI work. For CI/CD, infra/Terraform, Kubernetes/deploy, observability, LLM-prompt, or E2E tasks, delegate to the matching owner and prompt from the table instead. Quick Flow does NOT cover visual/layout UI changes on Figma-backed screens — those carry a UI-verification requirement and must run in Full Flow with the live-capture + Figma verification gate; never treat a layout/CSS/sizing change as a plain narrow code change to keep it in Quick Flow.
3. **Run validation checks** - After implementation, run the appropriate checks for the affected area. These checks (type checks, build, unit/integration tests) confirm the code is sound; they do NOT verify the UI against Figma and are never a substitute for the UI verification gate. "It compiles" and "the slice is type-clean" do not mean the layout matches the design.
4. **Delegate code review** - Delegate review to `tsh-code-reviewer` via `tsh-review.prompt.md`.
5. **Handle review results explicitly:**
   - If review passes with no required changes, complete the flow.
   - If review requests changes, first classify the fix: non-material and staying within the unchanged current Human-approved plan revision, or material to that revision.
   - A non-material, plan-conforming fix routes directly to the appropriate owner via the same app-code decision rule used in Step 1, then is validated and re-reviewed as needed; no repeated user approval is required for this path.
   - If the fix causes or reveals a material change to a previously Human-approved plan revision, apply **Material Revision Handling** above instead of routing the fix: halt subsequent file-changing delegation, reset the Plan Revision and record it in the plan's Changelog, run the mandatory automated re-review with no low-risk exemption, then resume only after renewed Human approval through the exact gate choices.
6. **Abort Quick Flow if hidden complexity appears** - If ambiguity, cross-domain work, plan gaps, or any Figma/UI-verification need appears during execution, stop Quick Flow, rewrite the execution plan, and restart in Full Flow.

## Full Flow

### Planning readiness

Check the current state before creating or executing any plan.

| Artifact or signal  | Treat as ready when                                                                                                                     | If not ready                                                                          |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| `*.research.md`     | It exists for the current task and contains enough context to explain scope, constraints, requirements, and referenced inputs or links  | Route to `tsh-context-engineer` with `tsh-research.prompt.md`                         |
| `*.plan.md`         | It exists for the current task and contains ordered, actionable tasks that can be delegated                                             | Route to `tsh-architect` with `tsh-plan.prompt.md`                                    |
| Open questions gate | It exists and contains no `❓ Open` rows in `## Open Questions`, so unresolved questions are not blocking execution readiness           | Route to `tsh-architect` with `tsh-plan.prompt.md`                                    |
| Technical Context   | The plan has a populated `Technical Context` section with conventions, patterns, stack, and testing guidance relevant to implementation | Route to `tsh-architect` with `tsh-review-codebase.prompt.md`                         |
| Reviewer readiness | Before any Human approval has ever been recorded, satisfied by either an automated `APPROVED` verdict from `tsh-plan-reviewer` recorded in its review report, or an explicitly recorded valid low-risk automated-review exemption for initial plan preparation from `tsh-architect`; after any Human approval has ever been recorded, only the `APPROVED` verdict satisfies this row | Route to `tsh-architect` with `tsh-plan.prompt.md` to return a finished reviewed plan or an explicitly stated valid exemption |
| Human approval state | The plan's persisted Human Approval record matches the current revision and valid timestamp                                             | Present the mandatory Human approval gate before the first file-changing delegation |

### Planning sequence

1. **Check for existing research and plan files** - Inspect current `*.research.md` and `*.plan.md` state first.
2. **Fill missing context when needed** - If research is missing or incomplete, delegate to `tsh-context-engineer` with `tsh-research.prompt.md`.
3. **Create or refresh the reviewed plan when needed** - If the plan is missing, stale, not actionable, or not reviewer-ready, delegate to `tsh-architect` with `tsh-plan.prompt.md`. The architect owns producing a finished reviewed plan, including any nested `tsh-plan-reviewer` loop and its maximum of 3 review iterations. The plan MUST be authored following the `tsh-creating-implementation-plans` skill — it owns the plan template and structure rules. Missing research always routes to `tsh-context-engineer` first; missing plans always route to `tsh-architect`.
4. **Create execution todos from the plan** - Create todos per plan task, not just per phase.
5. **Capture UI inventory early** - Find every `[REUSE]` UI task and every Figma URL in the plan and research files. If a Figma-backed UI task does not have a Figma reference, stop and get it from the user before execution starts.
6. **Ask for the dev server URL when UI tasks exist** - If the UI inventory is non-empty, use `vscode/askQuestions` to get the exact user-confirmed full dev server URL before execution starts. Treat it as a pinned session input and forward it unchanged through every reviewer and capture delegation.
7. **Apply the Technical Context rule** - If the plan already contains populated Technical Context, use it and skip rediscovery; otherwise delegate to `tsh-architect` with `tsh-review-codebase.prompt.md`.
8. **Separate reviewer readiness from Human approval readiness** - `tsh-plan-reviewer` `APPROVED` is Reviewer approval only and never execution permission. Before any Human approval has ever been recorded for this plan, reviewer readiness is satisfied by either (a) that `APPROVED` verdict documented in a plan-review report/path, or (b) `tsh-architect` explicitly stating a valid low-risk automated-review exemption for initial plan preparation in its handoff — either basis is sufficient, and neither substitutes for Human approval. Once any Human approval has ever been recorded for this plan, the exemption is no longer available: any material revision requires the mandatory automated re-review verdict, with no exemption, before renewed Human approval.
9. **Pass the Human approval gate before execution** - Before the first file-changing delegation, present the exact current plan path, the plan's current contents, the current Plan Revision, and the review path when present. When reviewer readiness rests on the initial-plan low-risk exemption instead of a review report, state plainly that no reviewer report exists because the initial-preparation exemption is the documented readiness basis; never let the exemption substitute for Human approval itself. Offer exactly: `Approve current plan`, `Request changes`, `Stop`. `Approve current plan` authorizes every unchanged task in that revision, in plan order; `Request changes` returns to `tsh-architect`; `Stop` ends without implementation.
10. **Rewrite the task-order plan after approval** - Refresh the ordered task list from the current Human-approved plan revision before the first implementation task starts; the agent + prompt for each task is resolved at execution time by the Execution routing table.

### Execution routing

Process tasks in plan order. Consult the todo list before each task and update the plan and todo list after each completed task. Use the Task-to-Owner Routing table above to select the delegate agent and prompt for each task — it is not repeated here. Apply the app-code decision rule consistently during execution and follow-up fixes: `tsh-plan-implementor` is the DEFAULT route for actionable, low-risk plan seams, while `tsh-software-engineer` is the EXCEPTION route for complex non-UI work.

### Execution rules and gates

1. **Stay inside the Human-approved plan** - Execute the Human-approved plan revision as written. If execution requires a material deviation, stop immediately and apply **Material Revision Handling** — a generic confirmation from the user is never sufficient on its own to resume file changes.
2. **Require current Human approval** - Before any file-changing delegation, the delegation must identify a plan whose persisted record satisfies exactly: `Human Decision=APPROVED`, `Approved Revision=current Plan Revision`, and `Decision Timestamp` is valid ISO 8601 UTC ending in `Z`. Missing, stale, mismatched, inferred, or Reviewer-only approval returns to `tsh-engineering-manager` and cannot be bypassed by direct invocation.
3. **Handle a material plan revision** - Apply **Material Revision Handling** above in full whenever `Request changes`, execution discovery, a workflow deviation, or a review-driven solution change materially revises a previously Human-approved plan. A fresh session may reuse persisted approval only when `Human Decision=APPROVED`, `Approved Revision=current Plan Revision`, and `Decision Timestamp` is valid ISO 8601 UTC ending in `Z`; otherwise return to `tsh-engineering-manager` for the gate.
4. **Delegate by route with an explicit handoff contract** - Use the routing table for each task and hand off a bounded task slice, the relevant technical context, and a targeted summary of the prior worker's actionable output. Do not dump raw prior output or unscoped context; give the specialist exactly the slice they own plus the context they need to execute it. For any Figma-backed UI task, the handoff MUST include the Figma URL or node reference; if it is missing, use `vscode/askQuestions` to obtain it before delegating. `tsh-ui-engineer` must fetch and review that design before coding.
5. **Update after every task** - After each task, update the plan status, update the matching todo, and run the appropriate checks for that task type.
6. **Run checks after every task** - Use the validation set that matches the changed area, such as lint, build, unit tests, integration tests, E2E checks, or infrastructure validation.
7. **Handle `[REUSE]` UI verification as a per-item loop:**
   - Process each `[REUSE]` UI verification task one item at a time in plan order.
   - Before the first pass for an item, define the shared verification root as `specifications/<task-id>/ui-verification` and reuse `specifications/<task-id>/ui-verification/figma-expected.png` across all iterations for that item while the Figma URL/node remains unchanged. Do not create per-iteration copies of the Figma reference image.
   - First delegate each item to `tsh-ui-capture-worker`, passing the pinned user-confirmed full dev server URL unchanged, the current iteration artifact directory, and, when authentication is already prepared, either the local `.env` contract derived from the real login form or an already-authenticated storage-state path. If those inputs were not prepared yet and the worker hits a standard login redirect, it must return the exact derived env var names the caller should ask the user to add to repo-root `.env`, then rerun capture. The worker must reload `.env` on the next pass so user edits made during the same flow are picked up immediately. Never tell the worker to use credentials "from the current thread."
   - **Hard ordering gate (do not skip):** You must not invoke `tsh-ui-reviewer` until a `tsh-ui-capture-worker` pass has completed for the current iteration AND you have confirmed that `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml` exist in the iteration artifact directory. Invoking the reviewer without these artifacts is a process error — the reviewer will return `VERIFICATION NOT RUN` and no comparison happens.
   - **Never assume capture is unavailable.** `tsh-ui-capture-worker` is loaded in agent discovery and is invocable with `runSubagent` exactly like every other worker you delegate to. Do not claim, infer, or tell the reviewer that the capture worker is unavailable, missing, or not exposed unless an actual `runSubagent` invocation of `tsh-ui-capture-worker` has failed. A belief about availability is never a reason to skip capture or to delegate review without artifacts.
   - Then delegate the same item to `tsh-ui-reviewer` with `tsh-review-ui.prompt.md`, passing the Figma URL, the same pinned full dev server URL unchanged, the component or section name, and the exact artifact directory produced by `tsh-ui-capture-worker`.
   - This delegated capture-plus-review sequence is mandatory. The orchestrator/main agent must never perform the UI verification step itself, never collect EXPECTED/ACTUAL as a fallback, and never substitute code review, compile/typecheck results, or ad hoc browser inspection for a real `tsh-ui-capture-worker` pass followed by a real `tsh-ui-reviewer` pass.
   - The orchestrator/main agent must not infer a Figma MCP blocker from its own tool access. Once a valid Figma URL exists, delegate to `tsh-ui-reviewer` and let the reviewer runtime determine whether `figma` is actually unavailable.
   - **Authentication and access gates require explicit user-owned inputs.** Neither the orchestrator nor any capture or review worker may bypass, fake, seed, inject, or otherwise work around a login or access/permission gate by any means. If capture escalates that the target redirected to a standard login form, the default next step is repo-root `.env`: ask the user through `vscode/askQuestions` to add the exact env vars returned by `tsh-ui-capture-worker` to `.env` and confirm when the file is saved. For standard forms, those vars are derived one-per-field using `TSH_UI_LOGIN_<NORMALIZED_FIELD_KEY>`, where `NORMALIZED_FIELD_KEY` is computed from `name` -> `autocomplete` -> `id` -> visible label text and normalized to uppercase snake case. A genuine login through the application's real sign-in UI is allowed; bypass is not. After the user confirms the `.env` update, rerun capture and require the worker to reload `.env` so the new values are picked up immediately without the user pasting secrets into chat. Direct manual login and an already-authenticated storage-state path are fallbacks for non-standard auth such as SSO, MFA, captcha, or when the runtime cannot derive field keys or load `.env` reliably. Forward only the prepared env-based inputs or storage-state path in the capture delegation payload, never by saying the worker should use credentials "from the current thread." Prefer the login-once-then-reuse-state pattern after a successful real login: save the authenticated session to a secret path outside `specifications/**`, pass that storage-state path to later iterations, and never persist credentials in plans, specs, or reports. If capture flags the gate as trivially bypassable (a potential security vulnerability), relay that warning to the user in the same `vscode/askQuestions` call so they can note it and plan remediation.
     Use this exact message pattern when asking the user:
     "The page redirected to login. Add these exact vars to repo-root `.env` and tell me when the file is saved:
     - [DERIVED_ENV_VAR_1]=...
     - [DERIVED_ENV_VAR_2]=...
       After you save the file, I will rerun capture and reload `.env` automatically."
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
8. **Enforce the UI verification gate** - Do not start code review until every UI/visual/layout change on a Figma-backed screen has cleared the live-capture + Figma verification loop (`tsh-ui-capture-worker` artifacts compared by `tsh-ui-reviewer`, iterated up to 5) and is individually PASSED or individually ESCALATED. This applies to every visual/layout change, not only to changes that happen to carry a `[REUSE]` task. Type checks, build, unit/integration tests, and code review are NOT UI verification and can never substitute for it — "it compiles" and "code review passed" do not mean the UI matches Figma.
9. **Run code review after the UI gate clears** - Delegate to `tsh-code-reviewer` with `tsh-review.prompt.md` only after the UI verification gate passes or is explicitly escalated per item.
   - Treat UI verification and code review as separate gates with separate owners and separate outputs. Do not communicate or batch them as one combined step, and report UI verification status separately from code review status.
10. **Classify review fixes before routing** - If code review finds issues that require changes, determine whether each fix is non-material and remains within the unchanged current Human-approved plan revision, or is material to that revision. A non-material, plan-conforming fix requires no repeated user approval before it is routed. If a fix causes or reveals a material change to a previously Human-approved plan revision, apply **Material Revision Handling** instead of routing the fix: halt subsequent file-changing delegation, reset the Plan Revision and record it in the plan's Changelog, run the mandatory automated re-review with no low-risk exemption, then resume only after renewed Human approval through the exact gate choices.
11. **Route review fixes back through the correct implementer** - For a non-material, plan-conforming fix, package the review findings as a structured follow-up list (one actionable item per finding, scoped to its owner) and delegate the fixes through the same routing rules rather than dumping raw review commentary; run affected checks again, and re-run review when needed.
12. **Treat any direct file edit as a workflow violation** - The orchestrator never edits any file directly; always delegates every file change to the owning specialist. If the orchestrator starts editing any file itself, stop that path, return to delegated execution, and continue only through the correct owner. If no suitable specialist exists, stop and ask the user.
13. **Record solution changes in the plan Changelog** - Document any solution change or workflow deviation in the plan file's Changelog section with a timestamp. When the change is material to a previously Human-approved plan revision, this record is produced as part of **Material Revision Handling**, not as a separate confirmation-only step.

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
