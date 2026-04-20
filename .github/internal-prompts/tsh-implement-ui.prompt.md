---
agent: "tsh-engineering-manager"
model: "Claude Opus 4.6"
description: "Implement UI feature according to the plan, orchestrating iterative Figma verification until pixel-perfect."
---

Your goal is to implement the UI feature according to the provided implementation plan and feature context, orchestrating iterative verification against Figma designs until the implementation matches within agreed tolerances.

## Design References from Research & Plan

Before delegating tasks, open the research file (`*.research.md`) and plan file (`*.plan.md`) to find all Figma URLs:

- In the **research file**, look for:
  - Figma URLs in the `Relevant Links` section.
  - Specific component/node links mentioned in `Gathered Information`.
- In the **plan file**, look for:
  - Figma URLs and design references in `Task details`.
  - A structured "Design References" subsection mapping views/components to Figma URLs or node IDs.

Use these URLs when delegating to both `tsh-software-engineer` (implementation context) and `tsh-ui-reviewer` (verification target).

### When Figma link is missing

If you cannot find a Figma URL for a component/section that needs verification:

1. **Stop** — do not delegate implementation or verification for that component
2. **Ask the user** to provide the Figma link for the specific section
3. **Wait for the link** before proceeding
4. **Add the link** to the plan file once provided (in `Task details` or `Design References`)

Do NOT skip verification or delegate without a Figma reference.

## Workflow

1. **Review the plan** — Review the implementation plan and feature context thoroughly. Identify which tasks are UI implementation tasks (need Figma verification) and which are non-visual tasks. Extract all Figma URLs from the research/plan files.

2. **Delegate codebase analysis** — Use `tsh-architect` agent to perform codebase analysis and technical context discovery to establish project conventions, coding standards, architecture patterns, and existing codebase patterns before implementing.

3. **Confirm dev server URL** — **Use `vscode/askQuestions` now** to ask the user for the dev server URL (e.g., "What URL is the frontend app running at? Is it http://localhost:3000?"). Do not defer this to later — you need the confirmed URL before any verification can start. Do not guess from running processes or port scans — multiple services may run on different ports. Use the confirmed URL for all subsequent verifications in this session.

4. **Delegate UI implementation** — For each UI implementation task, delegate to `tsh-software-engineer` using [tsh-implement-ui-common-task.prompt.md](../internal-prompts/tsh-implement-ui-common-task.prompt.md). Pass the relevant Figma URLs, component context, and plan section. For non-Figma frontend and backend tasks, use [tsh-implement-common-task.prompt.md](../internal-prompts/tsh-implement-common-task.prompt.md).

5. **Delegate UI verification** — After each UI implementation task completes, delegate verification to `tsh-ui-reviewer` using `runSubagent` with [tsh-review-ui.prompt.md](tsh-review-ui.prompt.md). Pass: the Figma URL, the user-confirmed dev server URL from step 3, and the component/section name. The ui-reviewer will compare the Figma design against the running implementation and return a structured report. **Note:** You do NOT need `figma` or `playwright` tools yourself — the `tsh-ui-reviewer` agent has them. Just use `runSubagent` to delegate. Never skip verification because these tools aren't in your own tool list.

6. **Handle verification results**:
   - If **PASS** → mark the task and its verification step as complete in the plan. Move to the next task.
   - If **FAIL** → delegate fix to `tsh-software-engineer` — pass the **complete** verification report and explicitly instruct the engineer to fix **ALL** listed differences, not just the first one. After the fix, re-delegate verification to `tsh-ui-reviewer`. Repeat up to **5 iterations per component**.
   - After 5 failed iterations → **escalate**: list remaining mismatches with the Figma URL, describe what was tried in each iteration, state the suspected root cause, document in the plan's Changelog, and ask the user for guidance.

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

11. **Delegate code review** — Delegate to `tsh-code-reviewer` agent via [tsh-review.prompt.md](tsh-review.prompt.md). Include E2E test execution as part of the review. The code reviewer runs all quality gates (unit, integration, E2E tests, linting, build).

## Verification Rules

1. Every UI component must be verified by `tsh-ui-reviewer` — minimum once per component, no exceptions
2. Fix all reported differences — do not skip or rationalize
3. Re-delegate verification after every fix — never assume a fix worked
4. Maximum 5 iterations per component — escalate if still failing
5. Check confidence level — LOW confidence means tool data may be incomplete

## Verification Gate — Do Not Proceed Without Real Verification

Before proceeding from a UI verification step to the next task or to code review, confirm that the `tsh-ui-reviewer` actually performed a **real Figma+Playwright comparison**. A valid verification report must contain:

- Data extracted from Figma via `figma` (design specifications)
- Data captured from the running app via `playwright` (screenshots, computed styles, accessibility snapshot)
- A structured comparison with EXPECTED vs ACTUAL values

**If the report is missing either side of the comparison** (e.g., the reviewer only read source code files, or skipped Playwright because of a blocker), the verification is **INVALID**. Do not accept it. Instead:

1. Identify why verification failed (wrong URL? auth blocker? tool error?)
2. Ask the user to resolve the blocker (provide correct URL, credentials, or manual verification)
3. Re-delegate to `tsh-ui-reviewer` once the blocker is resolved
4. Only proceed when you have a valid verification report or the user explicitly instructs you to skip

**Never proceed to code review with unverified UI components.** If verification cannot be completed for a component, document it in the plan's Changelog and get explicit user approval before moving to code review.

## Fallback: When `tsh-ui-reviewer` Returns Errors

If `tsh-ui-reviewer` consistently returns LOW confidence or tool errors:

1. Do not continue the loop blindly
2. Ask the user if they can verify manually (open Figma + app side-by-side)
3. Document the issue in the plan's Changelog
4. Continue with next component or escalate

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-implement-ui:v1 -->
