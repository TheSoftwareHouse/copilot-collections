---
agent: "tsh-product-designer"
model: "Claude Opus 4.6"
description: "Perform a structured UX review of Figma designs against Laws of UX and Nielsen's usability heuristics. Used by tsh-design-manager to delegate UX validation."
---

Review the specified Figma design screens against Laws of UX, Nielsen's 10 usability heuristics, and team design standards.

## Required Skills

Before starting, load and follow these skills:

- `tsh-ux-reviewing` — UX review process, Laws of UX checklist, Nielsen's heuristics checklist
- `tsh-figma-designing` — team conventions for inspecting design structure

## Reference Materials

Primary UX review frameworks:

- **Laws of UX** ([https://lawsofux.com/](https://lawsofux.com/)) — the canonical reference for all 13+ UX laws checked in step 4. Every law-based finding must cite the specific law from this source.
- **Nielsen's 10 Usability Heuristics** ([https://www.nngroup.com/articles/ten-usability-heuristics/](https://www.nngroup.com/articles/ten-usability-heuristics/)) — the canonical reference for all heuristic findings in step 5. Every heuristic-based finding must cite the specific heuristic from this source.

If installed in the project, also leverage these community skills for enhanced review depth:

- `vercel-labs/agent-skills@web-design-guidelines` — design review checklist for spacing, typography, hierarchy, and interaction patterns
- `supercent-io/skills-template@web-accessibility` — accessibility review for contrast, keyboard navigation, and semantic structure
- `nextlevelbuilder/ui-ux-pro-max-skill@ui-ux-pro-max` — visual hierarchy and interaction pattern analysis

## Workflow

1. **Read and load all required skills** before proceeding.
2. **Inspect target screens**: Use `figma/*` tools to inspect the target screens/components specified by the calling orchestrator.
3. **Gather context**: Understand the feature purpose, target users, and design brief from the provided context.
4. **Run Laws of UX check**: Check against all applicable laws (13 laws from `tsh-ux-reviewing` skill).
5. **Run Nielsen's heuristics check**: Check against Nielsen's 10 usability heuristics.
6. **Check design system compliance**: Verify correct component usage, variable usage, naming conventions.
7. **Compile findings**: Compile findings into a severity-categorized report:
   - **Critical**: Issues that will cause usability failures or block user goals
   - **Major**: Issues that significantly degrade user experience
   - **Minor**: Issues that are noticeable but don't block goals
   - **Suggestion**: Opportunities for improvement
8. **Cite principles**: Every finding MUST reference a specific UX law or heuristic — no subjective opinions.
9. **Return structured report**: Return the structured report with: screen/component reference, finding, severity, principle violated, recommendation.

## Constraints

- All inspection MUST use `figma/*` tools — never review based on descriptions alone.
- Every finding must cite a specific principle (e.g., "Violates Fitts's Law", "Fails Heuristic #4: Consistency and Standards").
- Do not suggest implementation changes — focus on design-level recommendations.
- If the Figma file URL or specific screens are not provided, ask the user — do not guess.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-review-ux-task:v2 -->
