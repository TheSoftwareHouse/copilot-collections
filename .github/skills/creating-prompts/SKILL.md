---
name: creating-prompts
description: "Create custom prompt files (.prompt.md) for GitHub Copilot in VS Code. Provides templates, guidelines, and a structured process for building prompt files that trigger specific workflows routed to the right custom agent and AI model. Use when creating, reviewing, or updating .prompt.md files."
---

# Creating Prompts

Creates well-structured custom prompt files for GitHub Copilot in VS Code. Enforces a consistent pattern across all prompts and ensures clear separation between prompt files, agent definitions, and skills.

## Core Design Principles

<principles>

<separation-of-concerns>
A prompt file (.prompt.md) defines WHAT workflow to execute. It must NOT define WHO the agent is.

- **Prompt** = workflow trigger, workflow steps, tool configuration, expected outcome
- **Agent** = behavior, personality, responsibilities, and problem-solving approach (.agent.md files)
- **Skills** = reusable domain knowledge, step-by-step processes, templates (SKILL.md files)

A prompt routes work to an agent and configures the workflow context. The agent's role, personality, and behavioral guidelines are defined exclusively in the agent file. The prompt must never redefine, override, or contradict the agent's identity.
</separation-of-concerns>

<workflow-focus>
A prompt file is a **workflow trigger**. It must:

- Route to a **specific custom agent** via the `agent` frontmatter field
- Target a **specific AI model** via the `model` frontmatter field
- Describe the **workflow steps** the agent should follow for this specific task
- Define the **expected outcome** of the workflow
- Optionally configure **tools** (MCP servers, built-in tools) available for the workflow

A prompt must NOT:

- Define or alter the agent's personality, tone, or behavioral traits
- Duplicate instructions that belong in skills
- Duplicate coding standards or guidelines that belong in `.instructions.md` files
- Contain generic instructions that are not specific to the workflow
</workflow-focus>

<xml-syntax>
All structured content inside the prompt body MUST use XML-like tags for explicit structure. This ensures reliable parsing across all LLM model tiers.

Use Markdown only for inline formatting (bold, code blocks, tables, lists) within XML sections.
</xml-syntax>

<minimal-scope>
A prompt should only describe what is necessary for the specific workflow it triggers. Delegate domain knowledge to skills, coding standards to instructions, and behavioral guidelines to agents.
</minimal-scope>

</principles>

## Creation Process

Use the checklist below and track your progress:

```
Creation progress:
- [ ] Step 1: Define the prompt's purpose
- [ ] Step 2: Choose the target agent and model
- [ ] Step 3: Determine tool requirements
- [ ] Step 4: Identify required skills
- [ ] Step 5: Design the workflow steps
- [ ] Step 6: Define output expectations
- [ ] Step 7: Assemble the prompt file using the template
- [ ] Step 8: Validate the prompt file
```

**Step 1: Define the prompt's purpose**

Answer these questions before writing anything:
- What specific workflow does this prompt trigger? (e.g., research a task, implement a feature, run e2e tests)
- What is the expected outcome? (e.g., a research document, implemented code, test suite)
- What inputs does the workflow require? (e.g., Jira ID, plan file, feature description)
- Does this prompt extend or depend on another prompt?
- What makes this workflow distinct from existing prompts?

**Step 2: Choose the target agent and model**

Select the agent and model best suited for the workflow:
- Review existing agents in `.github/agents/` to find the one whose role aligns with the workflow
- Choose the agent based on its specialization — the prompt should not need to redefine the agent's capabilities
- Select the AI model based on the workflow's complexity requirements (e.g., reasoning-heavy tasks may need a more capable model)
- The `agent` field controls which agent runs the prompt; the `model` field controls which LLM is used

**Step 3: Determine tool requirements**

Decide if the prompt needs tools beyond the agent's defaults:
- If the workflow requires specific MCP servers (e.g., `figma-mcp-server/*`, `atlassian/*`), list them in the `tools` frontmatter
- If the workflow only needs the agent's default tools, omit the `tools` field entirely
- Remember: prompt-level tools take priority over agent-level tools (see VS Code docs on tool list priority)
- Use the `<server-name>/*` format to include all tools from an MCP server

**Step 4: Identify required skills**

Determine which skills the workflow depends on:
- Review existing skills in `.github/skills/` to find relevant ones
- Each referenced skill will be loaded by the agent before starting the workflow
- List skills with a brief explanation of why they are needed for THIS workflow
- Do not reference skills that are not directly used in the workflow steps

**Step 5: Design the workflow steps**

Outline the workflow as a numbered sequence:
- Each step should be a clear, actionable instruction
- Steps should reference skills and tools where appropriate
- Include decision points and branching logic if the workflow is not purely linear
- Include automatic handoffs to other agents if the workflow spans multiple specializations
- Keep steps focused on WHAT to do, not HOW to think about it (the agent's personality handles the how)

**Step 6: Define output expectations**

Specify the expected deliverables of the workflow:
- File name conventions and output locations
- Document structure or template to follow (reference skill templates where applicable)
- Summary format if the workflow produces a report
- Success criteria — how to know the workflow is complete
- This step is optional if the workflow outcome is self-evident (e.g., implemented code)

**Step 7: Assemble the prompt file using the template**

Use the `./prompt.template.md` template to assemble the final `.prompt.md` file. Place the file in `.github/prompts/` with a descriptive kebab-case filename (e.g., `research.prompt.md`, `implement-ui.prompt.md`).

**Step 8: Validate the prompt file**

Verify the prompt file against this checklist:
- [ ] YAML frontmatter is valid and parseable
- [ ] `agent` field references an existing agent in `.github/agents/`
- [ ] `model` field specifies a valid AI model
- [ ] `description` field is present and concise
- [ ] `tools` field (if present) lists only tools needed beyond agent defaults
- [ ] All skills referenced in `Required Skills` section exist in `.github/skills/`
- [ ] XML-like tags are properly opened and closed
- [ ] No agent personality or behavioral instructions are embedded (those belong in .agent.md)
- [ ] No coding standards or guidelines are embedded (those belong in .instructions.md)
- [ ] No skill content is duplicated (reference skills, don't copy them)
- [ ] Workflow steps are clear, sequential, and actionable
- [ ] The prompt is distinct from existing prompts and does not duplicate their workflows
- [ ] If the prompt extends another prompt, the dependency is explicitly stated

## Prompt File Structure Reference

### Frontmatter Fields

| Field | Required | Description |
|---|---|---|
| `agent` | **Yes*** | The custom agent used for running the prompt. Must match an agent filename in `.github/agents/` (without the `.agent.md` suffix). If omitted, the current agent in chat is used. |
| `model` | **Yes*** | The AI model used when running the prompt. If omitted, the currently selected model in the model picker is used. |
| `description` | **Yes*** | A short description of what the prompt does. Shown in the `/` menu. |
| `name` | No | Override display name shown in the `/` menu instead of the filename. |
| `argument-hint` | No | Hint text shown in the chat input field to guide the user on what to provide (e.g., `[Jira ID or task description]`). |
| `tools` | No | A list of tool or tool set names available for this prompt. Overrides agent defaults. Use `<server-name>/*` for all MCP server tools. |

\* Technically optional per VS Code, but **required by convention** in this project to ensure every prompt explicitly routes to the correct agent and model.

### Body Sections

| Section | Required | Purpose |
|---|---|---|
| Goal statement | **Yes** | 1-2 paragraphs describing what the prompt accomplishes and the expected outcome. |
| `<prerequisites>` | No | Dependencies on other prompts or files that must be completed first. |
| `<input-requirements>` | No | Describes what context or inputs the workflow needs to start. |
| Required Skills | **Yes** | Skills to load before starting the workflow, with brief rationale for each. |
| Workflow | **Yes** | Numbered steps defining the workflow sequence. |
| `<output-specification>` | No | File naming, document structure, summary format, or success criteria. |
| `<handoff>` | No | Automatic handoff to another agent at the end of the workflow. |
| `<constraints>` | No | Workflow-specific limitations, anti-patterns, or scope boundaries. |

## XML Syntax Guidelines

All body content in the prompt file must use XML-like tags for structure. Rules:

1. Every section uses a matching opening and closing tag: `<section-name>` ... `</section-name>`
2. Tags use lowercase-kebab-case naming
3. Nesting is allowed for sub-sections
4. Markdown formatting (bold, lists, tables, code blocks) is used inside XML tags for content
5. Avoid XML attributes for structural content — use nested tags or Markdown content instead. Exception: identifier attributes (e.g., `<tool name="...">`) are acceptable when they improve readability.

## Variables Reference

Prompt files support variables that are resolved at runtime. Use them to make prompts more flexible:

| Variable | Description |
|---|---|
| `${workspaceFolder}` | Absolute path to the workspace root |
| `${workspaceFolderBasename}` | Name of the workspace folder |
| `${file}` | Path to the currently open file |
| `${fileBasename}` | Filename of the currently open file |
| `${fileDirname}` | Directory of the currently open file |
| `${fileBasenameNoExtension}` | Filename without extension |
| `${selection}` / `${selectedText}` | Currently selected text in the editor |
| `${input:variableName}` | Prompts user for text input at runtime |
| `${input:variableName:placeholder}` | User input with placeholder hint |

Variables are useful for prompts that operate on dynamic context (e.g., the current file, user-provided identifiers).

## Connected Skills

- `creating-agents` - to understand agent patterns and ensure prompts don't overlap with agent responsibilities
- `creating-skills` - to ensure this skill's own structure follows the canonical skill creation requirements
- `technical-context-discovery` - to understand existing prompt patterns and project conventions before creating a new one
- `codebase-analysis` - to analyze existing prompts and identify patterns to follow
