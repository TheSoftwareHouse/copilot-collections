---
sidebar_position: 4
title: Engineering Manager
---

**File:** `.github/agents/tsh-engineering-manager.agent.md`

The Engineering Manager is the orchestration seat for implementation delivery. It defines **WHO** does the work — persona, delegation boundaries, ambiguity handling, and tool discipline — and never writes product code itself. The actual workflow mechanics (flow selection, planning readiness, execution routing, and quality gates) live in the `tsh-orchestrating-implementation` skill, not in the agent.

It runs on the **Claude Sonnet 5** model, keeping the orchestration seat cost-efficient while high-leverage decisions are escalated to the **Architect**.

## How to Use

The Engineering Manager works from two entry points:

- **Directly** — invoke the agent in chat with a task description, Jira ID, or implementation plan.
- **Via [`/tsh-implement`](../prompts/public/implement)** — the public prompt routes to the agent on the same model.

For any request whose intent is to deliver implementation changes, the agent loads the `tsh-orchestrating-implementation` skill and starts at **Step 0** (creating flow-start todos). Information-only, advisory-only, and standalone review- or research-only requests do not trigger the workflow.

## Workflow Skill

All workflow mechanics are owned by a single canonical skill:

- `tsh-orchestrating-implementation` — flow-start todos (Step 0), flow selection (Step 1), Quick vs Full Flow, planning readiness, todo protocol, upfront execution plan, delegated execution routing, and review/UI-verification gates.

### Step 0 — Start with Todos

The skill begins by creating the todos needed for the selected flow: one todo per orchestration action in Quick Flow, or one todo per plan task, review loop, `[REUSE]` UI verification item, and final gate in Full Flow.

### Step 1 — Assess Complexity and Recommend a Flow

The skill then assesses complexity and recommends a flow (the user can override):

- **Quick Flow** — narrow, single-domain change with an obvious solution, ~3 files or fewer, no ambiguity, no missing research/plan, and **no Figma/UI-verification involvement**.
- **Full Flow** — cross-domain work, unclear requirements, architectural change, missing research or plan, larger scope, or **any Figma/UI-verification involvement** (a hard exclusion from Quick Flow).

## Architect Consultation

The agent escalates to the **Architect** when:

- Requirements, constraints, or acceptance criteria are ambiguous or internally inconsistent.
- The plan leaves material technical decisions unresolved.
- Task ownership spans architecture, platform, backend, frontend, or prompt concerns.
- An unexpected issue, tradeoff, or design conflict surfaces.
- It is unclear whether a shortcut is acceptable, or one reasoning pass is not enough to defend the next step.

## Delegation Roster

| Agent | Delegate when |
| --- | --- |
| **Software Engineer** | Backend, frontend, API, database, business logic, or accessibility/UX work in application code |
| **E2E Engineer** | End-to-end test design, mocking strategy, or CI-ready test suites |
| **DevOps Engineer** | Infrastructure, Terraform, Kubernetes, CI/CD pipelines, or observability |
| **Architect** | Architectural guidance, codebase analysis, or a missing/incomplete plan |
| **Code Reviewer** | Reviewing implemented changes against the plan, tests, and acceptance criteria |
| **UI Reviewer** | Verifying implemented UI against Figma, including `[REUSE]` UI verification tasks |
| **Context Engineer** | Gathering requirements and context before the Architect can plan |
| **Prompt Engineer** | Designing, optimizing, or auditing LLM application prompts |

## Tool Access

| Tool | Usage |
| --- | --- |
| **Read / Search** | Locate plans, research, and files needed to route work correctly |
| **Atlassian** | Gather context from Jira/Confluence — only when issue keys or page IDs are provided |
| **Sequential Thinking** | Resolve non-obvious ownership and assess whether ambiguity needs Architect consultation |
| **Terminal (execute)** | Run validation, inspection, and quality-gate commands only — never as an editing workaround |
| **Sub-agents** | Delegate research, planning, implementation, review, and verification |
| **Todo** | Track multi-step delivery work as the progress-control surface |
| **VS Code Commands** | Support inspection or validation during orchestration |
| **Ask Questions** | Resolve real blocking ambiguity — used conditionally, not as a ritual gate |

The agent has **no direct document-editing tools**. Any file, plan, prompt, or product-code change is delegated to the appropriate specialist.

## Key Behaviors

- **Never writes product code** — always delegates implementation to a specialist.
- **Orchestrates through the skill** — flow selection and execution mechanics come from `tsh-orchestrating-implementation`, not the agent page.
- **Routes by ownership** — application code, infrastructure, tests, and prompts each go to their owning specialist.
- **Escalates ambiguity** — consults the Architect rather than guessing when the next step is not defensible.
- **Confirms conditionally** — asks the user only when a real blocker remains, not at every transition.
