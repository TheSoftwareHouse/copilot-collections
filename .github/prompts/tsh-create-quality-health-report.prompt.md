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

**Delivery destination** — always use `vscode/askQuestions` to ask where the quality health report should be delivered. Do not assume a destination from flags alone; the user must explicitly confirm. Present these options:
- **Chat only** — Markdown dashboard in conversation
- **HTML file** — Standalone HTML dashboard with Chart.js visualizations saved to workspace
- **Publish to Confluence** — Published to a Confluence space (ask for space key and optionally parent page title)
- **Create Jira ticket** — New Jira ticket with dashboard as description (ask for project key and issue type)

The user may skip this step — if skipped, default to chat delivery. If the user provided a flag inline (e.g., `--html`, `--confluence`), use it as the pre-selected option but still present the question for confirmation. If the user selects Confluence or Jira but cannot provide the required identifiers (space key, project key, etc.), ask them to provide the missing information before proceeding — do not fall back silently to chat.

The report must include visual classification of bugs into **🐛 Bugs** (standalone defects) and **📖 Story Bugs** (bugs tied to user stories). Follow the skill's Bug Classification Breakdown section. If the project has no Story Bug issue type and no bugs are linked to stories, note this finding and present all bugs as Bugs.

Confluence cross-referencing is skipped by default. Only fetch Confluence context when the user passes `--with-confluence` or explicitly asks for it.

</workflow>

<constraints>

## Constraints

- Do not generate test plans, regression plans, or E2E scripts — use the appropriate prompts/agents for those.
- Do not infer or complete missing acceptance criteria — this prompt analyzes existing bugs, not requirements.
- If no bugs are found, report that finding and suggest broadening the search criteria.
- When publishing to Confluence or Jira, confirm the destination before creating/posting.

</constraints>
