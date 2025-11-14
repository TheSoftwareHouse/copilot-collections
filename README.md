# Copilot Configurations

This repository contains configurations and prompts for GitHub Copilot.

## Workflow
Our workflow is based on 4 phases:

- Research - build a context based on task description, jira, figma and other sources
- Plan - build an implementation plans divided into tasks and phases
- Implement - implement the plan
- Review - to perform core review against acceptance criteria and security guidelines

The other of the phases is always the same: Research -> Plan -> Implement -> Review

### Example usage
1. Start with /research <JIRA_ID>
2. Continue with /plan <JIRA_ID>
3. Continue with /implement <JIRA_ID>
4. End with /review <JIRA_ID>

### Chatmodes
- Architect - used for designing solution and implementation proposal
- Business Analyst - used for knowledge and task information gathering
- Software Engineer - used for task implementation
- Code Reviewer - used to perform code review

### Prompts
- /research <JIRA_ID> or task description - gathers all information about the task, used to build a context and fill-up the gaps
- /plan <JIRA_ID> or task description - creates a plan of implementation
- /implement <JIRA_ID> or task description - implements the plan
- /review <JIRA_ID> or task description - checks the implementation against plan

### Installation
- clone the repository
- configure your VSC settings for copilot to use custom chatmodes and prompts 
  - type CMD + shift + p -> Open User Settings
  - type chat.modeFilesLocation and add new location for mode files
  - type chat.promptFilesLocation and add new location for prompt files
- activate experimental thinking - CMD + shift + p -> Open User Settings -> type Custom Agent in Subagent -> activate
- install necessary MCP Servers
  - Atlassian
  - Figma Dev Mode
  - Context7
  - Playwright

## Usage in External Projects

To use these shared configuration in your own projects, add the following to your project's `.vscode/settings.json`:

```json
{
  "chat.promptFilesLocations": {
    ".github/prompts": true,
    "../copilot-configuration/.github/prompts": true
  },
  "chat.modeFilesLocations": {
    ".github/chatmodes": true,
    "../copilot-configuration/.github/agents": true
  },
  "github.copilot.chat.agent.thinkingTool": true //We use it in chatmodes. You can turn on in user configuration
}
```

**Setup steps:**

1. Clone this repository next to your project directory:

   ```bash
   # If your project is at ~/Projects/my-project
   cd ~/Projects
   git clone <this-repo-url> copilot-configuration
   ```

2. Your directory structure should look like:

   ```
   Projects/
   ├── my-project/
   │   └── .vscode/
   │       └── settings.json
   └── copilot-configurations/
       └── .github/
           ├── prompts/
           └── chatmodes/
   ```

3. Add the configuration above to your project's `.vscode/settings.json`

4. Restart VS Code or reload the window to apply the changes

This will make all prompts and chat modes from this repository available in your project, along with your project-specific configurations.

### MCP Configuration
Some MCP's require authorisation or installation before.

```
{
	"servers": {
		"playwright": {
			"command": "npx",
			"args": [
				"@playwright/mcp@latest"
			],
			"type": "stdio"
		},
		"Context7": {
			"type": "stdio",
			"command": "npx",
			"args": [
				"-y",
				"@upstash/context7-mcp@latest"
			]
		},
		"Figma Dev Mode MCP": {
			"url": "http://127.0.0.1:3845/mcp",
			"type": "http"
		},
		"atlassian": {
			"url": "https://mcp.atlassian.com/v1/sse",
			"type": "http"
		}
	},
	"inputs": []
}
```