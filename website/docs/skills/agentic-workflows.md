---
sidebar_position: 34
title: Agentic Workflows
---

# Agentic Workflows

**Folder:** `.github/skills/tsh-designing-agentic-workflows/`  
**Used by:** Software Engineer, Architect, Code Reviewer

Pattern-level knowledge base for designing and implementing LLM agent systems. Teaches architecture patterns, state management, memory, and safety — not framework-specific APIs.

## Content Sections

### Architecture Patterns

Decision matrix for selecting agent architecture (single agent + tools, router, supervisor, hierarchical, collaborative) based on complexity, team size, latency, and tool count.

### Tool/Function Calling

Typed tool interface design, input/output validation, error handling, and execution strategies (sequential vs parallel).

### State Management

Patterns for in-memory state, graph-based state machines, persistent state stores, and event-sourced state. Checkpointing guidance for long-running workflows.

### Memory Patterns

Selection matrix for buffer, summary, entity, sliding window, and vector-backed memory based on conversation length, domain complexity, and cost sensitivity.

### Framework Selection Criteria

Durable evaluation criteria (control level, type safety, state persistence, multi-agent support, ecosystem lock-in, observability) with a clearly marked landscape snapshot for current framework options.

### Guardrails & Security

Non-negotiable safety patterns: prompt injection defense, tool access control, output validation, PII masking, human approval checkpoints, and structured output enforcement.

### Error Handling & Reliability

Retry with backoff, fallback chains, graceful degradation, token budget management, timeout handling, and max iteration limits.

## Anti-Patterns

- Over-engineered hierarchies for simple tasks
- Untyped tool schemas
- No max iteration limit (infinite loops)
- No human-in-the-loop for critical decisions
- Ignoring token budgets
- No state persistence for long-running workflows

## Technology Approach

Framework selection criteria are durable; specific framework names appear only as illustrative examples in clearly marked landscape snapshots. Use `context7` to verify the current framework landscape before making technology decisions.

## Connected Skills

- `tsh-implementing-rag-pipelines` — agents often use RAG for knowledge retrieval
- `tsh-evaluating-llm-outputs` — evaluation metrics, testing strategy, guardrails for agent outputs
- `tsh-python-project-standards` — project structure, type safety, async patterns for agent implementations
