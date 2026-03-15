---
slug: /
sidebar_position: 1
title: Introduction
---

# Introduction

**Copilot Collections** is an AI-powered product engineering framework that helps teams build wonderful products — covering the full lifecycle from product ideation through development to quality assurance.

Built by [The Software House](https://tsh.io) and validated across 50+ AI-powered projects.

## The Problem

According to Gartner, only **10% of software engineers** see meaningful productivity improvement from AI tools. The gap isn't the technology — it's the lack of structure, specialization, and repeatable workflows around it.

Most teams use AI for code completion. **Copilot Collections turns AI into an end-to-end product engineering partner** — from converting a workshop transcript into a Jira backlog, through architecture design and implementation, to automated code review and E2E testing.

## What It Provides

| Capability | Count | Description |
|---|---|---|
| 🧑‍💻 **Specialized Agents** | 12 | Business Analyst, Context Engineer, Architect, Engineering Manager, Software Engineer, Prompt Engineer, Code Reviewer, UI Reviewer, E2E Engineer, DevOps Engineer, Copilot Engineer, Copilot Orchestrator |
| 💬 **Public Prompts** | 12 | `/tsh-analyze-materials`, `/tsh-implement`, `/tsh-review`, `/tsh-review-ui`, `/tsh-review-codebase`, `/tsh-create-custom-agent`, `/tsh-create-custom-skill`, `/tsh-create-custom-prompt`, `/tsh-create-custom-instructions`, `/tsh-audit-infrastructure`, `/tsh-analyze-aws-costs`, `/tsh-analyze-gcp-costs` |
| 🔧 **Automatic Delegation** | via `/tsh-implement` | The Engineering Manager automatically routes tasks to Software Engineer, Prompt Engineer, E2E Engineer, DevOps Engineer, and UI Reviewer based on the implementation plan |
| 🧰 **Reusable Skills** | 31 | Transcript Processing, Task Extraction, Task Quality Review, Jira Task Formatting, Task Analysis, Architecture Design, Codebase Analysis, Code Review, Frontend Review, Implementation Gap Analysis, E2E Testing, Technical Context Discovery, Prompt Engineering, Frontend Implementation, Implementing Forms, Writing Hooks, Ensuring Accessibility, Optimizing Frontend, UI Verification, SQL & Database Engineering, CI/CD Implementation, Kubernetes Implementation, Terraform Modules, Observability Implementation, Secrets Management, Cloud Cost Optimization, Multi-Cloud Architecture Design, Creating Agents, Creating Skills, Creating Prompts, Creating Instructions |
| 🔌 **MCP Integrations** | 11 | Atlassian, Figma Dev Mode, Context7, Playwright, Sequential Thinking, PDF Reader, AWS API, AWS Documentation, GCP Gcloud, GCP Observability, GCP Storage |
| 🧠 **Structured Workflows** | 5 | Standard Flow, UI Flow, E2E Testing Flow, Workshop Analysis Flow, Copilot Customization Flow |

## Key Benefits

### For Product Teams
- **Workshop to Jira in minutes** — Process transcripts, Figma designs, and documents into structured epics and stories with a quality review gate. No more lost workshop outputs.
- **Systematic backlog quality** — 10-pass quality analysis catches missing entity lifecycles, error states, notification gaps, and undocumented dependencies in both new and existing backlogs.

### For Developers
- **Instant task context** — Pull requirements from Jira, designs from Figma, and patterns from the codebase into one research document. No more tool-hopping.
- **Structured implementation plans** — Get phased plans with CREATE/MODIFY/REUSE labels, security considerations, and definitions of done before writing a single line of code.
- **Pixel-perfect UI delivery** — Automated Figma verification loop catches design mismatches before human review. Design-to-code accuracy reaches 95–99%.

### For Engineering Leads
- **Consistent quality gates** — Every task goes through the same structured review process regardless of who implements it.
- **Faster onboarding** — New developers get structured context and clear plans within minutes instead of days.
- **Measurable impact** — 30% faster delivery, 60–80% reduction in context-gathering time, 70–90% fewer UI defects reaching QA.

## Quick Wins — Solve Real Problems Today

| Problem | Solution | Time |
|---|---|---|
| Workshop notes sitting in notebooks | `/tsh-analyze-materials` — epics and stories in Jira | ~15 min |
| New developer struggling with context | `/tsh-research PROJ-123` — structured research doc | ~3 min |
| No implementation plan | `/tsh-plan PROJ-123` — phased architecture plan | ~5 min |
| UI doesn't match Figma | `/tsh-implement` — automated Figma verification loop via internal UI prompt | ~20 min |
| Inconsistent code reviews | `/tsh-review PROJ-123` — structured multi-dimensional review | ~5 min |
| Flaky or missing E2E tests | `/tsh-implement` — Engineering Manager delegates to E2E Engineer | ~10 min |
| Technical debt piling up | `/tsh-review-codebase` — full quality analysis with action plan | ~15 min |
| Cloud costs out of control | `/tsh-analyze-aws-costs` or `/tsh-analyze-gcp-costs` — cost optimization audit | ~10 min |
| Infrastructure security gaps | `/tsh-audit-infrastructure` — security and best practices audit | ~15 min |

## How It Works

Every task follows a structured lifecycle:

> **Ideate → Research → Plan → Implement → Review**

1. **Ideate** — Convert workshop materials into Jira-ready epics and stories.
2. **Research** — Gather context from Jira, Figma, and the codebase.
3. **Plan** — Create a step-by-step implementation plan.
4. **Implement** — Execute the plan with scoped, reviewable changes.
5. **Review** — Verify against acceptance criteria, security, and quality standards.

Each phase produces a documented artifact that feeds the next, ensuring nothing is lost between steps. Think of it as a **relay race** — every handoff is a reviewed artifact.

## Next Steps

- [Prerequisites](./getting-started/prerequisites) — Check license and VS Code version requirements.
- [Installation](./getting-started/installation) — Clone and configure VS Code.
- [MCP Setup](./getting-started/mcp-setup) — Connect Jira, Figma, and other tools.
- [Workflow Overview](./workflow/overview) — Understand the full delivery lifecycle.
- [Use Cases](./use-cases) — See real problems the framework solves.
- [Quick Wins](./getting-started/quick-wins) — Start using the framework in your daily routine.
