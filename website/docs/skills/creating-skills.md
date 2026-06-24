---
sidebar_position: 17
title: Creating Skills
---

# Creating Skills

**Folder:** `.github/skills/tsh-creating-skills/`
**Used by:** Copilot Engineer

Provides naming conventions (gerund form), description guidelines, body structure, progressive disclosure patterns, templates, and validation checklists for creating new skills (`SKILL.md`).

## Core Design Principles

- **Conciseness** — The context window is a shared resource. Only add context the LLM doesn't already have.
- **Progressive disclosure** — Discovery tier (~100 tokens): name + description. Activation tier (&lt;5000 tokens): full SKILL.md body. Resource tier (on demand): templates, examples.
- **Separation of concerns** — A skill defines HOW to perform a task. It must NOT define WHO the agent is (agent territory) or WHAT triggers the workflow (prompt territory).

## Naming Conventions

- Skill directories use gerund form: `tsh-<gerund-subject>/` (e.g., `tsh-code-reviewing/`, `tsh-creating-prompts/`)
- The `name` field in SKILL.md frontmatter must match the directory name
- The `tsh-` prefix identifies artifacts from The Software House's copilot-collections

## Skill Folder Structure

```
tsh-<gerund-subject>/
├── SKILL.md            # Main skill file (required)
├── <name>.example.md   # Example output (optional)
└── <name>.template.md  # Output template (optional)
```

## Validation Checklist

- Directory name uses gerund form with `tsh-` prefix
- `name` field in frontmatter matches directory name
- Description is concise (1–2 sentences)
- Body stays under 5000 tokens
- No personality or behavioral content (agent territory)
- No project-specific conventions (instructions territory)

## Connected Skills

- `tsh-creating-agents` — For creating agents that load this skill.
- `tsh-creating-prompts` — For creating prompts that trigger workflows using this skill.
- `tsh-creating-router-skills` — For creating router-style skills when a domain grows too large for a single-skill body.
