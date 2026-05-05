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

1. **Ask delivery destination** — always use `vscode/askQuestions` to ask where the audit report should be delivered. Do not assume a destination; the user must choose:
   - **Chat only** — display the report in the conversation
   - **Publish to Confluence** — create or update a Confluence page with the audit report. If chosen, ask for the Confluence space key and optionally a parent page title.
   - **Add to Jira ticket** — post as a comment on an existing Jira ticket. If chosen, ask for the target ticket ID.
   - **Create Jira sub-task** — create an "Accessibility Audit" sub-task under a source ticket. If chosen, ask for the parent ticket ID.
   - **Save as HTML file** — save the report as a standalone HTML file in the workspace.
   Store the choice and apply it in step 7. If the user selects a destination but cannot provide the required identifiers (space key, ticket ID, etc.), ask them to provide the missing information before proceeding — do not fall back silently to chat.
2. Detect audit mode — determine if this is an external audit (URL provided) or internal audit (codebase access). If unclear, ask the user
3. Run automated tools — execute at least 2-3 CLI tools. The skill's `./references/automated-tools.md` has the full tool list and commands
4. Perform manual testing — keyboard navigation, screen reader, and visual checks per the skill's manual testing section
5. Check WCAG 2.2 new criteria — verify all 9 new success criteria from the skill's `./references/wcag22-new-criteria.md`
6. Classify and de-duplicate findings using the skill's severity matrix
7. **Deliver the audit report** — generate the technical audit report using the skill's `audit-report.example.md` template, then deliver based on the destination chosen in step 1:
   - **Chat only**: present in the conversation. Use the template's formatting (severity emoji, tables, WCAG criterion citations) to ensure readability.
   - **Publish to Confluence**: create a page titled "Accessibility Audit — [URL/feature] — [date]" in the specified space using the `atlassian` tool. Confirm with link.
   - **Add to Jira ticket**: post as a comment using the `atlassian` tool, confirm with link.
   - **Create Jira sub-task**: create a sub-task titled "Accessibility Audit" using the `atlassian` tool, confirm with link.
   - **Save as HTML file**: save to the workspace root. Confirm with file path.
   If delivery fails (e.g., invalid space key, permission error), inform the user of the error and ask them to provide a valid destination before retrying.

After delivering the report, ask the user if they want a business-facing summary. If yes, generate it using the `business-summary.example.md` template from the skill and deliver to the same destination.

## Constraints

- Always cite the exact WCAG Success Criterion number and official title (e.g., "1.1.1 Non-text Content").
- Do not report SC 4.1.1 Parsing — it was removed in WCAG 2.2.
- For external audits, note that fixes are recommendations only — no access to source code.
- Always run at least 2-3 automated tools — no single tool catches more than 30-40% of issues.
- When in doubt on severity, classify up (more severe) rather than down.
