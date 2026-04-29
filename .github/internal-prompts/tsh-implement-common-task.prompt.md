---
agent: "tsh-software-engineer"
model: "Claude Opus 4.6"
description: "Implement common feature according to the plan."
---

Your goal is to implement the feature according to the provided implementation plan and feature context.

Thoroughly review the implementation plan and feature context before starting the implementation. Ensure a clear understanding of the requirements and technical designs to deliver effective solutions.

Use available tools to gather necessary information and document your findings.

Don't deviate from the implementation plan. Follow it step by step to ensure all requirements are met.

If you need to make changes to the original solution during implementation, wait for a confirmation before proceeding. Also, ensure to document those changes in the specified plan file in Changelog section. This helps maintain clarity and ensures that all modifications are tracked.

## Required Skills

Before starting, load and follow these skills:
- `tsh-technical-context-discovering` - to establish project conventions, coding standards, and existing patterns
- `tsh-implementation-gap-analysing` - to verify current state before making changes
- `tsh-sql-and-database-understanding` - when implementing database schemas, migrations, SQL queries, ORM-based data access, or working with transactions and locking
- `tsh-implementing-backend` - when implementing backend API features: REST/GraphQL endpoints, DataGrid filtering/pagination, database handling, JWT authentication, external service adapters, logging, and Docker setup

## Workflow

1. Review the implementation plan and feature context thoroughly.
2. **Read the "Technical Context" section from the plan file** (`*.plan.md`). This section contains project conventions, coding standards, architecture patterns, tech stack details, testing patterns, and relevant `.instructions.md` rules already discovered during planning. Use it as your primary source of truth — do NOT re-scan the codebase or re-read instruction files for information already captured there. Only perform additional discovery for aspects not covered by the persisted context.
3. Gather a list of commands you will need during implementation: running tests (unit, integration, E2E and others), linters, building the project, running and generating migrations, etc. These may already be documented in the plan's Technical Context section. Run tests and linters **before** starting implementation and **after** completing each phase.
4. Focus only on the implementation plan. Don't implement anything not part of the plan unless explicitly instructed.
5. Don't implement improvements from the plan's improvements section unless explicitly instructed.
6. Start implementing the feature according to the plan, following each task step by step.
7. After completing each task step, update the relevant plan to reflect progress by checking the box for the completed task step.
8. Before making any changes to the original solution during implementation, ask for confirmation. Document those changes in the plan file's Changelog section with timestamps.
9. Before handing over to review, ensure all tasks in the delegated scope have been completed and the feature meets the defined requirements. Update the acceptance criteria checklist after every verified item.

Ensure to write clean, efficient, and maintainable code following best practices and coding standards for the project.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-implement-common-task:v1 -->
