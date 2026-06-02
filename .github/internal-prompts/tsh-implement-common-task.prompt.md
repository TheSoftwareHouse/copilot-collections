Implement the delegated task exactly as written.

Read the delegated task block in the plan and only the files/resources named in its `Read First` list. Do not reopen the research file or any external spec notes while executing the task.

Use the task block’s `Preconditions / Dependencies`, `Changes Required`, `Expected Artifacts`, `Definition of Done`, `Verification`, and `Out of Scope / Do NOT` fields to guide the work. Treat the plan as a non-executable guidance artifact: prose, tables, contracts, and clearly labeled pseudocode are illustrative only and must be translated into project-appropriate implementation.

Stay within the task’s exact file scope. If needed information is missing from the task block or its named reading, stop and ask for clarification rather than widening the scope.
Your goal is to implement the delegated task according to the provided implementation plan.

Read the delegated task block carefully before starting. Open only the files and resources explicitly named in its `Read First` section, plus the exact file listed in `Files in Scope` when you are ready to edit. Treat that task block as the source of truth for scope, dependencies, required changes, verification, and guardrails.

Do not reopen the research file or external spec notes while executing the task. If the task block is missing critical information, stop and ask for clarification or request a plan update instead of running a broader research pass.

Don't deviate from the implementation plan. Follow the delegated task step by step to ensure all requirements are met.

If you need to make changes to the original solution during implementation, wait for confirmation before proceeding.

## Required Skills

Before starting, load and follow these skills when relevant:

- `tsh-implementation-gap-analysing` - to verify current state before making changes
- `tsh-technical-context-discovering` - only for gaps not covered by the delegated task block or its `Read First` items
- `tsh-sql-and-database-understanding` - when implementing database schemas, migrations, SQL queries, ORM-based data access, or working with transactions and locking
- any domain-specific implementation skill named by the wrapper prompt or delegated task

## Workflow

1. Read the delegated task block and the files or resources named in `Read First`.
2. Keep the scope exact. Do not expand the task beyond the single file listed in `Files in Scope`.
3. Run the relevant checks before and after the change when they are available for the scoped work.
4. Implement only what the delegated task requires.
5. After completing the scoped change, update the relevant `Definition of Done` items and any verified `Quality Assurance` items in the plan.
6. Before making any change to the planned solution, ask for confirmation before proceeding.
7. Treat labeled pseudocode, tables, and contracts in the plan as illustrative guidance only. They are not production code and must not be copied verbatim into source files.

Ensure the implementation stays clean, efficient, and maintainable while following the project patterns surfaced by the delegated task and its named reading.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-implement-common-task:v2 -->
