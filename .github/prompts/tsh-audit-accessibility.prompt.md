---
agent: "tsh-qa-engineer"
model: Claude Opus 4.6
description: "Conduct a WCAG 2.2 Level AA accessibility audit on a URL or codebase, producing a technical audit report or business-facing summary."
argument-hint: "[URL to audit, or 'audit' for internal codebase audit]"
tools: ['playwright/*', 'atlassian/*', 'sequential-thinking/*', 'execute', 'read', 'search', 'edit', 'vscode/askQuestions']
---

<goal>
Conduct a comprehensive WCAG 2.2 Level AA accessibility audit using automated tools and manual testing following the POUR methodology. Depending on input, perform either an external audit (URL provided) or internal audit (codebase access). Produce a structured technical audit report with findings classified by severity. Optionally generate a business-facing summary on request.
</goal>

<required-skills>
## Required Skills

Before starting, load and follow these skills:
- `tsh-accessibility-auditing` - provides the POUR-based audit process, severity matrix, WCAG 2.2 criteria, manual testing checklists, report templates, and business summary format
</required-skills>

<workflow>
## Workflow

1. **Detect mode**: Determine if this is an external audit (URL provided) or internal audit (codebase). If unclear, ask the user.
2. **Load skill**: Load the `tsh-accessibility-auditing` skill and follow its Audit Process step by step.
3. **Run automated tools**: Execute at least 2-3 CLI accessibility tools against the target using the `execute` tool. Reference `automated-tools.md` from the skill for commands.
4. **Manual testing**: Perform keyboard navigation, screen reader, and visual checks as described in the skill's manual testing section.
5. **Check WCAG 2.2 new criteria**: Explicitly verify all 9 new success criteria from `wcag22-new-criteria.md`.
6. **Classify findings**: Rate each issue using the severity matrix. De-duplicate across tools.
7. **Generate report**: Produce the technical audit report using the `audit-report.example.md` template.
8. **Offer summary**: Inform the user they can request a business-facing summary using `/audit-summary`.
</workflow>

<constraints>
## Constraints

- Always cite the exact WCAG Success Criterion number and official title (e.g., "1.1.1 Non-text Content").
- Do not report SC 4.1.1 Parsing — it was removed in WCAG 2.2.
- For external audits, note that fixes are recommendations only — no access to source code.
- For internal audits with `/fix`, provide exact code fixes with explanations.
- Always run at least 2-3 automated tools — no single tool catches more than 30-40% of issues.
- When in doubt on severity, classify up (more severe) rather than down.
</constraints>
