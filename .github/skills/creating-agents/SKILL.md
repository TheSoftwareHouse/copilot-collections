---
name: creating-agents
description: "Create custom agents (.agent.md) for GitHub Copilot in VS Code. Provides templates, guidelines, and a structured process for building agent definitions that describe behavior, personality, responsibilities, and problem-solving approaches. Use when creating, reviewing, or updating .agent.md files."
---

# Creating Agents

Creates well-structured custom agents for GitHub Copilot in VS Code. Enforces a consistent pattern across all agents and ensures clear separation between agent definitions, skills, and prompts.

## Core Design Principles

<principles>
<separation-of-concerns>
An agent file (.agent.md) defines WHO the agent is. It must NOT define HOW specific workflows are executed.

- **Agent** = behavior, personality, responsibilities, and problem-solving approach
- **Skills** = reusable workflows, domain knowledge, step-by-step processes (SKILL.md files)
- **Prompts** = task triggers, workflow starters, reusable prompt templates (.prompt.md files)

Every agent is designed to be extendable with skills and prompts. The agent itself provides the foundation; skills and prompts layer on top for specific workflows.
</separation-of-concerns>

<xml-syntax>
All structured content inside the agent body MUST use XML-like tags for explicit structure. This ensures reliable parsing across all LLM model tiers.

Use Markdown only for inline formatting (bold, code blocks, tables, lists) within XML sections.
</xml-syntax>

<minimal-scope>
An agent should only describe what is necessary for its specific role. Avoid duplicating instructions that belong in skills or project-level instruction files (.instructions.md).
</minimal-scope>
</principles>

## Creation Process

Use the checklist below and track your progress:

```
Creation progress:
- [ ] Step 1: Define the agent's purpose
- [ ] Step 2: Write the agent role and responsibilities
- [ ] Step 3: Determine tools and write tool usage guidelines
- [ ] Step 4: Determine skills and write skills usage guidelines
- [ ] Step 5: Configure handoffs (if applicable)
- [ ] Step 6: Add domain standards (if applicable)
- [ ] Step 7: Add constraints (if applicable)
- [ ] Step 8: Assemble the agent file using the template
- [ ] Step 9: Validate the agent file
```

**Step 1: Define the agent's purpose**

Answer these questions before writing anything:
- What specific role does this agent fulfill? (e.g., architect, reviewer, engineer)
- What problems does it solve?
- What is the agent's primary focus area?
- Which other agents does it collaborate with?
- What makes this agent distinct from existing agents?

**Step 2: Write the agent role and responsibilities**

Write the `<agent-role>` section. This is the core of the agent. It must describe:
- A clear role statement starting with "Role: You are..."
- The agent's primary responsibilities and focus areas
- The agent's behavioral guidelines (how it approaches work)
- Skip-level instructions for skill and tool usage (always check skills first, always use tools to gather context)

Follow the pattern from existing agents. Keep the role focused. Do not include workflow-specific steps — those belong in skills.

**Step 3: Determine tools and write tool usage guidelines**

Review available tools and select only those relevant to the agent's role:
- List each tool in the YAML frontmatter `tools` array
- For each tool, write a `<tool>` entry in the `<tool-usage>` section describing:
  - **MUST use when**: Specific conditions requiring tool use
  - **IMPORTANT**: Configuration notes, prerequisites, or behavioral constraints
  - **SHOULD NOT use for**: Anti-patterns and out-of-scope usage

Match tool selection to the agent's responsibilities. Read-only agents should not get edit tools. Implementation agents need execution tools.

**Step 4: Determine skills and write skills usage guidelines**

Review available skills and select those the agent should load:
- For each skill, write a short entry explaining WHEN to use it
- Use the format: `skill-name` - brief description of when to use it

Do not duplicate skill content in the agent file. The agent only references skills.

**Step 5: Configure handoffs (if applicable)**

If the agent participates in multi-step workflows:
- Define handoff entries in the YAML frontmatter
- Each handoff needs: `label`, `agent`, `prompt`, and `send` (typically `false` for user approval)
- Optionally specify `model` for the target agent

**Step 6: Add domain standards (if applicable)**

If the agent's role requires enforcing domain-specific standards (e.g., testing conventions, security rules, UI patterns), add a `<domain-standards>` section. This section is optional and should only appear when the agent genuinely needs domain-specific rules that are NOT covered by skills.

**Step 7: Add constraints (if applicable)**

If the agent has specific limitations or anti-patterns to avoid, add a `<constraints>` section. Common constraints include:
- What the agent must NOT produce (e.g., "don't create implementation plans")
- Scope boundaries (e.g., "don't provide deployment instructions")
- Delegation rules (e.g., "escalate architectural decisions to the architect")

**Step 8: Assemble the agent file using the template**

Use the `./agent.template.md` template to assemble the final `.agent.md` file. Place the file in `.github/agents/` with the naming convention `<agent-name>.agent.md`.

**Step 9: Validate the agent file**

Verify the agent file against this checklist:
- [ ] YAML frontmatter is valid and parseable
- [ ] `description` is present and concise
- [ ] `tools` array includes only relevant tools
- [ ] All tools listed in frontmatter have corresponding `<tool>` entries in `<tool-usage>`
- [ ] All skills referenced in `<skills-usage>` are existing skills in the project
- [ ] XML-like tags are properly opened and closed
- [ ] No workflow-specific instructions are embedded (those belong in skills)
- [ ] No coding standards are embedded (those belong in .instructions.md)
- [ ] Agent role is focused and distinct from existing agents
- [ ] Handoffs (if present) target valid agent names

## Agent File Structure Reference

### Frontmatter Fields

| Field | Required | Description |
|---|---|---|
| `description` | **Yes** | Brief description of the agent, shown as placeholder text in chat input. |
| `tools` | **Yes** | Array of tool/tool-set names available to the agent. Use `<server>/*` for all MCP server tools. |
| `handoffs` | No | Array of handoff configurations for multi-step workflows. |
| `agents` | No | Array of agent names available as subagents. Use `*` for all, `[]` for none. |
| `name` | No | Override display name (defaults to filename). |
| `argument-hint` | No | Hint text shown in chat input to guide user interaction. |
| `model` | No | Preferred AI model (string or prioritized array). |
| `user-invokable` | No | Boolean, controls visibility in agents dropdown (default: `true`). |
| `disable-model-invocation` | No | Boolean, prevents auto-invocation as subagent (default: `false`). |

### Body Sections

| Section | Required | Purpose |
|---|---|---|
| `<agent-role>` | **Yes** | Role definition, responsibilities, behavioral guidelines. |
| `<skills-usage>` | **Yes** | List of skills the agent uses with guidance for each. |
| `<tool-usage>` | **Yes** | Tool access rules and usage guidelines per tool. |
| `<domain-standards>` | No | Domain-specific standards and rules the agent enforces. |
| `<collaboration>` | No | Interaction patterns with other agents or team members. |
| `<constraints>` | No | Explicit limitations and anti-patterns for the agent. |
| `<output-format>` | No | Expected structure or format of the agent's deliverables. |

## XML Syntax Guidelines

All body content in the agent file must use XML-like tags for structure. Rules:

1. Every section uses a matching opening and closing tag: `<section-name>` ... `</section-name>`
2. Tags use lowercase-kebab-case naming
3. Nesting is allowed for sub-sections: `<tool>` inside `<tool-usage>`
4. Markdown formatting (bold, lists, tables, code blocks) is used inside XML tags for content
5. Avoid XML attributes for structural content — use nested tags or Markdown content instead. Exception: identifier attributes (e.g., `<tool name="...">`) are acceptable when they improve readability.

Example structure:
```xml
<agent-role>
Role: You are a...
</agent-role>

<tool-usage>
<tool name="context7">
- **MUST use when**: ...
- **SHOULD NOT use for**: ...
</tool>
</tool-usage>
```

## Connected Skills

- `creating-prompts` - to understand how prompts reference agents and ensure agents don't overlap with prompt responsibilities
- `creating-skills` - to ensure this skill's own structure follows the canonical skill creation requirements
- `technical-context-discovery` - to understand existing agent patterns in the project before creating a new one
- `codebase-analysis` - to analyze existing agents and identify patterns to follow
- `creating-instructions` - to understand when coding standards and project conventions belong in instruction files rather than agent definitions
