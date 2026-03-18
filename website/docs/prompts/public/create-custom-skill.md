---
sidebar_position: 14
title: /tsh-create-custom-skill
---

# /tsh-create-custom-skill

**Agent:** Copilot Orchestrator  
**File:** `.github/prompts/tsh-create-custom-skill.prompt.md`

Creates a new custom skill (`SKILL.md`) for VS Code Copilot. Analyzes existing skills for patterns, enforces gerund naming convention, creates the skill file with supporting resources, and validates against best practices.

## Usage

```text
/tsh-create-custom-skill <skill requirements or description>
```

## What It Does

1. **Research existing skills** — Analyzes skills in `.github/skills/` for naming conventions (gerund form), folder structure, progressive disclosure patterns, and content structure.
2. **Clarify requirements** — Determines the skill's domain, purpose, trigger conditions, target workflows, and supporting resources needed.
3. **Design the skill** — Skill name in gerund form (e.g., `creating-agents`, `analyzing-performance`), folder structure, and supporting resource types.
4. **Create the skill** — Delegates creation to the artifact creator worker.
5. **Review and validate** — Delegates review to the artifact reviewer. Fixes issues if found.

## Skills Loaded

- `tsh-creating-skills` — Skill file creation workflow, naming conventions, progressive disclosure, and validation checklist.
- `tsh-technical-context-discovering` — Discover project conventions and workspace patterns.
- `tsh-codebase-analysing` — Analyze existing skills for structural patterns.

## Output

A skill directory with `SKILL.md` and supporting files in `.github/skills/`.

:::info Orchestrator Workflow
This command routes to the Copilot Orchestrator which handles the full research → create → review workflow automatically using specialized sub-agents.
:::
