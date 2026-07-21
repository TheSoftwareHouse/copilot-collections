Your goal is to implement the UI feature according to the provided implementation plan and feature context. The canonical orchestration skill determines whether the rendered surface is web UI or native React Native UI; this prompt supplies the corresponding implementation and evidence contract without replacing that routing decision.

## Platform Contract

- **Web/Figma browser UI**: use the browser verification contract below. Preserve the user-confirmed full URL, the capture-before-review ordering, the shared `figma-expected.png`, and the `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml` artifact contract.
- **Rendered React Native UI**: route implementation through the existing UI owner with `tsh-implementing-react-native`. A browser URL is not required, and Playwright or browser capture artifacts are not required for native verification. Browser artifacts cannot prove native safe areas, navigation, touch or gesture behavior, device behavior, VoiceOver/TalkBack behavior, or native end-to-end behavior.
- Native simulator/device, accessibility, and end-to-end evidence is target-project-owned. If the target project does not supply an explicit native evidence contract, record native verification as an explicit prerequisite or limitation rather than claiming it was performed. Do not enter the browser verification loop for native React Native work.

## Design References from Research & Plan

Before delegating web/Figma browser tasks, open the research file (`research.md` in the same task specification directory as the associated `*.plan.md`, or a generic `*.research.md`) and plan file (`*.plan.md`) to find all Figma URLs:

- In the **research file**, look for:
  - Figma URLs in the `Relevant Links` section.
  - Specific component/node links mentioned in `Gathered Information`.
- In the **plan file**, look for:
  - Figma URLs and design references in `Task details`.
  - A structured "Design References" subsection mapping views/components to Figma URLs or node IDs.

Use these URLs when delegating web/Figma browser work to `tsh-ui-engineer` (implementation context) and `tsh-ui-reviewer` (verification target). For native React Native work, pass a Figma URL only as implementation design context when the plan provides one; do not turn it into a browser verification requirement.

### When Figma link is missing

If you cannot find a Figma URL for a web/Figma component or section that needs verification:

1. **Stop** — do not delegate implementation or verification for that component
2. **Ask the user** to provide the Figma link for the specific section
3. **Wait for the link** before proceeding
4. **Add the link** to the plan file once provided (in `Task details` or `Design References`)

Do NOT skip web verification or delegate web/Figma review without a Figma reference. Native React Native work follows the target project's design and evidence inputs; this prompt does not invent a browser substitute.

## Workflow

1. **Review the plan** — Review the implementation plan and feature context thoroughly. Identify web UI tasks (which use Figma/browser verification), rendered React Native UI tasks (which do not use the browser verification contract), and non-visual tasks. Extract all relevant Figma URLs from the research/plan files.

2. **Delegate codebase analysis (if needed)** — Check if the plan file (`*.plan.md`) contains a populated **"Technical Context"** section. If it does, skip this step — the context was already captured during planning. If the section is missing or empty, use `tsh-architect` agent to perform codebase analysis and technical context discovery to establish project conventions, coding standards, architecture patterns, and existing codebase patterns before implementing.

3. **Confirm the web verification URL when applicable** — For web/Figma browser work, **use `vscode/askQuestions` now** to ask the user for the exact full dev server URL that should be used for verification (e.g., "What exact URL should UI verification use for this page?"). Do not defer this to later, guess from running processes, project config, or port scans, or switch ports after confirmation. Once confirmed, treat that full URL as a pinned session input and use it unchanged for all subsequent web captures and reviews. This URL is not required for native React Native work; use the target project's native evidence contract when supplied, otherwise record the native verification prerequisite or limitation.

4. **Delegate UI implementation** — For each UI implementation task, delegate to `tsh-ui-engineer` using [tsh-implement-ui-common-task.prompt.md](./tsh-implement-ui-common-task.prompt.md). Pass the relevant Figma URLs, component context, and plan section. For native React Native work, pass the target-project profile and any supplied native evidence contract as context; do not require a browser URL. For non-Figma frontend and backend tasks, use [tsh-implement-common-task.prompt.md](./tsh-implement-common-task.prompt.md).

5. **Delegate web/Figma browser verification** — For web/Figma browser work only, after each UI implementation task completes, first delegate capture to `tsh-ui-capture-worker` using the pinned user-confirmed full dev server URL from step 3, the Figma URL, the shared verification root, and the current iteration artifact directory. Require the capture worker to prepare or ensure the shared `figma-expected.png` before ACTUAL browser capture starts. Then delegate verification to `tsh-ui-reviewer` using `runSubagent` with [tsh-review-ui.prompt.md](../prompts/tsh-review-ui.prompt.md). Pass: the Figma URL, the same pinned full dev server URL, the component/section name, and the exact artifact directory produced by `tsh-ui-capture-worker`. Forward that exact URL unchanged through every delegate, retry, and capture pass. The ui-reviewer will compare the Figma design against the running implementation and return a structured report. **Note:** The reviewer consumes the shared Figma EXPECTED reference plus caller-provided ACTUAL live-capture artifacts (`actual.png`, `computed-styles.json`, `a11y-snapshot.yml`) produced earlier by `tsh-ui-capture-worker`. No agent in this loop may launch, start, or switch to another local app/server or port once the URL is confirmed.

- In every delegation, explicitly require the reviewer response to include: `Verification Result`, `Component`, exact `Artifact Directory`, per-file artifact status, and blocker-resolution guidance. Treat an empty response or a response missing any of those fields as an invalid verification result and re-run the reviewer once with the same pinned URL, the same fresh artifact directory, and a stricter handoff.
- The caller/orchestrator must not treat its own lack of `figma` tool access as a Figma blocker for UI verification. If a Figma URL is available, delegate review first and let `tsh-ui-reviewer` determine whether `figma` MCP is actually unavailable in its own runtime.

- This step is **delegate-only**. The main/orchestrating agent must not perform UI verification itself and must not substitute code review, type checks, or browser inspection for the delegated `tsh-ui-capture-worker` + `tsh-ui-reviewer` flow.
- If `tsh-ui-reviewer` cannot be invoked, if `figma` is unavailable to the reviewer, or if `tsh-ui-capture-worker` cannot be invoked by the caller, treat that as a blocker in the UI gate and report `VERIFICATION NOT RUN`. Do not self-execute a fallback verification path in the caller.

6. **Handle web/Figma verification results**:
   - If **PASS** → mark the task and its verification step as complete in the plan. Move to the next task.

- If **FAIL** → this is NOT a stopping point. Delegate the fix to `tsh-ui-engineer` — pass the **complete** verification report and explicitly instruct the engineer to fix **ALL** listed differences, not just the first one. After the fix, delegate a **fresh capture** to `tsh-ui-capture-worker` using the same pinned full URL and the same Figma URL to ensure the shared `figma-expected.png` still exists (or refresh it if the node changed) and to regenerate `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml`, and only then re-delegate verification to `tsh-ui-reviewer` on those new artifacts. Re-verification must never run on stale artifacts. Then loop again: a single FAIL pass never ends the loop — keep running fix → fresh capture → re-verify until the result is PASS or you have completed **5 full iterations** for this component. Only after 5 completed iterations with remaining mismatches do you open the structured gate below.
- If **VERIFICATION NOT RUN** → treat it as a **pre-verification blocker**, not as a failed verification iteration. Resolve the blocker with the user through `vscode/askQuestions` if needed (missing confirmed URL, auth, wrong page state, unreachable page, incomplete artifacts); do not use a freeform text request as a substitute. Regenerate capture via `tsh-ui-capture-worker` using the same pinned full URL, and re-run verification. This state does **not** consume the 5-iteration budget and does **not** enter the post-5-iteration continue/stop/custom gate. Only treat it as `ESCALATED` if the user explicitly acknowledges an unresolved blocker.
- If **VERIFICATION NOT RUN** because `tsh-ui-reviewer` reported `figma` MCP unavailability, only then may the caller ask the user to enable Figma MCP or provide an exported reference image. The caller must not raise that blocker based on its own tool availability.
- If **VERIFICATION NOT RUN** because the reviewer step itself was not delegated or could not access its required tools/subagents, that is an orchestration blocker. Resolve it through `vscode/askQuestions`; do not let the main agent attempt the verification step directly.
  - After 5 failed iterations with remaining mismatches → pause behind a **structured** `vscode/askQuestions` gate. Present a structured summary containing exactly these fields: component or section name, Figma URL, remaining mismatches, what was attempted in each iteration, suspected root cause.

  - For rendered React Native UI, do not use this web/Figma result handling. Native verification is target-project-owned; when no target-project evidence contract is supplied, record `VERIFICATION NOT RUN` or an equivalent explicit native limitation and identify the missing prerequisite. Browser artifacts cannot upgrade that limitation to a native PASS.
- The `vscode/askQuestions` gate must offer exactly 3 choices: `continue-with` an explicit additional iteration count, stop and accept the current state as acknowledged `ESCALATED`, or provide a custom instruction.
- Record the user's decision and the resulting outcome in the plan's Changelog.
- If the extra iteration budget is exhausted and gaps remain, run the same structured `vscode/askQuestions` gate again.
- Code review cannot start for that item until it resolves as `PASSED` or explicitly acknowledged `ESCALATED`.

7. **Handle confidence levels** from verification reports:
   - **HIGH** confidence: fix exactly as reported
   - **MEDIUM** confidence: fix obvious issues, ask user about unclear ones
   - **LOW** confidence: ask user before making any changes — tool data may be incomplete

8. **Update the plan** — After completing each task step, update the plan to reflect progress (check the box). Note the verification result (PASS, number of iterations, or escalation).

9. **Run quality checks after each phase** — Run static code analysis, build the project, run unit and integration tests to verify nothing is broken.

10. **Before code review — UI Verification Summary** — Before delegating code review, compile:

- Components/sections verified by `tsh-ui-reviewer`
- Number of verification iterations per component
- Design gaps discovered and how they were handled
- Any deviations from design with rationale

11. **Delegate code review** — Delegate to `tsh-code-reviewer` agent via [tsh-review.prompt.md](../prompts/tsh-review.prompt.md). Include E2E test execution as part of the review. The code reviewer runs all quality gates (unit, integration, E2E tests, linting, build).

## Web/Figma Verification Loop (MANDATORY - never stop after one pass)

For each web/Figma browser UI component, run this loop explicitly. Rendered React Native UI does not enter this loop:

```text
iteration = 0
while iteration < 5:
    iteration += 1
    fix ALL differences from the latest report (skip on the very first pass)
    fresh capture via tsh-ui-capture-worker -> ensure shared figma-expected.png + actual.png + computed-styles.json + a11y-snapshot.yml
    fresh verification via tsh-ui-reviewer on those new artifacts
    if PASS: component done, exit loop
    if FAIL: continue loop (do NOT stop, do NOT accept the current state)
    if VERIFICATION NOT RUN: resolve the blocker via vscode/askQuestions; this does NOT count as one of the 5 iterations
after 5 completed FAIL iterations with remaining mismatches:
    open the structured vscode/askQuestions gate (continue-with-N / stop-as-ESCALATED / custom)
```

Hard rules for weaker models:

- A single FAIL is never terminal and never "good enough" — keep iterating.
- Never report the component complete while the latest result is FAIL.
- Every iteration regenerates fresh ACTUAL artifacts and ensures the shared `figma-expected.png` exists (refresh only if the Figma node changed); never reuse pre-fix ACTUAL evidence.
- `VERIFICATION NOT RUN` (capture / auth / URL blocker) does not consume the 5-iteration budget.

## Web/Figma Verification Rules

1. Every UI component must be verified by `tsh-ui-reviewer` — minimum once per component, no exceptions
2. Fix all reported differences — do not skip or rationalize
3. Re-delegate verification after every fix — never assume a fix worked
4. Maximum 5 iterations per component — escalate if still failing
5. Check confidence level — LOW confidence means tool data may be incomplete

## Web/Figma Verification Gate - Do Not Proceed Without Real Verification

**Default to asking (judgment rule, not a checklist):** the blocker cases named in this prompt are only examples. Whenever anything is missing, broken, ambiguous, inconsistent, or unexpected - including situations not listed here - and you cannot complete a real web/Figma verification with the full artifact base, stop and resolve it through `vscode/askQuestions`. Do not guess, improvise, fabricate, or proceed on partial evidence. Think about whether the evidence actually supports the verdict before continuing.

Before proceeding from a UI verification step to the next task or to code review, confirm that the `tsh-ui-reviewer` actually performed a **real Figma comparison with live-capture artifacts**. A valid verification report must contain:

- Data extracted from Figma via `figma` (design specifications)
- Data captured from the running app via `tsh-ui-capture-worker` producing `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml`
- A structured comparison with EXPECTED vs ACTUAL values

**If the report is missing either side of the comparison** (e.g., the reviewer only read source code files, or skipped capture because of a blocker), the verification is **INVALID**. Do not accept it. Instead:

1. Identify why verification failed (wrong URL? auth blocker? tool error?)
2. Use `vscode/askQuestions` to resolve the blocker (provide correct URL, credentials, or manual verification) rather than a freeform text request
3. Re-delegate capture to `tsh-ui-capture-worker`, then re-delegate verification to `tsh-ui-reviewer` once the blocker is resolved
4. Only proceed when you have a valid verification report or the user explicitly instructs you to skip

If `tsh-ui-reviewer` was never actually invoked, if `tsh-ui-capture-worker` was never actually invoked for the current pass, or if the caller attempted to approximate either step itself, treat that exactly like an invalid verification report: the UI gate did not run.

If `tsh-ui-reviewer` returns an empty response, or omits the explicit verdict or artifact-directory contract, treat that exactly like an invalid verification report: rerun once with the same pinned URL and a stricter handoff demanding those fields; if it still fails, keep the item at `VERIFICATION NOT RUN` and resolve the orchestration blocker through `vscode/askQuestions`.

**Never proceed to code review with unverified web UI components.** Web UI verification is a separate gate that must clear first, and it must be reported separately from code review. If web verification cannot be completed for a component, document it in the plan's Changelog and get explicit user approval before moving to code review. Type checks, build, unit/integration tests, and code review are NOT UI verification and never substitute for the live-capture + Figma comparison - a layout/CSS/sizing change is not "done" just because it compiles or because code review found the code clean. For native React Native UI, do not claim that this browser gate ran; use target-project-owned evidence or document the explicit limitation.

After every UI fix, repeat the capture and reviewer pass on fresh artifacts before treating the item as done. Do not reuse stale evidence, and do not merge the UI gate into the code-review step.

## Web/Figma Fallback: When `tsh-ui-reviewer` Returns Errors

If `tsh-ui-reviewer` consistently returns LOW confidence or tool errors:

1. Do not continue the loop blindly
2. Ask the user if they can verify manually (open Figma + app side-by-side)
3. Document the issue in the plan's Changelog
4. Continue with next component or escalate

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-implement-ui:v1 -->
