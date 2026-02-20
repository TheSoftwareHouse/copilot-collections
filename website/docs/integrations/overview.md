---
sidebar_position: 1
title: Integrations Overview
---

# Integrations Overview

Copilot Collections integrates with 5 external services via the **Model Context Protocol (MCP)**. These are configured in `.vscode/mcp.json` and provide agents with access to external tools, documentation, and services.

## What is MCP?

The Model Context Protocol allows VS Code Copilot agents to call external tools as part of their workflow. Each MCP server exposes specific capabilities (search, navigate, execute) that agents can use to gather information or perform actions.

## Configured Servers

| Server | Type | Purpose | Used By |
|---|---|---|---|
| [Atlassian](./atlassian) | HTTP | Jira & Confluence integration | BA, Architect, CR |
| [Figma](./figma) | HTTP | Design extraction and verification | BA, Architect, SE, UI Reviewer, CR, E2E |
| [Context7](./context7) | stdio | Library documentation search | Architect, SE, CR, UI Reviewer, E2E |
| [Playwright](./playwright) | stdio | Browser automation and UI testing | SE, UI Reviewer, E2E |
| [Sequential Thinking](./sequential-thinking) | stdio | Structured reasoning for complex problems | BA, Architect, SE, CR, E2E |

## Configuration

All servers are configured in `.vscode/mcp.json`:

```json
{
  "servers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"],
      "type": "stdio"
    },
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
      "type": "stdio"
    },
    "figma-mcp-server": {
      "url": "https://mcp.figma.com/mcp",
      "type": "http"
    },
    "atlassian": {
      "url": "https://mcp.atlassian.com/v1/mcp",
      "type": "http"
    }
  }
}
```

## Server Types

- **stdio** — Runs locally via `npx`. The MCP server starts as a child process.
- **HTTP** — Connects to a remote API endpoint. Requires authentication (handled by the service).
