---
agent: "tsh-copilot-orchestrator"
model: "Claude Opus 4.6"
description: "Create a new custom prompt (.prompt.md) for VS Code Copilot. Analyzes existing prompts for patterns, identifies the right agent to route to, creates the prompt file, and validates the workflow end-to-end."
---

Create a new custom prompt for VS Code Copilot. Every prompt must specify an agent and model in YAML frontmatter — the orchestrator handles research of existing prompts and agents, design decisions, prompt file creation, and end-to-end validation. The user's message following this prompt may contain specific requirements or a description of the desired prompt.

## Required Skills

Before starting, load and follow these skills:
- `tsh-creating-prompts` - for prompt file creation workflow, templates, and validation checklist
- `tsh-technical-context-discovering` - for discovering project conventions and workspace patterns before creating
- `tsh-codebase-analysing` - for analyzing existing prompts for structural patterns and routing conventions

## Workflow

1. **Research existing prompts**: Analyze prompts in `.github/prompts/` for patterns and conventions:
   - Frontmatter format (agent, model, description fields)
   - Body structure (intro, Required Skills, Workflow, optional sections)
   - Skill reference format and conventions
   - Body size and level of detail
2. **Research available agents**: Analyze agents in `.github/agents/` to determine the best routing target for the new prompt:
   - Available agent names and their responsibilities
   - Which agent is best suited for the prompt's workflow
   - Existing agent-to-prompt routing patterns
3. **Clarify requirements**: Determine the prompt's design parameters with the user:
   - Purpose, target workflow, and expected user interaction
   - Which agent should handle the prompt (based on agent research)
   - Required skills the prompt should reference
   - If the user's message already contains requirements, confirm understanding before proceeding
4. **Create the prompt file**: Create the `.prompt.md` file in `.github/prompts/` with correct agent routing, model, and skill references. Apply the `tsh-creating-prompts` skill workflow for structure and validation.
5. **Review and validate**: Review the created prompt against best practices:
   - Verify the routing agent exists in `.github/agents/`
   - Confirm structural consistency with existing prompts
   - Validate end-to-end workflow (prompt → agent → skills → output)

## Important

- Every prompt MUST specify an `agent` and `model` in YAML frontmatter — this is the established pattern with 100% consistency across all prompts in this repository.
- Research available agents in `.github/agents/` before choosing the routing target for the new prompt.

If the user attaches files or provides a description, use them as input for prompt design.

When in doubt about design decisions, ask the user for clarification rather than guessing.
