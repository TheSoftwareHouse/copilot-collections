---
sidebar_position: 3
title: MCP Setup
---

# MCP Setup

To unlock the full workflow (Jira, Figma, code search, browser automation), you need to configure the MCP (Model Context Protocol) servers. Copilot Collections provides a ready-to-use template in `.vscode/mcp.json`.

## Installation Options

### Option 1: User Profile (Recommended)

This enables the MCP tools globally across all your projects.

1. Open the **Command Palette**: `CMD` + `Shift` + `P` (macOS) or `Ctrl` + `Shift` + `P` (Windows/Linux).
2. Type and select **"MCP: Open User Configuration"**.
3. This will open your global `mcp.json` file.
4. Copy the contents of the `mcp.json` configuration [below](#mcp-configuration) and paste them into your user configuration file.

### Option 2: Workspace Configuration

Use this if you want to enable these tools only for a specific project.

1. Copy the `mcp.json` configuration [below](#mcp-configuration).
2. Save it as `.vscode/mcp.json` in your target project (e.g., `my-project/.vscode/mcp.json`).

## MCP Configuration

Here is the full `mcp.json` configuration with all 5 servers:

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
    }
  },
  "inputs": []
}
```

## MCP Server Reference

Each MCP server enables specific capabilities within the workflow:

| MCP Server                 | Purpose                                                                                    | Used By                                                       |
| -------------------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------- |
| 🧩 **Atlassian**           | Access Jira issues and Confluence pages for research, planning, implementation, and review | Business Analyst, Architect, Software Engineer, Code Reviewer |
| 🎨 **Figma MCP**           | Pull design details, components, and variables for design-driven work                      | Software Engineer (UI), UI Reviewer                           |
| 📚 **Context7**            | Semantic search in external documentation and knowledge bases                              | All agents                                                    |
| 🧪 **Playwright**          | Run browser interactions and end-to-end style checks from Copilot                          | Software Engineer, E2E Engineer, UI Reviewer                  |
| 🧠 **Sequential Thinking** | Advanced reasoning for complex problem analysis, revision, and branching                   | All agents (for complex tasks)                                |

## Configuring Context7 API Key

To get higher rate limits and access to private repositories, you can provide a Context7 API key. Get your key at [context7.com/dashboard](https://context7.com/dashboard).

Copilot Collections uses VS Code's `inputs` feature to securely prompt for the API key. When you first use the Context7 MCP, VS Code will ask for the key and store it securely.

To enable this, modify your `mcp.json` configuration (User or Workspace) to use the `--api-key` CLI argument with an input variable:

```json
{
  "servers": {
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "@upstash/context7-mcp@latest",
        "--api-key",
        "${input:context7-api-key}"
      ]
    }
  },
  "inputs": [
    {
      "id": "context7-api-key",
      "description": "Context7 API Key (optional, for higher rate limits)",
      "type": "promptString",
      "password": true
    }
  ]
}
```

:::note
Server IDs in `mcp.json` are lowercase (e.g., `context7`, `figma`). If you copied an older template with different names, update your configuration to match the current template.
:::

## After Installation

Once you've copied the configuration, here's what to do:

1. **Start using Copilot** — simply send a message in Copilot Chat. VS Code will start the MCP servers automatically.
2. **Authenticate when prompted** — for **Atlassian** and **Figma**, your browser will open asking you to log in and authorize access. Just follow the prompts.
3. **(Optional) Add a Context7 API key** — Context7 works out of the box with rate limits. For higher limits, see [Configuring Context7 API Key](#configuring-context7-api-key) below.

That's it — no extra commands or manual wiring needed.

## Verify Your Setup

To confirm all MCP servers are running correctly:

1. Open the **Command Palette**: `CMD` + `Shift` + `P` (macOS) or `Ctrl` + `Shift` + `P` (Windows/Linux).
2. Type and select **"MCP: List Servers"**.
3. You should see all servers listed with a **Running** status:

![MCP List Servers showing all servers running](/img/mcp-list-servers.png)

If any server shows a different status, try restarting VS Code or check the [Authentication Requirements](#authentication-requirements) section below.

## Authentication Requirements

Some MCP servers require additional setup:

- **Atlassian** — Requires Atlassian account authentication. The HTTP MCP endpoint handles OAuth automatically via your browser.
- **Figma** — Requires Figma account access. The HTTP MCP endpoint handles authentication via your browser.
- **Context7** — Works without an API key (with rate limits). Optional API key for higher limits.
- **Playwright** — No authentication required. Runs locally via npx.
- **Sequential Thinking** — No authentication required. Runs locally via npx.

## Official Documentation

- [Atlassian MCP](https://support.atlassian.com/atlassian-rovo-mcp-server/docs/getting-started-with-the-atlassian-remote-mcp-server/)
- [Context7 MCP](https://github.com/upstash/context7)
- [Playwright MCP](https://github.com/microsoft/playwright-mcp)
- [Figma MCP](https://help.figma.com/hc/en-us/articles/32132100833559-Guide-to-the-Figma-MCP-server)
- [Sequential Thinking MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking)
