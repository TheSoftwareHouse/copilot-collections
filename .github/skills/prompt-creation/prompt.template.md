---
# ============================================================
# REQUIRED FIELDS (by project convention)
# Every prompt must explicitly route to an agent and model.
# ============================================================
agent: "<agent-name>"
model: "<model-name>"
description: "<one-sentence description of what the prompt does>"

# ============================================================
# OPTIONAL FIELDS
# Uncomment and fill in only when needed for the workflow.
# ============================================================
# name: "<override-display-name>"
# argument-hint: "<hint text for chat input, e.g. [Jira ID or task description]>"
# tools: ['<tool-1>', '<tool-2>', '<mcp-server>/*']
---

<!-- ============================================================ -->
<!-- REQUIRED: Goal Statement                                      -->
<!-- 1-2 paragraphs describing what the prompt accomplishes and    -->
<!-- the expected outcome. Be specific about the workflow purpose. -->
<!-- This is NOT the agent's role — it's the task being triggered. -->
<!-- ============================================================ -->

<goal>
<what-this-prompt-does>
</goal>

<!-- ============================================================ -->
<!-- OPTIONAL: Prerequisites                                       -->
<!-- Uncomment if this prompt depends on another prompt or file    -->
<!-- being completed first.                                        -->
<!-- ============================================================ -->

<!--
<prerequisites>
> **PREREQUISITE**: Before using this prompt, you MUST first <describe dependency>.

- [dependency-prompt.prompt.md](./dependency-prompt.prompt.md) — <why it must run first>
- `*.research.md` or `*.plan.md` — <what context it provides>
</prerequisites>
-->

<!-- ============================================================ -->
<!-- OPTIONAL: Input Requirements                                  -->
<!-- Uncomment if the workflow needs specific inputs or context    -->
<!-- to start. Describe what the user must provide.                -->
<!-- ============================================================ -->

<!--
<input-requirements>
Before running this workflow, ensure you have:

1. **<input-1>** — <description of first required input>
2. **<input-2>** — <description of second required input>

If any input is missing: STOP and ask user to provide it.
</input-requirements>
-->

<!-- ============================================================ -->
<!-- REQUIRED: Required Skills                                     -->
<!-- List skills that the agent must load before starting.         -->
<!-- Reference existing skills from .github/skills/ only.          -->
<!-- Include a brief rationale for each skill.                     -->
<!-- ============================================================ -->

<required-skills>
## Required Skills

Before starting, load and follow these skills:
- `<skill-name-1>` - <why this skill is needed for the workflow>
- `<skill-name-2>` - <why this skill is needed for the workflow>
</required-skills>

<!-- ============================================================ -->
<!-- REQUIRED: Workflow                                             -->
<!-- Numbered steps defining the workflow sequence.                 -->
<!-- Each step should be clear and actionable.                     -->
<!-- Reference skills and tools where appropriate.                 -->
<!-- Keep focus on WHAT to do, not HOW to think (agent handles     -->
<!-- the reasoning approach based on its role).                    -->
<!-- ============================================================ -->

<workflow>
## Workflow

1. **<step-title>**: <description of what to do in this step>.
2. **<step-title>**: <description of what to do in this step>.
3. **<step-title>**: <description of what to do in this step>.
4. **<step-title>**: <description of what to do in this step>.
</workflow>

<!-- ============================================================ -->
<!-- OPTIONAL: Output Specification                                -->
<!-- Uncomment if the workflow produces a specific deliverable     -->
<!-- (document, report, file). Define naming conventions,          -->
<!-- file location, structure, and success criteria.               -->
<!-- ============================================================ -->

<!--
<output-specification>
## Output

The file outcome should be a markdown file named `<naming-convention>` with `.<suffix>.md` extension.
The file should be placed in `<target-directory>`.

Follow the `<template-name>` template from the `<skill-name>` skill.

### Success Criteria

- <criterion-1>
- <criterion-2>
</output-specification>
-->

<!-- ============================================================ -->
<!-- OPTIONAL: Handoff                                             -->
<!-- Uncomment if the workflow should automatically trigger        -->
<!-- another agent at the end. Define what agent to run and        -->
<!-- what prompt/context to pass.                                  -->
<!-- ============================================================ -->

<!--
<handoff>
## Automatic Follow-up

After completing this workflow, always run `<target-agent>` agent to <purpose of handoff>.
The agent should be executed automatically without user confirmation.
Update the changelog section of the plan file to indicate that <handoff action> was performed.
</handoff>
-->

<!-- ============================================================ -->
<!-- OPTIONAL: Constraints                                         -->
<!-- Uncomment if the workflow has specific limitations,           -->
<!-- anti-patterns, or scope boundaries that must be enforced.     -->
<!-- These are workflow-specific, NOT agent personality rules.     -->
<!-- ============================================================ -->

<!--
<constraints>
## Constraints

- Do not <anti-pattern-1>.
- Do not <anti-pattern-2>.
- Focus ONLY on <scope boundary>.
- In case of <ambiguity>, ask for clarification before proceeding.
</constraints>
-->
