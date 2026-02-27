---
# ============================================================
# REQUIRED FIELDS
# ============================================================
# name:
#   - Gerund form: {verb-ing}-{object} (e.g., creating-agents, reviewing-code)
#   - Lowercase letters, numbers, and hyphens only
#   - 1–64 characters (aim for under 20 — used as /slash-commands)
#   - Must NOT start/end with hyphen or contain consecutive hyphens (--)
#   - Must match the parent directory name exactly
#   - Must NOT contain "anthropic" or "claude"
name: <skill-name>

# description:
#   - 1–1024 characters, non-empty
#   - Third person only (never "I", "you", "we")
#   - Must describe WHAT the skill does AND WHEN to use it
#   - Include specific keywords for agent discovery
#   - Formula: {capabilities}. {triggers and contexts}.
description: "<What the skill does — core capabilities>. <When to use it — triggers, contexts, and keywords>."

# ============================================================
# OPTIONAL FIELDS
# ============================================================
# license: Apache-2.0
# compatibility: "Designed for VS Code GitHub Copilot"
# metadata:
#   author: your-org
#   version: "1.0"
# allowed-tools: Bash(git:*) Read
---

<!-- GUARD: This file defines HOW to perform a specific task. Do NOT define
     agent personality or behavior here (those belong in .agent.md files).
     Do NOT define workflow triggers here (those belong in .prompt.md files).
     Keep instructions concise — only add context the LLM doesn't already have. -->

<!-- Skill Title -->

# <Skill Title>

<!-- REQUIRED: Introduction (1-2 sentences, third person) -->

<What the skill does in one sentence — third person, no "you" or "I">.

<!-- OPTIONAL: Core Principles -->

<!--
<principles>

<principle-name>
Description of this principle and why it matters for this skill.
</principle-name>

<another-principle>
Description of another foundational rule.
</another-principle>

</principles>
-->

<!-- REQUIRED: Process / Workflow -->

## <Skill Process Name> Process

Use the checklist below and track your progress:

```
Progress:
- [ ] Step 1: <step title>
- [ ] Step 2: <step title>
- [ ] Step 3: <step title>
- [ ] Step 4: <step title>
```

**Step 1: <Step title>**

<Detailed instructions for this step. Be specific about what to do, what tools to use, and what to produce.>

**Step 2: <Step title>**

<Detailed instructions for this step.>

**Step 3: <Step title>**

<Detailed instructions for this step.>

**Step 4: <Step title>**

<Detailed instructions for this step.>

<!-- OPTIONAL: Reference Tables -->

<!--
## Quick Reference

| Rule | Description |
|------|-------------|
| <rule-1> | <description> |
| <rule-2> | <description> |
-->

<!-- OPTIONAL: Common Patterns / Examples -->

<!--
## Examples

**Example 1: <scenario>**

Input: <what the agent receives>
Output: <what the agent should produce>

**Example 2: <scenario>**

Input: <what the agent receives>
Output: <what the agent should produce>
-->

<!-- OPTIONAL: Validation Checklist -->

<!--
## Validation Checklist

```
Validation:
- [ ] <check-1>
- [ ] <check-2>
- [ ] <check-3>
```
-->

<!-- REQUIRED: Connected Skills -->

## Connected Skills

- `<skill-name-1>` - <when/why to use this related skill>
- `<skill-name-2>` - <when/why to use this related skill>
