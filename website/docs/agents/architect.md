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

| Tool                      | Usage                                                                  |
| ------------------------- | ---------------------------------------------------------------------- |
| **Atlassian**             | Gather requirements from Jira issues and Confluence pages              |
| **Context7**              | Evaluate libraries, verify compatibility, search integration patterns  |
| **Figma**                 | Translate visual requirements into technical specifications            |
| **PDF Reader**            | Read and extract content from PDF requirement documents                |
| **Sequential Thinking**   | Design complex architectures, evaluate trade-offs, break down features |
| **Terminal**              | Run build tools, scripts, and validation commands                      |
| **File Read/Edit/Search** | Read, modify, and search workspace files                               |
| **VS Code Commands**      | Execute VS Code commands and run tasks                                 |
| **Sub-agents**            | Delegate subtasks to specialized agents                                |
| **Todo**                  | Track task progress with structured checklists                         |

## Skills Loaded

- `tsh-architecture-designing` — Solution design, components, data flows, implementation plan creation.
- `tsh-codebase-analysing` — Analyze current architecture, components, and patterns.
- `tsh-implementation-gap-analysing` — Focus the plan on necessary changes without duplicating existing work.
- `tsh-technical-context-discovering` — Establish project conventions and patterns before designing.
- `tsh-sql-and-database-understanding` — Database schema design, indexing strategies, transaction patterns.
- `tsh-designing-multi-cloud-architecture` — Cross-provider infrastructure design and service selection across AWS, Azure, and GCP.
- `tsh-optimizing-cloud-cost` — Cost implications of architectural decisions, pricing model comparison.
- `tsh-implementing-ci-cd` — CI/CD pipeline design, deployment strategies, delivery workflows.
- `tsh-implementing-terraform-modules` — IaC structure, Terraform module hierarchy, Terragrunt patterns.
- `tsh-managing-secrets` — Secrets management, credential rotation, vault integration.
- `tsh-implementing-kubernetes` — K8s workload configurations, scaling strategies, Helm chart structure.
- `tsh-implementing-observability` — Monitoring architecture, SLO frameworks, alerting, distributed tracing.
- `tsh-engineering-prompts` — LLM prompt architecture: prompt template strategy, system prompt design, few-shot vs zero-shot decisions.

## Handoffs

After creating the plan, the Architect can hand off to:

- **Software Engineer** → `/tsh-implement` (standard implementation)
- **Software Engineer** → `/tsh-implement` (frontend implementation with Figma verification via internal UI prompt)
