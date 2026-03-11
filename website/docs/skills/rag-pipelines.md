---
sidebar_position: 33
title: RAG Pipelines
---

# RAG Pipelines

**Folder:** `.github/skills/tsh-implementing-rag-pipelines/`  
**Used by:** Software Engineer, Architect, Code Reviewer

Pattern-level knowledge base for designing and implementing Retrieval-Augmented Generation systems. Teaches what patterns to use and when — not which library to import.

## Content Sections

### Chunking Strategies

Decision matrix for selecting chunking approaches (fixed-size with overlap, semantic, recursive character, sentence-window, parent-child) based on document type, volume, and query patterns.

### Embedding Models

Selection criteria for embedding models: dimensionality, latency, cost, multilingual support, and domain specificity. Categories include open-source, commercial, and domain-specific models.

### Vector Stores

Selection criteria for vector stores: managed vs self-hosted, metadata filtering, hybrid search support, scaling model, and cost. Integration patterns for metadata schema design and batch ingestion.

### Retrieval Strategies

Patterns for dense, sparse, hybrid, re-ranking, multi-query expansion, and contextual compression approaches, with decision matrices for combining strategies.

### Generation Patterns

Context window management, citation grounding, "I don't know" handling, prompt template design, and source attribution.

### Evaluation

Metric categories (faithfulness, answer relevancy, context precision, context recall) and evaluation dataset management.

## Anti-Patterns

- Context stuffing — dumping full documents into the prompt
- No chunk overlap — losing context at boundaries
- Dense-only retrieval — missing exact keyword matches
- Not evaluating retrieval separately from generation
- Ignoring metadata filtering
- Fixed chunk sizes for all document types

## Technology Approach

This skill is technology-agnostic and pattern-first. All framework and tool names appear as illustrative examples with `context7` verification directives. The patterns (chunking strategies, retrieval approaches, evaluation metrics) are durable; the specific tools are volatile.

## Connected Skills

- `tsh-evaluating-llm-outputs` — evaluation metrics, testing strategy, guardrails for RAG outputs
- `tsh-python-project-standards` — project structure, type safety, async patterns for RAG implementations
