---
name: tsh-analyzing-bugs
description: "Quality health report creation from Jira data — defect density by feature area, regression risk indicators, bug age analysis, creation vs resolution trends, and recommended testing focus areas. Delivers to chat, HTML file, Confluence page, or Jira ticket. Use when analyzing bug trends, creating quality health reports, assessing defect density, or identifying regression risk from bug history."
---

# Analyzing Bugs

Creates quality health reports from Jira bug data to surface defect density, regression risk, and recommended manual testing focus areas.

## Workflow

```
Progress:
- [ ] Step 1: Determine output destination
- [ ] Step 2: Gather all bug data from Jira (single query)
- [ ] Step 3: Analyze and classify
- [ ] Step 4: Deliver dashboard
- [ ] Step 5: (Optional) Fetch Confluence context
```

**Step 1: Determine output destination**

Always use `vscode/askQuestions` to ask the user where the report should be delivered. Do not assume a destination — the user must choose. If the user provided a flag inline (e.g., `--html`), pre-select that option but still present the question for confirmation.

Options (the user may also skip this step — if skipped, default to chat delivery):

- **Here in chat** — Markdown dashboard in the conversation.
- **HTML file** — Standalone HTML with Chart.js visualizations, saved to workspace.
- **Confluence page** — Ask for destination space key and (optionally) parent page title or URL.
- **Jira ticket** — Create a new ticket in the project with the dashboard as the description. Ask for issue type (default: Task) and any additional labels.

**Step 2: Gather all bug data from Jira (single query)**

Use a **single JQL query** to fetch all bugs at once:

```
project = {KEY} AND type = Bug ORDER BY created DESC
```

If the project uses additional bug-like issue types, expand the query:

```
project = {KEY} AND type in (Bug, "{CUSTOM_TYPE}") ORDER BY created DESC
```

This returns all bugs regardless of status. **Pagination is MANDATORY**: set `maxResults: 100`. After each query, compare returned count to `totalCount`. If `totalCount` exceeds returned results, paginate using `AND key < "{lastKeyFromPreviousPage}" ORDER BY key DESC` until ALL results are fetched. Do NOT generate reports or analysis from partial data.

**Do NOT run separate queries** for open bugs, recent bugs, reopened bugs, etc. Instead, derive all metrics from the single result set by filtering in-memory:
- **Open bugs**: filter where status category ≠ Done
- **Recently reported**: filter where created date is within last 2-4 weeks
- **Reopened**: check if any bug's status changed from Done back to an open status (note: this requires changelog data — if not available from the search result, skip and note "reopened data unavailable from search API")
- **By severity/priority**: group by the priority field
- **By component/area**: group by component, labels, or infer from summary/description

**Step 3: Analyze and classify**

Group bugs by feature area, classify defect density, identify regression risk indicators (reopened bugs, high-density areas, recently fixed bugs needing retest), and calculate bug age metrics.

**Step 4: Deliver dashboard**

When generating an HTML file, always **create the complete file from scratch** using the template — do not patch an existing file. This avoids incremental edit errors.

**Linking to Jira:** All KPI values, bug counts, and the JQL query shown in the report MUST link to Jira. Use the project's Jira base URL (`https://{instance}.atlassian.net`):
- **KPI cards** — wrap the numeric value in an `<a>` linking to the relevant JQL filter in Jira (e.g., open bugs count links to `https://{instance}.atlassian.net/issues/?jql=project%20%3D%20{KEY}%20AND%20type%20%3D%20Bug%20AND%20statusCategory%20!%3D%20Done`).
- **JQL query in methodology section** — render as a clickable link to the Jira issue navigator with that JQL pre-filled.
- **Individual bug keys** in tables — link to `https://{instance}.atlassian.net/browse/{KEY}`.
- **Project name in header** — link to the project board.

**Step 5: (Optional) Fetch Confluence context**

Skip this step by default — Jira data is sufficient for the dashboard. Only search Confluence if the user explicitly requests cross-referencing with regression docs or QA documentation (e.g., `--with-confluence` flag or explicit mention).

When enabled, search for regression checklists, feature specs, and QA documentation to identify gaps in existing regression coverage.

All output formats include these sections:

**Bug Summary**

| Category | Count | Details |
|----------|-------|---------|
| Total open bugs | [N] | [Breakdown by status] |
| Critical/High severity | [N] | [List titles] |
| Reopened bugs | [N] | [List titles — regression risk] |
| Recently created (last 2 weeks) | [N] | [Trend: increasing/stable/decreasing] |

**Defect Density by Area**

| Feature Area / Component | Open Bugs | Critical/High | Trend | Regression Risk |
|--------------------------|-----------|---------------|-------|-----------------|
| [Area] | [N] | [N] | ↑/→/↓ | High/Medium/Low |

**Regression Risk Indicators**
- Reopened bugs → incomplete fixes
- High defect density areas → priority in regression testing
- Recently fixed bugs in current release → retest needed
- Bugs related to recently changed code → high regression risk

**Recommended Manual Testing Focus**
Top 5-10 areas with justification from bug data.

### Destination-specific formatting

- **Chat**: Markdown with tables, emoji indicators, and styled callout blocks.
- **HTML file**: Generate the **complete HTML file from scratch** — do not incrementally edit an existing report file. Save as `[PROJECT_KEY]-quality-health-report.html` or `[EPIC_KEY]-quality-health-report-[DATE].html` in workspace root. Populate all values from the analyzed data. Choose alert class: `danger` for blocking issues, `warning` for concerns, `success` for on-track. **All numeric KPI values must be clickable links to the corresponding JQL filter in Jira.** The methodology section's JQL query must also link to the Jira issue navigator. Use Chart.js for visualizations (bar chart for defect density by area, severity distribution). The HTML file must be self-contained (no external dependencies beyond CDN-loaded Chart.js).
- **Confluence page**: Title `[PROJECT_KEY] Quality Health Report — [DATE]`. Format with Confluence tables, status macros, and Jira issue links. Create as child of parent page if provided.
- **Jira ticket**: Create a new issue in the project (default type: Task, summary: `[PROJECT_KEY] Quality Health Report — [DATE]`). Format description with Jira wiki markup (tables, status indicators, issue links).

## Connected Skills

- `tsh-planning-tests` — for test plan generation that may follow quality health report findings
- `tsh-analyzing-regression-risk` — for regression scope analysis based on bug density data
- `tsh-task-analysing` — for gathering broader Jira/Confluence context before analysis
