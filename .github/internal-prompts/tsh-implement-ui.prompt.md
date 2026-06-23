Your goal is to implement the UI feature according to the provided implementation plan and feature context, orchestrating iterative verification against Figma designs until the implementation matches within agreed tolerances.

## Design References from Research & Plan

Before delegating tasks, open the research file (`*.research.md`) and plan file (`*.plan.md`) to find all Figma URLs:

- In the **research file**, look for:
  - Figma URLs in the `Relevant Links` section.
  - Specific component/node links mentioned in `Gathered Information`.
- In the **plan file**, look for:
  - Figma URLs and design references in `Task details`.
  - A structured "Design References" subsection mapping views/components to Figma URLs or node IDs.

Use these URLs when delegating to both `tsh-ui-engineer` (implementation context) and `tsh-ui-reviewer` (verification target).

### When Figma link is missing

If you cannot find a Figma URL for a component/section that needs verification:

1. **Stop** — do not delegate implementation or verification for that component
2. **Ask the user** to provide the Figma link for the specific section
3. **Wait for the link** before proceeding
4. **Add the link** to the plan file once provided (in `Task details` or `Design References`)

Do NOT skip verification or delegate without a Figma reference.

## Workflow

1. **Review the plan** — Review the implementation plan and feature context thoroughly. Identify which tasks are UI implementation tasks (need Figma verification) and which are non-visual tasks. Extract all Figma URLs from the research/plan files.

2. **Delegate codebase analysis (if needed)** — Check if the plan file (`*.plan.md`) contains a populated **"Technical Context"** section. If it does, skip this step — the context was already captured during planning. If the section is missing or empty, use `tsh-architect` agent to perform codebase analysis and technical context discovery to establish project conventions, coding standards, architecture patterns, and existing codebase patterns before implementing.

3. **Confirm dev server URL** — **Use `vscode/askQuestions` now** to ask the user for the exact full dev server URL that should be used for verification (e.g., "What exact URL should UI verification use for this page?"). Do not defer this to later — you need the confirmed URL before any verification can start. Do not guess from running processes, project config, or port scans — multiple services may run on different ports. Once confirmed, treat that full URL as a pinned session input and use it unchanged for all subsequent verifications in this session.

4. **Delegate UI implementation** — For each UI implementation task, delegate to `tsh-ui-engineer` using [tsh-implement-ui-common-task.prompt.md](./tsh-implement-ui-common-task.prompt.md). Pass the relevant Figma URLs, component context, and plan section. For non-Figma frontend and backend tasks, use [tsh-implement-common-task.prompt.md](./tsh-implement-common-task.prompt.md).

5. **Delegate UI verification** — After each UI implementation task completes, delegate verification to `tsh-ui-reviewer` using `runSubagent` with [tsh-review-ui.prompt.md](../prompts/tsh-review-ui.prompt.md). Pass: the Figma URL, the pinned user-confirmed full dev server URL from step 3, and the component/section name. Forward that exact URL unchanged through every delegate, retry, and capture pass. The ui-reviewer will compare the Figma design against the running implementation and return a structured report. **Note:** The reviewer uses `figma` for EXPECTED and relies on `tsh-ui-capture-worker` for the ACTUAL live-capture artifacts (`actual.png`, `computed-styles.json`, `a11y-snapshot.yml`). No agent in this loop may launch, start, or switch to another local app/server or port once the URL is confirmed.

6. **Handle verification results**:
   - If **PASS** → mark the task and its verification step as complete in the plan. Move to the next task.

- If **FAIL** → delegate fix to `tsh-ui-engineer` — pass the **complete** verification report and explicitly instruct the engineer to fix **ALL** listed differences, not just the first one. After the fix, delegate a **fresh capture** to `tsh-ui-capture-worker` using the same pinned full URL to regenerate `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml`, and only then re-delegate verification to `tsh-ui-reviewer` on those new artifacts. Re-verification must never run on stale artifacts. Repeat up to **5 iterations per component**.
- If **VERIFICATION NOT RUN** → treat it as a **pre-verification blocker**, not as a failed verification iteration. Resolve the blocker with the user through `vscode/askQuestions` if needed (missing confirmed URL, auth, wrong page state, unreachable page, incomplete artifacts); do not use a freeform text request as a substitute. Regenerate capture via `tsh-ui-capture-worker` using the same pinned full URL, and re-run verification. This state does **not** consume the 5-iteration budget and does **not** enter the post-5-iteration continue/stop/custom gate. Only treat it as `ESCALATED` if the user explicitly acknowledges an unresolved blocker.
- After 5 failed iterations with remaining mismatches → pause behind a **structured** `vscode/askQuestions` gate. Present a structured summary containing exactly these fields: component or section name, Figma URL, remaining mismatches, what was attempted in each iteration, suspected root cause.
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

## Verification Rules

1. Every UI component must be verified by `tsh-ui-reviewer` — minimum once per component, no exceptions
2. Fix all reported differences — do not skip or rationalize
3. Re-delegate verification after every fix — never assume a fix worked
4. Maximum 5 iterations per component — escalate if still failing
5. Check confidence level — LOW confidence means tool data may be incomplete

## Verification Gate — Do Not Proceed Without Real Verification

Before proceeding from a UI verification step to the next task or to code review, confirm that the `tsh-ui-reviewer` actually performed a **real Figma comparison with live-capture artifacts**. A valid verification report must contain:

- Data extracted from Figma via `figma` (design specifications)
- Data captured from the running app via `tsh-ui-capture-worker` producing `actual.png`, `computed-styles.json`, and `a11y-snapshot.yml`
- A structured comparison with EXPECTED vs ACTUAL values

**If the report is missing either side of the comparison** (e.g., the reviewer only read source code files, or skipped capture because of a blocker), the verification is **INVALID**. Do not accept it. Instead:

1. Identify why verification failed (wrong URL? auth blocker? tool error?)
2. Use `vscode/askQuestions` to resolve the blocker (provide correct URL, credentials, or manual verification) rather than a freeform text request
3. Re-delegate capture to `tsh-ui-capture-worker`, then re-delegate verification to `tsh-ui-reviewer` once the blocker is resolved
4. Only proceed when you have a valid verification report or the user explicitly instructs you to skip

**Never proceed to code review with unverified UI components.** UI verification is a separate gate that must clear first, and it must be reported separately from code review. If verification cannot be completed for a component, document it in the plan's Changelog and get explicit user approval before moving to code review.

After every UI fix, repeat the capture and reviewer pass on fresh artifacts before treating the item as done. Do not reuse stale evidence, and do not merge the UI gate into the code-review step.

## Fallback: When `tsh-ui-reviewer` Returns Errors

If `tsh-ui-reviewer` consistently returns LOW confidence or tool errors:

1. Do not continue the loop blindly
2. Ask the user if they can verify manually (open Figma + app side-by-side)
3. Document the issue in the plan's Changelog
4. Continue with next component or escalate

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-implement-ui:v1 -->
