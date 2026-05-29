Analyze the feature context file for the provided task or Jira ID. Based on it, prepare a detailed implementation plan that a software engineer can follow step by step to deliver the feature.

The file outcome should be a markdown file named after the task Jira ID in kebab-case format or after task name (if no Jira task provided) with `.plan.md` suffix (e.g., `user-authentication.plan.md`). The file should be placed in the `specifications` directory under a folder named after the issue ID or the shortened task name in kebab-case format.

## Required Skills

Before starting, load and follow these skills:

- `tsh-architecture-designing` - for the architecture design process and output template (`plan.example.md`)
- `tsh-codebase-analysing` - for analyzing the existing codebase
- `tsh-implementation-gap-analysing` - for verifying what exists vs what needs to be built
- `tsh-technical-context-discovering` - for understanding project conventions and patterns
- `tsh-sql-and-database-understanding` - when the feature involves database schema design, data model changes, migrations, or query-heavy implementation

## Workflow

1. **Analyze context**: Review the feature context file (`.research.md`) thoroughly to understand the requirements and scope. Cross-check with industry, domain, and company best practices.
2. **Analyze tech stack**: Understand the project's tech stack, industry, and domain to identify best practices for implementation.
3. **Verify current implementation**: Before planning, perform a thorough analysis of the existing codebase:
   - Use semantic search to find components, functions, hooks, utilities, or files related to the feature requirements.
   - Identify what is already implemented and functional.
   - Identify what exists but needs modification or extension.
   - Identify what needs to be created from scratch.
   - Document findings in the "Current Implementation Analysis" section.
4. **Persist technical context**: During steps 2-3, capture all discovered project conventions, coding standards, architecture patterns, tech stack details, testing patterns, and relevant `.instructions.md` rules. Save them in the **"Technical Context"** section of the plan file. This section is critical — downstream implementation agents will read it to avoid redundant codebase analysis. Be thorough: include framework conventions, naming patterns, test commands, linting rules, and any project-specific standards. Embed the key rules inline in the plan itself; file paths are secondary support only and must not be the only place where critical rules live.
5. **Understand project standards**: Review project best practices and quality standards (check `*.instructions.md` files). Incorporate findings into the "Technical Context" section.
6. **Prepare implementation plan**: Create a self-contained implementation plan for lower-tier implementors. The plan must remain recognizable as the repository's implementation-plan format while being rich enough to execute without reopening research.
7. **Define required plan sections**: Always include these sections in the final plan, even when some entries are short:
   - `Glossary / Ubiquitous Language` — define task-specific terms, role names, acronyms, and naming choices that the implementor must understand without re-reading research.
   - `Technical Context` — persist actual technical rules and conventions inline.
   - `Traps and Warnings` — capture non-obvious failure modes, misleading paths, and explicit "do not do this" guidance.
8. **Define phases**: For each phase, add the reusable phase preamble block with:
   - `Purpose`
   - `State Before`
   - `State After`
   - `Dependencies / Risks`
9. **Define tasks**: For each phase, identify specific tasks with:
   - Clear title
   - Action type: `[CREATE]`, `[MODIFY]`, or `[REUSE]`
   - `Context` — what the implementor must understand before starting
   - `Approach` — how to execute the task and key sequencing or boundary decisions
   - `References` — files, contracts, diagrams, or labeled pseudocode that support execution
   - `Traps` — task-specific pitfalls, misleading options, or explicit constraints
   - Definition of done as a checkbox list for each task
10. **Address security**: Include security considerations relevant to the implementation.
11. **UI verification tasks**: For features with UI components based on Figma designs, add a `[REUSE]` UI verification task immediately after each implementation task that produces visible UI. The verification task should reference `tsh-ui-reviewer` agent, include the Figma URL, and describe the verify-fix loop (max 5 iterations). Non-visual tasks (data fetching, state management, API integration) do not need verification tasks.
12. **Honor the non-code boundary**: Plans are guidance artifacts only. Do NOT include real / production code in the plan. Allowed formats are prose, tables, diagrams, contracts, and clearly labeled non-executable pseudocode.
13. **Save the plan**: Follow the current `plan.example.md` template from the `tsh-architecture-designing` skill as the canonical output contract.
14. **Scope control**: Focus ONLY on changes specific to THIS task. Do not include prerequisite work or dependencies - assume those are already done. Do not plan features not in the original requirements (document them separately in an Improvements section).
15. **Avoid duplication**: Never plan to create components, functions, or utilities that already exist. Use the "Current Implementation Analysis" section and plan to reuse or modify existing code.
16. **Bug fixes**: When planning bug fixes, include steps to reproduce the issue, root cause analysis, and implementation of a fix verified by tests.

Don't provide deployment plans, code pushing instructions, or code review instructions in the repository.

Follow the template structure and naming conventions strictly to ensure clarity and consistency.

Optimize the plan for execution by a lower-tier implementor: the implementor should be able to start from the plan alone, using the glossary, technical context, traps, phase preambles, and task-level guidance without reopening research for basic context recovery.

In case of any ambiguities or missing information for the planning, ask for clarification before finalizing the plan.

Update the plan file after each interaction if new information is gathered.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-plan:v2 -->
