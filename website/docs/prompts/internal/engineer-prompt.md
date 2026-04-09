---
sidebar_position: 11
title: /tsh-engineer-prompt
---

# /tsh-engineer-prompt

:::info
Not invoked directly by users. To trigger prompt engineering, use [`/tsh-implement`](../public/implement) — the [Engineering Manager](../../agents/engineering-manager) will automatically delegate to the [Prompt Engineer](../../agents/prompt-engineer).
:::

**Agent:** Prompt Engineer  
**File:** `.github/internal-prompts/tsh-engineer-prompt.prompt.md`

Designs, optimizes, audits, or reviews LLM application prompts for quality, security, and consistency.

## How It's Triggered

```text
/tsh-implement <JIRA_ID or task description>
```

The Engineering Manager identifies LLM prompt tasks in the plan and delegates them to the Prompt Engineer automatically.

## What It Does

### 1. Context Gathering

- Reads the provided prompt(s) or requirements.
- Identifies the LLM provider, model, and use case.
- Discovers existing prompt patterns and conventions in the project via `tsh-technical-context-discovering`.

### 2. Analysis

- Identifies issues — vague instructions, missing output format, injection vulnerabilities, no delimiter separation.
- Checks against anti-patterns from the `tsh-engineering-prompts` skill.

### 3. Optimization or Creation

- Applies prompt structure patterns from `tsh-engineering-prompts`.
- Adds constraints, output format specification, and security layers.
- Uses delimiter separation between system instructions and user input.

### 4. Security Check

- Verifies prompt injection defenses — delimiter separation, input sanitization guidance, output validation.
- Flags any missing security layers.

## Skills Loaded

- `tsh-engineering-prompts` — Prompt structure patterns, optimization techniques, security patterns, templates, evaluation approaches, and anti-patterns.
- `tsh-technical-context-discovering` — Project conventions and existing prompt patterns.

## Output

Each deliverable includes (sections omitted when not applicable):

1. **Tech Stack** — LLM provider, model, temperature, relevant framework.
2. **Prompt Template** — Complete prompt with system prompt, context/input sections, and output format specification.
3. **Integration Example** — Non-production example showing how to use the prompt (LangChain, OpenAI SDK, Anthropic SDK, etc.). Focuses on integration guidance — full application logic is left to the Software Engineer.
4. **Security Assessment** — For audits: vulnerability table with severity, CWE, location, impact, and fix. For creation/optimization: summary of security measures applied (three-layer defense).
