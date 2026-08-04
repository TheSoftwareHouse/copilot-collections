---
name: tsh-engineer-prompt
description: "Design, optimize, audit, or review LLM application prompts for quality, security, and consistency."
user-invocable: false
---
<routing>Designated agent: `tsh-prompt-engineer`; private workflow skill: `tsh-engineer-prompt`.</routing>

Design, optimize, audit, or review runtime LLM application prompts, not Copilot customization artifacts.

<required-skills>`tsh-engineering-prompts`, `tsh-technical-context-discovering`</required-skills>
<workflow>Gather provider, model, use case, and prompt context; analyze clarity, output contracts, delimiters, injection defenses, and anti-patterns; apply the engineering skill; return Tech Stack, Prompt Template, Integration Example, Security Assessment, and Design Decisions.</workflow>
<constraints>Do not handle `.agent.md`, `SKILL.md`, command skills, or instruction files; route those to `tsh-copilot-engineer`.</constraints>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-engineer-prompt:v1 -->
