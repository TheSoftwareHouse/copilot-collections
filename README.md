<p align="center">
  <img src="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png" alt="GitHub Copilot" width="72" />
</p>

<h1 align="center">⚙️ Copilot Configurations</h1>

<p align="center">
  Opinionated GitHub Copilot setup for delivery teams – with shared workflows, agents, prompts, and MCP integrations.
</p>

<p align="center">
  <b>Focus on building features – let Copilot handle the glue.</b><br/>
  Built by <a href="https://tsh.io" target="_blank">The Software House</a>.
</p>

---

## 🚀 What This Repo Provides

- 🧠 **Shared workflows** – a 4‑phase delivery flow: Research → Plan → Implement → Review.
- 🧑‍💻 **Specialized agents** – Architect, Business Analyst, Software Engineer, Code Reviewer.
- 💬 **Task prompts** – `/research`, `/plan`, `/implement`, `/review` with consistent behavior across projects.
- 🔌 **MCP integrations** – Atlassian, Figma Dev Mode, Context7, Playwright, Sequential Thinking.
- 🧩 **VS Code setup** – ready‑to‑plug global configuration via VS Code User Settings.

---

## 🧭 Supported Workflow

Our standard workflow is always:

> **Research → Plan → Implement → Review**

### 1. 🔍 Research
- Builds context around a task using Jira, Figma and other integrated tools.
- Identifies missing information, risks, and open questions.
- Produces a concise summary and a list of unknowns.

### 2. 🧱 Plan
- Translates the task into a structured implementation plan.
- Breaks work into phases and executable steps.
- Clarifies acceptance criteria and technical constraints.

### 3. 🛠 Implement
- Executes against the agreed plan.
- Writes or modifies code with a focus on safety and clarity.
- Keeps changes scoped to the task, respecting existing architecture.

### 4. ✅ Review
- Performs a structured code review against:
  - Acceptance criteria
  - Security and reliability
  - Maintainability and style
- Surfaces risks and suggested improvements.

#### Example End‑to‑End Usage

```text
1️⃣ /research <JIRA_ID or task description>
2️⃣ /plan     <JIRA_ID or task description>
3️⃣ /implement<JIRA_ID or task description>
4️⃣ /review   <JIRA_ID or task description>
```

You can run the same flow with either a **Jira ticket ID** or a **free‑form task description**.

---

## 🧑‍🤝‍🧑 Agents

These are configured as Copilot **agents / sub‑agents**.

### 🧱 Architect
- Focus: **solution design and implementation proposals**.
- Helps break down complex tasks into components and interfaces.
- Produces architecture sketches, trade‑off analyses, and integration strategies.

### 📝 Business Analyst
- Focus: **requirements, context and domain understanding**.
- Extracts and organizes information from Jira issues and other sources.
- Identifies missing requirements, stakeholders, edge cases, and business rules.

### 💻 Software Engineer
- Focus: **implementing the agreed plan**.
- Writes and refactors code in small, reviewable steps.
- Follows repository style, tests where available, and avoids over‑engineering.

### 🔍 Code Reviewer
- Focus: **structured code review and risk detection**.
- Checks changes against acceptance criteria, security and reliability guidelines.
- Suggests concrete improvements, alternative designs, and missing tests.

Each agent is designed to be used together with the workflow prompts below.

---

## 💬 Prompts & Chat Commands

All commands work with either a **Jira ID** or a **plain‑text description**.

### `/research <JIRA_ID | description>`
- Gathers all available information about the task.
- Pulls context from Jira, design artifacts, and code (via MCPs where applicable).
- Outputs: task summary, assumptions, open questions, and suggested next steps.

### `/plan <JIRA_ID | description>`
- Creates a **multi‑step implementation plan**.
- Groups work into phases and tasks aligned with your repo structure.
- Outputs: checklist‑style plan that can be executed by the Software Engineer agent.

### `/implement <JIRA_ID | description>`
- Implements the previously defined plan.
- Proposes file changes, refactors, and new code in a focused way.
- Outputs: concrete modifications and guidance on how to apply/test them.

### `/review <JIRA_ID | description>`
- Reviews the final implementation against the plan and requirements.
- Highlights security, reliability, performance, and maintainability concerns.
- Outputs: structured review with clear “pass/blockers/suggestions”.

---

## 🧩 Installation in VS Code

### 1. Clone the repository

```bash
cd ~/Projects
git clone <this-repo-url> copilot-configuration
```

The important part is that VS Code can see the `.github/prompts` and `.github/agents` folders from this repository.

### 2. Configure global Copilot locations (User Settings)

You can configure this once at the **user level** and reuse it across all workspaces.

1. Open the **Command Palette**: `CMD` + `Shift` + `P`.
2. Select **“Preferences: Open User Settings (JSON)”**.
3. Add or merge the following configuration:

```jsonc
{
  "chat.promptFilesLocations": {
    "../copilot-configuration/.github/prompts": true
  },
  "chat.modeFilesLocations": {
    "../copilot-configuration/.github/agents": true
  },
  "chat.customAgentInSubagent.enabled": true
}
```

- Adjust the relative path (`../copilot-configuration/...`) if your folder layout differs.
- Once set, these locations are available in **all VS Code workspaces** that sit next to `copilot-configuration`.

### 3. Enable Copilot experimental features (UI)

If you prefer the UI instead of editing JSON directly:

1. Open **Settings** (`CMD` + `,`).
3. Search for **“promptFilesLocations”** and **“modeFilesLocations”** and add entries pointing to the `copilot-configuration/.github/prompts` and `copilot-configuration/.github/agents` directories.
3. Search for **“Custom Agent in Subagent”** and enable `chat.customAgentInSubagent.enabled`.

---

## 🔌 MCP Server Configuration

To unlock the full workflow (Jira, Figma, code search, browser automation), you need to configure the MCP servers. We provide a ready-to-use template in [`.vscode/mcp.json`](./.vscode/mcp.json).

You have two options for installation:

### Option 1: User Profile (Recommended)

This is the best option as it enables these tools globally across all your projects.

1. Open the **Command Palette**: `CMD` + `Shift` + `P`.
2. Type and select **“MCP: Open User Configuration”**.
3. This will open your global `mcp.json` file.
4. Copy the contents of [`.vscode/mcp.json`](./.vscode/mcp.json) from this repository and paste them into your user configuration file.

### Option 2: Workspace Configuration

Use this if you want to enable these tools only for a specific project.

1. Copy the `.vscode/mcp.json` file from this repository.
2. Paste it into the `.vscode` folder of your target project (e.g., `my-project/.vscode/mcp.json`).

### Official Documentation

To learn more about configuring these servers, check their official documentation:

- [Atlassian MCP](https://support.atlassian.com/atlassian-rovo-mcp-server/docs/getting-started-with-the-atlassian-remote-mcp-server/)
- [Context7 MCP](https://github.com/upstash/context7)
- [Playwright MCP](https://github.com/microsoft/playwright-mcp)
- [Figma MCP](https://help.figma.com/hc/en-us/articles/32132100833559-Guide-to-the-Figma-MCP-server)
- [Sequential Thinking MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking)

### Configuring Context7 API Key

To get higher rate limits and access to private repositories, you can provide a Context7 API key.
You can get your key at [context7.com/dashboard](https://context7.com/dashboard).

We use VS Code's `inputs` feature to securely prompt for the API key. When you first use the Context7 MCP, VS Code will ask for the key and store it securely.

To enable this, modify your `mcp.json` configuration (User or Workspace) to use the `--api-key` CLI argument with an input variable:

```json
{
  "servers": {
    "Context7": {
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

**Note regarding Figma:** The `Figma Dev Mode MCP` requires the [Figma desktop app](https://www.figma.com/downloads/) to be running in [Dev Mode](https://help.figma.com/hc/en-us/articles/15023124644247-Guide-to-Dev-Mode) to work correctly.

### What each MCP is used for

- 🧩 **Atlassian MCP** – access Jira issues for `/research`, `/plan`, `/implement`, `/review`.
- 🎨 **Figma Dev Mode MCP** – pull design details, components, and variables for design‑driven work.
- 📚 **Context7 MCP** – semantic search in external docs and knowledge bases.
- 🧪 **Playwright MCP** – run browser interactions and end‑to‑end style checks from Copilot.
- 🧠 **Sequential Thinking MCP** – advanced reasoning tool for complex problem analysis.

> Some MCPs require **API keys or local apps running**. Configure auth as described in each MCP’s own documentation.

### 🧠 Sequential Thinking MCP

We use the **Sequential Thinking MCP** to handle complex logic, reduce hallucinations, and ensure thorough problem analysis. It allows agents to:

- **Revise** previous thoughts when new information is found.
- **Branch** into alternative lines of thinking.
- **Track** progress through a complex task.

---

## 🛠 Using This Repository in Your Projects

Once the repo is cloned and `.vscode/settings.json` is configured:

1. Open your project in VS Code.
2. Open **GitHub Copilot Chat**.
3. Switch to one of the configured **agents** (Architect, Business Analyst, Software Engineer, Code Reviewer).
4. Use the workflow prompts:
   - `/research <JIRA_ID>`
   - `/plan <JIRA_ID>`
   - `/implement <JIRA_ID>`
   - `/review <JIRA_ID>`

All of these will leverage the shared configuration from `copilot-configuration` while still respecting your project’s own code and context.

---

## 📌 Summary

- Central place for **shared Copilot agents, prompts, and workflows**.
- Optimized for teams working with **Jira, Figma, MCPs, and VS Code**.
- Designed to be **plug‑and‑play** – clone next to your projects, configure it once in **VS Code User Settings**, and start using `/research → /plan → /implement → /review` immediately in any workspace.

---

## 📄 License

This project is licensed under the **MIT License**.

© 2025 [The Software House](https://tsh.io)
