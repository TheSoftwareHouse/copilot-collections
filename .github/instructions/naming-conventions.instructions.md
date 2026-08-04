---
name: copilot-collections
description: 'Naming conventions for Copilot customization artifacts in the copilot-collections repository. Ensures all non-exempt prompts, agents, skills, and hooks use the tsh- prefix.'
applyTo: '.github/**'
---

# Naming Conventions

## `tsh-` prefix required on all non-exempt artifact filenames

Every non-exempt Copilot customization artifact in this repository must use the `tsh-` prefix:

- **Prompts:** `tsh-<action>.prompt.md` — e.g., `tsh-implement.prompt.md`, `tsh-review.prompt.md`
- **Agents:** `tsh-<role>.agent.md` — e.g., `tsh-software-engineer.agent.md`, `tsh-architect.agent.md` (applies to both user-facing and internal worker agents)
- **Skill directories:** `tsh-<gerund-subject>/` — e.g., `tsh-code-reviewing/`, `tsh-creating-prompts/`
- **Hooks:** `tsh-<action>.hooks.md` — e.g., `tsh-pre-commit.hooks.md`

## Why the prefix exists

These artifacts are designed to be installed into other projects (via setting path in VS Code settings or just copying). The `tsh-` prefix identifies them as originating from The Software House's copilot-collections repository and prevents naming collisions with project-specific customizations.

## Non-exempt skill directories and frontmatter `name` fields must match the prefixed name

All non-exempt skill directories use the `tsh-` prefix, and their `name` field in SKILL.md frontmatter must include the `tsh-` prefix and match the directory name. For example, skill directory `tsh-code-reviewing/` must have `name: tsh-code-reviewing` in its SKILL.md frontmatter.

Prompts and agents do not use a `name` frontmatter field — the filename is their sole identifier.

## Cross-references for non-exempt artifacts must use prefixed names

When one non-exempt artifact references another (e.g., a prompt's `agent:` field), use the prefixed name:

- Correct: `agent: "tsh-architect"`
- Avoid: `agent: "architect"`

## Narrow external-tool wrapper exception

The only exception to the `tsh-` naming requirement is the externally named tool-wrapper skill `playwright-cli`. Its upstream-compatible directory and `SKILL.md` frontmatter name must remain `playwright-cli`; this exception does not apply to any other artifact.

References to this wrapper may therefore use its unchanged unprefixed `playwright-cli` identity; references to every other artifact must use its `tsh-`-prefixed name.
