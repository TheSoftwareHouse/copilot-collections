Analyze the feature context for the provided task or Jira ID and prepare a detailed implementation plan that a software engineer can follow step by step to deliver the feature.

Use the required skills to understand the feature, design the solution, and author the plan artifact.

## Required Skills

Before starting, load and follow these skills:

- `tsh-architecture-designing` - for the architecture design process
- `tsh-creating-implementation-plans` - for the plan structure, definition-of-done rules, and output template (`plan.example.md`)
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
4. **Persist technical context**: During steps 2-3, capture all discovered project conventions, coding standards, architecture patterns, tech stack details, testing patterns, and relevant `.instructions.md` rules. Save them in the **"Technical Context"** section of the plan file. This section is critical — downstream implementation agents will read it to avoid redundant codebase analysis. Be thorough: include framework conventions, naming patterns, test commands, linting rules, and any project-specific standards.
5. **Understand project standards**: Review project best practices and quality standards (check `*.instructions.md` files). Incorporate findings into the "Technical Context" section.
6. **Design the solution architecture using `tsh-architecture-designing`**: Design the solution architecture (components, interactions, data flows, trade-offs) before structuring it into a plan.
7. **Create the implementation plan using `tsh-creating-implementation-plans`**: Delegate ALL plan content to `tsh-creating-implementation-plans`, including task definition, security considerations, UI verification where applicable, the plan save pattern, bug-fix planning, scope control, and duplication avoidance.

In case of any ambiguities or missing information for the planning, ask for clarification before finalizing the plan.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-plan:v3 -->
