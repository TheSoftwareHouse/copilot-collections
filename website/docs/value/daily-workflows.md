---
sidebar_position: 3
title: Daily Developer Workflows
---

# Daily Developer Workflows

:::tip From Theory to Practice
This page shows how developers integrate Copilot Collections into their daily routines. Each workflow maps a real developer need to the specific agents, prompts, and skills that address it — so you can see exactly where the framework adds value.
:::

---

## 1. Understanding How the Code Works

**When:** You pick up a ticket in an unfamiliar part of the codebase, inherit a legacy module, or need to trace a bug across multiple services.

**The old way:** Open dozens of files, grep for function names, read outdated Confluence pages, ask colleagues on Slack, and piece together a mental model over hours.

**With Copilot Collections:**

```text
/research PROJ-456
```

| Step | What Happens |
|---|---|
| **1. Automatic context gathering** | The Business Analyst agent pulls requirements from Jira, related Confluence docs, and Figma designs via MCP integrations. |
| **2. Codebase analysis** | The `codebase-analysis` skill traces dependencies, identifies business logic patterns, and maps the data flow across layers. |
| **3. Structured output** | A `.research.md` document is generated with a task summary, identified components, assumptions, open questions, and risks. |

**Key prompts & agents:** `/research` → Business Analyst  
**Key skills:** `codebase-analysis`, `technical-context-discovery`

**Value:** What used to take hours of manual exploration is compressed into minutes. The research document becomes a reusable artifact that helps the entire team — not just you.

---

## 2. Designing Architecture for a New Feature

**When:** You need to add a new module, design an API, restructure existing services, or plan a database migration.

**The old way:** Sketch something in a quick meeting, start coding, discover edge cases mid-sprint, refactor, repeat.

**With Copilot Collections:**

```text
/research PROJ-789
# Review the research doc, then:
/plan PROJ-789
```

| Step | What Happens |
|---|---|
| **1. Research phase** | Business Analyst gathers all context — existing architecture, related features, constraints from Jira and Confluence. |
| **2. Architecture design** | The Architect agent creates a phased implementation plan with CREATE/MODIFY/REUSE labels for every task. |
| **3. Gap analysis** | The `architecture-design` skill evaluates security considerations, scalability, and identifies risks before a single line of code is written. |
| **4. Database planning** | If the feature involves data changes, the `sql-and-database` skill provides schema design patterns, indexing strategies, and migration safety checks. |

**Key prompts & agents:** `/research` → Business Analyst, `/plan` → Architect  
**Key skills:** `architecture-design`, `sql-and-database`, `technical-context-discovery`

**Value:** Architecture decisions are documented, reviewed, and agreed upon before implementation starts. Every task is clearly scoped with action labels (CREATE, MODIFY, REUSE), reducing mid-sprint surprises by 50–70%.

---

## 3. Delivering Pixel-Perfect Frontend

**When:** You're implementing a UI component from a Figma design and need it to match exactly — spacing, typography, colors, responsive behavior, and accessibility.

**The old way:** Eyeball the Figma spec, implement the component, get "doesn't match" feedback in design review, fix, re-submit, repeat 3–5 times.

**With Copilot Collections:**

```text
/implement-ui PROJ-321
```

| Step | What Happens |
|---|---|
| **1. Figma extraction** | The agent reads exact design specs from Figma MCP — spacing values, color tokens, typography, component variants. |
| **2. Implementation** | Code is written following the `frontend-implementation` skill — semantic HTML, design system tokens, a11y patterns. |
| **3. Automated verification loop** | `/review-ui` is called automatically. Playwright captures the running app; Figma MCP provides expected values. A structured PASS/FAIL diff table is generated. |
| **4. Auto-fix cycle** | If FAIL, the agent fixes mismatches and re-verifies — up to 5 iterations — until the component passes or escalates. |

**Key prompts & agents:** `/implement-ui` → Software Engineer, `/review-ui` → UI Reviewer  
**Key skills:** `frontend-implementation`, `ui-verification`, `technical-context-discovery`

**Value:** Design-to-code accuracy reaches 95–99%. Design QA feedback rounds are reduced by 60–80%. Accessibility compliance is built in from the start, not bolted on after review.

---

## 4. Increasing Test Coverage and Quality

**When:** You need to add E2E tests for a new feature, improve coverage for an existing flow, or fix flaky tests that the team no longer trusts.

**The old way:** Write tests with brittle CSS selectors, fight with timing issues, add `waitForTimeout` hacks, watch tests pass locally but fail in CI.

**With Copilot Collections:**

```text
/e2e PROJ-654
```

| Step | What Happens |
|---|---|
| **1. Test scenario design** | The E2E Engineer agent analyzes the feature, maps acceptance criteria to test scenarios, and identifies critical user journeys. |
| **2. Page Object creation** | Reusable page abstractions are created with accessibility-first locators (`getByRole`, `getByLabel`, `getByText`). |
| **3. Test implementation** | Tests follow BDD-style Arrange-Act-Assert structure with dynamic test data (timestamps/UUIDs) — no shared state between tests. |
| **4. Stability verification** | Tests must pass **3+ consecutive times** in headless mode before being committed. Flaky detection is built into the verification loop. |

**Key prompts & agents:** `/e2e` → E2E Engineer  
**Key skills:** `e2e-testing`, `technical-context-discovery`

**Value:** E2E test flakiness is reduced by 50–80%. Tests use proper auto-waiting assertions instead of arbitrary timeouts. Page Object patterns make tests maintainable and resistant to UI refactors.

---

## 5. Finding Implementation Gaps

**When:** You've finished coding a feature and want to verify that everything in the plan was actually implemented — no missed edge cases, no forgotten acceptance criteria.

**The old way:** Manually cross-reference the Jira ticket, the implementation plan, and your code changes. Hope you didn't miss anything. Find out during QA.

**With Copilot Collections:**

```text
/review PROJ-456
```

| Step | What Happens |
|---|---|
| **1. Plan-to-code comparison** | The Code Reviewer agent compares the implementation against the original plan, checking every phase and acceptance criterion. |
| **2. Gap detection** | The `implementation-gap-analysis` skill identifies what was planned but not implemented, what was implemented but not planned, and what was partially done. |
| **3. Structured findings** | A review report lists blockers (must fix), suggestions (should fix), and passes — with specific file and line references. |

**Key prompts & agents:** `/review` → Code Reviewer  
**Key skills:** `implementation-gap-analysis`, `code-review`, `technical-context-discovery`

**Value:** Rework cycles are reduced by 40–60%. Gaps are caught before QA, not during. Every review is structured and consistent, regardless of who performs it.

---

## 6. Finding Gaps in Task Descriptions

**When:** You receive a Jira ticket with vague requirements, missing acceptance criteria, or conflicting information across Jira, Figma, and Confluence.

**The old way:** Start implementing with assumptions. Discover ambiguities halfway through. Go back to the PM. Lose half a sprint.

**With Copilot Collections:**

```text
/research PROJ-101
```

| Step | What Happens |
|---|---|
| **1. Multi-source aggregation** | The Business Analyst agent pulls context from Jira, Confluence, Figma, and the codebase simultaneously via MCP integrations. |
| **2. Contradiction detection** | The `task-analysis` skill cross-references requirements across sources and flags inconsistencies, missing details, and ambiguous language. |
| **3. Open questions list** | The research document includes a structured list of open questions, assumptions that need validation, and risks — ready to send back to the PM. |
| **4. Scope validation** | The output highlights what's covered by the ticket and what's missing, so you can request clarification before writing a single line of code. |

**Key prompts & agents:** `/research` → Business Analyst  
**Key skills:** `task-analysis`, `codebase-analysis`

**Value:** Ambiguities are surfaced in minutes instead of days. The structured open questions list becomes a communication tool with PMs, reducing back-and-forth by 60–80%.

---

## 7. Performing Thorough Code Reviews

**When:** You're reviewing a colleague's PR and want to go beyond surface-level "looks good to me" — checking for security, performance, correctness, and adherence to project standards.

**The old way:** Skim the diff, check for obvious bugs, approve. Miss the SQL injection, the missing error handling, and the N+1 query.

**With Copilot Collections:**

```text
/review PROJ-789
```

| Step | What Happens |
|---|---|
| **1. Multi-dimensional analysis** | The Code Reviewer agent checks acceptance criteria, security vulnerabilities, reliability, performance, maintainability, and coding standards. |
| **2. Security scanning** | Missing input validation, exposed secrets, improper error handling, and SQL injection vectors are flagged explicitly. |
| **3. Database review** | The `sql-and-database` skill checks for missing indexes, N+1 queries, improper locking, and migration safety. |
| **4. Structured verdict** | Findings are categorized as PASS, BLOCKER, or SUGGESTION — with clear explanations and remediation guidance. |

**Key prompts & agents:** `/review` → Code Reviewer  
**Key skills:** `code-review`, `sql-and-database`, `technical-context-discovery`

**Value:** Reviews are consistent, thorough, and documented. Security and performance issues are caught before production. Review cycle time is reduced by 30–50%.

---

## 8. Cleaning Up Technical Debt

**When:** The codebase has accumulated dead code, duplicated logic, inconsistent patterns, and outdated dependencies. You need a systematic cleanup plan.

**The old way:** Nobody knows where the dead code is. Duplicate utilities are scattered across packages. "We'll clean it up later" never comes.

**With Copilot Collections:**

```text
/code-quality-check
```

| Step | What Happens |
|---|---|
| **1. Full codebase scan** | The Architect agent runs parallel analysis across all layers — frontend, backend, shared libraries. |
| **2. Dead code detection** | Identifies unused imports, unreachable code paths, deprecated functions, and files not imported anywhere. |
| **3. Duplication mapping** | Finds duplicated functions, validation logic, UI components, and copy-pasted blocks that differ only in variable names. |
| **4. Improvement roadmap** | Generates a prioritized list of improvements — high cyclomatic complexity, SRP violations, excessive `any` types, missing error handling. |

**Key prompts & agents:** `/code-quality-check` → Architect  
**Key skills:** `codebase-analysis`, `technical-context-discovery`

**Value:** Technical debt becomes visible and quantifiable. Cleanup is prioritized by impact. Teams can tackle debt systematically with a clear roadmap instead of random ad-hoc fixes.

---

## 9. Onboarding to a New Project

**When:** You're joining a new team or project and need to become productive fast — understanding the tech stack, project conventions, architecture, and current state of the codebase.

**The old way:** Read a stale README, ask teammates for a walkthrough, spend the first week just getting oriented.

**With Copilot Collections:**

```text
/code-quality-check
# Then pick your first task:
/research PROJ-001
/plan PROJ-001
```

| Step | What Happens |
|---|---|
| **1. Codebase health snapshot** | `/code-quality-check` gives you an immediate understanding of the codebase — its structure, patterns, tech stack, and quality issues. |
| **2. Convention discovery** | The `technical-context-discovery` skill identifies project conventions, coding standards, and established patterns — you learn how this team works. |
| **3. Guided first task** | `/research` and `/plan` on your first ticket produce a structured analysis and step-by-step implementation plan, so you deliver with confidence. |

**Key prompts & agents:** `/code-quality-check` → Architect, `/research` → Business Analyst, `/plan` → Architect  
**Key skills:** `technical-context-discovery`, `codebase-analysis`, `architecture-design`

**Value:** Onboarding time is reduced by 40–60%. New developers deliver their first meaningful PR days earlier. They absorb project conventions automatically instead of learning them through review feedback.

---

## 10. Planning Database Changes Safely

**When:** You need to add tables, modify schemas, write complex queries, or plan a database migration with zero downtime.

**The old way:** Write the migration, run it in staging, hope nothing breaks. Discover missing indexes in production. ORM hides the N+1 query until load testing.

**With Copilot Collections:**

```text
/research PROJ-555
/plan PROJ-555
/implement PROJ-555
```

| Step | What Happens |
|---|---|
| **1. Schema analysis** | The research phase identifies existing tables, relationships, and constraints affected by the change. |
| **2. Migration planning** | The Architect agent designs the migration with rollback strategies, following naming conventions and normalisation best practices. |
| **3. Query optimization** | The `sql-and-database` skill enforces `EXPLAIN ANALYZE`, proper indexing, join optimization, and parameterized queries. |
| **4. ORM integration** | Supports TypeORM, Prisma, Doctrine, Eloquent, Entity Framework, Hibernate, and GORM — generating idiomatic code for your stack. |

**Key prompts & agents:** `/research` → Business Analyst, `/plan` → Architect, `/implement` → Software Engineer  
**Key skills:** `sql-and-database`, `architecture-design`, `technical-context-discovery`

**Value:** Database performance issues are reduced by 40–60%. Migrations are planned with rollback strategies from the start. N+1 queries and missing indexes are caught during implementation, not in production.

---

## Quick Reference: Workflow by Developer Need

| Developer Need | Primary Prompt | Agent | Key Skills |
|---|---|---|---|
| Understand unfamiliar code | `/research` | Business Analyst | `codebase-analysis`, `technical-context-discovery` |
| Design feature architecture | `/plan` | Architect | `architecture-design`, `sql-and-database` |
| Pixel-perfect UI implementation | `/implement-ui` | Software Engineer | `frontend-implementation`, `ui-verification` |
| Increase E2E test coverage | `/e2e` | E2E Engineer | `e2e-testing` |
| Find implementation gaps | `/review` | Code Reviewer | `implementation-gap-analysis`, `code-review` |
| Find gaps in task descriptions | `/research` | Business Analyst | `task-analysis`, `codebase-analysis` |
| Thorough code review | `/review` | Code Reviewer | `code-review`, `sql-and-database` |
| Clean up technical debt | `/code-quality-check` | Architect | `codebase-analysis` |
| Onboard to new project | `/code-quality-check` + `/research` | Architect + BA | `technical-context-discovery`, `codebase-analysis` |
| Safe database changes | `/plan` + `/implement` | Architect + SE | `sql-and-database`, `architecture-design` |
