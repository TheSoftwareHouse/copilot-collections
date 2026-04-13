---
sidebar_position: 1
title: Integrations Overview
---

# Integrations Overview

Copilot Collections integrates with **12 external services** via the **Model Context Protocol (MCP)**. These integrations bring Jira, Shortcut, Figma, documentation, browser automation, structured reasoning, document reading, and cloud provider APIs directly into your Copilot sessions — enabling the end-to-end product engineering workflow.

## What is MCP?

The Model Context Protocol allows VS Code Copilot agents to call external tools as part of their workflow. Each MCP server exposes specific capabilities (search, navigate, execute) that agents can use to gather information or perform actions.

## Configured Servers

| Server | Type | Purpose | Used By |
|---|---|---|---|
| [Atlassian](./atlassian) | HTTP | Jira & Confluence integration | Knowledge, Architect, CR, CE, E2E, SE |
| [Shortcut](https://github.com/useshortcut/mcp) | stdio | Shortcut task management integration | Knowledge |
| [Figma](./figma) | HTTP | Design extraction and verification | BA, Architect, SE, UI Reviewer, CR, E2E |
| [Context7](./context7) | stdio | Library documentation search | Architect, SE, CR, UI Reviewer, E2E, Copilot Eng., DevOps |
| [Playwright](./playwright) | stdio | Browser automation and UI testing | SE, UI Reviewer, E2E |
| [Sequential Thinking](./sequential-thinking) | stdio | Structured reasoning for complex problems | BA, Architect, SE, CR, E2E, UI Reviewer, Copilot Eng., Orchestrator, DevOps |
| [PDF Reader](./pdf-reader) | stdio | PDF document extraction | BA, CE, Architect |
| [AWS API](./aws-api) | stdio | AWS infrastructure automation and resource management | DevOps |
| [AWS Documentation](./aws-documentation) | stdio | AWS service documentation and reference | DevOps |
| [GCP Gcloud](./gcp-gcloud) | stdio | Google Cloud operations and management | DevOps |
| [GCP Observability](./gcp-observability) | stdio | Google Cloud monitoring and observability | DevOps |
| [GCP Storage](./gcp-storage) | stdio | Google Cloud Storage integration | DevOps |

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
    "figma": {
      "url": "https://mcp.figma.com/mcp",
      "type": "http"
    },
    "atlassian": {
      "url": "https://mcp.atlassian.com/v1/mcp",
      "type": "http"
    },
    "pdf-reader": {
      "command": "npx",
      "args": ["@sylphx/pdf-reader-mcp"],
      "type": "stdio"
    },
    "awslabs.aws-api-mcp-server": {
      "command": "uvx",
      "args": ["awslabs.aws-api-mcp-server@latest"]
    },
    "awslabs.aws-documentation-mcp-server": {
      "command": "uvx",
      "args": ["awslabs.aws-documentation-mcp-server@latest"],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR",
        "AWS_DOCUMENTATION_PARTITION": "aws"
      }
    },
    "gcp-gcloud": {
      "command": "npx",
      "args": ["-y", "@google-cloud/gcloud-mcp"]
    },
    "gcp-observability": {
      "command": "npx",
      "args": ["-y", "@google-cloud/observability-mcp"]
    },
    "gcp-storage": {
      "command": "npx",
      "args": ["-y", "@google-cloud/storage-mcp"]
    }
  }
}
```

## Server Types

- **stdio** — Runs locally via `npx` or `uvx`. The MCP server starts as a child process.
- **HTTP** — Connects to a remote API endpoint. Requires authentication (handled by the service).
