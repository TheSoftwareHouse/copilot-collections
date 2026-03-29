---
sidebar_position: 16
title: Using Task & Knowledge Management Tools
---

# Using Task & Knowledge Management Tools

**Folder:** `.github/skills/tsh-using-task-and-knowledge-management-tools/`  
**Used by:** Knowledge, Business Analyst

Guidelines for accessing and using task management and knowledge base tools to retrieve and update information related to tasks, projects, and documentation. This is a parent skill that delegates to tool-specific sub-skills based on the target platform:

- **Jira and Confluence** — `tsh-using-atlassian` (sub-skill)
- **Shortcut** — `tsh-using-shortcut` (sub-skill)

## Supported Tools

### Task Management
| Tool | Sub-skill |
|---|---|
| **Atlassian Jira** | `tsh-using-atlassian` |
| **Shortcut** | `tsh-using-shortcut` |

### Knowledge Base
| Tool | Sub-skill |
|---|---|
| **Atlassian Confluence** | `tsh-using-atlassian` |

## How It Works

When an agent needs to interact with a task management or knowledge base tool, this skill:

1. **Identifies the target tool** — Based on project context, user preferences, or VS Code memory.
2. **Delegates to the appropriate sub-skill** — Routes to `tsh-using-atlassian` for Jira/Confluence operations or `tsh-using-shortcut` for Shortcut operations.
3. **Provides common guidelines** — Covers resource discovery, workspace selection, error handling, and data integrity practices that apply across all tools.

## Key Principles

- **Discover before acting** — Always identify the correct workspace and tool preferences before performing operations.
- **Separate task management and knowledge base** — Don't assume the same tool is used for both. A project may use Jira for tasks and Confluence for docs.
- **Human-in-the-loop for writes** — All create/update operations should be confirmed with the user before execution.
- **Data integrity** — Never overwrite data without explicit approval. Prefer additive changes over destructive ones.
- **Error handling** — Report failures clearly and suggest resolution steps rather than retrying silently.

## Connected Skills

- `tsh-task-formatting` — Formats tasks before they are pushed to the task management tool.
- `tsh-task-extracting` — Provides the extracted tasks that get pushed after formatting.
- `tsh-task-quality-reviewing` — Reviews task quality before formatting and push.
