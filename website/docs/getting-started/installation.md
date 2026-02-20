---
sidebar_position: 2
title: Installation
---

# Installation

Follow these steps to install and configure Copilot Collections for use across all your VS Code workspaces.

## 1. Clone the Repository

```bash
cd ~/projects
git clone https://github.com/TheSoftwareHouse/copilot-collections.git copilot-collections
```

The important part is that VS Code can see the `.github/prompts`, `.github/agents`, and `.github/skills` folders from this repository.

## 2. Configure Global Copilot Locations (User Settings)

You can configure this once at the **user level** and reuse it across all workspaces.

1. Open the **Command Palette**: `CMD` + `Shift` + `P` (macOS) or `Ctrl` + `Shift` + `P` (Windows/Linux).
2. Select **"Preferences: Open User Settings (JSON)"**.
3. Add or merge the following configuration:

```jsonc
{
  "chat.promptFilesLocations": {
    "~/projects/copilot-collections/.github/prompts": true
  },
  "chat.agentFilesLocations": {
    "~/projects/copilot-collections/.github/agents": true
  },
  "chat.agentSkillsLocations": {
    "~/projects/copilot-collections/.github/skills": true
  },
  "chat.useAgentSkills": true,
  "github.copilot.chat.searchSubagent.enabled": true,
  "chat.experimental.useSkillAdherencePrompt": true,
  "chat.customAgentInSubagent.enabled": true,
  "github.copilot.chat.agentCustomizationSkill.enabled": true
}
```

:::tip
Adjust the path (`~/projects/copilot-collections/...`) if your folder layout differs. Once set, these locations are available in **all VS Code workspaces**.
:::

## 3. Enable Copilot Experimental Features (UI)

If you prefer the UI instead of editing JSON directly:

1. Open **Settings** (`CMD` + `,` on macOS or `Ctrl` + `,` on Windows/Linux).
2. Search for **"promptFilesLocations"** and add an entry pointing to `~/projects/copilot-collections/.github/prompts`.
3. Search for **"agentFilesLocations"** and add an entry pointing to `~/projects/copilot-collections/.github/agents`.
4. Search for **"agentSkillsLocations"** and add an entry pointing to `~/projects/copilot-collections/.github/skills`.
5. Search for **"chat.useAgentSkills"** and enable it — allows Copilot to use Skills.
6. Search for **"chat.customAgentInSubagent.enabled"** and enable it — allows custom agents in subagents.
7. Search for **"github.copilot.chat.searchSubagent.enabled"** and enable it — enables the search subagent for better codebase analysis.
8. Search for **"chat.experimental.useSkillAdherencePrompt"** and enable it — forces Copilot to use Skills more often.
9. Search for **"github.copilot.chat.agentCustomizationSkill.enabled"** and enable it — enables the agent customization skill.

## Using in Your Projects

Once the repo is cloned and VS Code User Settings are configured:

1. Open your project in VS Code.
2. Open **GitHub Copilot Chat**.
3. Switch to one of the configured **agents** (Architect, Business Analyst, Software Engineer, Code Reviewer).
4. Use the workflow prompts:
   - `/research <JIRA_ID or task description>`
   - `/plan <JIRA_ID or task description>`
   - `/implement <JIRA_ID or task description>`
   - `/review <JIRA_ID or task description>`

All of these will leverage the shared configuration from Copilot Collections while still respecting your project's own code and context.
