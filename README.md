<p align="center">
  <img src="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png" alt="GitHub Copilot" width="72" />
</p>

<h1 align="center">⚙️ Copilot Collections</h1>

<p align="center">
  Opinionated GitHub Copilot setup for delivery teams – with shared workflows, agents, prompts, skills and MCP integrations.
</p>

<p align="center">
  <b>Focus on building features – let Copilot handle the glue.</b><br/>
  Built by <a href="https://tsh.io" target="_blank">The Software House</a>.
</p>

---

## 🚀 What This Repo Provides

- 🧠 **Shared workflows** – a 4‑phase delivery flow: Research → Plan → Implement → Review.
- 🧑‍💻 **Specialized agents** – Architect, Business Analyst, Software Engineer, Frontend Software Engineer, UI Reviewer, Code Reviewer, E2E Engineer.
- 💬 **Task prompts** – `/research`, `/plan`, `/implement`, `/implement-ui`, `/review`, `/review-ui`, `/e2e` with consistent behavior across projects.
- � **Reusable skills** – Task Analysis, Architecture Design, Codebase Analysis, Code Review, Implementation Gap Analysis, E2E Testing, Technical Context Discovery.
- �🔌 **MCP integrations** – Atlassian, Figma Dev Mode, Context7, Playwright, Sequential Thinking.
- 🧩 **VS Code setup** – ready‑to‑plug global configuration via VS Code User Settings.

---

## ⚠️ Copilot License Requirement

**This configuration requires GitHub Copilot Pro license (or higher)** to use custom agents and MCP integrations.

---

## ⚠️ VS Code Version Requirement

**This configuration requires VS Code version 1.109 or later.**

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
   ↳ 📖 Review the generated research document
   ↳ ✅ Verify accuracy, iterate if needed

2️⃣ /plan     <JIRA_ID or task description>
   ↳ 📖 Review the implementation plan
   ↳ ✅ Confirm scope, phases, and acceptance criteria

3️⃣ /implement <JIRA_ID or task description>
   ↳ 📖 Review code changes after each phase
   ↳ ✅ Test functionality, verify against plan

4️⃣ /review   <JIRA_ID or task description>
   ↳ 📖 Review findings and recommendations
   ↳ ✅ Address blockers before merging
```

You can run the same flow with either a **Jira ticket ID** or a **free‑form task description**.

> ⚠️ **Important:** Each step requires your review and verification. Open the generated documents, go through them carefully, and iterate as many times as needed until the output looks correct. AI assistance does not replace human judgment – treat each output as a draft that needs your approval before proceeding.

#### Example Frontend Flow (with Figma designs)

For UI-heavy tasks with Figma designs, use the specialized frontend workflow:

```text
1️⃣ /research     <JIRA_ID or task description>
   ↳ 📖 Review research doc – verify Figma links, requirements
   ↳ ✅ Iterate until context is complete and accurate

2️⃣ /plan         <JIRA_ID or task description>
   ↳ 📖 Review plan – check component breakdown, design references
   ↳ ✅ Confirm phases align with Figma structure

3️⃣ /implement-ui <JIRA_ID or task description>
   ↳ 📖 Review code changes and UI Verification Summary
   ↳ ✅ Manually verify critical UI elements in browser
   ↳ 🔄 Agent calls /review-ui in a loop until PASS or escalation

4️⃣ /review       <JIRA_ID or task description>
   ↳ 📖 Review findings – code quality, a11y, performance
   ↳ ✅ Address all blockers before merging
```

> ⚠️ **Important:** The automated Figma verification loop helps catch visual mismatches, but it does not replace manual review. Always visually inspect the implemented UI in the browser, test interactions, and verify responsive behavior yourself.

**How the verification loop works:**

1. `/implement-ui` implements a UI component
2. Calls `/review-ui` to perform **single-pass verification** (read-only)
3. `/review-ui` uses **Figma MCP** (EXPECTED) + **Playwright MCP** (ACTUAL) → returns PASS or FAIL with diff table
4. If FAIL → `/implement-ui` fixes the code and calls `/review-ui` again
5. Repeats until PASS or max 5 iterations (then escalates)

**What `/review-ui` does:**

- Single-pass, **read-only** verification – does not modify code
- Uses **Figma MCP** to extract design specifications
- Uses **Playwright MCP** to capture current implementation
- Returns structured report: PASS/FAIL + difference table with exact values

**What `/implement-ui` does:**

- Implements UI components following the plan
- Runs **iterative verification loop** calling `/review-ui` after each component
- **Fixes mismatches** based on `/review-ui` reports
- Escalates after 5 failed iterations with detailed report
- Produces **UI Verification Summary** before code review

#### Example E2E Testing Flow

For features that need end-to-end test coverage:

1️⃣ /research     <JIRA_ID or task description>
   ↳ 📖 Review research doc – understand feature scope and user journeys
   ↳ ✅ Identify critical paths that need E2E coverage

2️⃣ /plan         <JIRA_ID or task description>
   ↳ 📖 Review plan – confirm test scenarios and acceptance criteria
   ↳ ✅ Ensure E2E testing is included in the plan

4️⃣ /e2e          <JIRA_ID or task description>
   ↳ 📖 Implements Page Objects, test files, and fixtures
   ↳ ✅ Run tests locally, verify they pass
   ↳ 🔄 Iterate on flaky or failing tests

> ⚠️ **Important:** The `/e2e` command generates tests using Playwright MCP for real-time browser interaction. Always run the generated tests locally, review test scenarios for completeness, and verify they cover the critical user journeys identified during research.

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

### 🎨 Frontend Software Engineer
- Focus: **implementing UI components and frontend features**.
- Specialized in design systems, accessibility, and responsive behavior.
- Uses **iterative Figma verification loop** to ensure pixel-perfect implementation.
- Verifies implementation against Figma designs using Playwright and Figma MCP.

### 🔎 UI Reviewer
- Focus: **single-pass UI verification against Figma designs**.
- Performs read-only comparison: Figma (EXPECTED) vs Playwright (ACTUAL).
- Returns PASS/FAIL verdict with structured difference table.
- Called by `/implement-ui` in a loop; can also be used standalone.

### 🔍 Code Reviewer
- Focus: **structured code review and risk detection**.
- Checks changes against acceptance criteria, security and reliability guidelines.
- Suggests concrete improvements, alternative designs, and missing tests.

### 🧪 E2E Engineer
- Focus: **end-to-end testing with Playwright**.
- Creates comprehensive, reliable test suites for critical user journeys.
- Uses Page Object Model, proper fixtures, and accessibility-first locators.
- Integrates with Playwright MCP for real-time test debugging and validation.
- Follows testing pyramid principles - E2E for critical paths, not unit-level validation.

Each agent is designed to be used together with the workflow prompts below.

---

## 🧠 Skills

Skills provide **specialized domain knowledge and structured workflows** that agents automatically load when relevant to a task. They encode tested, step-by-step processes for common activities — ensuring consistent, high-quality outputs across team members.

Skills are stored in `.github/skills/` and are picked up automatically by Copilot when enabled via `chat.agentSkillsLocations` in VS Code settings.

### 🔍 Task Analysis
- Focus: **gathering and expanding context** for a development task.
- Pulls information from Jira, Confluence, GitHub, and other integrated tools.
- Identifies gaps in task descriptions and asks clarification questions.
- Produces a finalized research report with all findings.

### 🧱 Architecture Design
- Focus: **designing solution architecture** that follows best practices.
- Analyzes the current codebase and task requirements.
- Proposes a solution that is scalable, secure, and easy to maintain.
- Covers patterns like DRY, KISS, DDD, CQRS, modular/hexagonal architecture, and more.

### 📊 Codebase Analysis
- Focus: **structured analysis of the entire codebase**.
- Reviews repository structure, dependencies, scripts, and architecture.
- Examines backend, frontend, infrastructure, and third-party integrations.
- Identifies dead code, duplications, security concerns, and potential improvements.

### 🔎 Code Review
- Focus: **verifying implemented code** against quality standards.
- Compares implementation to the task description and plan.
- Validates test coverage, security, scalability, and best practices.
- Runs available tests and static analysis tools.

### 📋 Implementation Gap Analysis
- Focus: **comparing expected vs. actual implementation state**.
- Analyzes what needs to be built, what already exists, and what must be modified.
- Cross-references task requirements with the current codebase.
- Produces a structured gap report for planning next steps.

### 🧪 E2E Testing
- Focus: **end-to-end testing patterns and practices** using Playwright.
- Provides Page Object Model patterns, test structure templates, and mocking strategies.
- Includes a verification loop with iteration limits and flaky test detection.
- Covers error recovery strategies and CI readiness checklists.
- Ensures consistent, reliable E2E tests across the team.

### 🧭 Technical Context Discovery
- Focus: **establishing technical context** before implementing any feature.
- Prioritizes project instructions, existing codebase patterns, and external documentation — in that order.
- Checks for Copilot instruction files, analyzes existing code conventions, and consults external docs as a fallback.
- Ensures new code is consistent with established patterns and prevents conflicting conventions.

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

### `/implement-ui <JIRA_ID | description>`
- Implements UI features with **iterative Figma verification**.
- Extends `/implement` with a verification loop after each component.
- Uses **Playwright** to capture current UI state and **Figma MCP** to compare with designs.
- Automatically fixes mismatches and re-verifies until implementation matches design.
- Outputs: code changes + UI Verification Summary with iteration counts.

### `/review-ui`
- Performs **single-pass UI verification** comparing implementation against Figma.
- Uses **Figma MCP** (EXPECTED) and **Playwright MCP** (ACTUAL) to compare.
- **Read-only** – reports differences but does not fix them.
- Called by `/implement-ui` in a loop; can also be used standalone.
- Outputs: PASS/FAIL verdict + structured difference table with exact values.

### `/review <JIRA_ID | description>`
- Reviews the final implementation against the plan and requirements.
- Highlights security, reliability, performance, and maintainability concerns.
- Outputs: structured review with clear “pass/blockers/suggestions”.

### `/e2e <JIRA_ID | description>`
- Creates comprehensive **end-to-end tests** for the feature using Playwright.
- Analyzes the application, designs test scenarios, and implements Page Objects.
- Uses **Playwright MCP** for real-time interaction and test verification.
- Follows BDD-style scenarios with proper Arrange-Act-Assert structure.
- Outputs: Page Objects, test files, fixtures, and execution report.
---

## 🧩 Installation in VS Code

### 1. Clone the repository

```bash
cd ~/projects
git clone <this-repo-url> copilot-collections
```

The important part is that VS Code can see the `.github/prompts`, `.github/agents` and `.github/skills` folders from this repository.

### 2. Configure global Copilot locations (User Settings)

You can configure this once at the **user level** and reuse it across all workspaces.

1. Open the **Command Palette**: `CMD` + `Shift` + `P`.
2. Select **“Preferences: Open User Settings (JSON)”**.
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

- Adjust the path (`~/projects/copilot-collections/...`) if your folder layout differs.
- Once set, these locations are available in **all VS Code workspaces**.

### 3. Enable Copilot experimental features (UI)

If you prefer the UI instead of editing JSON directly:

1. Open **Settings** (`CMD` + `,`).
2. Search for **"promptFilesLocations"** and add entry pointing to the `~/projects/copilot-collections/.github/prompts` directory.
3. Search for **"agentFilesLocations"** and add entry pointing to the `~/projects/copilot-collections/.github/agents` directory.
4. Search for **"agentSkillsLocations"** and add entry pointing to the `~/projects/copilot-collections/.github/skills` directory.
5. Search for **"chat.useAgentSkills"** and enable it, this will allow Copilot to use Skills
6. Search for **"chat.customAgentInSubagent.enabled"** and enable it, this will allow Custom Agents to be used in Subagents
7. Search for **"github.copilot.chat.searchSubagent.enabled"** and enable it, this will allow Copilot to use special search subagent for better codebase analysis
8. Search for **"chat.experimental.useSkillAdherencePrompt"** and enable it, this will force Copilot to use Skills more often
9. Search for **"github.copilot.chat.agentCustomizationSkill.enabled"** and enable it, this will enable a special Skill to help you build custom agents, skills, prompts

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

> **Note:** Server IDs in `mcp.json` are lowercase (e.g., `context7`, `figma-mcp-server`). If you copied an older template with different names, update your configuration to match the current template.

### What each MCP is used for

- 🧩 **Atlassian MCP** – access Jira issues for `/research`, `/plan`, `/implement`, `/review`.
- 🎨 **Figma MCP Server** – pull design details, components, and variables for design‑driven work.
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

Once the repo is cloned and VS Code User Settings are configured:

1. Open your project in VS Code.
2. Open **GitHub Copilot Chat**.
3. Switch to one of the configured **agents** (Architect, Business Analyst, Software Engineer, Code Reviewer).
4. Use the workflow prompts:
   - `/research <JIRA_ID>`
   - `/plan <JIRA_ID>`
   - `/implement <JIRA_ID>`
   - `/review <JIRA_ID>`

   **For frontend tasks with Figma designs:**
   - `/research <JIRA_ID>` – gather requirements including design context
   - `/plan <JIRA_ID>` – create implementation plan
   - `/implement-ui <JIRA_ID>` – implement with iterative Figma verification (calls `/review-ui` in loop)
   - `/review <JIRA_ID>` – final code review

All of these will leverage the shared configuration from `copilot-collections` while still respecting your project’s own code and context.

---

## 📌 Summary

- Central place for **shared Copilot agents, prompts, and workflows**.
- Optimized for teams working with **Jira, Figma, MCPs, and VS Code**.
- Designed to be **plug‑and‑play** – clone next to your projects, configure it once in **VS Code User Settings**, and start using `/research → /plan → /implement → /review` immediately in any workspace.

---

## 📄 License

This project is licensed under the **MIT License**.

© 2026 [The Software House](https://tsh.io)
