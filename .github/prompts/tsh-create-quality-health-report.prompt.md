---
agent: "tsh-qa-engineer"
model: "Claude Opus 4.6"
description: "Create a quality health report from Jira data — defect density, regression risk indicators, and recommended testing focus. Output to chat, HTML file, Confluence page, or Jira ticket."
argument-hint: "[Jira project key, epic key, or feature area] [--chat|--html|--confluence|--jira] [--with-confluence]"
---

<goal>
Analyze existing Jira bugs for a given project, epic, or feature area and produce a structured quality health report. The user chooses where the report is delivered.
</goal>

<required-skills>

## Required Skills

Before starting, load and follow these skills:

- `tsh-analyzing-bugs` - provides the full workflow, output templates, and the HTML report template at `./quality-health-report.example.html`

</required-skills>

<workflow>

## Workflow

Follow the workflow from the `tsh-analyzing-bugs` skill.

The user can specify the output destination inline via flags appended to the argument:
- `--chat` → Markdown dashboard in conversation
- `--html` → Standalone HTML dashboard saved to workspace
- `--confluence` → Published to a Confluence space (will ask for space key)
- `--jira` → New Jira ticket with dashboard as description
- `--with-confluence` → Cross-reference Jira data with Confluence regression docs

If no destination flag is provided, ask the user via `vscode/askQuestions`.

Confluence cross-referencing is skipped by default. Only fetch Confluence context when the user passes `--with-confluence` or explicitly asks for it.

</workflow>

<constraints>

## Constraints

- Do not generate test plans, regression plans, or E2E scripts — use the appropriate prompts/agents for those.
- Do not infer or complete missing acceptance criteria — this prompt analyzes existing bugs, not requirements.
- If no bugs are found, report that finding and suggest broadening the search criteria.
- When publishing to Confluence or Jira, confirm the destination before creating/posting.

</constraints>
