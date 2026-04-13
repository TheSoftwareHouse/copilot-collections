---
sidebar_position: 4
title: Quick Wins
---

# Quick Wins

:::tip From Theory to Practice
This page shows how teams integrate Copilot Collections into their daily routines. Each workflow maps a real need to the specific agents, prompts, and skills that address it — organized by the role that benefits the most.
:::

---

## Product Managers & Business Analysts

### 1. Converting Workshop Materials into a Structured Backlog

**When:** Your team just finished a discovery workshop. You have a raw transcript, Figma boards, and scattered notes — and you need to turn them into a structured, prioritized backlog before the next sprint planning.

**The old way:** Manually re-read the transcript, extract action items into a spreadsheet, copy-paste into your task management tool one by one, miss half the edge cases, and spend the next grooming session fixing vague stories.

**With Copilot Collections:**

```text
/tsh-analyze-materials <paste transcript or attach materials>
```

| Step | What Happens |
|---|---|
| **1. Transcript processing** | The Business Analyst agent cleans the raw transcript — removes small talk, structures content by discussion topics, and extracts key decisions, action items, and open questions. |
| **2. Material analysis** | Figma designs are analyzed via Figma MCP for functional requirements. The codebase is scanned to understand what already exists. |
| **3. Task extraction** | Epics and user stories are identified with business-oriented descriptions, acceptance criteria, dependencies, and priority suggestions. |
| **4. Gate 1 — Your review** | You review the extracted tasks. Split, merge, add, or remove stories until the breakdown matches what was discussed. |
| **5. Quality review (10 passes)** | The `tsh-task-quality-reviewing` skill automatically runs 10 analysis passes — entity lifecycle completeness, error states, notification gaps, third-party boundaries, platform operations, and more. |
| **6. Gate 1.5 — Accept/reject suggestions** | Each quality improvement is presented individually. You accept what makes sense and reject what doesn't apply. |
| **7. Task formatting & push** | Tasks are formatted per the benchmark template for the target tool. After your final approval (Gate 2), epics and stories are created in Jira or Shortcut with proper linking (via the Knowledge agent). |

**Key prompts & agents:** `/tsh-analyze-materials` → Business Analyst (delegates to Knowledge for task management operations)  
**Key skills:** `tsh-transcript-processing`, `tsh-task-extracting`, `tsh-task-quality-reviewing`, `tsh-task-formatting`, `tsh-codebase-analysing`

**Value:** A full discovery workshop is converted into a validated backlog in a single session instead of days of manual work. The 10-pass quality review catches edge cases and gaps that manual extraction routinely misses — missing error states, notification gaps, incomplete entity lifecycles, and platform operations. The three-gate review process ensures nothing reaches your task management tool without your approval.

---

### 2. Finding Gaps in Task Descriptions

**When:** You receive a Jira ticket with vague requirements, missing acceptance criteria, or conflicting information across Jira, Figma, and Confluence.

**The old way:** Start implementing with assumptions. Discover ambiguities halfway through. Go back to the PM. Lose half a sprint.

**With Copilot Collections:**

```text
/tsh-implement PROJ-101
```

| Step | What Happens |
|---|---|
| **1. Automatic research** | As part of the internal research phase, the Context Engineer agent pulls context from Jira, Confluence, Figma, and the codebase simultaneously via MCP integrations. |
| **2. Contradiction detection** | The `tsh-task-analysing` skill cross-references requirements across sources and flags inconsistencies, missing details, and ambiguous language. |
| **3. Open questions list** | The research document includes a structured list of open questions, assumptions that need validation, and risks — ready to send back to the PM. |
| **4. Scope validation** | The output highlights what's covered by the ticket and what's missing, so you can request clarification before proceeding to implementation. |

**Key prompts & agents:** `/tsh-implement` → Engineering Manager → Context Engineer (research phase)
**Key skills:** `tsh-task-analysing`, `tsh-codebase-analysing`

**Value:** Ambiguities are surfaced in minutes instead of days. The structured open questions list becomes a communication tool with PMs, reducing back-and-forth by 60–80%.

---

## Developers

### 3. Understanding How the Code Works

**When:** You pick up a ticket in an unfamiliar part of the codebase, inherit a legacy module, or need to trace a bug across multiple services.

**The old way:** Open dozens of files, grep for function names, read outdated Confluence pages, ask colleagues on Slack, and piece together a mental model over hours.

**With Copilot Collections:**

```text
/tsh-implement PROJ-456
```

| Step | What Happens |
|---|---|
| **1. Automatic context gathering** | During the internal research phase, the Context Engineer agent pulls requirements from Jira, related Confluence docs, and Figma designs via MCP integrations. |
| **2. Codebase analysis** | The `tsh-codebase-analysing` skill traces dependencies, identifies business logic patterns, and maps the data flow across layers. |
| **3. Structured output** | A `.research.md` document is generated with a task summary, identified components, assumptions, open questions, and risks. |

**Key prompts & agents:** `/tsh-implement` → Engineering Manager → Context Engineer (research phase)
**Key skills:** `tsh-task-analysing`, `tsh-codebase-analysing`

**Value:** The research document becomes a reusable artifact that helps the entire team — not just you.

---

### 4. Designing Architecture for a New Feature

**When:** You need to add a new module, design an API, restructure existing services, or plan a database migration.

**The old way:** Sketch something in a quick meeting, start coding, discover edge cases mid-sprint, refactor, repeat.

**With Copilot Collections:**

```text
/tsh-implement PROJ-789
```

| Step | What Happens |
|---|---|
| **1. Research phase** | The internal research phase gathers all context — existing architecture, related features, constraints from Jira and Confluence. |
| **2. Architecture design** | During the internal planning phase, the Architect agent creates a phased implementation plan with CREATE/MODIFY/REUSE labels for every task. |
| **3. Gap analysis** | The `tsh-architecture-designing` skill evaluates security considerations, scalability, and identifies risks before a single line of code is written. |
| **4. Database planning** | If the feature involves data changes, the `tsh-sql-and-database-understanding` skill provides schema design patterns, indexing strategies, and migration safety checks. |

**Key prompts & agents:** `/tsh-implement` → Engineering Manager → Context Engineer (research) → Architect (planning)
**Key skills:** `tsh-architecture-designing`, `tsh-sql-and-database-understanding`, `tsh-codebase-analysing`

**Value:** Architecture decisions are documented, reviewed, and agreed upon before implementation starts. Every task is clearly scoped with action labels (CREATE, MODIFY, REUSE), reducing mid-sprint surprises by 50–70%.

---

### 5. Delivering Pixel-Perfect Frontend

**When:** You're implementing a UI component from a Figma design and need it to match exactly — spacing, typography, colors, responsive behavior, and accessibility.

**The old way:** Eyeball the Figma spec, implement the component, get "doesn't match" feedback in design review, fix, re-submit, repeat 3–5 times.

**With Copilot Collections:**

```text
/tsh-implement PROJ-321
```

| Step | What Happens |
|---|---|
| **1. Figma extraction** | The agent reads exact design specs from Figma MCP — spacing values, color tokens, typography, component variants. |
| **2. Implementation** | Code is written following the `tsh-implementing-frontend` skill — semantic HTML, design system tokens, a11y patterns. |
| **3. Automated verification loop** | `/tsh-review-ui` is called automatically. Playwright captures the running app; Figma MCP provides expected values. A structured PASS/FAIL diff table is generated. |
| **4. Auto-fix cycle** | If FAIL, the agent fixes mismatches and re-verifies — up to 5 iterations — until the component passes or escalates. |

**Key prompts & agents:** `/tsh-implement` → Engineering Manager → Software Engineer, `/tsh-review-ui` → UI Reviewer  
**Key skills:** `tsh-implementing-frontend`, `tsh-ui-verifying`, `tsh-technical-context-discovering`

**Value:** Design-to-code accuracy reaches 95–99%. Design QA feedback rounds are reduced by 60–80%. Accessibility compliance is built in from the start, not bolted on after review.

---

### 6. Planning Database Changes Safely

**When:** You need to add tables, modify schemas, write complex queries, or plan a database migration with zero downtime.

**The old way:** Write the migration, run it in staging, hope nothing breaks. Discover missing indexes in production. ORM hides the N+1 query until load testing.

**With Copilot Collections:**

```text
/tsh-implement PROJ-555
```

| Step | What Happens |
|---|---|
| **1. Schema analysis** | The internal research phase identifies existing tables, relationships, and constraints affected by the change. |
| **2. Migration planning** | During the internal planning phase, the Architect agent designs the migration with rollback strategies, following naming conventions and normalisation best practices. |
| **3. Query optimization** | The `tsh-sql-and-database-understanding` skill enforces `EXPLAIN ANALYZE`, proper indexing, join optimization, and parameterized queries. |
| **4. ORM integration** | Supports TypeORM, Prisma, Doctrine, Eloquent, Entity Framework, Hibernate, and GORM — generating idiomatic code for your stack. |

**Key prompts & agents:** `/tsh-implement` → Engineering Manager → Context Engineer (research) → Architect (planning) → Software Engineer (implementation)  
**Key skills:** `tsh-sql-and-database-understanding`, `tsh-architecture-designing`, `tsh-technical-context-discovering`

**Value:** Database performance issues are reduced by 40–60%. Migrations are planned with rollback strategies from the start. N+1 queries and missing indexes are caught during implementation, not in production.

---

## Tech Leads & Engineering Managers

### 7. Performing Thorough Code Reviews

**When:** You're reviewing a colleague's PR and want to go beyond surface-level "looks good to me" — checking for security, performance, correctness, and adherence to project standards.

**The old way:** Skim the diff, check for obvious bugs, approve. Miss the SQL injection, the missing error handling, and the N+1 query.

**With Copilot Collections:**

```text
/tsh-review PROJ-789
```

| Step | What Happens |
|---|---|
| **1. Multi-dimensional analysis** | The Code Reviewer agent checks acceptance criteria, security vulnerabilities, reliability, performance, maintainability, and coding standards. |
| **2. Security scanning** | Missing input validation, exposed secrets, improper error handling, and SQL injection vectors are flagged explicitly. |
| **3. Database review** | The `tsh-sql-and-database-understanding` skill checks for missing indexes, N+1 queries, improper locking, and migration safety. |
| **4. Structured verdict** | Findings are categorized as PASS, BLOCKER, or SUGGESTION — with clear explanations and remediation guidance. |

**Key prompts & agents:** `/tsh-review` → Code Reviewer  
**Key skills:** `tsh-code-reviewing`, `tsh-sql-and-database-understanding`, `tsh-technical-context-discovering`

**Value:** Reviews are consistent, thorough, and documented. Security and performance issues are caught before production. Review cycle time is reduced by 30–50%.

---

### 8. Finding Implementation Gaps

**When:** You've finished coding a feature and want to verify that everything in the plan was actually implemented — no missed edge cases, no forgotten acceptance criteria.

**The old way:** Manually cross-reference the Jira ticket, the implementation plan, and your code changes. Hope you didn't miss anything. Find out during QA.

**With Copilot Collections:**

```text
/tsh-review PROJ-456
```

| Step | What Happens |
|---|---|
| **1. Plan-to-code comparison** | The Code Reviewer agent compares the implementation against the original plan, checking every phase and acceptance criterion. |
| **2. Gap detection** | The `tsh-implementation-gap-analysing` skill identifies what was planned but not implemented, what was implemented but not planned, and what was partially done. |
| **3. Structured findings** | A review report lists blockers (must fix), suggestions (should fix), and passes — with specific file and line references. |

**Key prompts & agents:** `/tsh-review` → Code Reviewer  
**Key skills:** `tsh-implementation-gap-analysing`, `tsh-code-reviewing`, `tsh-technical-context-discovering`

**Value:** Rework cycles are reduced by 40–60%. Gaps are caught before QA, not during. Every review is structured and consistent, regardless of who performs it.

---

### 9. Cleaning Up Technical Debt

**When:** The codebase has accumulated dead code, duplicated logic, inconsistent patterns, and outdated dependencies. You need a systematic cleanup plan.

**The old way:** Nobody knows where the dead code is. Duplicate utilities are scattered across packages. "We'll clean it up later" never comes.

**With Copilot Collections:**

```text
/tsh-review-codebase
```

| Step | What Happens |
|---|---|
| **1. Full codebase scan** | The Architect agent runs parallel analysis across all layers — frontend, backend, shared libraries. |
| **2. Dead code detection** | Identifies unused imports, unreachable code paths, deprecated functions, and files not imported anywhere. |
| **3. Duplication mapping** | Finds duplicated functions, validation logic, UI components, and copy-pasted blocks that differ only in variable names. |
| **4. Improvement roadmap** | Generates a prioritized list of improvements — high cyclomatic complexity, SRP violations, excessive `any` types, missing error handling. |

**Key prompts & agents:** `/tsh-review-codebase` → Architect  
**Key skills:** `tsh-codebase-analysing`, `tsh-technical-context-discovering`

**Value:** Technical debt becomes visible and quantifiable. Cleanup is prioritized by impact. Teams can tackle debt systematically with a clear roadmap instead of random ad-hoc fixes.

---

### 10. Onboarding New Team Members

**When:** You're joining a new team or project and need to become productive fast — understanding the tech stack, project conventions, architecture, and current state of the codebase.

**The old way:** Read a stale README, ask teammates for a walkthrough, spend the first week just getting oriented.

**With Copilot Collections:**

```text
/tsh-review-codebase
# Then pick your first task:
/tsh-implement PROJ-001
```

| Step | What Happens |
|---|---|
| **1. Codebase health snapshot** | `/tsh-review-codebase` gives you an immediate understanding of the codebase — its structure, patterns, tech stack, and quality issues. |
| **2. Convention discovery** | The `tsh-technical-context-discovering` skill identifies project conventions, coding standards, and established patterns — you learn how this team works. |
| **3. Guided first task** | `/tsh-implement` on your first ticket performs automatic research and planning, then produces a step-by-step implementation — so you deliver with confidence. |

**Key prompts & agents:** `/tsh-review-codebase` → Architect, `/tsh-implement` → Engineering Manager → Context Engineer → Architect → Software Engineer  
**Key skills:** `tsh-technical-context-discovering`, `tsh-codebase-analysing`, `tsh-architecture-designing`

**Value:** Onboarding time is reduced by 40–60%. New developers deliver their first meaningful PR days earlier. They absorb project conventions automatically instead of learning them through review feedback.

---

## QA Engineers

### 11. Increasing Test Coverage and Quality

**When:** You need to add E2E tests for a new feature, improve coverage for an existing flow, or fix flaky tests that the team no longer trusts.

**The old way:** Write tests with brittle CSS selectors, fight with timing issues, add `waitForTimeout` hacks, watch tests pass locally but fail in CI.

**With Copilot Collections:**

```text
/tsh-implement Add E2E tests for the checkout flow in PROJ-654
```

:::tip
When the implementation plan contains E2E test tasks, the Engineering Manager automatically delegates them to the E2E Engineer agent. You don't need to invoke E2E testing separately — just use `/tsh-implement`.
:::

| Step | What Happens |
|---|---|
| **1. Test scenario design** | The E2E Engineer agent analyzes the feature, maps acceptance criteria to test scenarios, and identifies critical user journeys. |
| **2. Page Object creation** | Reusable page abstractions are created with accessibility-first locators (`getByRole`, `getByLabel`, `getByText`). |
| **3. Test implementation** | Tests follow BDD-style Arrange-Act-Assert structure with dynamic test data (timestamps/UUIDs) — no shared state between tests. |
| **4. Stability verification** | Tests must pass **3+ consecutive times** in headless mode before being committed. Flaky detection is built into the verification loop. |

**Key prompts & agents:** `/tsh-implement` → Engineering Manager → E2E Engineer  
**Key skills:** `tsh-e2e-testing`, `tsh-technical-context-discovering`

**Value:** E2E test flakiness is reduced by 50–80%. Tests use proper auto-waiting assertions instead of arbitrary timeouts. Page Object patterns make tests maintainable and resistant to UI refactors.

---

## DevOps & SRE Engineers

### 12. Auditing Cloud Costs

**When:** Your cloud bill keeps growing and nobody knows exactly where the money is going. Unused resources, over-provisioned instances, and missing reserved instance commitments are likely costing thousands per month.

**The old way:** Export cost reports from the console, manually cross-reference with running resources, build spreadsheets, present them in a meeting, and then nothing changes.

**With Copilot Collections:**

```text
/tsh-analyze-aws-costs us-east-1 everything
```

| Step | What Happens |
|---|---|
| **1. IaC analysis** | The DevOps Engineer agent scans Terraform and CloudFormation templates for over-provisioned resources, missing savings plan opportunities, and tagging gaps. |
| **2. Live infrastructure validation** | AWS API MCP queries actual resource usage — identifying orphaned EBS volumes, idle load balancers, and underutilized instances. |
| **3. Cost report** | A prioritized optimization report is generated with estimated monthly savings and specific CLI or Terraform changes for each recommendation. |

**Key prompts & agents:** `/tsh-analyze-aws-costs` or `/tsh-analyze-gcp-costs` → DevOps Engineer
**Key skills:** `tsh-optimizing-cloud-cost`

**Value:** Uncovers 20–40% potential cost savings. Tagging compliance gaps are identified for proper cost attribution. The hybrid approach (IaC + live API) catches both planned and untracked waste.

---

### 13. Provisioning Infrastructure Safely

**When:** You need to create new cloud resources, set up a Kubernetes cluster, configure a CI/CD pipeline, or implement monitoring — and you want to follow production-ready patterns from the start.

**The old way:** Copy Terraform from a blog post, skip cost estimation, realize the naming doesn't match your conventions, spend a day refactoring.

**With Copilot Collections:**

```text
/tsh-implement Create a VPC with public and private subnets for EKS
/tsh-implement Deploy the payment service with HPA and PDB
/tsh-implement Create GitHub Actions CI/CD for the monorepo
```

| Step | What Happens |
|---|---|
| **1. Delegation** | The Engineering Manager reads the plan and delegates infrastructure tasks to the DevOps Engineer. |
| **2. Context discovery** | The DevOps Engineer discovers existing IaC patterns, naming conventions, tagging policies, and CI/CD platform. |
| **3. Implementation** | Infrastructure code is written following project conventions with proper naming, tagging, cost estimation, and safety guardrails. |
| **4. Safety checks** | `terraform plan`, `--dry-run`, or `validate` is run before any changes. Destructive operations require explicit authorization. |

**Key prompt:** `/tsh-implement` → Engineering Manager delegates to DevOps Engineer
**Key skills:** `tsh-implementing-terraform-modules`, `tsh-implementing-kubernetes`, `tsh-implementing-ci-cd`, `tsh-managing-secrets`

**Value:** Infrastructure follows production patterns from day one. Cost estimation is built into every proposal. Safety guardrails prevent accidental destruction. Reusable modules reduce duplication across projects.


