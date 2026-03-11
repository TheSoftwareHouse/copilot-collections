---
name: tsh-designing-agentic-workflows
description: Agentic workflow patterns — architecture selection, tool calling, state management, memory, framework selection criteria, guardrails, and error handling. Technology-agnostic knowledge base for designing and implementing LLM agent systems. Use when building agents, selecting architecture patterns, or designing multi-agent systems.
---

# Designing Agentic Workflows

Pattern-level knowledge base for agentic system design and implementation. Teaches architecture patterns, state management, memory, and safety — not framework-specific APIs.

<principles>

<simplest-pattern-first>
Start with the simplest architecture that solves the problem. A single agent with tools handles most tasks. Only escalate to supervisor, hierarchical, or collaborative patterns when the task genuinely requires it. Over-engineering agent hierarchies for simple tasks creates unnecessary complexity, latency, and failure modes.
</simplest-pattern-first>

<typed-interfaces-everywhere>
Every boundary — tool schemas, agent inputs, agent outputs, state transitions — MUST use typed interfaces. Untyped tool schemas produce unpredictable LLM behavior. Untyped state produces silent corruption. Define the contract, validate it, enforce it.
</typed-interfaces-everywhere>

<human-in-the-loop-by-default>
Critical decisions, destructive actions, and high-cost operations MUST require human approval. Design the approval checkpoint first, then make it skippable — not the other way around. Agents are assistants, not autonomous decision-makers for consequential actions.
</human-in-the-loop-by-default>

</principles>

## Section 1: Architecture Patterns *(STABLE — pattern knowledge)*

Select the simplest pattern that meets the requirements:

| Pattern | Description | When to Use |
|---|---|---|
| Single agent + tools | One LLM with access to typed tool functions | Simple tasks, few tools, linear flow |
| Router / dispatcher | Routes to specialized sub-agents by task type | Clear task categories, no inter-agent dependency |
| Supervisor | One manager agent delegates to specialized workers | Multiple specialists, clear routing logic |
| Hierarchical | Nested supervisors with domain-specific teams | Complex domains, multi-level delegation |
| Collaborative / swarm | Peer agents with shared state, negotiation | Research tasks, creative exploration |

**Architecture Decision Matrix**:

| Factor | Single Agent | Router | Supervisor | Hierarchical |
|---|---|---|---|---|
| Complexity | Low | Low–Medium | Medium | High |
| Latency | Low (1 LLM call per step) | Medium | Medium–High | High |
| Debugging | Easy | Easy | Moderate | Difficult |
| Team size | 1 developer | 1–2 developers | 2–3 developers | 3+ developers |
| Tool count | 1–10 | Varies by route | 5–15 per worker | 5–15 per team |
| Best for | Most tasks | Task classification | Complex workflows | Enterprise domains |

Implementation principles:
- Start with a single agent + tools. Move to supervisor only when you need multiple specialized agents that share state.
- Each agent should have a clear, bounded responsibility — like a microservice, not a monolith.
- Define explicit handoff protocols — which agent calls which, what data is passed, what happens on failure.

## Section 2: Tool/Function Calling *(STABLE — interface design principles)*

Design typed tool interfaces for every tool the agent can call:

- Define input and output schemas using typed data validation models (the same models used for LLM interfaces — see `tsh-python-project-standards`).
- Include clear descriptions in tool schemas — the LLM reads these to decide when and how to call the tool.
- Validate inputs before execution and outputs before returning to the agent.
- Handle tool errors gracefully — return structured error objects, not raw exceptions.

```python
# Pattern: typed tool interface (framework-agnostic)
class SearchInput(TypedModel):
    query: str
    max_results: int = 5
    filters: dict[str, str] | None = None

class SearchResult(TypedModel):
    title: str
    url: str
    snippet: str
    relevance_score: float

# Tool function with typed I/O
async def search_documents(input: SearchInput) -> list[SearchResult]:
    # Implementation validates input via type system
    # Returns typed output — no raw dicts
    ...
```

Execution strategies:
- **Sequential**: Default — tools execute one at a time. Simpler, easier to debug.
- **Parallel**: Use when tools are independent and latency matters. Requires careful error handling — one failure shouldn't block all others.

## Section 3: State Management *(STABLE — concepts; VOLATILE — framework APIs)*

Patterns for managing agent state across steps:

| Pattern | When to Use | Key Benefit |
|---|---|---|
| In-memory state object | Simple agents, short conversations | No infrastructure needed |
| Graph-based state machine | Complex branching, conditional flows | Visual debugging, checkpointing |
| Persistent state store | Long-running workflows, resumability | Survives restarts |
| Event-sourced state | Audit requirements, replay capability | Full history |

Implementation principles:
- Define state as a typed model — never use raw dictionaries for workflow state.
- Implement checkpointing for any workflow that takes more than a few seconds — users need to resume, not restart.
- Separate agent state (conversation history, current step) from domain state (business data, results).
- Use graph-based state machines when workflows have conditional branching — they make the flow visible and debuggable.

*Use `context7` to fetch the chosen framework's state management API before implementing.*

## Section 4: Memory Patterns *(STABLE — pattern knowledge)*

Select a memory pattern based on conversation requirements:

| Memory Type | Mechanism | Best For |
|---|---|---|
| Buffer | Store last N messages verbatim | Short conversations, simple chatbots |
| Summary | Compress older messages into summaries | Long conversations, cost control |
| Entity | Extract and track entities across turns | Customer support, knowledge tracking |
| Sliding window | Keep recent messages, drop oldest | Continuous interaction, fixed budget |
| Vector-backed | Embed messages, retrieve relevant history | Long-term memory, knowledge recall |

**Memory Decision Matrix**:

| Conversation Length | Domain Complexity | Cost Sensitivity | Recommended |
|---|---|---|---|
| Short (<10 turns) | Low | Any | Buffer |
| Medium (10–50 turns) | Low–Medium | High | Sliding window |
| Medium (10–50 turns) | High | Medium | Entity + sliding window |
| Long (>50 turns) | Any | High | Summary |
| Long + recall needed | High | Medium | Vector-backed + summary |

## Section 5: Framework Selection Criteria *(STABLE — criteria; VOLATILE — specific tools)*

Evaluate agent frameworks using these durable criteria:

| Criterion | What to Evaluate |
|---|---|
| Control level | Full graph control vs high-level orchestration |
| Type safety | Native typed interfaces vs string-based |
| State persistence | Built-in checkpointing vs manual implementation |
| Multi-agent support | Native supervisor/hierarchy vs single-agent only |
| Ecosystem lock-in | Provider-agnostic vs single-provider |
| Observability | Built-in tracing vs external integration required |
| Community & maturity | Active maintenance, documentation quality, adoption |

*Landscape snapshot (verify via `context7` before selecting — this evolves rapidly):*

| Framework Category | Current Examples | Selection Signal |
|---|---|---|
| Graph-based state machines | LangGraph, etc. | Maximum control, complex branching, checkpointing |
| Type-safe agent frameworks | PydanticAI, etc. | Strong typing, simple tool calling |
| Role-based multi-agent | CrewAI, etc. | Quick prototyping, role-based mental model |
| Provider-native SDKs | OpenAI Agents SDK, etc. | Single-provider projects, built-in tracing |
| Enterprise orchestration | Semantic Kernel, etc. | Enterprise/.NET stack integration |
| RAG-integrated agents | LlamaIndex Workflows, etc. | Data-heavy agents, RAG-first design |

*Always verify the current landscape via `context7` — new frameworks appear frequently, and existing ones pivot or deprecate.*

## Section 6: Guardrails & Security *(STABLE — security principles)*

Non-negotiable safety patterns for agent systems:

- **Prompt injection defense**: Never insert raw user input into system prompts. Sanitize, use delimiters, and validate tool outputs before passing them back into the agent loop.
- **Tool access control**: Limit which tools each agent can access. A summarization agent should not have database write access.
- **Output validation**: Validate every LLM output against a typed schema before acting on it. Never execute raw LLM-generated code without review.
- **PII masking**: Detect and mask personally identifiable information before sending to external LLM APIs. Log masked versions.
- **Human approval checkpoints**: Destructive operations (delete, send, publish) require explicit human confirmation.
- **Structured output enforcement**: All agent responses that drive downstream logic must be parsed into typed models — never rely on free-text parsing.

## Section 7: Error Handling & Reliability *(STABLE — engineering principles)*

Reliability patterns for agent systems:

| Pattern | When to Use | Implementation |
|---|---|---|
| Retry with backoff | Transient LLM API failures | Exponential backoff, max 3 retries |
| Fallback chains | Primary model unavailable | Try model A → model B → smaller model |
| Graceful degradation | Partial failure in multi-tool call | Return partial results with clear indication |
| Token budget management | Long conversations, cost control | Track usage, summarize when approaching limit |
| Timeout handling | LLM API latency spikes | Explicit timeout on every external call |
| Max iteration limits | Agent loops | Hard cap on loop iterations (e.g., 10–25) |

Implementation principles:
- Every agent loop MUST have a max iteration limit — infinite loops are the most common agent failure mode.
- Log every LLM call with input tokens, output tokens, latency, and cost for observability.
- Use circuit breakers for external API calls — repeated failures should stop the loop, not retry indefinitely.

## Anti-Patterns

| Anti-Pattern | Why It Fails | Instead Do |
|---|---|---|
| Over-engineered hierarchies | Latency, debugging complexity, unnecessary cost | Start with single agent + tools |
| Untyped tool schemas | LLM misuses tools, silent failures | Typed input/output models for every tool |
| No max iteration limit | Infinite loops, cost explosion | Hard cap (10–25) with graceful exit |
| No human-in-the-loop | Dangerous autonomous actions | Approval checkpoints for destructive ops |
| Ignoring token budgets | Cost explosion in long conversations | Track and manage token usage |
| No state persistence | Users lose progress on failure | Checkpointing for workflows > few seconds |

## Connected Skills

- `tsh-implementing-rag-pipelines` — agents often use RAG for knowledge retrieval
- `tsh-evaluating-llm-outputs` — evaluation metrics, testing strategy, guardrails for agent outputs
- `tsh-python-project-standards` — project structure, type safety, async patterns for agent implementations
