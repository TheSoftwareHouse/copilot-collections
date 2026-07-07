---
sidebar_position: 2
title: Architecture Design
---

# Architecture Design

**Folder:** `.github/skills/tsh-architecture-designing/`  
**Used by:** Architect

Provides a structured 5-step process for designing solution architecture.

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

Hand off to [Creating Implementation Plans](./creating-implementation-plans.md) so the plan can be authored with the owned `plan.example.md` template and plan-structure rules.

## Enforced Patterns

| Category | Patterns |
| --- | --- |
| **Software Design** | DRY, KISS, DDD, TDD, CQRS, SOLID |
| **Architecture** | Hexagonal, Layered, Modular |
| **UI/UX** | Atomic Design, WCAG |
| **Security** | OWASP TOP10 |

## Implementation Plan Handoff

Implementation plan authoring rules, template ownership, and task definition-of-done constraints live in [Creating Implementation Plans](./creating-implementation-plans.md).

## Connected Skills

- `tsh-codebase-analysing` — Understand existing architecture.
- `tsh-implementation-gap-analysing` — Focus on necessary changes only.
- `tsh-technical-context-discovering` — Establish project conventions.
- `tsh-creating-implementation-plans` — Author the phased implementation plan.
- `tsh-sql-and-database-understanding` — Database schema and data model design.
