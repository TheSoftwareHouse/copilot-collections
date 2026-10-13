---
sidebar_position: 35
title: Orchestrating Implementation
---

# Orchestrating Implementation

**Folder:** `.github/skills/tsh-orchestrating-implementation/`  
**Used by:** [Engineering Manager](../agents/engineering-manager), [Architect](../agents/architect)

The canonical workflow owner for implementation orchestration. It prepares execution context, routes delegated work to specialist agents, and closes quality gates without ever writing product code itself.

## Principles

- **Canonical source of truth** — planning readiness, task routing, todo protocol, and review gates live here rather than in agents or prompts.
- **Never edits files directly** — every file change is delegated to the owning specialist; if none exists, the orchestrator stops and asks the user.
- **Read/search for routing only** — used to choose the right specialist, not to solve the task.
- **Todos are a progress-control surface** — not a context-recovery mechanism.

## Workflow

1. **Step 0** — create flow-start todos (one per plan task, review event, `[REUSE]` UI item, and final gate).
2. **Step 1** — establish Full Flow (the only route) and assess planning readiness.
3. **Step 2** — plan the task order before the first delegation, and again after Human approval.
4. **Step 3** — run Full Flow: planning sequence, then execution routing in plan order.
5. **Step 4** — close validation and review gates.

## Task-to-Owner Routing

| Task type | Delegate to | Prompt |
|---|---|---|
| App code (plan task, default) | `tsh-plan-implementor` | `tsh-implement-common-task.prompt.md` |
| App code (complex, exception) | `tsh-software-engineer` | `tsh-implement-common-task.prompt.md` |
| UI with Figma | `tsh-ui-engineer` | `tsh-implement-ui-common-task.prompt.md` |
| E2E | `tsh-e2e-engineer` | `tsh-implement-e2e.prompt.md` |
| Infra, Kubernetes, CI/CD, observability | `tsh-devops-engineer` | Terraform, Kubernetes, pipeline, or observability prompt |
| LLM prompts | `tsh-prompt-engineer` | `tsh-engineer-prompt.prompt.md` |
| Documentation | `tsh-technical-writer` | `tsh-write-documentation.prompt.md` |
| `[REUSE]` UI verification | `tsh-ui-reviewer` | `tsh-review-ui.prompt.md` |

## Approval and Revision Rules

- **Two separate gates** — the Architect's plan-authoring approval (`Approve plan`, `I have comments`) and the Engineering Manager's recovery-only execution authorization (`Approve current plan`, `Request changes`, `Stop`).
- **Reuse, never manufacture** — a persisted `## Human Approval` record is reused only when `Human Decision=APPROVED`, `Approved Revision` equals the current Plan Revision, and the timestamp is valid UTC ISO 8601 ending in `Z`; otherwise the gate fails closed.
- **Material revision** — any material change to a Human-approved plan halts file-changing delegation until renewed Human approval.
- **Implementation discussion boundary** — implementation starts in a new discussion, not in the one where the plan was approved.

## Execution Gates

- Every task is followed by a plan and todo update and the checks matching the changed area.
- `[REUSE]` UI items run one at a time: `tsh-ui-capture-worker` first, then `tsh-ui-reviewer` on the captured artifacts, up to 5 iterations, each ending as PASSED or ESCALATED.
- Code review via `tsh-code-reviewer` starts only after the UI verification gate clears, and is reported separately.
- Solution changes and deviations are recorded in the plan Changelog.

## Connected Skills

- `tsh-technical-context-discovering` — defines when existing Technical Context is sufficient.
- `tsh-code-reviewing` — strengthens the final review gate.
- `tsh-ui-verifying` — the verification standard behind the per-item UI review gate.
- `tsh-task-analysing` — determines whether research context is complete before planning.
- `tsh-task-quality-reviewing` — reinforces explicit gaps, edge cases, and task completeness.
- `tsh-creating-implementation-plans` — owns the plan template and structure rules.
