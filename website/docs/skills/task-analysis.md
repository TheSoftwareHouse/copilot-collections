---
sidebar_position: 9
title: Task Analysis
---

# Task Analysis

**Folder:** `.github/skills/task-analysis/`  
**Used by:** Business Analyst, E2E Engineer

Provides a structured process for gathering and expanding task context from multiple sources.

## Process

### Step 0: Determine Input Source

Before anything else, determine where the context comes from:

| Source | How to Identify |
|---|---|
| **Research/plan files** | Check `specifications/` folder for `.research.md` or `.plan.md` |
| **Task ID** | Jira ID, GitHub issue number, or similar identifier |
| **Prompt context** | Free-form description in the chat message |

### Step 1: Search External Sources

Discover and search relevant external tools:

- **Jira** — Task details, subtasks, parent tasks, linked issues.
- **Confluence** — Knowledge base articles, process documentation.
- **Notion, Linear, Trello** — Alternative project management tools.
- **GitHub** — Issues, PRs, discussions.

### Step 2: Gather Information

Collect information from all available sources:

- Task management tools (requirements, acceptance criteria).
- Knowledge bases (domain context, business rules).
- Codebase (existing implementation, patterns, constraints).
- Figma designs (UI requirements, user flows).

### Step 3: Identify Gaps

Ask clarifying questions for:

- Ambiguous requirements.
- Missing acceptance criteria.
- Undefined edge cases.
- Conflicting information between sources.

### Step 4: Produce Research Report

Generate a structured document (`research.example.md` template) containing all gathered context, ready for the planning phase.

## Connected Skills

- `codebase-analysis` — For understanding the existing codebase in context.
- `implementation-gap-analysis` — For identifying what exists vs what needs to be built.
