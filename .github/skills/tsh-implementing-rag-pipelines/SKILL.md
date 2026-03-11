---
name: tsh-implementing-rag-pipelines
description: RAG pipeline patterns — chunking strategies, embedding models, vector stores, retrieval strategies, generation patterns, and evaluation. Technology-agnostic knowledge base for designing and implementing Retrieval-Augmented Generation systems. Use when building RAG pipelines, selecting retrieval strategies, or evaluating retrieval quality.
---

# Implementing RAG Pipelines

Pattern-level knowledge base for RAG system design and implementation. Teaches what patterns to use and when — not which library to import.

<principles>

<pattern-first>
Learn the retrieval pattern, then pick the framework. Chunking strategies, re-ranking approaches, and hybrid retrieval are durable concepts that outlive any specific library. Skills teach the WHAT and WHY; `context7` provides the HOW for whichever framework is current.
</pattern-first>

<evaluate-retrieval-independently>
Always measure retrieval quality separately from generation quality. If the retriever returns irrelevant chunks, no amount of prompt engineering fixes the answer. Test retrieval precision and recall before optimizing generation.
</evaluate-retrieval-independently>

<context-quality-over-quantity>
Fewer, highly relevant chunks produce better answers than stuffing the context window. Every token of irrelevant context is noise that degrades generation quality and increases cost.
</context-quality-over-quantity>

</principles>

## Section 1: Chunking Strategies *(STABLE — pattern knowledge)*

Select a chunking strategy based on document type and query pattern:

| Strategy | Best For | Trade-Off |
|---|---|---|
| Fixed-size with overlap | Uniform documents, fast ingestion | Splits semantic units |
| Recursive character | Semi-structured text (markdown, code) | Needs separator tuning |
| Sentence-window | Question-answering over prose | Higher chunk count |
| Semantic chunking | Mixed-format documents | Requires embedding calls during ingestion |
| Parent-child / hierarchical | Long documents with sections | Complex retrieval logic |

**Chunking Decision Matrix**:

| Document Type | Volume | Recommended Strategy |
|---|---|---|
| Short articles / FAQs | Any | Sentence-window or fixed-size |
| Long-form docs with sections | Medium–High | Parent-child / hierarchical |
| Code + documentation mix | Any | Recursive character (language-aware separators) |
| PDFs / scanned documents | Any | Fixed-size with overlap (after OCR) |
| Conversational transcripts | Any | Sentence-window with speaker metadata |

Implementation principles:
- Always include overlap between chunks (10–20% of chunk size) to preserve context at boundaries.
- Preserve metadata (source, page, section) on every chunk — retrieval without attribution is useless.
- Test chunk sizes empirically — there is no universal optimal size. Start with 256–512 tokens and adjust based on retrieval metrics.

## Section 2: Embedding Models *(STABLE — criteria are durable; model names are volatile)*

Selection criteria for embedding models:

| Criterion | What to evaluate |
|---|---|
| Dimensionality | Higher dims = more expressive but more storage/compute |
| Latency | Batch vs real-time embedding requirements |
| Cost | Per-token pricing for commercial models, compute for open-source |
| Multilingual | Required for non-English or mixed-language corpora |
| Domain specificity | General-purpose vs fine-tuned for legal, medical, code, etc. |

Categories:
- **Open-source**: Self-hosted, no per-call cost, full control. Higher operational overhead.
- **Commercial APIs**: Low operational overhead, per-call pricing, vendor dependency.
- **Domain-specific**: Fine-tuned for a specific domain — better accuracy, narrower applicability.

Trade-off: Higher dimensionality generally improves accuracy but increases storage, memory, and query latency. For most applications, 768–1536 dimensions provide a good balance.

*Model names and benchmark rankings change frequently. Use `context7` to check current embedding model comparisons before selecting.*

## Section 3: Vector Stores *(STABLE — categories; VOLATILE — specific products)*

Selection criteria:

| Criterion | What to evaluate |
|---|---|
| Managed vs self-hosted | Operational overhead vs control |
| Metadata filtering | Native support for filtering by attributes during search |
| Hybrid search | Combined dense + sparse retrieval support |
| Scaling model | Horizontal scaling, sharding, replication |
| Cost model | Per-vector, per-query, or compute-based pricing |

Categories:
- **Purpose-built vector databases**: Optimized for vector operations, purpose-designed for similarity search.
- **Vector extensions for existing databases**: Add vector capabilities to your existing database (e.g., pgvector for PostgreSQL). Good when you already have a relational database and want to avoid a new operational dependency.
- **In-memory / embedded**: Good for development, testing, and small-scale applications.

Integration patterns:
- Design a metadata schema upfront — retrofitting metadata filtering is expensive.
- Configure index type based on accuracy vs speed requirements (approximate vs exact search).
- Use batch ingestion pipelines — never insert vectors one at a time in production.
- Separate write and read paths if ingestion volume is high.

*Landscape snapshot (verify current options via `context7`): Purpose-built options include Qdrant, Pinecone, Weaviate, Chroma, Milvus. Extension options include pgvector. Always verify current feature sets and pricing.*

## Section 4: Retrieval Strategies *(STABLE — pattern knowledge)*

Retrieval approaches and when to combine them:

| Strategy | Mechanism | Best For |
|---|---|---|
| Dense retrieval | Embedding similarity (cosine/dot product) | Semantic understanding, paraphrased queries |
| Sparse retrieval | Keyword matching (BM25, TF-IDF) | Exact terms, proper nouns, IDs |
| Hybrid retrieval | Dense + sparse with score fusion | General-purpose — best default |
| Re-ranking | Cross-encoder scoring on top-N candidates | Precision-critical applications |
| Multi-query expansion | Generate query variants, retrieve for each | Ambiguous or complex queries |
| Contextual compression | Compress retrieved chunks to relevant parts | Long chunks, limited context window |

**Retrieval Strategy Decision Matrix**:

| Corpus Size | Query Type | Accuracy Need | Recommended Combination |
|---|---|---|---|
| Small (<10K docs) | Keyword-heavy | Medium | Sparse + metadata filtering |
| Medium (10K–1M) | Mixed | High | Hybrid (dense + sparse) + re-ranking |
| Large (>1M) | Semantic | High | Dense + re-ranking + metadata filtering |
| Any | Ambiguous | Very high | Multi-query + hybrid + re-ranking |

Implementation principles:
- Hybrid retrieval (dense + sparse with reciprocal rank fusion) is the best default for most applications.
- Always add re-ranking when precision matters — it dramatically improves top-K quality at moderate latency cost.
- Use metadata filtering to narrow the search space before vector similarity — this improves both speed and relevance.

## Section 5: Generation Patterns *(STABLE — pattern knowledge)*

Context management and generation quality:

- **Context window management**: Rank retrieved chunks by relevance and fill the context window from most to least relevant. Stop before hitting the token limit — leave room for the system prompt and generation.
- **Citation grounding**: Include source references in the generated output. Every claim should be traceable to a specific retrieved chunk.
- **"I don't know" handling**: Instruct the model to decline when retrieved context is insufficient rather than hallucinate. Measure refusal rate as a quality metric.
- **Prompt template design**: Separate the system prompt (instructions), context (retrieved chunks), and user query. Never concatenate them without clear delimiters.
- **Source attribution**: Return source metadata alongside the generated answer — users need to verify claims.

## Section 6: Evaluation *(STABLE — metric concepts; VOLATILE — tool names)*

Metric categories for RAG evaluation:

| Metric | What It Measures | Layer |
|---|---|---|
| Context precision | Are retrieved chunks relevant to the query? | Retrieval |
| Context recall | Are all relevant chunks retrieved? | Retrieval |
| Faithfulness | Is the answer grounded in retrieved context? | Generation |
| Answer relevancy | Does the answer address the query? | Generation |

Evaluation approach:
- Create a golden dataset of question–answer–source triples for offline evaluation.
- Measure retrieval and generation metrics independently — this isolates where improvements are needed.
- Run evaluation as part of CI — set threshold-based pass/fail gates.
- Track metrics over time to detect regressions from prompt changes or data updates.

*Landscape snapshot: RAG evaluation frameworks exist for both RAG-specific metrics and general-purpose LLM evaluation. Verify current tools via `context7` before selecting.*

## Anti-Patterns

| Anti-Pattern | Why It Fails | Instead Do |
|---|---|---|
| Context stuffing | Noise degrades generation, increases cost | Rank and truncate, use re-ranking |
| No chunk overlap | Loses context at boundaries | 10–20% overlap between chunks |
| Dense-only retrieval | Misses exact keyword matches | Hybrid retrieval (dense + sparse) |
| Not evaluating retrieval separately | Can't tell if retriever or generator is failing | Measure retrieval metrics independently |
| Ignoring metadata filtering | Full-corpus search when you know the category | Add metadata and filter before search |
| Fixed chunk sizes for all document types | Different structures need different strategies | Match chunking strategy to document type |

## Connected Skills

- `tsh-evaluating-llm-outputs` — evaluation metrics, testing strategy, guardrails for RAG outputs
- `tsh-python-project-standards` — project structure, type safety, async patterns for RAG implementations
