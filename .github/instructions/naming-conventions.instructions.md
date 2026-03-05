---
name: copilot-collections
description: 'Naming conventions for Copilot customization artifacts in the copilot-collections repository. Ensures all prompts, agents, skills, and hooks use the tsh- prefix.'
applyTo: '.github/**'
---

# Naming Conventions

## `tsh-` prefix required on all artifact filenames

Every Copilot customization artifact in this repository must use the `tsh-` prefix:

- **Prompts:** `tsh-<action>.prompt.md` — e.g., `tsh-implement.prompt.md`, `tsh-review.prompt.md`
- **Agents:** `tsh-<role>.agent.md` — e.g., `tsh-software-engineer.agent.md`, `tsh-architect.agent.md` (applies to both user-facing and internal worker agents)
- **Skill directories:** `tsh-<gerund-subject>/` — e.g., `tsh-code-reviewing/`, `tsh-creating-prompts/`
- **Hooks:** `tsh-<action>.hooks.md` — e.g., `tsh-pre-commit.hooks.md`

## Why the prefix exists

These artifacts are designed to be installed into other projects (via setting path in VS Code settings or just copying). The `tsh-` prefix identifies them as originating from The Software House's copilot-collections repository and prevents naming collisions with project-specific customizations.

## Frontmatter `name` fields must match the prefixed name

Skills use a `name` field in SKILL.md frontmatter — it must include the `tsh-` prefix and match the directory name. For example, skill directory `tsh-code-reviewing/` must have `name: tsh-code-reviewing` in its SKILL.md frontmatter.

Prompts and agents do not use a `name` frontmatter field — the filename is their sole identifier.

## Cross-references must use prefixed names

When one artifact references another (e.g., a prompt's `agent:` field), use the prefixed name:

- Correct: `agent: "tsh-architect"`
- Avoid: `agent: "architect"`
