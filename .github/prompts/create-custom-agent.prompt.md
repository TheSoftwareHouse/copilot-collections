---
agent: "tsh-copilot-orchestrator"
model: "Claude Opus 4.6"
description: "Create a new custom agent (.agent.md) for VS Code Copilot. Analyzes existing agents for patterns, guides through design decisions, creates the agent file, and validates against best practices."
---

Create a new custom agent for VS Code Copilot. The orchestrator handles research of existing agents, design decisions, agent file creation, and review against best practices. The user's message following this prompt may contain specific agent requirements or a description of the desired agent.

## Required Skills

Before starting, load and follow these skills:
- `creating-agents` - for agent file creation workflow, templates, and validation checklist
- `technical-context-discovery` - for discovering project conventions and workspace patterns before creating
- `codebase-analysis` - for analyzing existing agents for structural patterns and naming conventions

## Workflow

1. **Research existing agents**: Analyze agents in `.github/agents/` for patterns and conventions:
   - Naming conventions and file placement
   - Structural patterns (sections, headings, formatting)
   - Tool configurations and skill references
   - Behavioral constraints and personality definitions
2. **Clarify requirements**: Determine the agent's design parameters with the user:
   - Purpose and primary responsibilities
   - Target workflows and use cases
   - Tool needs and skill references
   - If the user's message already contains requirements, confirm understanding before proceeding
3. **Design the agent**: Make design decisions based on research findings and user input:
   - Agent name, description, and personality
   - Tool list and skill references
   - Behavioral constraints and operational boundaries
   - How the agent fits within the existing agent ecosystem
4. **Create the agent file**: Create the `.agent.md` file in `.github/agents/` following established conventions. Apply the `creating-agents` skill workflow for structure and validation.
5. **Review and validate**: Review the created agent against best practices:
   - Verify skill and tool references point to valid targets
   - Confirm structural consistency with existing agents
   - Check that the agent integrates well with the existing ecosystem

If the user attaches files or provides a description, use them as input for agent design.

Follow the conventions established by existing agents in the workspace.

When in doubt about design decisions, ask the user for clarification rather than guessing.
