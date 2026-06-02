Analyze the feature context and research notes, then author a lean implementation plan that matches `.github/skills/tsh-architecture-designing/plan.example.md`.

Use the research file while authoring to understand the rationale and scope, but keep the plan itself task-block self-contained. The finished plan is the execution artifact: each task must stand on its own with exact file scope, and implementors should only need the delegated task block plus its `Read First` items.

## Required Skills

Before starting, load and follow these skills:

- `tsh-architecture-designing` - to follow the canonical lean plan template.
- `tsh-codebase-analysing` - to map existing files, reuse points, and gaps.
- `tsh-implementation-gap-analysing` - to separate what exists from what still needs planning.
- `tsh-technical-context-discovering` - to capture only the project rules needed for the plan.
- `tsh-sql-and-database-understanding` - when the work involves schema, migrations, or query-heavy changes.

## Workflow

1. Read the feature context and research file thoroughly.
2. Check the current codebase and project instructions for facts needed to author the plan.
3. Build one task per file with exact scope. Do not bundle multiple files into a single task.
4. Use only the lean task field set: `Files in Scope`, `Read First`, `Preconditions / Dependencies`, `Changes Required`, `Expected Artifacts`, `Definition of Done`, `Verification`, `Out of Scope / Do NOT`.
5. Keep each task block self-contained. Put any required context, guardrails, and file-specific facts inside the task block rather than in global sections.
6. Keep the plan non-executable and code-free. Prose, tables, contracts, and clearly labeled non-executable pseudocode are allowed.
7. Validate the draft against `plan.example.md` and remove stale maximalist wording or instructions that would make implementors reopen research/spec docs during execution.

The plan must start with `Task Details`, then `Implementation Plan`, then `Quality Assurance`, and phase blocks must include the reusable `Purpose` / `State Before` / `State After` / `Dependencies / Risks` preamble.

If the task still has unresolved ambiguity after checking the available sources, ask for clarification before finalizing.
<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-plan:v2 -->

