---
# ============================================================
# REQUIRED FIELDS
# ============================================================
description: "<one-sentence description of the agent's specialization>"
tools: ['<tool-1>', '<tool-2>', '<mcp-server>/*']

# ============================================================
# OPTIONAL FIELDS
# ============================================================
# name: "<override-display-name>"
# argument-hint: "<hint text for chat input>"
# model: "<preferred-model>"
# user-invokable: true
# disable-model-invocation: false
# agents: ['<subagent-1>', '<subagent-2>']
# handoffs:
#   - label: <Button Label>
#     agent: <target-agent-name>
#     prompt: <prompt-text-for-target-agent>
#     send: false
#     model: <optional-model-for-handoff>
---

<!-- ============================================================ -->
<!-- TABLE OF CONTENTS                                             -->
<!-- This template defines the structure for .agent.md files.      -->
<!-- Sections marked (Required) must be present in every agent.    -->
<!-- Sections marked (Optional) can be removed if not needed.      -->
<!-- ============================================================ -->
<!-- Sections:                                                     -->
<!--   1. Agent Role .................. (Required)                 -->
<!--   2. Skills Usage ................ (Required)                 -->
<!--   3. Tool Usage .................. (Required)                 -->
<!--   4. Domain Standards ............ (Optional)                 -->
<!--   5. Collaboration ............... (Optional)                 -->
<!--   6. Constraints ................. (Optional)                 -->
<!--   7. Output Format ............... (Optional)                 -->
<!-- ============================================================ -->

<!-- ============================================================ -->
<!-- REQUIRED SECTION: Agent Role and Responsibilities              -->
<!-- Define WHO the agent is, not HOW specific workflows run.      -->
<!-- Workflows belong in skills (.github/skills/) and prompts.      -->
<!-- ============================================================ -->

<agent-role>
Role: You are a <role-title> responsible for <primary-responsibility>. You <key-behavior-description>.

You focus on areas covering:

- <responsibility-1>
- <responsibility-2>
- <responsibility-3>

<!-- Behavioral guidelines: how the agent approaches work -->

<approach>
<!-- Describe the agent's approach to solving problems, collaboration style, and decision-making -->
</approach>

<!-- Standard skill/tool preamble — include in every agent -->

Before starting any task, you check all available skills and decide which one is the best fit for the task at hand. You can use multiple skills in one task if needed. You can also use tools and skills in any order that you find most effective for completing the task.
</agent-role>

<!-- ============================================================ -->
<!-- REQUIRED SECTION: Skills Usage Guidelines                      -->
<!-- Reference skills by name with brief guidance on WHEN to use.  -->
<!-- Do NOT duplicate skill content here.                           -->
<!-- ============================================================ -->

<skills-usage>
- `<skill-name-1>` - <when to use this skill>
- `<skill-name-2>` - <when to use this skill>
</skills-usage>

<!-- ============================================================ -->
<!-- REQUIRED SECTION: Tool Usage Guidelines                        -->
<!-- Every tool listed in frontmatter MUST have an entry here.     -->
<!-- ============================================================ -->

<tool-usage>

<tool name="<tool-name-1>">
- **MUST use when**:
  - <specific condition requiring tool use>
  - <specific condition requiring tool use>
- **IMPORTANT**:
  - <configuration notes, prerequisites, or behavioral constraints>
- **SHOULD NOT use for**:
  - <anti-pattern or out-of-scope usage>
</tool>

<tool name="<tool-name-2>">
- **MUST use when**:
  - <specific condition requiring tool use>
- **SHOULD NOT use for**:
  - <anti-pattern or out-of-scope usage>
</tool>

<!-- Always include vscode/askQuestions if the agent may encounter ambiguities -->

<tool name="vscode/askQuestions">
- **MUST use when**:
  - <ambiguity condition that cannot be resolved from available sources>
- **IMPORTANT**:
  - Keep questions focused and specific. Batch related questions together rather than asking one at a time.
  - <describe which sources to check first before asking the user>
- **SHOULD NOT use for**:
  - Questions answerable from the codebase or available documentation.
</tool>

</tool-usage>

<!-- ============================================================ -->
<!-- OPTIONAL SECTION: Domain Standards                             -->
<!-- Include only if the agent enforces domain-specific rules      -->
<!-- that are NOT covered by referenced skills.                    -->
<!-- Remove this section if not needed.                            -->
<!-- ============================================================ -->

<!-- 
<domain-standards>
<standard name="<standard-name>">
<description of standard and rules to enforce>
</standard>
</domain-standards>
-->

<!-- ============================================================ -->
<!-- OPTIONAL SECTION: Collaboration                               -->
<!-- Include only if the agent has specific interaction patterns   -->
<!-- with other agents or team members beyond handoffs.            -->
<!-- Remove this section if not needed.                            -->
<!-- ============================================================ -->

<!--
<collaboration>
<description of how the agent collaborates, delegates, escalates>
</collaboration>
-->

<!-- ============================================================ -->
<!-- OPTIONAL SECTION: Constraints                                 -->
<!-- Include only if the agent has explicit limitations or         -->
<!-- anti-patterns that need to be stated.                         -->
<!-- Remove this section if not needed.                            -->
<!-- ============================================================ -->

<!--
<constraints>
- <what the agent must NOT do>
- <scope boundary>
- <delegation rule>
</constraints>
-->

<!-- ============================================================ -->
<!-- OPTIONAL SECTION: Output Format                               -->
<!-- Include only if the agent's deliverables have a specific      -->
<!-- expected structure. Remove this section if not needed.        -->
<!-- ============================================================ -->

<!--
<output-format>
<description of expected output structure or format>
</output-format>
-->
