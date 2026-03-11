---
sidebar_position: 35
title: LLM Evaluation
---

# LLM Evaluation

**Folder:** `.github/skills/tsh-evaluating-llm-outputs/`  
**Used by:** Software Engineer, Architect, Code Reviewer

Processes for evaluating, testing, tracing, and safeguarding LLM-powered applications. Focuses on what to measure and why — not which tool to use.

## Process

### Step 1: Define Evaluation Metrics

Choose metrics based on application type: RAG metrics (faithfulness, answer relevancy, context precision, context recall), agent metrics (task completion, tool call accuracy), and generation metrics (coherence, fluency, harmfulness).

### Step 2: Create Evaluation Datasets

Build representative datasets through manual curation, synthetic generation, or production sampling. Maintain a golden dataset of 50–200 curated examples.

### Step 3: Set Up Tracing / Observability

Instrument LLM pipelines with structured span logging — track inputs/outputs, token counts, latency, retrieval results, tool calls, and error rates.

### Step 4: Implement Automated Evaluation

CI-integrated evaluation suites with threshold-based pass/fail gates. Metric regression alerts on prompt or pipeline changes.

### Step 5: Add Guardrails

Typed output enforcement, content filtering, hallucination detection, citation verification, and PII detection. Non-negotiable for production systems.

### Step 6: Establish Regression Testing

Prompt versioning, versioned test suites, A/B comparison, and automated regression alerts.

## Testing Strategy by Layer

| Layer | Test Type | Approach |
|---|---|---|
| Tool functions | Unit tests | Standard test framework, standard mocks |
| Data validation models | Unit tests | Valid/invalid inputs, edge cases |
| Prompt templates | Snapshot tests | Verify template renders correctly |
| LLM integration | Integration tests | Mocked LLM responses, recorded cassettes |
| Retrieval quality | Offline evaluation | RAG-specific metrics on golden dataset |
| Agent orchestration | Integration tests | Scripted scenarios, verify state transitions |
| End-to-end pipeline | Regression suite | Evaluation framework with CI integration |

## Technology Approach

Evaluation concepts (metrics, testing layers, guardrail patterns) are durable. Specific evaluation and observability tools appear as illustrative examples with `context7` verification directives.

## Connected Skills

- `tsh-implementing-rag-pipelines` — RAG-specific evaluation metrics, retrieval quality testing
- `tsh-designing-agentic-workflows` — agent-specific evaluation, tool call verification, state testing
- `tsh-python-project-standards` — testing framework setup, type safety patterns for evaluation code
