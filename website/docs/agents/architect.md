---
sidebar_position: 2
title: Architect
---

# Architect Agent

**File:** `.github/agents/tsh-architect.agent.md`

The Architect agent designs technical solutions, system architecture, and detailed implementation plans. It translates business requirements into structured, executable specifications that are validated by the Architect Reviewer before implementation begins.

The Architect owns plan revisions and records only the user's literal Human approval response; it never infers consent from context or from Reviewer approval. `tsh-plan-reviewer` `APPROVED` is Reviewer approval only and leaves Human approval pending. Both **Start Implementation in a New Discussion** and **Start Infrastructure Implementation in a New Discussion** pass through the Engineering Manager and its Human approval gate; neither handoff directly authorizes file-changing work.

Recording plan-authoring Human approval ends the authoring discussion. Implementation starts in a new discussion, where the unchanged persisted approval can be reused without asking for approval twice.

The Architect presents and records Human Approval in two situations: unconditionally at its own plan-authoring gate (`Approve plan` / `I have comments`) immediately after it accepts a revision-bound Reviewer `APPROVED` verdict, and when the Engineering Manager delegates a narrowly scoped plan-record update after its own execution-authorization gate. Execution owners, not the Architect, validate the persisted Human Approval record from disk before editing.

## Responsibilities

- Designing the overall architecture of the solution (components, interactions, data flow).
- Creating detailed implementation plans broken into phases and tasks with checklist-style tracking.
- Ensuring solutions align with project requirements, best practices, and quality standards.
- Defining security considerations and quality assurance guidelines.
- Collaborating with Business Analysts to clarify ambiguities.

## What It Produces

Each technical specification includes:

1. **Solution Architecture** — High-level overview of components, interactions, and data flow.
2. **Implementation Plan** — Phases and tasks with clear definition of done for each task, ready for Architect Reviewer validation.
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

- `tsh-architecture-designing` — Solution design, components, data flows.
- `tsh-creating-implementation-plans` — Implementation plan template, structure, and DoD rules.
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

## Model Bands

The Architect ships as three agents that share one identical body and differ only in the frontmatter model array. Selection is route-varying logic owned by `tsh-orchestrating-implementation`, and the Engineering Manager picks the band at delegation time.

| Band | File | Models | Select when |
| --- | --- | --- | --- |
| default | `tsh-architect.agent.md` | Claude Sonnet 5, GPT-5.6 Terra | Any full-tier planning work without a deep-band signal. The standard route. |
| deep | `tsh-architect-deep.agent.md` | Claude Opus 5, Claude Sonnet 5 | Irreversible or high-cost decisions, schema migrations or backfills, security or authentication boundary design, cross-component architecture, competing viable designs, or an explicit user request. Expected to be rare. |
| fast | `tsh-architect-fast.agent.md` | GPT-5.6 Luna, Gemini 3.6 Flash | The request on its face satisfies the light-tier predicate. Light tier only. |

The two variants set `user-invocable: false`, so the chat dropdown shows a single Architect and the bands exist only as delegation targets.

The band–tier coupling is hard, not advisory. The fast band authors light-tier plans only: if a tier-predicate condition fails, it stops and returns a tier mismatch instead of switching to the full template, and the manager re-delegates to the default or deep band. Over-provisioning is permitted — the default or deep band may author a light-tier plan — but under-provisioning never is. A user request upward is always honored; a request down to the fast band is honored only when the predicate holds.

`tsh-architect.agent.md` is the single source of truth. `scripts/sync-architect-variants.mjs` regenerates both variants, and CI fails if regeneration produces a diff — so edit the base file only and re-run the script.

## Pre-Submission Self-Check and Review Loop

Before submitting a plan, the Architect runs a pre-submission self-check against the same six `BLOCKER` categories used by the Architect Reviewer: materially invalid architecture; security, privacy, or authentication risk; unsupported irreversible or high-cost decisions; critical integration, data, migration, rollout, or rollback failure; an execution-critical unresolved decision; and material contradiction with research or an omitted requirement.

After creating or revising a plan, the Architect invokes `tsh-plan-reviewer` one invocation per plan lifecycle. Every `BLOCKER` finding must be closed by an architect correction or a recorded explicit evidence-based resolution or justification — never by omission or an unexplained downgrade — and the Architect never approves a plan while a blocker remains. `.plan-review.md` is append-only and never overwritten.

A returned verdict is revision-bound only when its `reviewed-plan-revision` equals the current `Plan Revision`. A mismatch, `unknown`, or absent value is treated identically as not revision-bound: the Architect rejects the verdict and appends a reconciliation entry to `.plan-review.md`.

If an unresolved `BLOCKER` remains after disposition, the Architect escalates via `vscode/askQuestions` with exactly these choices: `stop here` or `custom guidance`. `stop here` ends the lifecycle with a closing `.plan-review.md` entry; `custom guidance` follows the supplied instruction. A non-revision-bound verdict is rejected and logged as a reconciliation entry in `.plan-review.md` without re-invoking the reviewer. A new review happens only through an explicitly user-directed new review event. The Architect never silently continues or approves while a blocker remains.

## Handoffs

After creating the plan, the Architect can hand off to:

- **Internal plan review loop** → the Architect invokes `tsh-plan-reviewer` as a nested subagent after creating or revising a plan, following the self-check and review loop described above. This loop only ever settles Reviewer approval; it never grants or implies Human approval.
- **Engineering Manager** → `/tsh-implement` (`Start Implementation in a New Discussion`) once the plan is Reviewer-ready and the Architect's own plan-authoring gate (`Approve plan` / `I have comments`) has recorded Human Approval, which the manager may reuse in the new discussion; on the low-risk-exemption path no plan-authoring gate runs and the manager's gate is the only user-facing gate
- **Engineering Manager** → `Start Infrastructure Implementation in a New Discussion` for infrastructure work, through the same Human approval gate
