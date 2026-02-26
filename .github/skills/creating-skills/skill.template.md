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

<!-- ============================================================ -->
<!-- Skill Title                                                    -->
<!-- Use the skill name in natural language as an H1 heading.      -->
<!-- ============================================================ -->

# <Skill Title>

<!-- ============================================================ -->
<!-- REQUIRED: Introduction                                        -->
<!-- 1-2 sentences describing what the skill does.                 -->
<!-- Keep it concise — the description field handles discovery.    -->
<!-- This paragraph is for the agent after it has already          -->
<!-- decided to load the skill.                                    -->
<!-- ============================================================ -->

This skill helps you <what the skill does in one sentence>.

<!-- ============================================================ -->
<!-- OPTIONAL: Core Principles                                     -->
<!-- Use XML tags for principles when the skill has foundational   -->
<!-- rules that constrain all decisions. These are the "always     -->
<!-- true" rules the agent must internalize before starting.       -->
<!--                                                               -->
<!-- Omit this section if the skill is purely procedural.          -->
<!-- ============================================================ -->

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

<!-- ============================================================ -->
<!-- REQUIRED: Process / Workflow                                   -->
<!-- The core of the skill. Break the task into sequential steps.  -->
<!-- Include a trackable checklist at the top.                     -->
<!--                                                               -->
<!-- Guidelines:                                                   -->
<!-- - Each step should be clear and actionable                    -->
<!-- - Include decision points if the workflow branches            -->
<!-- - Reference supporting files where appropriate                -->
<!-- - Include validation/feedback loops for quality-critical work -->
<!-- ============================================================ -->

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

<!-- ============================================================ -->
<!-- OPTIONAL: Reference Tables                                    -->
<!-- Quick-reference tables for rules, patterns, conventions,      -->
<!-- or decision matrices that the agent may need during           -->
<!-- execution. Keep them concise.                                 -->
<!-- ============================================================ -->

<!--
## Quick Reference

| Rule | Description |
|------|-------------|
| <rule-1> | <description> |
| <rule-2> | <description> |
-->

<!-- ============================================================ -->
<!-- OPTIONAL: Common Patterns / Examples                          -->
<!-- Include input/output examples if the skill's output quality   -->
<!-- depends on understanding expected format or style.            -->
<!-- Use examples instead of lengthy explanations.                 -->
<!-- ============================================================ -->

<!--
## Examples

**Example 1: <scenario>**

Input: <what the agent receives>
Output: <what the agent should produce>

**Example 2: <scenario>**

Input: <what the agent receives>
Output: <what the agent should produce>
-->

<!-- ============================================================ -->
<!-- OPTIONAL: Validation Checklist                                -->
<!-- Include when the skill produces a deliverable that should     -->
<!-- be verified before completion. Agent uses this as a           -->
<!-- self-check before finishing.                                  -->
<!-- ============================================================ -->

<!--
## Validation Checklist

```
Validation:
- [ ] <check-1>
- [ ] <check-2>
- [ ] <check-3>
```
-->

<!-- ============================================================ -->
<!-- REQUIRED: Connected Skills                                    -->
<!-- List related skills with brief rationale for each.            -->
<!-- This helps the agent understand the skill ecosystem           -->
<!-- and when to chain skills together.                            -->
<!--                                                               -->
<!-- Use the format: `skill-name` - when/why to use it             -->
<!-- Remove this comment block in your final file.                 -->
<!-- ============================================================ -->

## Connected Skills

- `<skill-name-1>` - <when/why to use this related skill>
- `<skill-name-2>` - <when/why to use this related skill>
