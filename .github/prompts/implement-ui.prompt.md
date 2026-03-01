---
agent: "tsh-software-engineer"
model: "Claude Opus 4.6"
description: "Implement UI feature according to the plan with iterative Figma verification until pixel-perfect."
---

> **PREREQUISITE**: Before using this prompt, you MUST first read and understand [implement.prompt.md](./implement.prompt.md). This prompt extends the base implementation workflow – you will execute all 11 steps from the base workflow, with UI-specific additions described below.

Implement the UI feature according to the **research context** and **implementation plan**, with continuous verification against Figma designs until the implementation matches the design within the agreed tolerance.

## Required Skills

Before starting, load and follow these skills:

- `implementing-frontend` - for accessibility, design system usage, component patterns, and performance guidelines
- `ui-verifying` - for understanding verification criteria, tolerances, and what constitutes PASS/FAIL
- `technical-context-discovering` - to establish project conventions before implementing

This prompt **extends and does not replace** the base implementation workflow defined in [implement.prompt.md](./implement.prompt.md).

---

## Relationship to Base Workflow

- **IMPORTANT**: First, read and fully understand [implement.prompt.md](./implement.prompt.md) – it defines the complete base workflow steps
- You MUST execute **all steps** from `implement.prompt.md`, including **final code review by `tsh-code-reviewer` agent**.
- Treat this prompt as an **extension focused on UI and Figma verification** – it adds UI-specific behaviors but does not remove or replace any base workflow steps.
- All constraints from `research.prompt.md` and `plan.prompt.md` remain valid: do not go out of scope, do not re‑implement existing solutions, and always update the plan/checklists instead of silently changing scope.

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

## UI Verification Loop (per UI component/section)

After implementing each UI component, run a verification loop using `review-ui.prompt.md` until the implementation matches the Figma design.

### Core Loop

```
BEFORE starting:
    0. Ensure you have a Figma URL → if not, ASK user

REPEAT (max 5 iterations):
    1. Call /review-ui to verify current implementation
    2. If PASS → done, exit loop
    3. If FAIL → fix the reported differences → go to step 1
```

### Rules

1. **Call `/review-ui` for every verification** – do not verify manually or skip this step
2. **Fix all reported differences** – do not skip or rationalize
3. **Verify again after fixing** – always re-run `/review-ui`
4. **Maximum 5 iterations** – escalate if still not matching
5. **Check confidence level** – if `/review-ui` returns LOW confidence, consider manual verification before fixing

### When `/review-ui` returns FAIL

1. Read the difference table from the report
2. Check confidence level:
   - **HIGH**: Fix code to match EXPECTED values exactly
   - **MEDIUM**: Fix obvious differences, manually verify unclear ones
   - **LOW**: Manually verify before making changes, tool data may be incomplete
3. Document fix in Changelog
4. Run `/review-ui` again

### Fallback: When Tools Are Unreliable

If `/review-ui` consistently returns LOW confidence or tool errors:

1. **Do not continue the automated loop blindly**
2. **Perform manual verification**:
   - Open Figma design in browser
   - Open running app side-by-side
   - Compare visually and note differences
3. **Document the manual verification** in Changelog
4. **Continue with next component** or escalate if unsure

### Escalation (after 5 iterations)

If still failing after 5 iterations:

1. **Stop the loop** – do not start a 6th iteration
2. **Prepare an escalation report** including:
   - Figma URL and component/screen being verified
   - Summary of each iteration: what changed, what remained
   - Current remaining mismatches (grouped by structure, dimensions, visual, components)
   - Suspected root causes (missing design tokens, conflicting constraints, missing Figma specs, etc.)
3. **Document in Changelog** – record the escalation and remaining issues
4. **Recommend next steps**:
   - If design is ambiguous → ask design owner for clarification
   - If issues seem architectural → escalate to architect
   - If blocked by technical constraints → document constraints and seek guidance
5. **Ask for guidance** – explicitly request human decision before proceeding

---

## Additional Phase Review (extension of step 8)

When performing the phase review required by the base workflow:

- Confirm that every UI‑related task in the phase has passed the verification loop (EXPECTED = ACTUAL)
- Re‑run targeted UI verification for any high‑risk flows if needed

---

## UI Verification Summary (before step 11)

Before handing off to the `tsh-code-reviewer` agent:

- List components/sections verified
- Number of verification iterations per component
- Any design gaps discovered and how you handled them
- Any deviations from design with rationale (accessibility, technical constraints)
