---
sidebar_position: 2
title: Architect
---

# Architect Agent

**File:** `.github/agents/tsh-architect.agent.md`

The Architect agent designs technical solutions, system architecture, and detailed implementation plans. It translates business requirements into structured, executable specifications.

## Responsibilities

- Designing the overall architecture of the solution (components, interactions, data flow).
- Creating detailed implementation plans broken into phases and tasks with checklist-style tracking.
- Ensuring solutions align with project requirements, best practices, and quality standards.
- Defining security considerations and quality assurance guidelines.
- Collaborating with Business Analysts to clarify ambiguities.

## What It Produces

Each technical specification includes:

1. **Solution Architecture** — High-level overview of components, interactions, and data flow.
2. **Implementation Plan** — Phases and tasks with clear definition of done for each task.
3. **Test Plan** — Automated testing strategies (no manual QA steps).
4. **Security Considerations** — Security aspects to address during implementation.
5. **Quality Assurance** — Guidelines for ensuring implementation quality.

## Tool Access

| Tool | Usage |
|---|---|
| **Atlassian** | Gather requirements from Jira issues and Confluence pages |
| **Context7** | Evaluate libraries, verify compatibility, search integration patterns |
| **Figma** | Translate visual requirements into technical specifications |
| **Sequential Thinking** | Design complex architectures, evaluate trade-offs, break down features |

## Skills Loaded

- `architecture-design` — Solution design, components, data flows, implementation plan creation.
- `codebase-analysis` — Analyze current architecture, components, and patterns.
- `implementation-gap-analysis` — Focus the plan on necessary changes without duplicating existing work.
- `technical-context-discovery` — Establish project conventions and patterns before designing.
- `sql-and-database` — Database schema design, indexing strategies, transaction patterns.

## Handoffs

After creating the plan, the Architect can hand off to:

- **Software Engineer** → `/implement` (standard implementation)
- **Software Engineer** → `/implement-ui` (frontend implementation with Figma verification)
