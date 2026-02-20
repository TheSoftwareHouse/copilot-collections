---
sidebar_position: 1
title: Use Cases
---

# Use Cases

:::info The AI Productivity Gap
According to Gartner, only **10% of software engineers** see meaningful productivity improvement from AI tools. The gap isn't the technology — it's the lack of structure, specialization, and repeatable workflows around it. Copilot Collections bridges that gap by turning AI potential into real delivery gains.
:::

Real-world problems that Copilot Collections solves for development teams.

---

## 1. Onboarding New Team Members

**Problem:** New developers join a project and spend days understanding the codebase, conventions, and task requirements before they can contribute.

**Solution:** The `/research` prompt + Business Analyst agent automatically gathers context from Jira, Confluence, Figma, and the codebase. The `/plan` prompt + Architect agent creates a step-by-step implementation plan. New developers get a structured understanding of the task and a clear path forward within **minutes instead of days**.

---

## 2. Inconsistent Code Quality Across Teams

**Problem:** Different developers follow different patterns, leading to inconsistent codebases that are hard to maintain. Code reviews catch issues late in the cycle.

**Solution:** Skills like `technical-context-discovery`, `code-review`, and `frontend-implementation` encode tested best practices. The Code Reviewer agent enforces them automatically. The `/code-quality-check` prompt detects dead code, duplications, and anti-patterns repository-wide.

---

## 3. UI Implementation Doesn't Match Designs

**Problem:** Frontend implementations deviate from Figma designs — wrong spacing, colors, component variants. QA catches these late, causing rework.

**Solution:** The `/implement-ui` prompt runs an automated Figma verification loop (up to 5 iterations) comparing the running app via Playwright against Figma specs. The UI Reviewer agent provides structured PASS/FAIL reports with exact pixel values before the code ever reaches human review.

---

## 4. Flaky or Missing E2E Tests

**Problem:** E2E tests are written inconsistently, use brittle selectors, and break on unrelated changes. Teams don't trust them and skip them.

**Solution:** The E2E Engineer agent + `e2e-testing` skill enforces Page Object patterns, accessibility-first locators, dynamic test data, and a verification loop with flaky detection. Tests are verified for **3+ consecutive passes** before being committed.

---

## 5. Context Scattered Across Tools

**Problem:** Requirements live in Jira, designs in Figma, documentation in Confluence, code in GitHub. Developers constantly context-switch to gather information.

**Solution:** MCP integrations (Atlassian, Figma, Context7, Playwright) bring all context into a single Copilot chat session. The Business Analyst agent synthesizes information from all sources into one research document.

---

## 6. Lack of Structured Delivery Workflow

**Problem:** Teams lack a consistent process. Some devs jump straight to coding, skip planning, and produce code that doesn't fully meet requirements. Reviews are ad-hoc.

**Solution:** The enforced **Research → Plan → Implement → Review** workflow ensures every task goes through proper analysis, planning, implementation, and review. Each phase produces a documented artifact that feeds the next phase.

---

## 7. Security and Best Practices Are Afterthoughts

**Problem:** Security reviews happen at the end of a sprint — if at all. Best practices like DRY, KISS, and proper error handling are inconsistently applied.

**Solution:** Every plan includes security considerations. The Code Reviewer agent checks for security vulnerabilities, missing input validation, and exposed secrets. The SQL & Database skill enforces least-privilege, parameterized queries, and proper indexing.

---

## 8. Database Schema and Query Quality Issues

**Problem:** ORMs hide performance problems. Developers create schemas without proper indexes, normalisation, or migration safety checks.

**Solution:** The `sql-and-database` skill provides comprehensive patterns for schema design (naming conventions, PK strategies, normalisation), indexing strategies, join optimization, locking mechanics, and query debugging with `EXPLAIN ANALYZE`. Supports TypeORM, Prisma, Doctrine, Eloquent, Entity Framework, Hibernate, and GORM.
