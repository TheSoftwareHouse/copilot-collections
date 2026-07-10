---
sidebar_position: 1
title: Prerequisites
---

# Prerequisites

Before using Copilot Collections, make sure you meet the following requirements.

## GitHub Copilot License

**This configuration requires a GitHub Copilot Pro license (or higher)** to use custom agents and MCP integrations.

GitHub Copilot Pro provides access to:

- Custom agents (`.agent.md` files)
- Custom prompts (`.prompt.md` files)
- Custom skills (`.github/skills/`)
- MCP server integrations
- Subagent orchestration

If you only have a free or individual Copilot license, some features — particularly agents and MCP integrations — will not be available.

## VS Code Version

**This configuration requires VS Code version 1.109 or later.**

Features used by Copilot Collections (such as agent skills, prompt file locations, and MCP support) require recent VS Code releases. To check your version:

1. Open VS Code.
2. Go to **Code → About Visual Studio Code** (macOS) or **Help → About** (Windows/Linux).
3. Verify the version is **1.109** or higher.

If you need to update, download the latest version from [code.visualstudio.com](https://code.visualstudio.com).

## Additional Requirement for Figma-backed UI Verification

If you plan to use `/tsh-implement` or `/tsh-review-ui` on UI work backed by Figma, make sure the machine running VS Code can execute `playwright-cli`. The UI capture step uses Playwright CLI to collect the ACTUAL artifacts that the reviewer compares against Figma.

- Preferred: `npx playwright-cli`
- Fallback: `npm install -g @playwright/cli@latest`
- You also need the target app running locally and must be able to provide the exact full dev server URL when the workflow asks for it.
