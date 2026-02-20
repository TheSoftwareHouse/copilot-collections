---
sidebar_position: 1
title: Skills Overview
---

# Skills Overview

Skills are reusable knowledge modules that provide specialized domain expertise, structured processes, and quality templates. They are stored in `.github/skills/` and loaded automatically by agents when their domain applies to the current task.

## How Skills Work

Each skill folder contains a `SKILL.md` file with:

- **Domain-specific guidelines** — Best practices, checklists, and processes.
- **Templates** — Example output formats (e.g., `plan.example.md`, `research.example.md`).
- **Connected skills** — References to other skills that complement or support this one.

When an agent starts a task, it checks all available skills and decides which ones to load. Multiple skills can be combined for tasks spanning different domains.

## Available Skills

| Skill | Description | Used By |
|---|---|---|
| [architecture-design](./architecture-design) | Solution architecture design and implementation plan creation | Architect |
| [code-review](./code-review) | Structured code review process | Code Reviewer |
| [codebase-analysis](./codebase-analysis) | Deep codebase analysis and dependency mapping | Architect, BA, SE |
| [e2e-testing](./e2e-testing) | Playwright E2E testing patterns and verification | E2E Engineer |
| [frontend-implementation](./frontend-implementation) | UI component patterns, accessibility, design system | Software Engineer |
| [implementation-gap-analysis](./implementation-gap-analysis) | Gap analysis between plan and current state | Architect, CR, SE |
| [sql-and-database](./sql-and-database) | Database engineering standards and ORM integration | Architect, CR, SE |
| [task-analysis](./task-analysis) | Task context gathering and research | BA, E2E Engineer |
| [technical-context-discovery](./technical-context-discovery) | Project conventions and pattern discovery | Architect, CR, SE, E2E |
| [ui-verification](./ui-verification) | Figma vs implementation verification criteria | UI Reviewer, SE |

## Agent–Skill Matrix

| Skill | Architect | BA | Code Reviewer | Software Engineer | E2E Engineer | UI Reviewer |
|---|---|---|---|---|---|---|
| architecture-design | ✅ | | | | | |
| code-review | | | ✅ | | | |
| codebase-analysis | ✅ | ✅ | | ✅ | | |
| e2e-testing | | | | | ✅ | |
| frontend-implementation | | | | ✅ | | |
| implementation-gap-analysis | ✅ | | ✅ | ✅ | | |
| sql-and-database | ✅ | | ✅ | ✅ | | |
| task-analysis | | ✅ | | | ✅ | |
| technical-context-discovery | ✅ | | ✅ | ✅ | ✅ | |
| ui-verification | | | | ✅ | | ✅ |

## Loading Priority

Skills follow a strict priority hierarchy:

1. **Project instructions** (`*.instructions.md` files) — highest priority.
2. **Existing codebase patterns** — replicate established conventions.
3. **Skill guidelines** — domain best practices and templates.
4. **External documentation** — framework docs, OWASP, industry standards.

This ensures consistency: existing patterns are never overridden unless explicitly requested.
