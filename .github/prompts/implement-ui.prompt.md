---
agent: "tsh-frontend-software-engineer"
model: "Claude Opus 4.5"
description: "Implement UI feature according to the plan with iterative Figma verification until pixel-perfect."
---

Implement the UI feature according to the **research context** and **implementation plan**, with continuous verification against Figma designs until the implementation matches the design within the agreed tolerance.

This prompt **extends and does not replace** the base implementation workflow defined in [implement.prompt.md](./implement.prompt.md).

---
## Relationship to Base Workflow

- **IMPORTANT**: First, read and fully understand [implement.prompt.md](./implement.prompt.md) – it defines the complete base workflow steps
- You MUST execute **all steps** from `implement.prompt.md`, including *final code review by `tsh-code-reviewer` agent**.
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
- Use these Figma URLs as the **default source** for all Figma MCP calls.
- Only ask the user for a Figma URL or node ID if:
   - No Figma links are available in research/plan, or
   - You are implementing a UI that is clearly out of scope of the documented design references.

When you discover missing or updated design links during implementation, add them to the appropriate sections in the **plan** under `Task details` (and, if needed, note them in the Change Log).

---
## Additional Setup (before starting implementation)

Before step 6 of the base workflow (starting implementation), ensure:

- The local development server is running.
- You have identified and opened all relevant Figma URLs from the research/plan files.
- You understand the design system tokens and components available in the project (rely on project docs and code, do not invent new tokens unless the plan explicitly allows it).

---
## UI Verification Loop (per UI component/section)

This is an **iterative refinement process**. The goal is to continuously compare your implementation against the Figma design and fix any differences until they match. You drive this loop autonomously.

### Core Principle

```
REPEAT until implementation matches Figma:
    1. Get EXPECTED state from Figma MCP
    2. Get ACTUAL state from Playwright MCP  
    3. Compare EXPECTED vs ACTUAL
    4. If differences exist → fix the code → go back to step 1
    5. If no differences → done
```

**This is a self-correcting loop. Every difference you find MUST be fixed before you can exit the loop.**

---

### Loop Execution Rules

1. **Call BOTH tools in EVERY iteration**
   - You MUST call Figma MCP to get EXPECTED state
   - You MUST call Playwright MCP to get ACTUAL state
   - You MUST compare them in the same response
   - Never rely on memory of previous Figma calls

2. **Every difference triggers a fix**
   - If EXPECTED ≠ ACTUAL → fix the code to match EXPECTED
   - Do not skip differences or mark them as "acceptable"
   - Do not rationalize why the difference is okay
   - The only acceptable variance is 1-2px browser rendering differences

3. **After fixing, verify again**
   - After each code fix, run another full iteration (Figma + Playwright)
   - Continue until no differences remain
   - Maximum 5 iterations per component (escalate if still not matching)

4. **Do not exit the loop prematurely**
   - You can only mark a task as done when EXPECTED = ACTUAL
   - Finding a difference and not fixing it means the loop is not complete

---

### Iteration Steps

**Step 1: Get EXPECTED (Figma MCP)**
- Call Figma MCP for the current component/node
- Extract all design values: layout, spacing, typography, colors, dimensions, states

**Step 2: Get ACTUAL (Playwright MCP)**
- Navigate to the running app
- Capture: accessibility tree, screenshot, console errors

**Step 3: Compare side-by-side**
- Compare each property from Figma against implementation
- List all differences found

**Step 4: Decision point**
- **If differences found**: Fix the code, document in Change Log, go back to Step 1
- **If no differences**: Mark task as complete, exit loop

---

### What to do when you find a difference

When EXPECTED ≠ ACTUAL:

1. **Fix the code** – change your implementation to match Figma exactly
2. **Document the fix** – add a brief note to the plan's Change Log
3. **Verify the fix** – run another iteration (back to Step 1)
4. **Repeat** – until no differences remain

**Do not:**
- Skip the fix because the current implementation "works"
- Classify differences as "minor" or "within tolerance" (unless truly 1-2px browser variance)
- Exit the loop while differences exist
- Ask the user if you should fix it – just fix it

---

### Escalation (after 5 iterations)

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

---
## Guidelines

- **Tolerance**: Only 1-2px browser rendering differences. All other differences must be fixed.
- **Design gaps**: If Figma lacks a state, follow existing design system patterns and document it.
- **Responsive**: If Figma shows multiple breakpoints, verify them. Otherwise ensure graceful degradation.
- **Accessibility**: Check focus order, keyboard navigation, labels, color contrast.
