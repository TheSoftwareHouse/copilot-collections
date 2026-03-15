---
name: tsh-using-atlassian
description: Guidelines for accessing Jira and Confluence via Atlassian MCP tools. Covers resource discovery, workspace selection, searching, reading, creating and updating issues and pages.
---

# Using Atlassian

This skill provides guidelines for interacting with Jira and Confluence via Atlassian MCP tools. It covers resource discovery, workspace/project selection, and common operations. Any agent that needs to access Jira or Confluence should follow these guidelines.

## Resource Discovery and Workspace Selection

Before performing any Atlassian operation, determine which resource to use:

1. **Check `vscode/memory`** for a stored Atlassian resource preference
2. **If found** → use the stored preference (confirm with the user only if they mention a different resource)
3. **If not found** → call `List accessible Resources`
4. **If single resource** → use it automatically
5. **If multiple resources** → ask the user via `vscode/askQuestions` which one to use
6. **Store selection** in `vscode/memory` for future calls in the same project

Never skip resource discovery. Every Atlassian operation depends on having the correct workspace context.

## Jira Operations

### Searching Issues

- **Rovo search** (`search` method) is the preferred search method — use it for natural language queries
- Use **JQL search** only when the user explicitly provides a JQL query or when precise filtering is needed (e.g., by status, assignee, sprint)
- Always include the project key or board context when searching to scope results

### Reading Issue Details

- Fetch issue details by issue key (e.g., `PROJ-123`)
- For epics with child stories, fetch the epic first, then fetch its children
- Extract and understand: Summary, Description, Status, Priority, Labels, Assignee, Sprint, Story Points, Linked Issues

### Creating Issues

Follow this sequence when creating issues:

- **Create epics first** to obtain their Jira IDs
- Then create stories linked to parent epics using the parent ID
- After creating each issue, **immediately record the returned Jira Key**
- Required fields: Summary, Issue Type, Project Key
- Add Description, Priority, Labels, and Parent link as available
- Add relationships (blocked-by, related-to) **after both linked issues exist**

### Updating Issues

Before updating any issue:

- **Check the issue's current status** against the Protected Status Policy (see below)
- If the status is protected, **do not update** — inform the caller
- **Fields safe to update**: Summary, Description, Priority, Labels, Acceptance Criteria
- **Fields NOT to update** unless explicitly requested: Issue Type, Parent link
- If an update fails because the issue no longer exists, report the error

### Transitions and Status

- Do **not** change issue status or transitions unless explicitly requested by the user
- If a status change is needed, verify available transitions for the issue first

## Confluence Operations

### Searching Pages

- Use **Rovo search** for natural language queries across Confluence spaces
- Use **CQL** (Confluence Query Language) only when precise filtering is needed
- Scope searches to the relevant space when known

### Reading Pages

- Fetch page content by page ID or by searching for the page title
- Navigate page hierarchy when context requires understanding parent/child page relationships
- Extract and understand: Title, Body content, Labels, Space, Parent page

### Creating and Updating Pages

Creating and updating Confluence pages is supported but less common. Follow the same pattern: confirm the space, create with required fields, record the page ID.

## Error Handling

- If a resource is not accessible, inform the caller and suggest checking MCP server configuration
- If authentication fails, inform the caller — do not retry with different credentials
- If an operation fails, report the specific error and let the caller decide how to proceed
- Never silently skip failed operations

## Protected Status Integration

The agent using this skill defines the authoritative list of protected statuses — this skill defers to the agent's Protected Status Policy.

Before any write operation on an existing issue:

- **Check the issue's current status** against the agent's protected status list
- If protected → skip the operation and inform the caller with the status name
- Default protected statuses (as defined by the business analyst agent): **Done**, **Cancelled**, **PO APPROVE**

If the agent does not define a Protected Status Policy, use the defaults above.

## Connected Skills

- `tsh-jira-task-formatting` — uses Atlassian tools to push formatted tasks to Jira
- `tsh-task-quality-reviewing` — may use Atlassian tools to check board context during quality review
