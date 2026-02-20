---
sidebar_position: 2
title: Atlassian
---

# Atlassian MCP

**Server key:** `atlassian`  
**Type:** HTTP  
**URL:** `https://mcp.atlassian.com/v1/mcp`

Provides integration with Jira and Confluence for gathering requirements, task context, and project documentation.

## Capabilities

- Search Jira issues by key or query.
- Read issue details including subtasks, parent tasks, and linked issues.
- Search and read Confluence pages.
- Access project documentation and knowledge base articles.

## Which Agents Use It

| Agent | When |
|---|---|
| **Business Analyst** | Gathering task requirements, searching related issues, reading Confluence documentation |
| **Architect** | Extending understanding of technical requirements from Jira/Confluence |
| **Code Reviewer** | Verifying requirements and context documented in Jira/Confluence |

## Configuration

```json
{
  "atlassian": {
    "url": "https://mcp.atlassian.com/v1/mcp",
    "type": "http"
  }
}
```

## Authentication

The Atlassian MCP connects via HTTP and handles authentication through the Atlassian cloud service. The Business Analyst agent always checks accessible resources first and asks which one to use if multiple are available.

## Official Documentation

- [Getting Started with the Atlassian Remote MCP Server](https://support.atlassian.com/atlassian-rovo-mcp-server/docs/getting-started-with-the-atlassian-remote-mcp-server/)

## Usage Notes

- Always provide Jira issue keys or Confluence page IDs when available.
- The BA agent checks for linked Confluence pages on every task.
- External links in Jira tasks are also followed for additional context.
