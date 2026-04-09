---
agent: "tsh-software-engineer"
model: "Claude Opus 4.6"
description: "Implement UI feature according to the plan with iterative Figma verification until pixel-perfect."
---

> **PREREQUISITE**: Before using this prompt, you MUST first read and understand [tsh-implement.prompt.md](./tsh-implement.prompt.md). This prompt extends the base implementation workflow – you will execute all 11 steps from the base workflow, with UI-specific additions described below.

Implement the UI feature according to the **research context** and **implementation plan**, with continuous verification against Figma designs until the implementation matches the design within the agreed tolerance.

## Required Skills

Before starting, load and follow these skills:

- `tsh-implementing-frontend` - for component patterns, design system usage, composition, and performance guidelines
- `tsh-implementing-filters` - for URL filter synchronization, bracket notation serialization, filter sync hooks, and navigation strategies when implementing filterable lists
- `tsh-ui-verifying` - for understanding verification criteria, tolerances, and what constitutes PASS/FAIL
- `tsh-ensuring-accessibility` - for WCAG 2.1 AA compliance, semantic HTML, ARIA, and automated axe-core verification
- `tsh-technical-context-discovering` - to establish project conventions before implementing

This prompt **extends and does not replace** the base implementation workflow defined in [tsh-implement.prompt.md](./tsh-implement.prompt.md).

---

## Relationship to Base Workflow

- **IMPORTANT**: First, read and fully understand [tsh-implement.prompt.md](./tsh-implement.prompt.md) – it defines the complete base workflow steps
- You MUST execute **all steps** from `tsh-implement.prompt.md`, including **final code review by `tsh-code-reviewer` agent**.
- Treat this prompt as an **extension focused on UI and Figma verification** – it adds UI-specific behaviors but does not remove or replace any base workflow steps.
- All constraints from `tsh-research.prompt.md` and `tsh-plan.prompt.md` remain valid: do not go out of scope, do not re‑implement existing solutions, and always update the plan/checklists instead of silently changing scope.

---

## Design References from Research & Plan

Always treat the **research** and **plan** files as the single source of truth for design links:

- Before starting implementation (during step 1–2 of the base workflow):
  - Open the **research file** (`*.research.md`) and look for:
    - Figma URLs in the `Relevant Links` section.
    - Any specific component/node links mentioned in `Gathered Information`.
  - Open the **plan file** (`*.plan.md`) and look for:
    - Figma URLs and design references in `Task details`.
    - If present, a structured "Design References" subsection mapping views/components to Figma URLs or node IDs.
- Use these Figma URLs as the **default source** for all `figma-mcp-server` calls.

### When Figma link is missing

If you cannot find a Figma URL for the component/section you are about to verify:

1. **Stop the verification loop** for that component
2. **Ask the user** to provide the Figma link for the specific section you need to verify
3. **Wait for the link** before proceeding with verification
4. **Add the link** to the plan file once provided (in `Task details` or `Design References`)

Do NOT:

- Skip verification because the link is missing
- Guess what the design should look like
- Proceed with implementation without Figma reference

When you discover missing or updated design links during implementation, add them to the appropriate sections in the **plan** under `Task details` (and, if needed, note them in the Changelog).

---

## Additional Setup (before starting implementation)

Before step 6 of the base workflow (starting implementation), ensure:

- The local development server is running.
- You can access the page you're implementing (authenticated if needed).
- You have identified and opened all relevant Figma URLs from the research/plan files.
- You understand the design system tokens and components available in the project.

---

## Step Modifications to Base Workflow

This prompt modifies specific steps from [tsh-implement.prompt.md](./tsh-implement.prompt.md). All other steps remain unchanged.

### Modified Step 6: Implement with Figma Verification

When implementing a UI component/section from the plan:

1. Write the code for the component
2. **Before marking the task step as complete**, run `tsh-ui-reviewer` subagent to verify against Figma. Pass it: the Figma URL, the page URL in the running app, and the component/section name. The subagent has `figma-mcp-server` and `playwright` tools — it will extract the Figma design, measure the actual implementation via browser automation, and return a structured verification report.
3. If the report says PASS → mark step complete, move to next
4. If the report says FAIL → fix all differences listed in the report, then run `tsh-ui-reviewer` subagent again (max 5 iterations)
5. Do NOT move to the next task step until verification passes or you escalate

**You MUST NOT verify UI yourself.** You do not have the verification workflow — `tsh-ui-reviewer` does. Do not read Figma and "mentally compare" — that misses CSS dimensions, layout differences, and visual details. Always delegate to the subagent.

This applies to every task step that produces visible UI. Non-visual steps (data fetching, state management, routing) do not need Figma verification.

### Modified Step 7: Update Plan with Verification Status

After completing each task step, update the plan as usual AND note verification result (PASS, number of iterations, or escalation).

### Modified Step 8: Phase Review with UI Check

In addition to the standard phase review:

- Confirm every UI task in the phase passed verification (EXPECTED = ACTUAL)
- Re-run `tsh-ui-reviewer` subagent for high-risk flows if needed

### New Step before 11: UI Verification Summary

Before handing off to `tsh-code-reviewer`:

- List components/sections verified by `tsh-ui-reviewer`
- Number of verification iterations per component
- Any design gaps discovered and how you handled them
- Any deviations from design with rationale

---

## Verification Rules

1. **Every UI component must be verified by `tsh-ui-reviewer` subagent** — minimum once per component, no exceptions. Do not verify UI yourself.
2. **Fix all reported differences** — do not skip or rationalize
3. **Re-run `tsh-ui-reviewer` after every fix** — never assume a fix worked
4. **Maximum 5 iterations per component** — escalate if still failing
5. **Check confidence level** — LOW confidence means tool data may be incomplete, ask user before fixing

### When `tsh-ui-reviewer` returns FAIL

1. Read the difference table from the report
2. Fix code to match EXPECTED values — HIGH confidence: fix exactly; MEDIUM: fix obvious, verify unclear; LOW: ask user before making changes
3. Document fix in Changelog
4. Run `tsh-ui-reviewer` subagent again

### Escalation (after 5 iterations)

If still failing after 5 iterations, **stop** and:

1. List remaining mismatches with Figma URL
2. Describe what you tried in each iteration
3. State suspected root cause
4. Document in Changelog
5. Ask the user for guidance — do not proceed without human decision

### Fallback: When Subagent Returns Errors

If `tsh-ui-reviewer` consistently returns LOW confidence or tool errors:

1. Do not continue the loop blindly
2. Ask the user if they can verify manually (open Figma + app side-by-side)
3. Document the issue in Changelog
4. Continue with next component or escalate if unsure
