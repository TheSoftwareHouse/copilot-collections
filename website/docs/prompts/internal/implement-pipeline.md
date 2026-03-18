---
sidebar_position: 14
title: /tsh-implement-pipeline
---

# /tsh-implement-pipeline

:::info
Not invoked directly by users. To trigger CI/CD pipeline implementation, use [`/tsh-implement`](../public/implement) — the [Engineering Manager](../../agents/engineering-manager) will automatically delegate to the [DevOps Engineer](../../agents/devops-engineer).
:::

**Agent:** DevOps Engineer
**File:** `.github/internal-prompts/tsh-implement-pipeline.prompt.md`

Creates or modifies CI/CD pipelines with proper deployment stages, environment protection, and secure authentication.

## How It’s Triggered

```text
/tsh-implement <describe the pipeline to create or modify>
```

The Engineering Manager identifies CI/CD pipeline tasks in the plan and delegates them to the DevOps Engineer automatically.

## What It Does

### 1. Context Discovery

- Identifies the CI/CD platform (GitHub Actions, GitLab CI, Bitbucket Pipelines, Jenkins).
- Checks for existing pipeline patterns, caching strategies, and environment configurations.
- Discovers secret management and authentication patterns.

### 2. Implementation

- Creates pipeline configuration following the project's CI/CD platform conventions.
- Implements deployment stages with proper environment protection rules.
- Configures caching and parallelization for optimal build times.
- Sets up secure authentication for deployments.

### 3. Safety Checks

- Validates pipeline configuration syntax.
- Ensures environment protection rules are in place for production deployments.
- Verifies secrets are properly referenced, not hardcoded.

## Skills Loaded

- `tsh-implementing-ci-cd` — CI/CD pipeline design patterns and deployment strategies.
- `tsh-managing-secrets` — Secrets management for CI/CD environments.
- `tsh-technical-context-discovering` — Project conventions and existing patterns.
