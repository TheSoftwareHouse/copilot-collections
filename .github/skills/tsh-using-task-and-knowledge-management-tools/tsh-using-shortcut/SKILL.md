---
name: tsh-using-shortcut
description: Guidelines for accessing Shortcut via Shortcut MCP tools. Covers resource discovery, workspace selection, searching, reading, creating and updating stories and epics.
---

# Using Shortcut

This skill provides guidelines for interacting with Shortcut via `shortcut/*` MCP tools. It covers workspace context discovery, and common operations for stories, epics, iterations, and documents. Any agent that needs to access Shortcut should follow these guidelines.

## Workspace Context Discovery

Shortcut API tokens are scoped to a single workspace — there is no multi-workspace selection needed. Instead, establish context by identifying the current user and their teams:

1. **Check `vscode/memory`** for stored Shortcut team preference for this project
2. **If found** → use the stored team (confirm with the user only if they mention a different team)
3. **If not found** → call `users-get-current` to identify the authenticated user, then `users-get-current-teams` to list their teams
4. **If single team** → use it automatically and store in `vscode/memory`
5. **If multiple teams** → ask the user via `vscode/askQuestions` which team to use
6. **Store selection** in `vscode/memory` for future calls in the same project

Call `workflows-get-default` (with the selected team ID) early to cache the available workflow states and their IDs — these are needed for creating and transitioning stories.

## Shortcut Operations

### Searching Stories and Epics

Use `stories-search` and `epics-search` with their filter parameters:

- **By name**: `name` parameter (contains match)
- **By state**: `state` for epics (unstarted/started/done), `state` for stories (workflow state name), or boolean filters `isDone`, `isStarted`, `isUnstarted`
- **By owner**: `owner` parameter (use mention name or `"me"`)
- **By label**: `label` parameter (label name)
- **By epic**: `epic` parameter on `stories-search` (epic ID) — this is how to get all stories in an epic
- **By team**: `team` parameter (team name or mention)
- **By type**: `type` parameter on `stories-search` (feature/bug/chore)
- **By iteration**: use `iterations-get-stories` with the iteration ID
- **By date**: `created`, `updated`, `completed`, `due` parameters with date filter syntax (e.g., `today`, `2026-01-01..2026-03-01`, `*..*today`)

Use `nextPageToken` from results to paginate through large result sets.

To search on a specific project, use `projects-get-stories` with the project ID.

### Reading Story and Epic Details

- **Stories**: `stories-get-by-id` with `storyPublicId` (numeric). Use `full: true` for all fields.
- **Epics**: `epics-get-by-id` with `epicPublicId` (numeric). Use `full: true` for all fields.
- **Stories in an epic**: Use `stories-search` with `epic: <epicPublicId>` — there is no direct "get stories by epic" method.
- **Key fields to extract**: Name, Description, Story Type (feature/bug/chore), Workflow State, Labels, Owners, Estimate, Epic, Iteration, Shortcut ID

### Creating Stories and Epics

**Create epics first** using `epics-create`:
- Required: `name`
- Optional: `description`, `owner`, `teamId`
- Record the returned epic ID immediately

**Then create stories** using `stories-create`:
- Required: `name` AND either `team` or `workflow` (one of these must be provided)
- Optional: `description`, `epic` (link to parent), `type` (feature/bug/chore, defaults to feature), `iteration`, `owner`
- After each creation, **immediately record the returned Shortcut ID**

**Add relationships** between stories using `stories-add-relation`:
- Supported types: `relates to`, `blocks`, `blocked by`, `duplicates`, `duplicated by`
- Both stories must exist before adding the relationship

**Add subtasks** using `stories-create-subtask` (creates new) or `stories-add-subtask` (links existing story).

### Updating Stories and Epics

Before updating any item:

- **Fetch the current item** using `stories-get-by-id` or `epics-get-by-id`
- **Check the workflow state** against the Protected Status Policy (see below)
- If protected, **do not update** — inform the caller

**Stories** via `stories-update` (provide only fields to change):
- **Fields safe to update**: `name`, `description`, `labels`, `estimate`, `deadline`, `iteration`, `owner_ids`
- **Fields to update only when explicitly requested**: `type` (story type), `epic` (parent epic link), `workflow_state_id` (state change)
- **Custom fields**: Use `custom_fields` array with `field_id` and `value_id` — call `custom-fields-list` first to get available field IDs

**Epics** via `epics-update` (provide only fields to change):
- **Fields safe to update**: `name`, `description`, `labels`, `deadline`, `owner_ids`

### Workflow State Changes

- Do **not** change workflow state unless explicitly requested by the user
- Workflow states are customizable per workflow — call `workflows-list` or `workflows-get-by-id` to get available states and their IDs
- To change a story's state, use `stories-update` with the `workflow_state_id` (numeric ID, not the state name)
- Epic states are simpler: use `epics-update` with `epic_state_id` or the deprecated `state` field (to do/in progress/done)

### Labels

- **List existing labels**: `labels-list`
- **Create new labels**: `labels-create` with `name` (and optional `color` hex, `description`)
- **Find stories by label**: `labels-get-stories` with `labelPublicId`

### Iterations

- **List iterations**: `iterations-search` or `iterations-get-active` / `iterations-get-upcoming`
- **Get stories in iteration**: `iterations-get-stories` with `iterationPublicId`
- **Create/update iterations**: `iterations-create` / `iterations-update`

### Documents

Shortcut has built-in document support (Markdown format):

- **List documents**: `documents-list`
- **Search documents**: `documents-search` with `title` filter
- **Read document**: `documents-get-by-id` with `docId`
- **Create document**: `documents-create` with `title` and `content` (Markdown)
- **Update document**: `documents-update` with `docId` and updated `title` or `content`

## Error Handling

- If authentication fails, inform the caller — do not retry with different credentials
- If an operation fails, report the specific error and let the caller decide how to proceed
- Never silently skip failed operations
- If a story or epic no longer exists (e.g., deleted), report the error clearly

## Protected Status Integration

The agent using this skill defines the authoritative list of protected statuses — this skill defers to the agent's Protected Status Policy.

Before any write operation on an existing item:

- **Fetch the item first** to check its current workflow state
- **Compare against the agent's protected status list**
- If protected → skip the operation and inform the caller with the state name
- Default protected states: **Done**, **Completed**

Shortcut workflows are customizable — the agent's Protected Status Policy determines the authoritative list. If the agent does not define a Protected Status Policy, use the defaults above.

## Connected Skills

- `tsh-shortcut-task-formatting` — uses Shortcut tools to push formatted tasks to Shortcut
- `tsh-task-quality-reviewing` — may use Shortcut tools to check board context during quality review
