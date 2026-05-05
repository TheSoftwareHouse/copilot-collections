---
agent: "tsh-qa-engineer"
model: "Claude Opus 4.6"
description: "Create a professional bug report with severity classification, steps to reproduce, and Jira-ready formatting."
argument-hint: "[Bug description, observed behavior, or Jira ticket ID for context]"
---

Create a professional, structured bug report from the provided bug description or observed behavior. The report follows the standard bug report template with severity classification, clear reproduction steps, and expected vs actual behavior. Output is formatted for direct use in Jira or team communication.

## Required Skills

Before starting, load and follow these skills:
- `tsh-functional-testing` - provides the severity matrix for bug classification

## Workflow

Follow the bug reporting process from the `tsh-functional-testing` skill:

1. **Ask delivery destination** — always use `vscode/askQuestions` to ask where the bug report should be delivered. Do not assume a destination; the user must choose:
   - **Chat only** — display the bug report in the conversation
   - **Create Jira bug** — create a new bug issue in Jira. If chosen, ask for the project key. If a source ticket is in context, offer to link the bug to it.
   - **Add to Jira ticket** — post as a comment on an existing Jira ticket. If chosen, ask for the target ticket ID.
   - **Publish to Confluence** — create or update a Confluence page with the bug report. If chosen, ask for the Confluence space key and optionally a parent page title.
   Store the choice and apply it in step 5. If the user selects a destination but cannot provide the required identifiers (project key, ticket ID, space key, etc.), ask them to provide the missing information before proceeding — do not fall back silently to chat.
2. Gather bug details — if a Jira ticket ID is provided, use the `atlassian` tool to fetch related ticket details
3. Structure the report following the `bug-report.example.md` template from `tsh-functional-testing`, classifying severity using the skill's severity matrix. Use the template's formatting exactly — emoji severity indicators, numbered steps, clear tables.
4. Review completeness — verify the report contains enough detail for a developer to reproduce the issue without additional context
5. **Deliver the bug report** — based on the destination chosen in step 1:
   - **Chat only**: present in the conversation. Use the template's formatting (emoji, tables, headings) to ensure readability.
   - **Create Jira bug**: create the issue using the `atlassian` tool. Link to the source ticket if in context. Confirm with issue key and link.
   - **Add to Jira ticket**: post as a comment using the `atlassian` tool, confirm with link.
   - **Publish to Confluence**: create a page titled "Bug Report — [summary] — [date]" in the specified space using the `atlassian` tool. Confirm with link.
   If delivery fails (e.g., invalid project key, permission error), inform the user of the error and ask them to provide a valid destination before retrying.

## Constraints

- Every bug report must include numbered Steps to Reproduce — vague descriptions like "it doesn't work" are not acceptable.
- Severity must be classified using the severity matrix (Critical / High / Medium / Low) with justification.
- Do not speculate on root cause unless evidence is clear — focus on observable behavior.
- If the user provides insufficient information to write a complete report, ask for the missing details before generating.
