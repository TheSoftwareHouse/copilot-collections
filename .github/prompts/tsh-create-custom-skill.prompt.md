---
agent: "tsh-copilot-orchestrator"
model: "Claude Opus 4.6"
description: "Create a new custom skill (SKILL.md) for VS Code Copilot. Analyzes existing skills for patterns, guides through design decisions, creates the skill file with supporting resources, and validates against best practices."
---

Create a new custom skill for VS Code Copilot. The orchestrator handles research of existing skills, design decisions, skill file creation with supporting resources, and review against best practices. The user's message following this prompt may contain specific skill requirements or a description of the desired skill.

## Required Skills

Before starting, load and follow these skills:
- `tsh-creating-skills` - for skill file creation workflow, naming conventions, progressive disclosure, and validation checklist
- `tsh-technical-context-discovering` - for discovering project conventions and workspace patterns before creating
- `tsh-codebase-analysing` - for analyzing existing skills for structural patterns and naming conventions

## Workflow

1. **Research existing skills**: Analyze skills in `.github/skills/` for patterns and conventions:
   - Naming conventions (gerund form: `creating-agents`, not `agent-creation`)
   - Folder structure and file organization (SKILL.md, templates, examples, references)
   - Progressive disclosure patterns and content structure
   - Frontmatter fields and description conventions
2. **Clarify requirements**: Determine the skill's design parameters with the user:
   - Domain, purpose, and trigger conditions
   - Target workflows and step-by-step processes
   - Supporting resources needed (templates, examples, references)
   - If the user's message already contains requirements, confirm understanding before proceeding
3. **Design the skill**: Make design decisions based on research findings and user input:
   - Skill name in gerund form (e.g., `creating-agents`, `analyzing-performance`)
   - Folder structure and supporting resource types
   - Progressive disclosure tiers (discovery, activation, resource)
   - How the skill fits within the existing skill ecosystem
4. **Create the skill files**: Create `SKILL.md` and any supporting files in `.github/skills/<skill-name>/` following established conventions. Apply the `tsh-creating-skills` skill workflow for structure and validation.
5. **Review and validate**: Review the created skill against best practices:
   - Verify gerund naming convention is followed
   - Confirm structural consistency with existing skills
   - Check supporting resources are complete and properly organized

Skill names MUST use gerund form (e.g., `creating-agents`, `analyzing-performance`, not `agent-creation`).

Skills may require supporting files beyond SKILL.md — templates, examples, and references directories. Ensure all are created.

If the user attaches files or provides a description, use them as input for skill design.

When in doubt about design decisions, ask the user for clarification rather than guessing.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-create-custom-skill:v1 -->
