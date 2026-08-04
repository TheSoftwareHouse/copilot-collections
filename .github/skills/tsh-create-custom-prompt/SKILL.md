---
name: tsh-create-custom-prompt
description: "Create a new custom prompt (.prompt.md) for VS Code Copilot. Analyzes existing prompts for patterns, identifies the right agent to route to, creates the prompt file, and validates the workflow end-to-end."
user-invocable: true
---
<routing>Run this stable `/tsh-create-custom-prompt` command through the designated agent: `tsh-copilot-orchestrator`, using `tsh-creating-command-skills` for the replacement command/private skill authoring procedure.</routing>

Create a new Copilot command skill while preserving the stable `/tsh-create-custom-prompt` routing interface. Analyze existing command skills and agents, resolve requirements, create the skill, and validate it.

<required-skills>
- `tsh-creating-command-skills` - command/private workflow authoring and validation.
- `tsh-technical-context-discovering` - repository conventions.
- `tsh-codebase-analysing` - existing workflow and routing patterns.
</required-skills>

<workflow>
1. Research existing command skills and available agents.
2. Clarify purpose, inputs, designated agent, required skills, and output.
3. Create the inherited `tsh-*` command skill under `.github/skills/`.
4. Validate frontmatter, in-body routing, references, XML-like structure, and marker.
</workflow>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-create-custom-prompt:v1 -->
