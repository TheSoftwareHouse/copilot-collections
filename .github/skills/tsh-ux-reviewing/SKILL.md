---
name: tsh-ux-reviewing
description: "UX review and validation against Laws of UX, Nielsen's 10 usability heuristics, and team design standards. Use when reviewing designs for usability issues, validating design decisions, auditing existing screens, or providing structured UX feedback on prototypes."
---

# Reviewing UX

Performs structured UX reviews of Figma designs by checking them against established UX laws and usability heuristics. Produces actionable findings categorized by severity.

<principles>

<evidence-based>
Every finding must reference a specific UX law or heuristic. Never provide subjective feedback like "this doesn't look right" — always tie findings to established principles with a concrete explanation of the violation and suggested fix.
</evidence-based>

<severity-driven>
Categorize every finding by severity (critical, major, minor, suggestion) to help designers prioritize. Critical = blocks users from completing tasks. Major = causes significant confusion. Minor = suboptimal but functional. Suggestion = improvement opportunity.
</severity-driven>

<design-context-aware>
Always inspect the actual design in Figma using `figma/*` tools before reviewing. Never review based on descriptions alone. Understand the target audience, platform, and use case before applying heuristics.
</design-context-aware>

</principles>

## UX Review Process

Use the checklist below and track your progress:

```
Review progress:
- [ ] Step 1: Gather design context
- [ ] Step 2: Run Laws of UX check
- [ ] Step 3: Run Nielsen's Heuristics check
- [ ] Step 4: Check design system compliance
- [ ] Step 5: Compile review report
```

**Step 1: Gather design context**

- Use `figma/*` tools to inspect the design being reviewed
- Identify the target screens/flows for review
- Understand the feature's purpose and target user persona
- Ask the user about specific review focus areas if not provided

**Step 2: Run Laws of UX check**

Evaluate the design against these key UX laws:

| Law                        | What to check                                                                |
| -------------------------- | ---------------------------------------------------------------------------- |
| Hick's Law                 | Are there screens with too many choices? Is progressive disclosure used?     |
| Fitts's Law                | Are interactive elements large enough? Are primary actions easily reachable? |
| Jakob's Law                | Does the design follow platform conventions users already know?              |
| Miller's Law               | Is information grouped in digestible chunks (5-9 items)?                     |
| Law of Proximity           | Are related elements grouped spatially?                                      |
| Law of Similarity          | Do similar elements have consistent visual treatment?                        |
| Aesthetic-Usability Effect | Is the visual design polished enough to support perceived usability?         |
| Doherty Threshold          | Are loading states and feedback designed for perceived speed?                |
| Von Restorff Effect        | Do key CTAs and important elements stand out visually?                       |
| Peak-End Rule              | Are key moments (onboarding, success states, errors) well-designed?          |
| Serial Position Effect     | Are the most important items at the beginning or end of lists?               |
| Goal-Gradient Effect       | Do multi-step flows show progress and proximity to completion?               |
| Tesler's Law               | Is inherent complexity managed instead of eliminated incorrectly?            |

**Step 3: Run Nielsen's Heuristics check**

Evaluate the design against all 10 heuristics:

1. **Visibility of System Status** — Are there loading indicators, progress bars, confirmation states?
2. **Match Between System and Real World** — Does it use familiar terminology and mental models?
3. **User Control and Freedom** — Can users undo, go back, cancel, exit?
4. **Consistency and Standards** — Are patterns consistent within the design and across the platform?
5. **Error Prevention** — Are destructive actions guarded? Are inputs constrained?
6. **Recognition Rather than Recall** — Are options visible? Are labels descriptive?
7. **Flexibility and Efficiency** — Are shortcuts available for expert users?
8. **Aesthetic and Minimalist Design** — Is every element necessary? Is content focused?
9. **Help Users Recognize, Diagnose, Recover from Errors** — Are error states clear and actionable?
10. **Help and Documentation** — Are tooltips, onboarding hints, or help available where needed?

**Step 4: Check design system compliance**

- Verify components are from the design system library (not detached or custom recreations)
- Verify variables are used for colors, spacing, typography
- Verify naming conventions are followed
- Verify auto-layout is used properly

**Step 5: Compile review report**

Produce findings in this format:

```
## UX Review Report

### Summary
- Total findings: {count}
- Critical: {count} | Major: {count} | Minor: {count} | Suggestion: {count}

### Findings

#### [{severity}] {Short title}
- **Screen/Frame**: {frame name or path}
- **Principle violated**: {UX law or heuristic name}
- **Issue**: {Description of what's wrong}
- **Impact**: {How this affects users}
- **Recommendation**: {Specific fix suggestion}
```

## Severity Reference

| Severity   | Definition                                       | Action                    |
| ---------- | ------------------------------------------------ | ------------------------- |
| Critical   | Blocks users from completing core tasks          | Must fix before release   |
| Major      | Causes significant user confusion or frustration | Should fix before release |
| Minor      | Suboptimal but users can complete tasks          | Fix in next iteration     |
| Suggestion | Enhancement opportunity, no current problem      | Consider for future       |

## Connected Skills

- `tsh-figma-designing` — for understanding team Figma conventions and design system rules that inform the design system compliance check
- `tsh-ensuring-accessibility` — for accessibility-specific review criteria that complement UX heuristic checks
- `tsh-ui-verifying` — for implementation-vs-design verification, which is a separate concern from UX review
