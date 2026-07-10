# Copilot Collections

Opinionated GitHub Copilot setup for product discovery, implementation, and review.

Full documentation: [copilot-collections.tsh.io](https://copilot-collections.tsh.io/)

This README is intentionally short. It covers the main workflows and the minimum setup needed so GitHub Copilot can use this repository effectively.

## What Matters Most

You do not need to learn every agent, prompt, or skill up front.

For most teams, the main entry points are:

- `/tsh-analyze-materials` for turning workshop inputs into structured tasks
- `/tsh-implement` for research, planning, and implementation
- `/tsh-review` for structured code review

The most important agents behind those workflows are:

- `tsh-business-analyst` for discovery and backlog shaping
- `tsh-engineering-manager` for orchestrating implementation work
- `tsh-code-reviewer` for review and risk detection
- `tsh-copilot-orchestrator` for creating or improving Copilot customizations

Everything else is supporting structure. Use the website for the full catalog, detailed flow descriptions, and deep documentation.

## Requirements

- GitHub Copilot Pro or higher
- VS Code 1.109 or later
- This repository available on disk so VS Code can read `.github/prompts`, `.github/agents`, `.github/skills`, and `.vscode/mcp.json`

## Recommended Thinking Effort Settings

In the VS Code Copilot Chat UI, manually select each model below, choose its recommended thinking effort, and repeat for every model. Once configured, the setting is active for that model in your current VS Code profile.

| Model | Recommended thinking effort |
| --- | --- |
| GPT-5.6 Sol | medium (default) |
| GPT-5.6 Terra | medium/high |
| GPT-5.6 Luna | high/xhigh |
| Sonnet 5 | high (default) |
| MAI-Code-1-Flash | high |

## Recommended Installation: Ask Copilot To Configure Itself

The preferred setup is to let GitHub Copilot update the required user-level configuration for you.

### 1. Clone this repository

```bash
cd ~/projects
git clone <this-repo-url> copilot-configuration
```

If you clone it somewhere else, replace the path in the prompt below.

### 2. Ask Copilot to configure your machine

Open any VS Code workspace, open Copilot Chat, and paste this prompt:

```text
Configure GitHub Copilot on this machine to use the Copilot Collections repository at /Users/adampolak/projects/copilot-configuration.

Update my VS Code User Settings so Copilot loads:
- prompts from /Users/adampolak/projects/copilot-configuration/.github/prompts
- agents from /Users/adampolak/projects/copilot-configuration/.github/agents
- skills from /Users/adampolak/projects/copilot-configuration/.github/skills

Enable the required Copilot settings for custom agents and skills.

Then open my user MCP configuration and copy in the MCP server template from /Users/adampolak/projects/copilot-configuration/.vscode/mcp.json.

Do not change project source files. Only modify user-level Copilot and MCP configuration.
```

### 3. If Copilot asks what settings to add, use these

These are the minimum VS Code user settings this repository expects:

```jsonc
{
  "chat.promptFilesLocations": {
    "/Users/adampolak/projects/copilot-configuration/.github/prompts": true,
  },
  "chat.agentFilesLocations": {
    "/Users/adampolak/projects/copilot-configuration/.github/agents": true,
  },
  "chat.agentSkillsLocations": {
    "/Users/adampolak/projects/copilot-configuration/.github/skills": true,
  },
  "chat.useAgentSkills": true,
  "github.copilot.chat.searchSubagent.enabled": true,
  "chat.experimental.useSkillAdherencePrompt": true,
  "chat.customAgentInSubagent.enabled": true,
  "chat.subagents.allowInvocationsFromSubagents": true,
  "github.copilot.chat.agentCustomizationSkill.enabled": true,
}
```

For MCP, copy the template from [`.vscode/mcp.json`](/Users/adampolak/projects/copilot-configuration/.vscode/mcp.json) into your user MCP configuration using `MCP: Open User Configuration`.

## Manual Fallback

If Copilot cannot complete the setup automatically:

1. Open `Preferences: Open User Settings (JSON)` and add the settings shown above.
2. Run `MCP: Open User Configuration`.
3. Copy the contents of [`.vscode/mcp.json`](/Users/adampolak/projects/copilot-configuration/.vscode/mcp.json) into your user MCP config.

## First Commands To Try

Once configured, open your target project and start with one of these:

- `/tsh-implement <task or Jira ID>`
- `/tsh-review <task or Jira ID>`
- `/tsh-review-ui`
- `/tsh-analyze-materials <transcript, notes, links, or workshop assets>`

For Figma-backed UI work, keep the target app running and be ready to confirm the exact full dev server URL. The UI verification loop uses Figma MCP for EXPECTED and `tsh-ui-capture-worker` Playwright CLI artifacts for ACTUAL, so `playwright-cli` must also be available on the machine running VS Code (`npx playwright-cli` or a global install).

If you want to extend the system itself, use:

- `/tsh-create-custom-agent`
- `/tsh-create-custom-skill`
- `/tsh-create-custom-prompt`
- `/tsh-create-custom-instructions`

## Learn More

- Full documentation: [copilot-collections.tsh.io](https://copilot-collections.tsh.io/)
- MCP template used by this repo: [`.vscode/mcp.json`](/Users/adampolak/projects/copilot-configuration/.vscode/mcp.json)

## License

MIT
