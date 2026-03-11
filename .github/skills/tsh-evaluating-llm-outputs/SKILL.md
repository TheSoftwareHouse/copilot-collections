---
name: tsh-evaluating-llm-outputs
description: LLM evaluation patterns — metric-based evaluation, test dataset management, tracing/observability, automated evaluation, guardrails, and regression testing. Technology-agnostic process for evaluating, testing, and safeguarding LLM-powered applications. Use when setting up evaluation pipelines, implementing guardrails, or establishing LLM testing strategies.
---

# Evaluating LLM Outputs

Processes for evaluating, testing, tracing, and safeguarding LLM-powered applications. Focuses on what to measure and why — not which tool to use.

<principles>

<measure-before-optimizing>
Establish baseline metrics before making changes. Without quantified baselines, you cannot prove an optimization improved anything. Define metrics first, measure, then iterate. Gut feelings about LLM quality are unreliable — numbers are not.
</measure-before-optimizing>

<test-each-layer-independently>
Evaluate retrieval quality separately from generation quality. Test tool functions separately from agent orchestration. Isolating layers reveals where the actual problem lives. End-to-end tests alone hide root causes behind compound failures.
</test-each-layer-independently>

<automate-regression>
Every prompt change, model swap, or pipeline modification MUST be validated against the existing evaluation suite before deployment. Manual spot-checking is not evaluation. Automate evaluation in CI and set threshold-based gates.
</automate-regression>

</principles>

## Evaluation Process

Use the checklist below and track progress:

```
Progress:
- [ ] Step 1: Define evaluation metrics
- [ ] Step 2: Create evaluation datasets
- [ ] Step 3: Set up tracing / observability
- [ ] Step 4: Implement automated evaluation
- [ ] Step 5: Add guardrails
- [ ] Step 6: Establish regression testing
```

**Step 1: Define evaluation metrics**

Choose metrics based on the application type:

**RAG applications**:
| Metric | What It Measures |
|---|---|
| Faithfulness | Is the answer grounded in retrieved context (not hallucinated)? |
| Answer relevancy | Does the answer address the user's query? |
| Context precision | Are the retrieved chunks relevant to the query? |
| Context recall | Were all relevant chunks retrieved? |

**Agent applications**:
| Metric | What It Measures |
|---|---|
| Task completion rate | Does the agent complete the assigned task? |
| Tool call accuracy | Does the agent call the right tools with correct arguments? |
| State transition correctness | Does the agent follow the expected workflow path? |
| Recovery rate | Does the agent recover from errors gracefully? |

**Generation applications**:
| Metric | What It Measures |
|---|---|
| Coherence | Is the output logically structured and readable? |
| Fluency | Is the language natural and grammatically correct? |
| Harmfulness | Does the output contain harmful, biased, or inappropriate content? |
| Custom rubrics | Application-specific quality criteria defined by the team |

These metric categories are durable concepts. Specific scoring implementations vary by evaluation library — use `context7` to fetch current evaluation framework docs when implementing.

**Step 2: Create evaluation datasets**

Build representative datasets for offline evaluation:

- **Manual curation**: Domain experts create question–answer–source triples. Highest quality, lowest scale.
- **Synthetic generation**: Use LLMs to generate test cases from existing documents. High scale, requires quality filtering.
- **Production sampling**: Sample real user queries and annotate correct answers. Most representative, requires annotation workflow.

Dataset management:
- Version evaluation datasets alongside code — changes to tests should be tracked.
- Maintain a "golden dataset" of ~50–200 curated examples that represent core use cases.
- Include edge cases: ambiguous queries, out-of-scope questions, multilingual inputs (if applicable).
- Separate datasets by metric type — retrieval datasets need source annotations, generation datasets need reference answers.

**Step 3: Set up tracing / observability**

Instrument the LLM pipeline for observability:

What to trace:
| Data Point | Why |
|---|---|
| Input/output per LLM call | Debug quality issues, track prompt changes |
| Token counts (input + output) | Cost tracking, budget management |
| Latency per call and per pipeline | Performance monitoring, SLA compliance |
| Retrieval results + scores | Debug retrieval quality independently |
| Tool calls + arguments | Debug agent behavior, verify correct tool usage |
| Error rates and types | Reliability monitoring, incident detection |

Implementation principles:
- Structure traces as spans with parent-child relationships — a pipeline span contains retrieval, generation, and tool call child spans.
- Log traces to a structured store, not just console output.
- Include cost estimates per trace — aggregate for budget monitoring.
- Correlate traces with user sessions for debugging specific interactions.

*Landscape snapshot: LLM observability platforms exist for both self-hosted and managed deployments. Verify current tools via `context7` before selecting.*

**Step 4: Implement automated evaluation**

Integrate evaluation into the development and CI workflow:

- Run evaluation suites automatically on prompt changes, model swaps, or pipeline modifications.
- Set threshold-based pass/fail gates — e.g., faithfulness > 0.85, context precision > 0.80.
- Generate evaluation reports with per-metric scores and comparison to baseline.
- Alert on metric regressions — a prompt change that drops faithfulness by 5% should block deployment.

CI integration pattern:
1. Developer changes prompt/pipeline code.
2. CI triggers evaluation suite against the golden dataset.
3. Metrics are compared to the baseline (last passing run).
4. If any metric drops below threshold → fail the build with a detailed report.
5. If all metrics pass → update baseline, proceed with deployment.

*Landscape snapshot: Evaluation frameworks exist for RAG-specific and general-purpose evaluation. Verify current tools via `context7` before selecting.*

**Step 5: Add guardrails**

Implement safety layers for LLM outputs:

- **Typed output enforcement**: Every LLM response that drives downstream logic MUST be parsed into a typed model. Never act on raw text. Use structured output APIs or extraction patterns.
  - *(e.g., Instructor, framework-native structured output — verify current tools via `context7`)*
- **Content filtering**: Detect and block harmful, biased, or inappropriate outputs before they reach the user.
- **Hallucination detection**: Cross-reference generated claims against retrieved sources. Flag unsupported assertions.
- **Citation verification**: If the output claims a source, verify the source was in the retrieved context.
- **PII detection**: Scan outputs for personally identifiable information before returning to the user or logging.

Guardrails are non-negotiable for production systems. They are safety engineering, not optional quality improvements.

**Step 6: Establish regression testing**

Prevent quality regressions across changes:

- **Prompt versioning**: Track all prompt changes with version numbers. Every version has an associated evaluation run.
- **Versioned test suites**: As the application evolves, evaluation datasets evolve with it. Old test cases are retained unless explicitly deprecated.
- **A/B comparison**: When testing a new prompt or model, run both old and new versions against the same dataset and compare metrics side by side.
- **Regression alerts**: Automated alerts when any evaluation metric drops below historical baseline.

## Testing Strategy by Layer

| Layer | Test Type | Approach |
|---|---|---|
| Tool functions | Unit tests | Standard test framework, standard mocks |
| Data validation models | Unit tests | Valid/invalid inputs, edge cases |
| Prompt templates | Snapshot tests | Verify template renders correctly with test data |
| LLM integration | Integration tests | Mocked LLM responses, recorded response cassettes |
| Retrieval quality | Offline evaluation | RAG-specific metrics on golden dataset |
| Agent orchestration | Integration tests | Scripted scenarios, verify state transitions |
| End-to-end pipeline | Regression suite | Evaluation framework with CI integration |
| Prompt changes | A/B comparison | Observability platform with experiment tracking |

## Anti-Patterns

| Anti-Pattern | Why It Fails | Instead Do |
|---|---|---|
| No evaluation metrics defined | Can't measure quality or detect regressions | Define metrics before building |
| Manual spot-checking only | Not reproducible, misses edge cases | Automated eval suite in CI |
| End-to-end tests only | Hides which layer is failing | Test each layer independently |
| No tracing / observability | Blind to cost, latency, quality issues | Structured span logging from day one |
| Raw text parsing of LLM output | Breaks on format changes, silent failures | Typed output enforcement |
| No guardrails in production | Safety, compliance, and reputation risk | Content filtering + PII detection + output validation |

## Connected Skills

- `tsh-implementing-rag-pipelines` — RAG-specific evaluation metrics, retrieval quality testing
- `tsh-designing-agentic-workflows` — agent-specific evaluation, tool call verification, state testing
- `tsh-python-project-standards` — testing framework setup, type safety patterns for evaluation code
