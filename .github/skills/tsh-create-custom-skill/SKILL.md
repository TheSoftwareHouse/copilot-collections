---
name: tsh-create-custom-skill
description: "Create a new custom skill (SKILL.md) for VS Code Copilot. Analyzes existing skills for patterns, guides through design decisions, creates the skill file with supporting resources, and validates against best practices."
user-invocable: true
---
<routing>Run this workflow through the designated agent: `tsh-copilot-orchestrator`.</routing>

Create a reusable skill by researching existing skills, defining purpose and triggers, selecting progressive-disclosure resources, and validating the result.

<required-skills>
- `tsh-creating-skills` - skill structure, naming, and validation.
- `tsh-technical-context-discovering` - project conventions.
- `tsh-codebase-analysing` - existing skill patterns.
</required-skills>

<workflow>
1. Analyze existing skill names, structures, templates, examples, and references.
2. Clarify domain, purpose, activation triggers, outputs, and supporting resources.
3. Create a gerund-named reusable skill under `.github/skills/`.
4. Validate frontmatter, body size, process checklist, connected skills, and references.
</workflow>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-create-custom-skill:v1 -->
