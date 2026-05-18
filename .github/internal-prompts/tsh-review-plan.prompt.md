---
agent: "tsh-architect-reviewer"
model: "Claude Opus 4.6"
description: "Review the architect's implementation plan for correctness, feasibility, and simplicity before proceeding to implementation."
---

Review the implementation plan for the provided task. Validate it against the research context, verify codebase assumptions, assess simplicity, and save the resulting report as `{task-name}.plan-review.md` alongside the plan in the same specifications directory.

## Required Skills

Before starting, load and follow these skills:

- `tsh-architecture-designing` - evaluate architectural shape, phase coherence, and trade-offs against the requirements.
- `tsh-codebase-analysing` - for verifying the plan's references against actual codebase state
- `tsh-technical-context-discovering` - for checking pattern consistency against established conventions
- `tsh-implementation-gap-analysing` - for validating what exists vs what the plan proposes to build
- `tsh-sql-and-database-understanding` - when the plan includes database schema, migration, indexing, or query changes

## Workflow

1. **Read the research file** (`.research.md`) — understand the full set of requirements, acceptance criteria, and constraints that the plan must address.

2. **Read the plan file** (`.plan.md`) — understand the proposed architecture, phases, tasks, and definitions of done.

3. **Requirements coverage pass** — For each requirement in the research file, verify it has a corresponding task in the plan. Flag any requirement that is:
   - Missing entirely from the plan
   - Only partially covered
   - Misinterpreted or implemented differently than specified

4. **Over-engineering pass** — Evaluate the plan for unnecessary abstractions, speculative features, premature generalization, and phase bloat. Keep the solution as simple as possible while still satisfying the requirements.

5. **Codebase alignment pass** — For every file, component, function, class, or pattern the plan references:
   - Search the codebase to verify it exists
   - Read the file to verify it has the expected interface/behavior
   - Flag any reference that doesn't match reality (wrong method name, missing field, non-existent file)

6. **Feasibility pass** — Check that the proposed sequence is technically realistic, that dependencies are ordered sensibly, and that the plan does not rely on unavailable or unverified capabilities.

7. **Pattern consistency pass** — Verify the plan follows established project conventions:
   - File naming and organization
   - Architectural layers and boundaries
   - Testing patterns (unit/integration/e2e split)
   - Error handling patterns
   - Coding standards from `*.instructions.md` files

8. **Quality pass** — Verify:
   - Security considerations are adequate
   - Test plan covers critical paths
   - Definitions of done are verifiable by code reviewer
   - No manual QA or deployment steps in definitions of done
   - Phases are logically ordered

9. **Produce review report** — Output the structured report with verdict (APPROVED or REVISIONS NEEDED) and persist it as `{task-name}.plan-review.md` in the same specifications directory as the plan.

<output-specification>
The review report is the primary deliverable. Save it as `{task-name}.plan-review.md` alongside the plan in the same `specifications` directory and structure it as follows:

- `# Plan Review: {plan-file-name}`
- Reviewed plan path, research file path, review date, and verdict (`APPROVED` or `REVISIONS NEEDED`)
- Summary counts for blockers, warnings, and suggestions
- Findings grouped under `BLOCKERS`, `WARNINGS`, and `SUGGESTIONS`, with the reasoning, evidence, and recommendation needed for each item
- Requirement coverage notes showing whether each research requirement is covered in the plan
- Codebase verification notes showing the plan references that were checked
- Simplicity assessment covering over-engineering, unnecessary abstractions, and speculative features
- Pattern consistency notes covering project conventions and any mismatches
  </output-specification>

## Key Principles

- **Pragmatism over perfectionism** — only flag issues that will cause real problems during implementation. Don't block for style preferences.
- **Verify, don't assume** — always search the codebase before flagging phantom references. The architect may have found something you haven't.
- **Simplicity bias** — when in doubt, flag toward simplicity. It's easier to add complexity later than to remove it.
- **Scope discipline** — never suggest adding features or requirements not in the research file.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-review-plan:v1 -->
