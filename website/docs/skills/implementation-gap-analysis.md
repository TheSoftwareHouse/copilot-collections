---
sidebar_position: 7
title: Implementation Gap Analysis
---

# Implementation Gap Analysis

**Folder:** `.github/skills/implementation-gap-analysis/`  
**Used by:** Architect, Code Reviewer, Software Engineer

Provides a 4-step process for comparing the current system state to the expected implementation, ensuring no duplicate work.

## Process

### Step 1: Analyse Task Requirements

Break down what needs to be implemented based on the research and plan files.

### Step 2: Analyse Current System

Examine the existing codebase to understand what already exists — components, functions, utilities, hooks, routes, API endpoints.

### Step 3: Compare

For each requirement, classify as:

| Action | Meaning |
|---|---|
| **[CREATE]** | Needs to be built from scratch |
| **[MODIFY]** | Exists but needs changes or extensions |
| **[REUSE]** | Exists and can be used as-is |

### Step 4: Produce Gap Report

Generate a structured report (`implementation-gap-analysis.example.md` template) documenting:

- What's already implemented and functional.
- What exists but needs modification.
- What needs to be created from scratch.
- Dependencies between existing and new code.

## Why It Matters

- Prevents building something that already exists.
- Identifies reusable components and utilities.
- Focuses implementation effort on what's actually needed.
- Keeps plans lean and execution efficient.

## Connected Skills

Cross-referenced by:

- `architecture-design` — To focus plans on necessary changes.
- `code-review` — To verify implementation completeness.
