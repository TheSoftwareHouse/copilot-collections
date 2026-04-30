---
sidebar_position: 32
title: Prompt Engineering
---

# Prompt Engineering

**Folder:** `.github/skills/tsh-engineering-prompts/`  
**Used by:** Prompt Engineer, Software Engineer, Architect, Code Reviewer

Technology-agnostic patterns for designing, optimizing, and securing LLM application prompts. Covers system prompts, user prompt templates, RAG templates, agent instructions, and classification/extraction prompts. NOT for Copilot customization — use `tsh-creating-prompts` for that.

## Prompt Structure Patterns

Reliable prompt structure separates concerns into distinct sections: system prompt (persona + rules), context (retrieved docs, session state), user input (the variable part), and output format (expected response shape). Patterns include role-based structure, few-shot prompting, chain-of-thought reasoning, and delimiter separation.

## Optimization Techniques

| Technique | Purpose |
|---|---|
| **Clarity and specificity** | Replace vague instructions with exact behavior, constraints, and output format |
| **Constraint specification** | Explicit MUST / MUST NOT rules for model behavior |
| **Output format control** | JSON schemas, structured output modes, explicit format instructions |
| **Token efficiency** | Remove filler, use tables over paragraphs, cache static content in system prompts |
| **Negative prompting** | Tell the model what NOT to do for better compliance |
| **Temperature guidance** | Match temperature to task type (0.0–0.2 for extraction, 0.7–1.0 for creative) |

## Security Patterns

Three-layer defense against prompt injection:

1. **Delimiter separation** — Always separate user input from instructions with clear delimiters.
2. **Input sanitization** — Strip delimiter characters, truncate, flag instruction-like patterns.
3. **Output validation** — Parse into typed models, validate schemas, reject unexpected content.

Also covers jailbreak resistance, secrets management (never hardcode in templates), and PII handling.

## Prompt Templates

Reusable templates for common patterns:

- **RAG** — Context injection with grounding instructions and citation requirements
- **Agent tool-calling** — Tool definitions with usage rules and error handling
- **Classification / Extraction** — Category selection with confidence scoring
- **Summarization** — Length-controlled summaries with preservation rules
- **Evaluation / Scoring** — Multi-criteria scoring with justification

## Evaluation Approaches

- **A/B testing** — Fix one variable, use the same test set, measure objectively
- **Metric-based comparison** — Format compliance, factual accuracy, consistency, token efficiency, hallucination rate
- **Edge case testing** — Empty input, long input, injection attempts, unexpected language, special characters
- **Version control** — Store prompts as named versioned constants, tag versions, log which version generated each response

## Anti-Patterns

| Anti-Pattern | Instead Do |
|---|---|
| Vague instructions ("be helpful") | Specify exact behavior and output format |
| User input in system prompt | Separate with delimiters in dedicated section |
| No output format specification | Define explicit schema or structure |
| Prompt-only validation | Parse into typed models, validate schemas |
| Hardcoded secrets in templates | Use environment variables or secret managers |
| Testing only happy paths | Include adversarial, empty, long, and multilingual inputs |

## Connected Skills

- `tsh-creating-prompts` — For Copilot `.prompt.md` files (different domain, complementary).
- `tsh-code-reviewing` — For reviewing prompt code quality alongside application code.
- `tsh-architecture-designing` — For prompt strategy decisions as part of system architecture.
