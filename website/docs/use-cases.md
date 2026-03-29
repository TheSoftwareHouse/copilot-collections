---
sidebar_position: 8
title: Use Cases
---

# Use Cases

Nine scenarios where Copilot Collections changes how work actually gets done.

---

## Product Ideation

### Workshop transcripts → structured backlog in 15 minutes

You’ve just run a discovery workshop. The transcript is a mess of raw ideas, half-formed requirements, and branching conversations. Turning that into a well-structured, ticket-ready backlog normally takes a BA a day or two, if you have one. If you don’t, it falls to a developer or PM, and it shows.

The Business Analyst agent processes the raw materials end-to-end. Transcripts are cleaned and structured. Epics and user stories are extracted with acceptance criteria, edge cases, and dependencies surfaced. A 10-pass quality review checks for missing entity lifecycles, error states, notification gaps, and off-happy-path scenarios. Nothing reaches your task management tool (Jira or Shortcut) without passing a three-gate human review.

**~15 min vs 1–2 days**

---

### Backlog grooming that actually catches the gaps

Backlogs accumulate debt. Stories that made sense six months ago are now vague. Acceptance criteria were never written. Dependencies were assumed, not documented. Grooming sessions spend half their time reconstructing intent rather than improving work.

The Business Analyst agent’s Import Mode fetches existing issues from Jira or Shortcut, converts them to a local format, and runs the same quality review used for new workshop outputs. Each suggested improvement is presented individually for accept or reject. Approved changes push back to the task management tool automatically.

**~10 min per epic**

---

## Development

### New developer, productive from day one

A developer joins mid-sprint. The standard onboarding is: read the README, ask questions in Slack, try to figure out the conventions, come back in three days when you have something to show. The first week is expensive.

The Context Engineer agent gathers context from Jira or Shortcut, Confluence, Figma, and the codebase automatically. The Architect agent turns that context into a step-by-step implementation plan scoped to the actual ticket. New developers get a structured picture of the task — what exists, what needs to change, where to start - in minutes, not days.

**~5 min per task**

---

### One place for everything: Jira, Figma, docs, code

The information needed to implement any feature lives across four tools at minimum. Developers spend 30–60 minutes per task reconstructing context that already exists — just in different places.

MCP integrations (Atlassian, Shortcut, Figma, Context7, Playwright, PDF Reader) bring every source into a single Copilot chat session. The Context Engineer agent synthesises them into one research document. You start implementing with full context already assembled.

**~3 min vs 30–60 min**

---

### UI that matches the design, verified before review

Frontend implementations drift from Figma. Wrong spacing, wrong colour variants, wrong component state. The defects are caught in QA - which means a developer context-switches back to a ticket they thought was done, fixes it, and waits for another review cycle.

The UI Reviewer agent runs an automated verification loop (up to 5 iterations) that compares the running app against Figma specs via Playwright. You get a structured PASS/FAIL report with exact pixel deltas before the code ever reaches a human reviewer.

**~20 min per component · 95–99% design accuracy**

---

## Quality

### Code review that enforces standards, not just style

Every team has conventions that exist in someone's head. Senior developers catch violations in review. Juniors don't always know what to look for. The result is review comments that relitigate the same issues across every PR, and inconsistent codebases that get harder to maintain over time.

The Code Reviewer agent enforces tested best practices automatically - the same ones encoded in TSH's production skills (`tsh-technical-context-discovering`, `tsh-code-reviewing`, `tsh-implementing-frontend`). The `/tsh-review-codebase` prompt runs a repository-wide pass detecting dead code, duplications, and anti-patterns.

**~5 min per review**

---

### Security built into every plan, not bolted on at the end

Security reviews happen at the end of a sprint - when it's expensive to fix what they find. Input validation is missing. Error messages leak stack traces. Database queries are parameterised inconsistently. These issues don't fail tests. They accumulate.

Security considerations are built into every implementation plan, not reviewed after the fact. The Code Reviewer agent checks for vulnerabilities, exposed secrets, and missing validation on every review pass. The SQL & Database skill enforces least-privilege access, parameterised queries, and proper indexing as defaults.

**Built into every** `/tsh-implement` **plan phase and** `/tsh-review`

---

### E2E tests that pass reliably, every time

E2E tests written fast are often brittle. They use CSS selectors that break on visual changes. They depend on hardcoded test data. They pass three times, fail once, and nobody trusts them. Teams start skipping them. The safety net disappears.

The E2E Engineer agent enforces Page Object patterns, accessibility-first locators, and dynamic test data by default. A flaky detection step runs each test 3+ consecutive times before it's considered stable. You ship tests that actually hold.

**~10 min per test suite · 50–80% flakiness reduction**

---

## Infrastructure & DevOps

### Cloud, CI/CD, Kubernetes, Terraform with consistent standards

Infrastructure work has the same problem as application code: every team does it differently. Pipelines are copy-pasted and diverge. Kubernetes manifests miss health probes and resource limits. Terraform is rewritten from scratch per project. Cloud costs grow and nobody knows which resources are responsible.

The DevOps Engineer agent covers the full infrastructure lifecycle:

- **Cloud cost audits** - hybrid analysis of IaC code against live infrastructure; rightsizing recommendations, tagging compliance, savings plan coverage. ~10 min per audit.
- **Infrastructure security** - comprehensive audit across Terraform, Kubernetes, and CI/CD; findings prioritised by severity with specific remediation steps. ~15 min per audit.
- **CI/CD pipelines** — GitHub Actions, GitLab CI, or Bitbucket Pipelines built to your conventions, with caching, parallelisation, environment protection, and secure auth. ~15 min per pipeline.
- **Kubernetes deployments** — production-ready manifests with Helm charts, health probes, resource limits, scaling policies, and security configuration. ~10 min per deployment.
- **Terraform modules** - reusable modules with proper variable design, naming conventions, cost estimation, and state management. Covers AWS, Azure, and GCP. ~15 min per module.
- **Observability** - metrics, structured logging, distributed tracing, and alerting set up together. RED method, SLO tracking, alert severity by design. ~15 min per service.

---

## Extending the framework

### Build custom agents and skills for your team's domain

Generic AI tools don't know your codebase conventions, your internal tooling, or your team's specific way of working. That gap shows up as suggestions you have to discard, context you have to re-explain every session, and patterns that don't fit.

The Copilot Engineer and Copilot Orchestrator agents help you encode your team's domain knowledge into the framework itself — custom agents, skills, prompts, and instructions that persist across sessions. The `/tsh-create-custom-*` commands guide the process: research the domain, create the artifact, review for consistency with the existing framework.

**~15 min per custom artifact**
