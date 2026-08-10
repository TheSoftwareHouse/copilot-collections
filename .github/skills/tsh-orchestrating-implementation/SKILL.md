---
name: tsh-orchestrating-implementation
description: Owns the canonical implementation orchestration workflow for feature implementation, including planning readiness, Human approval gating, delegated execution routing, todo control, and review gates. Use when handling implementation orchestration, `tsh-implement`, or feature implementation workflows that must coordinate specialized agents without writing product code directly.
user-invocable: false
---

# Orchestrating Implementation

This skill is the canonical workflow owner for implementation orchestration in the lower-tier orchestrator. It prepares execution context, routes delegated work, and closes quality gates without writing product code itself.

<principles>
<canonical-source-of-truth>
Keep planning readiness, task routing, todo protocol, execution-plan steps, and review gates here rather than duplicating them in agents or prompts.

This skill is the single owner of route-varying authorization bases, eligibility, and escalation. Execution owners carry the common invariant inline in their own `<human-approval-precondition>` block; use that inline precondition as the source of truth for the common invariant rather than restating the predicate here as an owners' source of truth.
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
- [ ] Step 1: Establish Full Flow and assess planning readiness
- [ ] Step 2: Plan the task order
- [ ] Step 3: Run Full Flow
- [ ] Step 4: Close validation and review gates
```

### Step 0 - Start with todos

- Create todos at the start of Full Flow.
- Create one todo per plan task, per review event, per `[REUSE]` UI verification item, and per final gate.
- Consult the todo list before each action.
- Mark the matching todo complete immediately after the action finishes.
- If scope changes, update the execution plan first, then synchronize the todo list.

### Step 1 - Establish Full Flow and assess planning readiness

Full Flow is the only implementation-orchestration route for this skill. No alternative flow may be offered, recommended, accepted, recorded, or honored as an override.

Use the following rules before any delegation. Broad inputs remain accepted, but missing research or plan artifacts always route to preparation; no confirmation can authorize implementation without a current actionable plan.

**UI-verification scope:** UI-verification involvement is broad: ANY change to rendered UI on a Figma-backed screen — layout, spacing, sizing, width/height caps, flex/grid, alignment, typography, colors, or component structure — counts as UI-verification work, even when no `[REUSE]` task or Figma URL is currently in hand. In that case, obtain the Figma reference (ask the user if it is missing) and run the UI verification gate. Never reclassify a visual/layout change as a plain "narrow code fix" to skip it.

**Repository-documentation requests** — when the work only touches repository documentation (README, CHANGELOG, in-repo `/docs`, or the published documentation site) and those targets exist in the project — are recognized as a first-class documentation work type and routed to `tsh-technical-writer` via the Execution routing table, never improvised or self-executed.

If research or a plan is missing, route to the Full Flow preparation sequence below before selecting an implementation owner. Do not offer or authorize no-plan implementation.

### Step 2 - Plan the task order

Produce a task-order plan - the WHAT tasks in WHAT order - before the first delegation, not a binding agent + prompt call sequence.

- Do this before the first delegation.
- Do it again after Human approval and before execution starts.
- List every planned task in order, covering each delegation, review, validation checkpoint, and UI verification item.
- Do not bind an agent or prompt to each task here; the agent + prompt per task is implied at execution time by the Execution routing table.
- Share the intended flow on chat with an explicit note that it may change as execution proceeds.
- Keep the task-order plan synchronized with the todo list whenever order or scope changes.

## Task-to-Owner Routing

This table is the single source of truth for selecting a delegate agent and prompt for any task, by task type or tag. Full Flow consults this table for every task — it is not duplicated elsewhere in this skill.

| Task type or tag              | Delegate to             | Prompt to use                            | Notes                                                                                                                                                                                                                                                 |
| ----------------------------- | ----------------------- | ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| app code (plan task)          | `tsh-plan-implementor`  | `tsh-implement-common-task.prompt.md`    | DEFAULT route for a Human-approved plan revision's actionable, low-risk plan seams that must be executed exactly as written                                                                                          |
| app code (complex)            | `tsh-software-engineer` | `tsh-implement-common-task.prompt.md`    | EXCEPTION route for complex non-UI work; choose `Kimi K2.7 Code` or `GPT-5.3-Codex` for medium-reasoning precision on complex work, or `Gemini 3.6 Flash` for fast, low-cost, large-context analysis |
| UI with Figma                 | `tsh-ui-engineer`       | `tsh-implement-ui-common-task.prompt.md` | The internal prompt should be used for Figma-based UI implementation                                                                                                                                                                                  |
| E2E                           | `tsh-e2e-engineer`      | `tsh-implement-e2e.prompt.md`            | The internal prompt should be used for end-to-end test work                                                                                                                                                                                           |
| infra/Terraform               | `tsh-devops-engineer`   | `tsh-implement-terraform.prompt.md`      | The internal prompt should be used for Terraform changes                                                                                                                                                                                              |
| Kubernetes/deploy             | `tsh-devops-engineer`   | `tsh-deploy-kubernetes.prompt.md`        | The internal prompt should be used for deployment or Kubernetes work                                                                                                                                                                                  |
| CI/CD                         | `tsh-devops-engineer`   | `tsh-implement-pipeline.prompt.md`       | The internal prompt should be used for pipeline work                                                                                                                                                                                                  |
| observability                 | `tsh-devops-engineer`   | `tsh-implement-observability.prompt.md`  | The internal prompt should be used for logging, metrics, or tracing work                                                                                                                                                                              |
| LLM prompts                   | `tsh-prompt-engineer`   | `tsh-engineer-prompt.prompt.md`          | The internal prompt should be used for prompt-engineering tasks                                                                                                                                                                                       |
| documentation                 | `tsh-technical-writer`  | `tsh-write-documentation.prompt.md`      | The internal prompt should be used for repository documentation work across all targets — README, CHANGELOG, `/docs`, and the published documentation site when those targets exist in the project                                                                                            |
| `[REUSE]` UI verification     | `tsh-ui-reviewer`       | `tsh-review-ui.prompt.md`                | Review each UI item individually; do not batch                                                                                                                                                                                                        |
| `[REUSE]` other               | per the task definition | —                                        | Execute as defined in the task definition; delegate to the matching implementer only when new product code is required                                                                                                                                |

Note: Apply the app-code decision rule consistently during execution and follow-up fixes: `tsh-plan-implementor` is the DEFAULT route for actionable, low-risk plan seams, while `tsh-software-engineer` is the EXCEPTION route for complex non-UI work.

## Architect Band Selection

Planning delegations select one of three architect bands. All three run the identical agent body; only the model band differs. Route-varying selection lives here, not in the agent files.

| Band | Agent | Select when |
| --- | --- | --- |
| default | `tsh-architect` | Any full-tier planning work without a deep-band signal. This is the standard route. |
| deep | `tsh-architect-deep` | The request or research shows a deep-band signal: irreversible or high-cost decisions (database engine, framework, vendor, data-model shape), schema migrations or backfills, security or authentication boundary design, cross-component architecture, competing viable designs, or an explicit user request for deep planning. Expected to be rare. |
| fast | `tsh-architect-fast` | The request appears on its face to satisfy the light-tier predicate. Light tier only. |

Band rules:

- The fast band authors light-tier plans only. On any tier-predicate failure it stops and returns a tier mismatch; the manager re-delegates to the default band (or deep, when a deep-band signal surfaced). It never continues on the full template.
- Over-provisioning is permitted: the default or deep band may author a light-tier plan when the predicate holds. Under-provisioning is never permitted.
- The user may name a band. An upward request (default → deep) is always honored. A downward request to fast is honored only when the tier predicate holds; the architect remains the authority, exactly as for the plan tier.
- When in doubt between bands, choose the higher band. Band selection is a routing bet; the tier predicate assessed by the architect is the authority.

Wherever the Planning readiness table and Planning sequence route to `tsh-architect` with `tsh-plan.prompt.md`, the delegate is the band selected by this table.

## Material Revision Handling

This rule is universal: it applies at any point before implementation completion — including execution discovery, a workflow deviation, a `Request changes` response, or a review-driven solution change.

Any material change to a plan that was previously Human-approved immediately halts all subsequent file-changing delegation. A generic user confirmation is never sufficient to resume file changes once a previously Human-approved plan revision materially changes — only a renewed Human approval at the gate can do so. Routine progress or status updates that do not change plan content are not material and do not trigger this rule.

When a material revision occurs:

1. `tsh-architect` increments the Plan Revision, sets `Human Decision=PENDING`, clears `Approved Revision`, and records the reason in the plan file's Changelog section.
2. No automatic re-review is invoked. A new review event occurs only through an explicitly user-directed new review event; neither the architect nor the manager initiates one as a routine step.
3. `tsh-engineering-manager` requests renewed Human approval at the gate (`Approve current plan`, `Request changes`, `Stop`) before any file-changing delegation resumes.

## Approval Gate Separation

Two distinct user-facing gates exist. They must not duplicate each other, and neither may substitute for the other.

| Gate | Owner | Exact labels | When it fires | Who writes the record |
| --- | --- | --- | --- | --- |
| Plan-authoring approval | `tsh-architect` | `Approve plan`, `I have comments` | Immediately after a settled review event: a revision-bound verdict accepted for the revision read plus a written disposition for every eligible blocker. It does not fire on the low-risk-exemption path, where no reviewer verdict exists. | `tsh-architect` writes the literal decision into the plan's `## Human Approval` table. |
| Execution authorization (recovery-only) | `tsh-engineering-manager` | `Approve current plan`, `Request changes`, `Stop` | Before the first file-changing delegation, and again after any material revision — but only when no valid approval already exists for the current unchanged `Plan Revision`. | `tsh-engineering-manager` delegates the write to `tsh-architect-fast`; it never writes the record itself because it has no `edit` tool. |

The Manager's gate is fail-closed recovery only, never a second normal authorization when a valid current-revision record already exists, including one recorded by `tsh-architect`.

The manager MUST read the exact plan path and evaluate each canonical approval field before reuse. This skill is the sole detailed owner of that validation and receipt procedure. The manager MUST perform the validation read-only against the exact plan path, then evaluate the existing three canonical fields: `Human Decision`, `Approved Revision`, and a valid UTC-Z `Decision Timestamp`. A valid unchanged persisted record produces an ephemeral bounded `reused` receipt containing the exact plan path, current revision, persisted timestamp, review path when available, and the result of each predicate field. It authorizes reuse without a duplicate manager gate.

If the record is unreadable or missing, stale, mismatched, non-literal, or in `PENDING` state, the manager MUST fail closed and produce an ephemeral `invalid-or-missing` receipt naming the exact failed field or path. Manager-turn-only consent is explicitly rejected as a validity criterion. The exact plan path and persisted fields win if handoff routing metadata conflicts; the manager fails closed rather than using conflicting pointers. Handoff pointers, architect prose, delegated turns, reviewer output, and receipts never replace on-disk validation. Do not persist a receipt or add metadata, provenance, a ledger, a cryptographic claim, a schema change, or a fourth predicate term.

Reuse never manufactures consent: it requires the exact canonical predicate over a literal recorded decision, and any missing, unreadable, stale, mismatched, or `PENDING` record forces the gate. Neither gate may weaken the canonical `## Human Approval` schema, values, validity predicate, or reset behavior owned by `tsh-creating-implementation-plans`. After any material revision, **Material Revision Handling** above applies in full and no prior approval is reusable.

## Implementation Discussion Boundary

The **authoring discussion** is the discussion in which the plan was authored, reviewed, and approved at the Architect's plan-authoring gate. The **implementation discussion** is a new discussion the user starts to deliver that plan. Recording plan-authoring Human approval completes the authoring discussion; implementation begins only in a new discussion.

In the authoring discussion, after a current-revision recorded `APPROVED`, the manager reports the exact plan path, current `Plan Revision`, persisted `Decision Timestamp`, and review path when present, names implementation as the next step, and MUST NOT perform any file-changing delegation there. This includes the Full Flow where `/tsh-implement` routed planning to the Architect in this same discussion and the Architect recorded approval there.

New implementation discussions enter through `/tsh-implement` or a direct `tsh-engineering-manager` invocation. The manager re-reads and reuses the existing on-disk record under the unchanged predicate `Human Decision=APPROVED`, `Approved Revision=current Plan Revision`, and a `Decision Timestamp` that is valid ISO 8601 UTC ending in `Z`, without presenting a duplicate approval gate. The discussion boundary is a lifecycle stop, never an approval-validity criterion.

Invalid or missing states remain fail-closed, and **Material Revision Handling** remains unchanged; the boundary grants no exception. The low-risk-exemption path is excluded: no Architect plan-authoring gate ran there, and the manager's execution-authorization gate remains the only user-facing gate. This boundary is instruction-level and auditable; it does not detect or enforce a VS Code conversation identifier. It introduces no fields, values, provenance, receipts, ledgers, or additional predicate terms.

## Implementation Code-Review Eligibility

A **reviewable implementation artifact** is a delivered artifact in one of these classes:

A delivered change set must contain at least one reviewable implementation artifact before the final implementation code-review gate can open.

| Class | Examples | Opens the final review gate |
| --- | --- | --- |
| Application / product source code | Feature code, libraries, and this repository's own `.github/**` Copilot customization artifacts | Yes |
| Automated tests | Unit, integration, and E2E specs, Page Objects, and fixtures | Yes |
| Infrastructure, CI/CD, and observability code | Terraform, Helm/Kubernetes manifests, pipeline definitions, and dashboards or alerts as code | Yes |
| LLM application prompts delivered as product artifacts | System prompts, RAG templates, and tool-calling instructions | Yes |

These classes never open the final review gate on their own:

| Excluded class | Examples | Opens the final review gate |
| --- | --- | --- |
| Planning artifacts | `specifications/**/*.plan.md`, `*.plan-review.md`, and `*.research.md` | No |
| Plan bookkeeping | Task checkboxes, progress/status, `UI Verification Status`, `Code Review Findings`, and Changelog entries | No |
| Repository-documentation-only delivery | README, CHANGELOG, in-repo `/docs`, and `website/docs/**` | No |

When implementation artifacts are delivered alongside a plan, the plan remains required comparison context for scope, Definition of Done, and acceptance criteria, and is never a review target. Plan prose, structure, and bookkeeping are never review findings and never a review trigger. “Never a review target” scopes review rather than forbidding file writes: the reviewer's narrowly defined bookkeeping writes — completed Definition of Done and acceptance-criteria boxes, `Code Review Findings`, and the Changelog entry — remain required and permitted.

The final review gate runs once per delivered implementation change set, after the UI verification gate clears. The reviewer's own mandated plan writes are bookkeeping, are not a new delivered change set, and can never re-open the gate. A re-run is justified only by a review-driven fix that delivers new implementation artifacts, under the existing execution rules.

Repository-documentation-only delivery is owned by `tsh-technical-writer` and uses the documentation build as its validation gate; it does not open the implementation code-review gate. Documentation delivered alongside implementation artifacts is reviewed as part of that single delivered change set.

Plans authored from old unconditional templates are governed by this workflow eligibility rule: for a plan-only, bookkeeping-only, or documentation-only delivery, the manager marks the stale review task `NOT APPLICABLE — no reviewable implementation artifacts delivered`. That status write is bookkeeping and is not a review trigger.

This section changes invocation eligibility only. It does not alter Human Approval semantics, gate labels, or the UI verification ordering.

## Full Flow

### Planning readiness

Check the current state before creating or executing any plan.

| Artifact or signal  | Treat as ready when                                                                                                                     | If not ready                                                                          |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| `*.research.md`     | It exists for the current task and contains enough context to explain scope, constraints, requirements, and referenced inputs or links  | Route to `tsh-context-engineer` with `tsh-research.prompt.md`; for a light-tier plan, a recorded Tier Justification in the plan satisfies this row without a research file |
| `*.plan.md`         | It exists for the current task and contains ordered, actionable tasks that can be delegated                                             | Route to `tsh-architect` with `tsh-plan.prompt.md`                                    |
| Open questions gate | It exists and contains no `❓ Open` rows in `## Open Questions`, so unresolved questions are not blocking execution readiness           | Route to `tsh-architect` with `tsh-plan.prompt.md`                                    |
| Technical Context   | The plan has a populated `Technical Context` section with conventions, patterns, stack, and testing guidance relevant to implementation | Route to `tsh-architect` with `tsh-review-codebase.prompt.md`                         |
| Reviewer readiness | Satisfied by a settled review event recorded in `.plan-review.md` — a revision-bound verdict accepted at return plus a written disposition for every eligible blocker — or, before any Human approval has ever been recorded, by the unchanged explicitly recorded valid low-risk automated-review exemption for initial plan preparation; this is never Human approval | Route to `tsh-architect` with `tsh-plan.prompt.md` to return a finished reviewed plan or an explicitly stated valid exemption |
| Human approval state | The plan's persisted Human Approval record satisfies `Human Decision=APPROVED`, `Approved Revision=current Plan Revision`, and a `Decision Timestamp` that is valid ISO 8601 UTC ending in `Z`. A record `tsh-architect` already wrote at its plan-authoring gate satisfies this row for the unchanged revision; apply the **Implementation Discussion Boundary**. | Present the mandatory Human approval gate before the first file-changing delegation |

### Planning sequence

1. **Check for existing research and plan files** - Inspect current `*.research.md` and `*.plan.md` state first.
2. **Fill missing context when needed** - If research is missing or incomplete, delegate to `tsh-context-engineer` with `tsh-research.prompt.md`.
3. **Create or refresh the reviewed plan when needed** - If the plan is missing, stale, not actionable, or not reviewer-ready, delegate to `tsh-architect` with `tsh-plan.prompt.md`. The architect owns producing a finished reviewed plan with one invocation per plan lifecycle; the sole exception is an explicitly user-directed new review event, never a routine architect or manager option. If a return is non-revision-bound or a blocker remains unresolved, the architect uses `vscode/askQuestions` with exactly `stop here` and `custom guidance`, neither of which authorizes another review. Preserve append-only review history and never approve with unhandled blockers. The plan MUST be authored following the `tsh-creating-implementation-plans` skill — it owns the plan template and structure rules. That skill also owns plan-tier selection: the architect assesses the tier predicate at planning start and authors on the light or full template accordingly. A light-tier plan with a recorded Tier Justification satisfies the Open questions and Reviewer readiness rows above, and its minimal Technical Context section satisfies the Technical Context row without a `tsh-review-codebase.prompt.md` delegation. The light tier is a plan-artifact property inside Full Flow, not an alternative flow. Missing research always routes to `tsh-context-engineer` first; missing plans always route to `tsh-architect`. After the review event is settled, the architect runs its own plan-authoring approval gate (`Approve plan`, `I have comments`) and records the literal decision in the plan's `## Human Approval` table; see **Approval Gate Separation**.
4. **Create execution todos from the plan** - Create todos per plan task, not just per phase.
5. **Capture UI inventory early** - Find every `[REUSE]` UI task and every Figma URL in the plan and research files. If a Figma-backed UI task does not have a Figma reference, stop and get it from the user before execution starts.
6. **Ask for the dev server URL when UI tasks exist** - If the UI inventory is non-empty, use `vscode/askQuestions` to get the exact user-confirmed full dev server URL before execution starts. Treat it as a pinned session input and forward it unchanged through every reviewer and capture delegation.
7. **Apply the Technical Context rule** - If the plan already contains populated Technical Context, use it and skip rediscovery; otherwise delegate to `tsh-architect` with `tsh-review-codebase.prompt.md`.
8. **Separate reviewer readiness from Human approval readiness** - Reviewer readiness is satisfied by a settled review event recorded in `.plan-review.md` — a revision-bound verdict accepted at return plus a written disposition for every eligible blocker — or, before any Human approval has ever been recorded for this plan, by the unchanged explicitly stated valid low-risk automated-review exemption for initial plan preparation. This is Reviewer readiness only and never execution permission; neither basis substitutes for Human approval. A material revision after Human approval still halts delegation and requires renewed Human approval, but no automatic reviewer invocation; a new review event occurs only through the explicitly user-directed new review event exception.
9. **Pass the Human approval gate before execution** - Before the first file-changing delegation, present the exact current plan path, the plan's current contents, the current Plan Revision, and the review path when present. When reviewer readiness rests on the initial-plan low-risk exemption instead of a review report, state plainly that no reviewer report exists because the initial-preparation exemption is the documented readiness basis; never let the exemption substitute for Human approval itself. Offer exactly: `Approve current plan`, `Request changes`, `Stop`. `Approve current plan` authorizes every unchanged task in that revision, in plan order; `Request changes` returns to `tsh-architect`; `Stop` ends without implementation. If the plan's persisted `## Human Approval` record already satisfies the canonical predicate for the current unchanged `Plan Revision` — for example because `tsh-architect` recorded it at its plan-authoring gate — reuse that approval per **Approval Gate Separation** instead of presenting this gate again, subject to the **Implementation Discussion Boundary**.
10. **Rewrite the task-order plan after approval** - Refresh the ordered task list from the current Human-approved plan revision before the first implementation task starts; the agent + prompt for each task is resolved at execution time by the Execution routing table.

### Execution routing

Process tasks in plan order. Consult the todo list before each task and update the plan and todo list after each completed task. Use the Task-to-Owner Routing table above to select the delegate agent and prompt for each task — it is not repeated here. Apply the app-code decision rule consistently during execution and follow-up fixes: `tsh-plan-implementor` is the DEFAULT route for actionable, low-risk plan seams, while `tsh-software-engineer` is the EXCEPTION route for complex non-UI work.

### Execution rules and gates

1. **Stay inside the Human-approved plan** - Execute the Human-approved plan revision as written. If execution requires a material deviation, stop immediately and apply **Material Revision Handling** — a generic confirmation from the user is never sufficient on its own to resume file changes.
2. **Require current Human approval** - Before any file-changing delegation, the delegation must identify a plan whose persisted record satisfies exactly: `Human Decision=APPROVED`, `Approved Revision=current Plan Revision`, and `Decision Timestamp` is valid ISO 8601 UTC ending in `Z`. Apply the **Implementation Discussion Boundary** before delegation. Missing, stale, mismatched, inferred, or Reviewer-only approval must block the file-changing delegation and cannot be bypassed by direct invocation. Recovery follows the execution owner's inline `<human-approval-precondition>` guided-recovery behavior: name the failed field, condition, or file, then use `vscode/askQuestions` to offer next steps. Returning to `tsh-engineering-manager` for the gate is one applicable choice, not the mandatory sole outcome.
3. **Handle a material plan revision** - Apply **Material Revision Handling** above in full whenever `Request changes`, execution discovery, a workflow deviation, or a review-driven solution change materially revises a previously Human-approved plan. A fresh session may reuse persisted approval only when `Human Decision=APPROVED`, `Approved Revision=current Plan Revision`, and `Decision Timestamp` is valid ISO 8601 UTC ending in `Z`; otherwise the file-changing delegation must be blocked. No automatic reviewer invocation follows; a new review event occurs only through the explicitly user-directed new review event exception. Recovery follows the execution owner's inline `<human-approval-precondition>` guided-recovery behavior: name the failed field, condition, or file, then use `vscode/askQuestions` to offer next steps. Returning to `tsh-engineering-manager` for the gate is one applicable choice, not the mandatory sole outcome.
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
9. **Run code review after the UI gate clears** - Delegate to `tsh-code-reviewer` with `tsh-review.prompt.md` only after the UI verification gate passes or is explicitly escalated per item. The delegation also requires the delivered change set to qualify under **Implementation Code-Review Eligibility**; when it does not qualify, close the flow with no review invocation and no substitute gate.
   - Treat UI verification and code review as separate gates with separate owners and separate outputs. Do not communicate or batch them as one combined step, and report UI verification status separately from code review status.
10. **Classify review fixes before routing** - If code review finds issues that require changes, determine whether each fix is non-material and remains within the unchanged current Human-approved plan revision, or is material to that revision. A non-material, plan-conforming fix requires no repeated user approval before it is routed. Plan bookkeeping is never a change requiring review. If a fix causes or reveals a material change to a previously Human-approved plan revision, apply **Material Revision Handling** instead of routing the fix: halt subsequent file-changing delegation, reset the Plan Revision and record it in the plan's Changelog, then resume only after renewed Human approval through the exact gate choices. A new review event occurs only through the explicitly user-directed new review event exception.
11. **Route review fixes back through the correct implementer** - For a non-material, plan-conforming fix, package the review findings as a structured follow-up list (one actionable item per finding, scoped to its owner) and delegate the fixes through the same routing rules rather than dumping raw review commentary; run affected checks again, and, only when a fix delivers new reviewable implementation artifacts, re-run review when needed. Plan status, findings, and Changelog entries never justify a re-run.
12. **Treat any direct file edit as a workflow violation** - The orchestrator never edits any file directly; always delegates every file change to the owning specialist. If the orchestrator starts editing any file itself, stop that path, return to delegated execution, and continue only through the correct owner. If no suitable specialist exists, stop and ask the user.
13. **Record solution changes in the plan Changelog** - Document any solution change or workflow deviation in the plan file's Changelog section with a timestamp. When the change is material to a previously Human-approved plan revision, this record is produced as part of **Material Revision Handling**, not as a separate confirmation-only step.

### Preservation coverage

Keep the workflow traceable to the plan's preserved branches:

| Coverage area                                                   | Preserved checklist items |
| --------------------------------------------------------------- | ------------------------- |
| Step 0 todos and Step 1 Full Flow establishment                 | 1-4                       |
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
