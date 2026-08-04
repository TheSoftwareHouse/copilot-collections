---
name: tsh-create-custom-agent
description: "Create a new custom agent (.agent.md) for VS Code Copilot. Analyzes existing agents for patterns, guides through design decisions, creates the agent file, and validates against best practices."
user-invocable: true
---
<routing>Run this workflow through the designated agent: `tsh-copilot-orchestrator`.</routing>

Create a new custom agent by researching existing agents, clarifying purpose and tools, applying the canonical agent-authoring guidance, and validating routing and structure.

<required-skills>
- `tsh-creating-agents` - agent structure and validation.
- `tsh-technical-context-discovering` - repository conventions.
- `tsh-codebase-analysing` - existing agent patterns.
</required-skills>

<workflow>
1. Analyze existing agents and their responsibilities, tools, skills, and handoffs.
2. Clarify the requested role, workflows, tools, and constraints.
3. Create the `.agent.md` under `.github/agents/` using established conventions.
4. Validate references, XML-like sections, frontmatter, and ecosystem integration.
</workflow>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-create-custom-agent:v1 -->
