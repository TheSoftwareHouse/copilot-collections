---
sidebar_position: 32
title: Python Project Standards
---

# Python Project Standards

**Folder:** `.github/skills/tsh-python-project-standards/`  
**Used by:** Software Engineer, Architect, Code Reviewer

Provides modern Python project standards for AI/LLM applications — project structure, type safety, linting, async patterns, configuration management, and testing.

## Process

### Step 1: Initialize Project Structure

Set up a standard `src` layout with `pyproject.toml`, pinned Python version, and domain-based package organization.

### Step 2: Configure Code Quality Tooling

Enforce consistent formatting and strict type checking with automated linting, formatting, and pre-commit hooks.

### Step 3: Establish Type Safety Patterns

Define typed data validation models for all LLM-facing interfaces — inputs, outputs, tool schemas, and configuration.

### Step 4: Set Up Configuration Management

Environment variable-based configuration with typed settings models. API keys and secrets never hardcoded.

### Step 5: Implement Async Patterns

Bounded concurrency with semaphores, explicit timeouts, and proper cleanup for I/O-bound LLM operations.

### Step 6: Configure Testing

Test framework setup with fixtures for LLM mocking, recorded response cassettes, and coverage configuration.

## Key Standards

| Standard | Requirement |
|---|---|
| Type safety | All LLM-facing interfaces use typed data validation models |
| Secrets | API keys via environment variables — never hardcoded |
| Code quality | Linting + formatting + type checking enforced via pre-commit and CI |
| Async | Bounded concurrency, explicit timeouts, proper cleanup |
| Dependencies | Pinned in project manifest with lockfile |

## Technology Approach

This skill is technology-agnostic. Python tooling names (e.g., Ruff, mypy, uv) appear as illustrative examples. Use `context7` to verify current best practices and tool recommendations before selecting.

## Connected Skills

- `tsh-implementing-rag-pipelines` — builds on these standards for RAG-specific patterns
- `tsh-designing-agentic-workflows` — builds on these standards for agent-specific patterns
- `tsh-evaluating-llm-outputs` — builds on these standards for evaluation and testing patterns
