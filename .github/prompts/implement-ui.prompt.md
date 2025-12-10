---
agent: "tsh-frontend-software-engineer"
model: "Claude Opus 4.5 (Preview)"
description: "Implement UI feature according to the plan with iterative Figma verification until pixel-perfect."
---

Implement the UI feature according to the **research context** and **implementation plan**, with continuous verification against Figma designs until the implementation matches the design within the agreed tolerance.

This prompt **extends and does not replace** the base implementation workflow defined in [implement.prompt.md](./implement.prompt.md).

---
## Relationship to Base Workflow

- **IMPORTANT**: First, read and fully understand [implement.prompt.md](./implement.prompt.md) – it defines the complete base workflow (steps 1–11) that you MUST follow.
- You MUST execute **all steps (1–11)** from `implement.prompt.md`, including **step 11 (final code review by `tsh-code-reviewer` agent)**.
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

During step 6–7 of the base workflow, after implementing each UI component or section, you must run the following **EXPECTED vs ACTUAL verification loop** **automatically** before marking the corresponding task as completed in the plan.

- Treat this loop as a fully automated process:
   - Invoke Figma MCP and Playwright MCP on your own.
   - Repeat the steps until the criteria are met or the iteration limit is reached.
   - Do not ask the user for permission before each individual iteration.

### 1. Determine the design reference for the current scope

- Map the current component/section to a Figma reference using, in order:
   - Explicit mapping from the plan's `Task details` / `Design References`.
   - Figma URLs in the research file's `Relevant Links` section.
   - If multiple URLs match, choose the one whose name/description best matches the current component or view.
- If no suitable Figma link exists, document this in the plan (`Change Log` and/or a short note in the relevant phase) and, if appropriate, ask for clarification.

### 2. FIRST: Extract Figma specifications (EXPECTED) via Figma MCP

- You MUST call Figma MCP tools **before** evaluating the implementation.
- For the chosen Figma URL/node:
   - Extract layout structure (containers, groups, grids).
   - Extract spacing, typography, colors, radii, shadows, and component variants.
   - Identify relevant states (default, hover, active, error, loading, disabled, etc.).
- Treat the extracted information as the **EXPECTED** design contract.

### 3. SECOND: Capture the current implementation (ACTUAL) via Playwright

- Use Playwright MCP to:
   - Navigate to the page/route showing the implemented component.
   - Capture the accessibility tree to understand structure and semantics.
   - Capture at least one screenshot for visual comparison.
   - Check for console errors/warnings related to the view.
- Treat this as the **ACTUAL** implementation snapshot.

### 4. THIRD: Compare EXPECTED vs ACTUAL

Compare in the following order:

- **Structure**:
   - Presence and count of key containers and elements.
   - Nesting and grouping (e.g. header, content, sidebar, tabs, buttons).
   - Component usage (design‑system components vs custom markup).
- **Visual details**:
   - Spacing (margins/paddings/gaps, alignment).
   - Typography (font family, size, weight, line height, letter spacing).
   - Color usage (tokens and semantic roles, including states).
   - Radii, borders, shadows, dividers.
- **Behavior and states**:
   - Visible states present in Figma (hover, focus, error, disabled, loading).
   - Responsive behavior if Figma specifies multiple breakpoints.

Classify each mismatch as:

- **Critical** – structural mismatch (missing/extra sections, wrong hierarchy, incorrect component used).
- **Major** – wrong component variant, incorrect token usage, missing important state, clear visual deviation.
- **Minor** – small spacing/typography tweaks, low‑impact visual nits within tolerance.

### 5. Fix and iterate (auto‑loop with iteration limit)

If any mismatches are found:

- Adjust the implementation to resolve them.
- Briefly document the changes in the plan's `Change Log` (e.g. "Adjusted spacing between header and tabs to match Figma").
- **Automatically repeat steps 3–4** for the same component/section until the criteria are met or the iteration limit is reached.

You MUST treat this as an internal loop you drive yourself:

- Do not ask the user whether to run another Playwright/Figma check.
- Run another capture/compare cycle whenever the code changes in a way that could affect the ACTUAL UI state.

If after several iterations:

- All Critical and Major mismatches have been resolved, and
- Any remaining differences (if present) are Minor and within tolerance,

→ then:

- Mark the relevant task in the plan as done (checkbox).
- Note in your working notes or commit message that the component passed Figma verification.

---
## Additional Phase Review (extension of step 8)

When performing the phase review required by the base workflow:

- Confirm that every UI‑related task in the phase has:
   - Passed the verification loop described above, and
   - Had its task checkbox updated in the plan.
- Re‑run targeted UI verification (Figma + Playwright) for any high‑risk flows or complex views if the phase introduced cross‑cutting changes.

---
## UI Verification Summary (before step 11)

Before handing off to the `tsh-code-reviewer` agent (step 11 of the base workflow):

- Prepare a concise **UI Verification Summary** to include in your final response:
   - List of components/sections verified.
   - Number of verification iterations per component.
   - Any design gaps or ambiguities discovered (e.g. missing states in Figma) – and how you handled them.
   - Any deliberate deviations from the design (if any) with rationale (e.g. accessibility, technical constraints).

---
## Verification Loop Guidelines

- **Maximum iterations (hard limit)**: For each individual component/section:
   - You MUST NOT perform more than **5 full cycles** of: (Playwright capture → comparison with EXPECTED → code fix).
   - If after 5 iterations Critical or Major mismatches still exist:
      - Stop the automatic loop.
      - Describe the blockers and current state in detail in the plan's `Change Log` and in your final summary.
      - Explicitly ask the user whether to continue further iterations or escalate the issue to the architect/designer.
- **Tolerance**: Allow 1–2px visual tolerance and minor rendering differences across browsers; focus on **design intent** and consistency with the design system, not pixel‑by‑pixel matching.
- **Design gaps**: If Figma lacks a state or variant that is clearly needed:
   - Follow the existing design‑system patterns.
   - Document the chosen approach and the gap in the plan (e.g. under `Quality assurance` notes or `Change Log`).
- **Responsive behavior**: If Figma specifies multiple breakpoints, verify at least desktop and one smaller breakpoint; otherwise, ensure the layout degrades gracefully.
- **Accessibility**: During Playwright checks, always pay attention to:
   - Focus order and keyboard navigation.
   - Accessible names/labels for interactive elements.
   - Sufficient color contrast, especially for text and key UI controls.
