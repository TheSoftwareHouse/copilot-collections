---
agent: "tsh-qa-engineer"
model: "Claude Opus 4.6"
description: "Conduct a WCAG 2.2 Level AA accessibility audit on a URL or codebase, producing a technical audit report or business-facing summary."
argument-hint: "[URL to audit, or 'audit' for internal codebase audit]"
---

Conduct a comprehensive WCAG 2.2 Level AA accessibility audit using automated tools and manual testing following the POUR methodology. Depending on input, perform either an external audit (URL provided) or internal audit (codebase access). Produce a structured technical audit report with findings classified by severity. Optionally generate a business-facing summary on request.

## Required Skills

Before starting, load and follow these skills:

- `tsh-accessibility-auditing` - provides the POUR-based audit process, severity matrix, WCAG 2.2 criteria, manual testing checklists, report templates, and business summary format

## Workflow

Follow the Audit Process defined in the `tsh-accessibility-auditing` skill. The skill contains the complete workflow including:

1. Detect audit mode — determine if this is an external audit (URL provided) or internal audit (codebase access). If unclear, ask the user
2. Run automated tools — execute at least 2-3 CLI tools. The skill's `./references/automated-tools.md` has the full tool list and commands
3. Perform manual testing — keyboard navigation, screen reader, and visual checks per the skill's manual testing section
4. Check WCAG 2.2 new criteria — verify all 9 new success criteria from the skill's `./references/wcag22-new-criteria.md`
5. Classify and de-duplicate findings using the skill's severity matrix
6. Generate the technical audit report using the skill's `audit-report.example.md` template

After delivering the report, ask the user if they want a business-facing summary. If yes, generate it using the `business-summary.example.md` template from the skill.

## Constraints

- Always cite the exact WCAG Success Criterion number and official title (e.g., "1.1.1 Non-text Content").
- Do not report SC 4.1.1 Parsing — it was removed in WCAG 2.2.
- For external audits, note that fixes are recommendations only — no access to source code.
- Always run at least 2-3 automated tools — no single tool catches more than 30-40% of issues.
- When in doubt on severity, classify up (more severe) rather than down.
