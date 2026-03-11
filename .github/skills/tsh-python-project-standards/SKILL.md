---
name: tsh-python-project-standards
description: Modern Python project standards for AI/LLM applications — project structure, type safety, linting, async patterns, configuration management, and testing. Use when working in Python projects involving LLM pipelines, RAG systems, agentic workflows, or any Python codebase requiring strict quality standards.
---

# Python Project Standards

Provides standards and patterns for structuring Python projects that involve LLM integrations, ensuring type safety, consistent code quality, secure configuration, and reliable async patterns.

<principles>

<type-safety-at-boundaries>
All data crossing system boundaries — LLM inputs/outputs, API requests/responses, configuration, external tool calls — MUST use typed data validation models. Untyped dictionaries at boundaries produce silent failures, hallucination propagation, and debugging nightmares. Define the contract, validate it, enforce it.
</type-safety-at-boundaries>

<secrets-never-in-code>
API keys, tokens, and credentials MUST come from environment variables or secrets managers — never hardcoded, never committed. This is a security principle, not a preference. Environment-based configuration (e.g., dev/staging/prod) follows the same pattern.
</secrets-never-in-code>

<enforce-consistency-automatically>
Code formatting, linting, and type checking MUST be automated and enforced — not left to human discipline. Pre-commit hooks and CI gates catch issues before they reach review. The toolchain does the enforcement; the developer does the thinking.
</enforce-consistency-automatically>

</principles>

## Implementation Process

Use the checklist below and track progress:

```
Progress:
- [ ] Step 1: Initialize project structure
- [ ] Step 2: Configure code quality tooling
- [ ] Step 3: Establish type safety patterns
- [ ] Step 4: Set up configuration management
- [ ] Step 5: Implement async patterns
- [ ] Step 6: Configure testing
```

**Step 1: Initialize project structure**

Set up a standard Python project layout:

- Use `src` layout with `pyproject.toml` as the single source of project metadata.
- Pin the Python version in `.python-version`.
- Structure packages by domain (e.g., `src/rag/`, `src/agents/`, `src/prompts/`), not by technical layer.
- Include a `README.md` with setup instructions, required environment variables, and development workflow.
- Use a modern package manager for dependency resolution and lockfile management.
  - *(e.g., uv, poetry — verify current best practices via `context7`)*

```
project-root/
├── pyproject.toml
├── .python-version
├── README.md
├── src/
│   └── <package>/
│       ├── __init__.py
│       ├── rag/
│       ├── agents/
│       └── config/
└── tests/
    ├── conftest.py
    ├── unit/
    └── integration/
```

**Step 2: Configure code quality tooling**

Enforce consistent formatting and strict type checking:

- Configure a linter/formatter that covers both linting rules and formatting in a single tool.
  - *(e.g., Ruff — verify current tools via `context7`)*
- Enable strict type checking for all source code.
  - *(e.g., mypy with `strict = true`, pyright — verify current tools via `context7`)*
- Set up pre-commit hooks to run linting, formatting, and type checking before each commit.
- Add CI gates that enforce all checks — code that fails quality checks must not merge.

Key configuration principles:
- Start strict, relax selectively — not the other way around.
- Treat type errors as blocking, not advisory.
- Formatter runs automatically on save and pre-commit — never manually.

**Step 3: Establish type safety patterns**

Define typed interfaces for all data boundaries:

- Use data validation models for all LLM-facing interfaces (inputs, outputs, tool schemas).
  - *(e.g., Pydantic BaseModel, dataclasses with validation — verify current patterns via `context7`)*
- Use `TypedDict` for interoperability with unstructured data (API responses, JSON configs) where full validation is unnecessary.
- Use `Generic` types for reusable components (e.g., `Pipeline[TInput, TOutput]`).
- Never use `Any` except at true escape hatches — document why when used.
- Define response models for every LLM call — never parse raw strings.

```python
# Pattern: typed LLM interface
# Framework-agnostic — the principle is always the same

class QueryInput(TypedModel):
    question: str
    max_results: int = 5
    filters: dict[str, str] | None = None

class RetrievalResult(TypedModel):
    content: str
    source: str
    relevance_score: float

class GeneratedAnswer(TypedModel):
    answer: str
    sources: list[RetrievalResult]
    confidence: float
```

**Step 4: Set up configuration management**

Manage application settings securely:

- Use environment variable-based configuration with typed settings models.
  - *(e.g., pydantic-settings, python-dotenv — verify current tools via `context7`)*
- Define a configuration hierarchy: defaults → `.env` file (development) → environment variables (production).
- API keys, model names, endpoint URLs — all come from environment, never hardcoded.
- Validate configuration at application startup — fail fast with clear error messages.

```python
# Pattern: typed configuration
class LLMConfig(TypedSettings):
    api_key: str          # Required — no default, fails if missing
    model_name: str = "gpt-4"
    temperature: float = 0.7
    max_tokens: int = 4096
    base_url: str | None = None  # Optional override
```

**Step 5: Implement async patterns**

Handle I/O-bound LLM operations efficiently:

- Use async/await for all LLM API calls, embedding generations, and vector store queries.
- Bound concurrency with semaphores — never fire unlimited parallel LLM calls.
- Implement proper cleanup with `try/finally` or async context managers.
- Handle cancellation gracefully — long-running pipelines must be interruptible.

Common pitfalls to avoid:
| Pitfall | Impact | Fix |
|---|---|---|
| Unbounded `gather()` | Rate limiting, cost explosion | Use semaphore with max concurrency |
| Missing `await` | Silent coroutine leak | Enable strict async linting rules |
| Sync calls in async context | Blocks event loop | Offload to thread pool or use async client |
| No timeout on LLM calls | Hanging pipeline | Set explicit timeouts on all external calls |

```python
# Pattern: bounded concurrent LLM calls
semaphore = asyncio.Semaphore(5)  # Max 5 concurrent calls

async def call_llm_bounded(prompt: str) -> str:
    async with semaphore:
        async with asyncio.timeout(30):  # Explicit timeout
            return await llm_client.generate(prompt)
```

**Step 6: Configure testing**

Set up a testing strategy for LLM-integrated code:

- Configure a test framework with clear directory separation: `tests/unit/`, `tests/integration/`.
  - *(e.g., pytest with conftest.py — verify current tools via `context7`)*
- Create fixtures for LLM mocking — never call real LLM APIs in unit tests.
- Use recorded response cassettes for integration tests.
- Set up coverage configuration excluding test files and config.

Testing patterns for AI code:
| What to test | How to test | Layer |
|---|---|---|
| Data validation models | Standard unit tests with valid/invalid inputs | Unit |
| Tool functions | Unit tests with mocked dependencies | Unit |
| Prompt templates | Snapshot tests — verify template renders correctly | Unit |
| LLM integration | Mocked LLM client, recorded responses | Integration |
| Pipeline end-to-end | Evaluation metrics on golden datasets | Evaluation |

## Key Standards Summary

| Standard | Requirement |
|---|---|
| Type safety | All LLM-facing interfaces use typed data validation models |
| Secrets | API keys via environment variables — never hardcoded |
| Code quality | Linting + formatting + type checking enforced via pre-commit and CI |
| Async | Bounded concurrency, explicit timeouts, proper cleanup |
| Dependencies | Pinned in project manifest with lockfile |
| Configuration | Environment-based, validated at startup, typed settings models |
| Testing | Mocked LLM calls in unit tests, eval metrics for pipeline testing |

## Anti-Patterns

| Anti-Pattern | Instead Do |
|---|---|
| Hardcoded API keys | Environment variables + typed settings |
| Raw `dict` for LLM I/O | Typed data validation models |
| `Any` type annotations | Explicit types, document escape hatches |
| Unbounded async concurrency | Semaphore-limited with timeouts |
| No pre-commit hooks | Automated formatting, linting, type checking |
| Testing against live LLMs | Mock clients, recorded cassettes, eval datasets |
| `requirements.txt` only | `pyproject.toml` with lockfile |

## Connected Skills

- `tsh-implementing-rag-pipelines` — builds on these standards for RAG-specific patterns
- `tsh-designing-agentic-workflows` — builds on these standards for agent-specific patterns
- `tsh-evaluating-llm-outputs` — builds on these standards for evaluation and testing patterns
