---
sidebar_position: 14
title: /tsh-review-ux
---

# /tsh-review-ux

**Agent:** Product Designer  
**File:** `.github/prompts/tsh-review-ux.prompt.md`

Reviews Figma designs for UX issues against Laws of UX and Nielsen's usability heuristics. Produces a severity-categorized report with actionable recommendations.

## Usage

```text
/tsh-review-ux <Figma file URL or description of screens to review>
```

## What It Does

1. **Identifies review targets** — Determines which Figma screens to review from the provided URL or user description.
2. **Gathers design context** — Inspects the design via Figma MCP tools to understand feature purpose and target users.
3. **Runs UX review** — Checks against 13 Laws of UX, Nielsen's 10 heuristics, and design system compliance.
4. **Compiles report** — Produces structured findings categorized by severity (critical, major, minor, suggestion).

## Skills Loaded

- `tsh-ux-reviewing` — Structured UX review process, heuristic checklists, report format.
- `tsh-figma-designing` — Team conventions and design system compliance criteria.

## Output

- Severity-categorized UX review report.
- Each finding includes: violated principle, issue description, impact, and specific fix recommendation.
- Summary with finding counts per severity level.
