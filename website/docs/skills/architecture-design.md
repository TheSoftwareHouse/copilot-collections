---
sidebar_position: 2
title: Architecture Design
---

# Architecture Design

**Folder:** `.github/skills/tsh-architecture-designing/`  
**Used by:** Architect

Provides a structured 5-step process for designing solution architecture and creating detailed implementation plans.

## Process

### Step 1: Understand the Business Goal

Analyze the task requirements and business context to ensure the solution addresses the actual problem.

### Step 2: Analyse the Codebase

Use the `tsh-codebase-analysing` and `tsh-implementation-gap-analysing` skills to understand existing architecture and identify what needs to change.

### Step 3: Ask Clarifying Questions

Identify ambiguities and missing information before committing to a design.

### Step 4: Design the Solution

Create the architecture following established patterns and principles.

### Step 5: Document the Plan

Produce a structured implementation plan (`plan.example.md` template) with phased, checklist-style tasks that is self-contained for lower-tier execution.

## Enforced Patterns

| Category | Patterns |
|---|---|
| **Software Design** | DRY, KISS, DDD, TDD, CQRS, SOLID |
| **Architecture** | Hexagonal, Layered, Modular |
| **UI/UX** | Atomic Design, WCAG |
| **Security** | OWASP TOP10 |

## Plan Requirements

- Each phase is independently runnable with quality gates.
- Every plan always includes `Glossary / Ubiquitous Language`, `Technical Context`, and `Traps and Warnings`.
- Every phase includes a reusable preamble: `Purpose`, `State Before`, `State After`, `Dependencies / Risks`.
- Tasks have `[CREATE]`, `[MODIFY]`, or `[REUSE]` action types.
- Every task includes `Context`, `Approach`, `References`, `Traps`, and a clear definition of done.
- A code review phase is mandatory at the end.
- No deployment plans or manual QA steps.
- Plans are guidance artifacts only — no real / production code. Use prose, tables, diagrams, contracts, and labeled non-executable pseudocode instead.

## Connected Skills

- `tsh-codebase-analysing` — Understand existing architecture.
- `tsh-implementation-gap-analysing` — Focus on necessary changes only.
- `tsh-technical-context-discovering` — Establish project conventions.
- `tsh-sql-and-database-understanding` — Database schema and data model design.
