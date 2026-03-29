---
sidebar_position: 15
title: Task Formatting
---

# Task Formatting

**Folder:** `.github/skills/tsh-task-formatting/`  
**Used by:** Business Analyst

Transforms extracted epics and user stories into a format supported by your task management system. This is a parent skill that delegates to tool-specific sub-skills based on the target platform:

- **Jira** — `tsh-jira-task-formatting` (sub-skill)
- **Shortcut** — `tsh-shortcut-task-formatting` (sub-skill)

Both sub-skills apply a consistent benchmark template to every task, validate completeness, and manage a two-gate review process before any stories are created. They also support importing existing issues for local iteration.

## Process

### Step 1: Determine Target Tool

The skill identifies which task management tool to use (Jira or Shortcut) based on user input or project context, then delegates to the appropriate sub-skill.

### Step 2: Load Template and Tasks

Load the benchmark template and the extracted tasks document (`extracted-tasks.md`).

### Step 3: Format Epics

For each epic, create an entry formatted for the target tool with:
- Summary (title) following naming conventions.
- Structured description with business overview, value statement, and success metrics.
- Acceptance criteria and labels.
- Priority mapping (Critical → Highest, High → High, etc.).

### Step 5: Format Stories

For each story, create an entry formatted for the target tool with:
- Summary following naming conventions.
- Structured description with context, user story format, requirements, and technical notes.
- Acceptance criteria as Jira-compatible checklists.
- Sizing guidance (Small / Medium / Large).
- Parent epic reference and labels.

### Step 6: Validate Completeness

Cross-check all tasks against the benchmark template for required fields, structure, and consistency.

### Step 7: Formatting Review (Gate 2 - Part 1)

Present formatted output to the user. Review any changes made during formatting.

### Step 8: Save Output

Save the formatted tasks to `specifications/<workshop-name>/formatted-tasks.md`.

### Step 9: Push Approval (Gate 2 - Part 2)

Confirm the target project in the task management tool, get explicit approval, then create/update issues. Push operations are delegated to the [Knowledge](../agents/knowledge) agent.

## Import Mode

An alternative entry point for working with existing backlogs:

1. **Identify target** — Project key, specific epic keys, or a query.
2. **Fetch issues** — Pull epics and their child stories from the task management tool (via the [Knowledge](../agents/knowledge) agent).
3. **Map to template** — Convert fields to the benchmark format.
4. **Generate local file** — Create `formatted-tasks.md` with issue keys pre-populated.
5. **User review** — Present imported tasks for validation.

After import, changes can be pushed back individually or in batch.

## Jira Markdown Compatibility

When creating issues in Jira (via the Jira sub-skill), standard markdown is converted to Jira format:

| Standard Markdown | Jira Format |
|---|---|
| `## Heading` | `h2. Heading` |
| `**bold**` | `*bold*` |
| `*italic*` | `_italic_` |
| `- item` | `* item` |
| `1. item` | `# item` |
| `` `code` `` | `{code}...{code}` |

:::note
The local markdown file uses standard markdown formatting. Jira-specific formatting is applied only when creating the actual issues. Shortcut uses standard markdown natively.
:::

## Per-Change Modification Flow

When the user modifies a specific task outside the main workflow:

1. Update the local `formatted-tasks.md` first.
2. Ask the user whether to push the change now.
3. If yes, update the specific issue using its key (via the [Knowledge](../agents/knowledge) agent).
4. If no, the change remains local until the next batch push.

## Protected Status Guard

Tasks with a protected status (**Done**, **Cancelled**, or **PO APPROVE**) cannot be modified. The guard is enforced at every processing step:

- **Formatting** — Protected tasks are preserved exactly as imported. No reformatting, rewriting, or field changes. Marked with a `🔒` indicator.
- **Validation** — Completeness checks are skipped for protected tasks; their content is not subject to benchmark compliance.
- **User Review** — Protected tasks are not flagged for user attention; their fields are read-only.
- **Per-Change Modifications** — If a user requests changes to a protected task, the agent informs them the task cannot be modified and suggests updating the status in the task management tool first, then re-importing.
- **Import** — After mapping fields, each imported task's status is checked. Protected tasks are marked as read-only with a `🔒` indicator and preserved as-is.

## Connected Skills

- `tsh-task-extracting` — Provides the extracted tasks used as input for formatting.
- `tsh-task-quality-reviewing` — Refines the task list before formatting.
