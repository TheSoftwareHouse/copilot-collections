---
name: tsh-creating-command-skills
description: "Create public command skills and private workflow skills for GitHub Copilot. Provides templates, routing guidance, invocation rules, and validation for inherited imperative skill IDs. Use when creating, reviewing, or updating command or private workflow skills."
user-invocable: false
---

# Creating Command Skills

Creates workflow-oriented skills that replace the retired Copilot prompt artifact model while preserving stable `tsh-*` command IDs and designated-agent routing.

<principles>
<separation-of-concerns>
- **Agents** define WHO: behavior, personality, responsibilities, and tool access.
- **Skills** define HOW: workflow steps, procedures, templates, and domain guidance.
- **Instructions** define RULES: project-wide or scoped constraints.

A command skill must not redefine its former agent's personality. A private workflow skill must not become a public slash command.
</separation-of-concerns>

<invocation-boundaries>
Public command skills use `user-invocable: true` and retain the inherited imperative `tsh-*` ID as their stable slash-command interface. Private workflow skills use `user-invocable: false`; they remain available for designated agents and model loading without being exposed as user-invocable commands. Do not add `disable-model-invocation` unless a separate specification requires it.
</invocation-boundaries>
</principles>

## Creation Process

Use the checklist below:

```
Progress:
- [ ] Confirm the inherited workflow ID and visibility
- [ ] Identify the designated former prompt agent
- [ ] Preserve the source workflow body and relevant skill references
- [ ] Convert supported metadata and add routing directives
- [ ] Add the exact skill marker and validate references
```

### 1. Choose the stable ID and visibility

Use the exact inherited `tsh-*` workflow ID. Public command skills set `user-invocable: true`; private procedure skills set `user-invocable: false`. General reusable skills continue to use the gerund naming convention and are not renamed to imperative command IDs.

### 2. Set skill frontmatter

Required fields are `name`, `description`, and `user-invocable`. The `name` must exactly match both the skill directory and the inherited ID. Copy `argument-hint` verbatim only when the migration specification identifies it as supported. Do not copy prompt-only `agent`, `model`, or `tools` fields into skill frontmatter.

### 3. Preserve routing and workflow intent

Copy the former workflow body and its relevant skill references. For every public migrated command, add a clear in-body directive such as:

`<routing>Run this workflow through the designated agent: [agent-id].</routing>`

Use the exact former `agent` value. Private workflows should name their designated agent and private skill in prose when a handoff is required. Replace links to retired prompt files with named skills or agents.

Stable routing exception: `tsh-create-custom-prompt` remains the `/tsh-create-custom-prompt` command-skill ID, and its authoring procedure routes to `tsh-creating-command-skills`.

### 4. Validate the result

Check that YAML frontmatter parses, the body retains XML-like structure where the source used it, every referenced skill or agent exists, the visibility is correct, and the final marker is exactly:

`<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-<name>:v<n> -->`

Preserve the source marker version number. Do not add prompt markers or leave `.prompt.md` runtime links in migrated skills.

## Quick Reference

| Skill type | `user-invocable` | Naming | Routing |
|---|---:|---|---|
| Public command skill | `true` | inherited imperative `tsh-*` ID | in-body former-agent directive |
| Private workflow skill | `false` | inherited imperative `tsh-*` ID | named agent/private skill prose |
| General reusable skill | existing value | gerund `tsh-*` name | reusable procedure reference |

## Connected Skills

- `tsh-creating-agents` - to keep agent behavior separate from command procedures.
- `tsh-creating-skills` - for reusable skill structure, progressive disclosure, and validation.
- `tsh-creating-instructions` - for repository and scoped rules rather than workflow steps.
- `tsh-technical-context-discovering` - to inspect existing artifact patterns before authoring.
