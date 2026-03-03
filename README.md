<p align="center">
  <img src="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png" alt="GitHub Copilot" width="72" />
</p>

<h1 align="center">⚙️ Copilot Collections</h1>

<p align="center">
  Opinionated GitHub Copilot setup that covers the <b>full product development lifecycle</b> – from product ideation, through development, to quality assurance.
</p>

<p align="center">
  <b>Product Ideation → Development → Quality – one toolchain, end to end.</b><br/>
  Built by <a href="https://tsh.io" target="_blank">The Software House</a>.
</p>

---

## 🚀 What This Repo Provides

This repository supports the **full product development lifecycle** with AI-powered agents, skills, and workflows organized into three lifecycle phases — plus a cross-cutting track for Copilot customization:

### 📋 Product Ideation – Requirements & Planning

- 🧑‍💻 **Agents** – Business Analyst.
- 💬 **Prompts** – `/analyze-materials`, `/clean-transcript`, `/create-jira-tasks`.
- 🧰 **Skills** – Task Analysis, Transcript Processing, Task Extraction, Jira Task Formatting.

### 🛠 Development – Architecture & Implementation

- 🧑‍💻 **Agents** – Context Engineer, Architect, Software Engineer.
- 💬 **Prompts** – `/research`, `/plan`, `/implement`, `/implement-ui`.
- 🧰 **Skills** – Architecture Design, Technical Context Discovery, Frontend Implementation, Implementation Gap Analysis, SQL & Database Engineering, Codebase Analysis.

### ✅ Quality – Review & Testing

- 🧑‍💻 **Agents** – Code Reviewer, UI Reviewer, E2E Engineer.
- 💬 **Prompts** – `/review`, `/review-ui`, `/review-codebase`, `/implement-e2e`.
- 🧰 **Skills** – Code Review, UI Verification, E2E Testing.

### ⚙️ Copilot Customization – Extending the Toolchain

- 🧑‍💻 **Agents** – Copilot Engineer, Copilot Orchestrator.
- 💬 **Prompts** – `/create-custom-agent`, `/create-custom-skill`, `/create-custom-prompt`, `/create-custom-instructions`.
- 🧰 **Skills** – Creating Agents, Creating Skills, Creating Prompts, Creating Instructions.

### 🔌 Infrastructure

- **MCP integrations** – Atlassian, Figma Dev Mode, Context7, Playwright, Sequential Thinking, PDF Reader.
- **VS Code setup** – ready-to-plug global configuration via VS Code User Settings.

---

## ⚠️ Copilot License Requirement

**This configuration requires GitHub Copilot Pro license (or higher)** to use custom agents and MCP integrations.

---

## ⚠️ VS Code Version Requirement

**This configuration requires VS Code version 1.109 or later.**

---

## 🧭 Supported Workflow

We support the **full product development lifecycle**, organized into three phases:

> **📋 Product Ideation → 🛠 Development → ✅ Quality**

### Phase 1: 📋 Product Ideation – Requirements & Planning

- Converts raw inputs (workshop transcripts, Figma designs, documents) into structured, actionable work items.
- Builds context around tasks using Jira, Figma, and other integrated tools.
- Identifies missing information, risks, and open questions.
- Produces Jira-ready epics and stories with a two-gate review process.

### Phase 2: 🛠 Development – Architecture & Implementation

- Translates tasks into structured implementation plans with phases and technical constraints.
- Writes or modifies code with a focus on safety and clarity.
- Keeps changes scoped to the task, respecting existing architecture.
- For UI tasks: uses iterative Figma verification to match designs.

**Two tracks are available:**

| | **Standard Flow** | **UI Flow** (with Figma) |
|---|---|---|
| Plan | `/plan` – architecture & steps | `/plan` – component breakdown with Figma refs |
| Implement | `/implement` – backend & frontend code | `/implement-ui` – UI code + iterative Figma verification |

### Phase 3: ✅ Quality – Review & Testing

- Performs structured code review against acceptance criteria, security, and reliability.
- Verifies UI implementation against Figma designs (single-pass or in loop).
- Creates comprehensive end-to-end tests using Playwright.
- Runs codebase-wide quality analysis (dead code, duplications, improvements).

---

### Example: Full Lifecycle (Standard Flow)

```text
📋 PRODUCT IDEATION
1️⃣ /analyze-materials <transcript + workshop materials>
   ↳ 📖 Review cleaned transcript, extracted tasks, Jira-formatted output
   ↳ ✅ Approve at each gate before proceeding

🛠 DEVELOPMENT
2️⃣ /research <JIRA_ID or task description>
   ↳ 📖 Review the generated research document
   ↳ ✅ Verify accuracy, iterate if needed

3️⃣ /plan     <JIRA_ID or task description>
   ↳ 📖 Review the implementation plan
   ↳ ✅ Confirm scope, phases, and acceptance criteria

4️⃣ /implement <JIRA_ID or task description>
   ↳ 📖 Review code changes after each phase
   ↳ ✅ Test functionality, verify against plan

✅ QUALITY
5️⃣ /review   <JIRA_ID or task description>
   ↳ 📖 Review findings and recommendations
   ↳ ✅ Address blockers before merging

6️⃣ /implement-e2e <JIRA_ID or task description>
   ↳ 📖 Review generated Page Objects, test files, and fixtures
   ↳ ✅ Run tests locally, verify they pass
```

### Example: Full Lifecycle (UI Flow with Figma)

```text
📋 PRODUCT IDEATION
1️⃣ /analyze-materials <transcript + workshop materials>
   ↳ 📖 Review cleaned transcript, extracted tasks, Jira-formatted output
   ↳ ✅ Approve at each gate before proceeding

🛠 DEVELOPMENT
2️⃣ /research <JIRA_ID or task description>
   ↳ 📖 Review research doc – verify Figma links, requirements
   ↳ ✅ Iterate until context is complete and accurate

3️⃣ /plan         <JIRA_ID or task description>
   ↳ 📖 Review plan – check component breakdown, design references
   ↳ ✅ Confirm phases align with Figma structure

4️⃣ /implement-ui <JIRA_ID or task description>
   ↳ 📖 Review code changes and UI Verification Summary
   ↳ ✅ Manually verify critical UI elements in browser
   ↳ 🔄 Agent calls /review-ui in a loop until PASS or escalation

✅ QUALITY
5️⃣ /review       <JIRA_ID or task description>
   ↳ 📖 Review findings – code quality, a11y, performance
   ↳ ✅ Address all blockers before merging

6️⃣ /implement-e2e <JIRA_ID or task description>
   ↳ 📖 Review generated tests for the UI feature
   ↳ ✅ Run tests locally, verify they pass
```

You can run any flow with either a **Jira ticket ID** or a **free-form task description**.

> ⚠️ **Important:** Each step requires your review and verification. Open the generated documents, go through them carefully, and iterate as many times as needed until the output looks correct. AI assistance does not replace human judgment – treat each output as a draft that needs your approval before proceeding.

### How the UI Verification Loop Works

1. `/implement-ui` implements a UI component
2. Calls `/review-ui` to perform **single-pass verification** (read-only)
3. `/review-ui` uses **Figma MCP** (EXPECTED) + **Playwright MCP** (ACTUAL) → returns PASS or FAIL with diff table
4. If FAIL → `/implement-ui` fixes the code and calls `/review-ui` again
5. Repeats until PASS or max 5 iterations (then escalates)

### Example: Standalone Product Ideation

For converting discovery workshop recordings into Jira-ready tasks without continuing to development:

```text
📋 PRODUCT IDEATION
1️⃣ /analyze-materials <transcript + workshop materials>
   ↳ 📖 Review cleaned transcript – verify topics, decisions, action items
   ↳ ✅ Confirm nothing important was removed during cleaning

   ↳ 📖 Review extracted epics and user stories
   ↳ ✅ Verify scope, dependencies, and acceptance criteria (Gate 1)

   ↳ 📖 Review Jira-formatted tasks before push
   ↳ ✅ Approve creation of Jira issues (Gate 2)
```

> ⚠️ **Important:** The business analyst produces three artifacts in sequence: cleaned transcript, extracted tasks, and Jira-formatted tasks. Each artifact has a mandatory review gate – you must approve the output before the agent proceeds to the next step.

---

## 🧑‍🤝‍🧑 Agents

These are configured as Copilot **agents / sub-agents**, organized by lifecycle phase.

### 📋 Product Ideation Agents

#### 📋 Business Analyst

- Focus: **converting discovery workshop materials into Jira-ready epics and stories**.
- Processes raw inputs: call transcripts, Figma designs, codebase context, and reference documents.
- Cleans transcripts from small talk, structures content by topics, and extracts actionable work items.
- Produces business-oriented output – no technical implementation details.
- Manages a two-gate review process before pushing tasks to Jira.
- Hands off to Context Engineer for deeper research and Architect for implementation planning.

### 🛠 Development Agents

#### 📝 Context Engineer

- Focus: **requirements, context and domain understanding**.
- Extracts and organizes information from Jira issues and other sources.
- Identifies missing requirements, stakeholders, edge cases, and business rules.

#### 🧱 Architect

- Focus: **solution design and implementation proposals**.
- Helps break down complex tasks into components and interfaces.
- Produces architecture sketches, trade-off analyses, and integration strategies.

#### 💻 Software Engineer

- Focus: **implementing the agreed plan** (backend and frontend).
- Writes and refactors code in small, reviewable steps.
- Follows repository style, tests where available, and avoids over-engineering.
- For UI tasks: uses design system, ensures accessibility, and runs iterative Figma verification.

### ✅ Quality Agents

#### 🔍 Code Reviewer

- Focus: **structured code review and risk detection**.
- Checks changes against acceptance criteria, security and reliability guidelines.
- Suggests concrete improvements, alternative designs, and missing tests.

#### 🔎 UI Reviewer

- Focus: **single-pass UI verification against Figma designs**.
- Performs read-only comparison: Figma (EXPECTED) vs Playwright (ACTUAL).
- Returns PASS/FAIL verdict with structured difference table.
- Called by `/implement-ui` in a loop; can also be used standalone.

#### 🧪 E2E Engineer

- Focus: **end-to-end testing with Playwright**.
- Creates comprehensive, reliable test suites for critical user journeys.
- Uses Page Object Model, proper fixtures, and accessibility-first locators.
- Integrates with Playwright MCP for real-time test debugging and validation.
- Follows testing pyramid principles – E2E for critical paths, not unit-level validation.

### ⚙️ Copilot Customization Agents

#### ⚙️ Copilot Engineer
- Focus: **designing, creating, reviewing, and improving Copilot customization artifacts**.
- Expert in prompt engineering, context engineering, and AI engineering for custom agents, skills, prompts, and instructions.
- Enforces separation of concerns between customization types (agent = WHO, skill = HOW, prompt = WHAT, instructions = RULES).
- Optimizes token efficiency, context architecture, and signal-to-noise ratio within context windows.

#### 🔀 Copilot Orchestrator *(experimental)*
- Focus: **coordinating complex, multi-step Copilot customization tasks** using specialized sub-agents.
- Decomposes work into focused subtasks and delegates to three workers: Researcher, Creator, and Reviewer — each running in an isolated context window.
- Solves the "context rot" problem where complex tasks degrade quality in a monolithic agent's context window.
- Coexists alongside Copilot Engineer for A/B comparison — see [Orchestrator Pattern](docs/orchestrator-pattern.md) for the full deep-dive.

Each agent is designed to be used together with the workflow prompts below.

---

## 🧠 Skills

Skills provide **specialized domain knowledge and structured workflows** that agents automatically load when relevant to a task. They encode tested, step-by-step processes for common activities — ensuring consistent, high-quality outputs across team members.

Skills are stored in `.github/skills/` and are picked up automatically by Copilot when enabled via `chat.agentSkillsLocations` in VS Code settings.

### 📋 Product Ideation Skills

> 💡 Skills follow a **gerund-form naming convention** (`verb-ing` + `object`). See the [Creating Skills](.github/skills/creating-skills/SKILL.md) skill for the full authoring methodology.

#### 🔍 Task Analysis

- Focus: **gathering and expanding context** for a development task.
- Pulls information from Jira, Confluence, GitHub, and other integrated tools.
- Identifies gaps in task descriptions and asks clarification questions.
- Produces a finalized research report with all findings.

#### 📝 Transcript Processing

- Focus: **cleaning raw workshop or meeting transcripts**.
- Removes small talk, filler words, greetings, off-topic tangents, and technical difficulties.
- Preserves all business-relevant discussion and structures content by topics.
- Extracts key decisions, action items, and open questions into dedicated sections.

#### 📋 Task Extraction

- Focus: **identifying epics and user stories from workshop materials**.
- Analyzes cleaned transcripts, Figma designs, codebase context, and other documents.
- Produces business-oriented task breakdowns with dependencies and assumptions.
- Flags ambiguous items for user clarification before finalizing.

#### 🎫 Jira Task Formatting

- Focus: **transforming extracted tasks into Jira-ready format**.
- Applies a benchmark template to ensure consistent field mapping across all tasks.
- Handles Jira markdown compatibility and two-gate review before push.
- Guides the agent on creating epics and linked stories via Atlassian tools.

### 🛠 Development Skills

#### 🧱 Architecture Design

- Focus: **designing solution architecture** that follows best practices.
- Analyzes the current codebase and task requirements.
- Proposes a solution that is scalable, secure, and easy to maintain.
- Covers patterns like DRY, KISS, DDD, CQRS, modular/hexagonal architecture, and more.

#### 🧭 Technical Context Discovery

- Focus: **establishing technical context** before implementing any feature.
- Prioritizes project instructions, existing codebase patterns, and external documentation — in that order.
- Checks for Copilot instruction files, analyzes existing code conventions, and consults external docs as a fallback.
- Ensures new code is consistent with established patterns and prevents conflicting conventions.

#### 🎨 Frontend Implementation

- Focus: **frontend implementation patterns and best practices**.
- Covers accessibility requirements, design system usage, component patterns, and performance guidelines.
- Provides token mapping process, semantic markup guidelines, and ARIA usage patterns.
- Includes component implementation checklist and anti-patterns to avoid.

#### 📋 Implementation Gap Analysis

- Focus: **comparing expected vs. actual implementation state**.
- Analyzes what needs to be built, what already exists, and what must be modified.
- Cross-references task requirements with the current codebase.
- Produces a structured gap report for planning next steps.

#### 🗄️ SQL & Database Engineering

- Focus: **database schema design, performant SQL, and query debugging**.
- Covers naming conventions, primary key strategies, data type selection, and normalisation.
- Provides indexing strategies, join optimisation, locking mechanics, and transaction patterns.
- Includes query debugging with `EXPLAIN ANALYZE` and common anti-pattern detection.
- Supports ORM integration with TypeORM, Prisma, Doctrine, Eloquent, Entity Framework, Hibernate, and GORM.
- Applies to PostgreSQL, MySQL, MariaDB, SQL Server, and Oracle.

#### 📊 Codebase Analysis

- Focus: **structured analysis of the entire codebase**.
- Reviews repository structure, dependencies, scripts, and architecture.
- Examines backend, frontend, infrastructure, and third-party integrations.
- Identifies dead code, duplications, security concerns, and potential improvements.

### ✅ Quality Skills

#### 🔎 Code Review

- Focus: **verifying implemented code** against quality standards.
- Compares implementation to the task description and plan.
- Validates test coverage, security, scalability, and best practices.
- Runs available tests and static analysis tools.

#### 🔍 UI Verification

- Focus: **verifying UI implementation against Figma designs**.
- Defines verification categories: structure, layout, dimensions, visual, components.
- Provides severity definitions, tolerance rules, and verification checklists.
- Includes confidence levels and report format for consistent verification outputs.

#### 🧪 E2E Testing

- Focus: **end-to-end testing patterns and practices** using Playwright.
- Provides Page Object Model patterns, test structure templates, and mocking strategies.
- Includes a verification loop with iteration limits and flaky test detection.
- Covers error recovery strategies and CI readiness checklists.
- Ensures consistent, reliable E2E tests across the team.

### ⚙️ Copilot Customization Skills

#### 🏗️ Creating Agents
- Focus: **creating custom agents** (.agent.md) for GitHub Copilot in VS Code.
- Provides templates, guidelines, and a structured process for building agent definitions.
- Enforces separation of concerns between agents (WHO), skills (HOW), and prompts (WHAT).
- Ensures consistent agent structure with clear behavior, personality, and responsibility definitions.

#### ✍️ Creating Skills
- Focus: **creating well-structured, reusable skills** (SKILL.md) for GitHub Copilot.
- Enforces gerund-form naming conventions, description guidelines, and body structure rules.
- Provides templates, examples, and a validation checklist for consistent skill authoring.
- Implements progressive disclosure patterns to optimize token usage across discovery, activation, and resource tiers.

#### 📝 Creating Prompts
- Focus: **creating custom prompt files** (.prompt.md) for GitHub Copilot in VS Code.
- Provides templates and guidelines for building prompt files that trigger specific workflows.
- Routes workflows to the right custom agent and AI model via frontmatter configuration.
- Ensures prompts focus on workflow steps without redefining agent identity or behavior.

#### 📜 Creating Instructions
- Focus: **creating custom instruction files** (.instructions.md) for GitHub Copilot in VS Code.
- Covers both repository-level instructions (the project constitution) and granular scoped instructions with applyTo glob patterns.
- Provides templates, decision framework for when conventions belong in instructions vs. skills, and validation checklists.
- Ensures instruction files are concise, self-contained, and focused on rules that linters and formatters don't enforce.

---

## 💬 Prompts & Chat Commands

All commands work with either a **Jira ID** or a **plain-text description**.

### 📋 Product Ideation Commands

#### `/analyze-materials <workshop materials>`

- Processes discovery workshop materials end-to-end: clean transcript → extract tasks → format for Jira → push.
- Accepts raw transcripts, Figma design links, codebase references, and other documents.
- Produces three artifacts: `cleaned-transcript.md`, `extracted-tasks.md`, `jira-tasks.md`.
- Includes two mandatory review gates before Jira creation.
- Outputs: Jira-ready epics and stories, created in your Jira project after approval.

#### `/clean-transcript <transcript>`

- Standalone command to clean a raw workshop transcript.
- Removes small talk, structures content by discussion topics, extracts decisions and action items.
- Outputs: `cleaned-transcript.md` in the specifications directory.

#### `/create-jira-tasks <extracted-tasks reference>`

- Formats an existing `extracted-tasks.md` into Jira-ready structure and pushes to Jira.
- Applies the benchmark template, validates completeness, and manages review gates.
- Outputs: `jira-tasks.md` + created Jira issues with linked epics and stories.

### 🛠 Development Commands

#### `/research <JIRA_ID | description>`

- Gathers all available information about the task.
- Pulls context from Jira, design artifacts, and code (via MCPs where applicable).
- Outputs: task summary, assumptions, open questions, and suggested next steps.

#### `/plan <JIRA_ID | description>`

- Creates a **multi-step implementation plan**.
- Groups work into phases and tasks aligned with your repo structure.
- Outputs: checklist-style plan that can be executed by the Software Engineer agent.

#### `/implement <JIRA_ID | description>`

- Implements the previously defined plan.
- Proposes file changes, refactors, and new code in a focused way.
- Outputs: concrete modifications and guidance on how to apply/test them.

#### `/implement-ui <JIRA_ID | description>`

- Implements UI features with **iterative Figma verification**.
- Extends `/implement` with a verification loop after each component.
- Uses **Playwright** to capture current UI state and **Figma MCP** to compare with designs.
- Automatically fixes mismatches and re-verifies until implementation matches design.
- Outputs: code changes + UI Verification Summary with iteration counts.

### ✅ Quality Commands

#### `/review <JIRA_ID | description>`

- Reviews the final implementation against the plan and requirements.
- Highlights security, reliability, performance, and maintainability concerns.
- Outputs: structured review with clear "pass/blockers/suggestions".

#### `/review-ui`

- Performs **single-pass UI verification** comparing implementation against Figma.
- Uses **Figma MCP** (EXPECTED) and **Playwright MCP** (ACTUAL) to compare.
- **Read-only** – reports differences but does not fix them.
- Called by `/implement-ui` in a loop; can also be used standalone.
- Outputs: PASS/FAIL verdict + structured difference table with exact values.

#### `/review-codebase`

- Performs a **comprehensive code quality analysis** of the repository.
- Detects dead code, unused imports, unreachable code paths, and orphaned files.
- Identifies code duplications across functions, components, API patterns, and type definitions.
- Proposes improvement opportunities covering complexity, naming, error handling, performance, and security.
- Includes an **architecture review** evaluating module boundaries, dependency graph, and separation of concerns.
- For monorepos, analyzes each layer/app separately using parallel subagents.
- Outputs: prioritized `code-quality-report.md` with severity levels (🔴 Critical / 🟡 Important / 🟢 Nice to Have) and a recommended action plan.

#### `/implement-e2e <JIRA_ID | description>`

- Creates comprehensive **end-to-end tests** for the feature using Playwright.
- Analyzes the application, designs test scenarios, and implements Page Objects.
- Uses **Playwright MCP** for real-time interaction and test verification.
- Follows BDD-style scenarios with proper Arrange-Act-Assert structure.
- Outputs: Page Objects, test files, fixtures, and execution report.

### ⚙️ Copilot Customization Commands

> To create or modify Copilot customization artifacts (agents, skills, prompts, instructions), use the `/create-custom-*` commands below. These route to the orchestrator which handles research, creation, and review automatically.

#### `/create-custom-agent`

- Creates a new custom agent (`.agent.md`) for VS Code Copilot.
- Analyzes existing agents for patterns and conventions, guides through design decisions.
- Validates that skill references, tool lists, and agent ecosystem integration are correct.
- Routes to `tsh-copilot-orchestrator` which handles the research → create → review workflow.
- Outputs: a new agent file in `.github/agents/` following workspace conventions.

#### `/create-custom-skill`

- Creates a new custom skill (`SKILL.md`) for VS Code Copilot.
- Analyzes existing skills for patterns, enforces gerund naming convention.
- Creates supporting resources (templates, examples) alongside the SKILL.md.
- Routes to `tsh-copilot-orchestrator` which handles the research → create → review workflow.
- Outputs: skill directory with SKILL.md and supporting files in `.github/skills/`.

#### `/create-custom-prompt`

- Creates a new custom prompt (`.prompt.md`) for VS Code Copilot.
- Analyzes existing prompts, identifies the right agent routing target.
- Ensures agent and model are specified following established patterns.
- Routes to `tsh-copilot-orchestrator` which handles the research → create → review workflow.
- Outputs: prompt file in `.github/prompts/` with correct routing.

#### `/create-custom-instructions`

- Creates custom instructions (`.instructions.md` or `copilot-instructions.md`) for VS Code Copilot.
- Helps decide between repository-level and file-scoped instructions.
- Analyzes existing project conventions for appropriate scope and content.
- Routes to `tsh-copilot-orchestrator` which handles the research → create → review workflow.
- Outputs: instructions file with appropriate scope and content.

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
    "~/projects/copilot-collections/.github/prompts": true,
  },
  "chat.agentFilesLocations": {
    "~/projects/copilot-collections/.github/agents": true,
  },
  "chat.agentSkillsLocations": {
    "~/projects/copilot-collections/.github/skills": true,
  },
  "chat.useAgentSkills": true,
  "github.copilot.chat.searchSubagent.enabled": true,
  "chat.experimental.useSkillAdherencePrompt": true,
  "chat.customAgentInSubagent.enabled": true,
  "github.copilot.chat.agentCustomizationSkill.enabled": true,
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

> Some MCPs require **API keys or local apps running**. Configure auth as described in each MCP's own documentation.

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
3. Pick an agent and prompt matching the lifecycle phase you need:

### 📋 Product Ideation – Create requirements & plan work

| Agent | Prompt | Purpose |
|---|---|---|
| Business Analyst | `/analyze-materials <materials>` | Clean transcript → extract tasks → push to Jira |

### 🛠 Development – Architect & implement

| Agent | Prompt | Purpose |
|---|---|---|
| Context Engineer | `/research <JIRA_ID>` | Gather context, identify gaps & risks |
| Architect | `/plan <JIRA_ID>` | Create multi-step implementation plan |
| Software Engineer | `/implement <JIRA_ID>` | Standard backend & frontend implementation |
| Software Engineer | `/implement-ui <JIRA_ID>` | UI implementation with iterative Figma verification |

### ✅ Quality – Review & test

| Agent | Prompt | Purpose |
|---|---|---|
| Code Reviewer | `/review <JIRA_ID>` | Structured code review against criteria |
| UI Reviewer | `/review-ui` | Single-pass UI vs Figma comparison |
| E2E Engineer | `/implement-e2e <JIRA_ID>` | End-to-end test creation with Playwright |
| — | `/review-codebase` | Full codebase quality analysis |

### ⚙️ Copilot Customization – Extend the toolchain

| Agent | Prompt | Purpose |
|---|---|---|
| Copilot Engineer / Orchestrator | `/create-custom-agent` | Create a new custom agent |
| Copilot Engineer / Orchestrator | `/create-custom-skill` | Create a new custom skill |
| Copilot Engineer / Orchestrator | `/create-custom-prompt` | Create a new custom prompt |
| Copilot Engineer / Orchestrator | `/create-custom-instructions` | Create custom instruction files |

All of these will leverage the shared configuration from `copilot-collections` while still respecting your project's own code and context.

---

## 📌 Summary

- Covers the **full product development lifecycle**: Product Ideation → Development → Quality.
- Provides **specialized agents** for each phase – from Business Analyst to E2E Engineer.
- Includes a **Copilot Customization** track for creating and maintaining custom agents, skills, prompts, and instructions.
- Includes **reusable skills** encoding tested workflows for consistent, high-quality outputs.
- Optimized for teams working with **Jira, Figma, MCPs, and VS Code**.
- Designed to be **plug-and-play** – clone next to your projects, configure once in **VS Code User Settings**, and start using the full lifecycle immediately in any workspace.

---

## 📄 License

This project is licensed under the **MIT License**.

© 2026 [The Software House](https://tsh.io)
