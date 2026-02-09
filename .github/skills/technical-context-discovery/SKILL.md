---
name: technical-context-discovery
description: Discover and establish technical context before implementing any feature. Prioritize project instructions, existing codebase patterns, and external documentation in that order. Use for any task requiring understanding of project conventions, coding standards, architecture patterns, and established practices before writing code.
---

# Technical Context Discovery

This skill provides a systematic approach for understanding a project's technical context before making any code changes. It ensures consistency with existing patterns and prevents introducing conflicting conventions.

## When to Use

- Before implementing any feature or fix
- Before writing tests (unit, integration, E2E)
- Before making architectural decisions that affect existing code
- When onboarding to a new area of the codebase

## Technical Context Discovery Process

Use the checklist below and track your progress:

```
Discovery progress:
- [ ] Step 1: Check Copilot instruction files
- [ ] Step 2: Analyze existing codebase patterns
- [ ] Step 3: Consult external documentation (if needed)
- [ ] Step 4: Apply the implementation rule
```

**Step 1: Check Copilot Instruction Files**

**ALWAYS check first** for existing Copilot instructions in the project:

- Search for `.github/copilot-instructions.md` at the repository root.
- Search for `*.instructions.md` files in relevant directories (e.g., `src/`, `tests/`, `e2e/`, `backend/`, feature-specific folders).
- Search for `.copilot/` directory with configuration files.

If instructions files exist, they are the **primary source of truth** for:

- Coding standards and conventions
- Architecture patterns and project structure
- Technology stack specifics and version requirements
- Testing strategies and patterns
- Naming conventions and file organization
- Locator strategies (for E2E tests)
- Test data management approaches
- Environment configuration

**Step 2: Analyze Existing Codebase Patterns**

If no Copilot instructions are found, or if they don't cover specific aspects, **analyze the existing codebase** to understand and replicate established patterns:

- **Architecture patterns**: Examine folder structure, layering (controllers, services, repositories), and module organization.
- **Code style**: Analyze existing files for naming conventions, formatting, and idioms used.
- **Error handling**: Look at how exceptions are caught, logged, and returned to clients.
- **Validation patterns**: Check how input validation is implemented (decorators, middleware, manual checks).
- **Testing patterns**: Review existing tests to understand structure, mocking strategies, assertion styles, fixtures, and test data management.
- **Database patterns**: Examine existing migrations, entities/models, and query patterns.
- **API patterns**: Analyze existing endpoints for response formats, status codes, and documentation style.
- **Configuration**: Check how environment variables, feature flags, and configuration are managed.

**Use `search` and `usages` tools** to find similar implementations in the codebase and follow the same approach.

**Step 3: Consult External Documentation**

If neither Copilot instructions nor sufficient existing codebase patterns are available (e.g., new project, greenfield feature, or first implementation of a specific pattern), **use external documentation and industry best practices**:

- **Use `context7` tool** to search for official documentation of the framework/library being used (check project config for exact versions first).
- Apply **industry-standard best practices** for the technology stack.
- Follow **OWASP security guidelines** for secure coding practices.
- Apply **SOLID principles** and clean architecture patterns.
- Use **well-established design patterns** appropriate for the use case.

**IMPORTANT**: When using best practices in a greenfield scenario, document your decisions in code comments or README to establish patterns for future development.

**Step 4: Apply the Implementation Rule**

Based on what you discovered, apply this decision hierarchy:

| Context Available | Action |
|---|---|
| Instructions files exist | Follow them strictly. Instructions take precedence over general best practices. |
| No instructions, but codebase has patterns | Mirror existing patterns exactly. Consistency with existing code > theoretical best practices. |
| No instructions, no existing patterns | Apply documentation-based best practices and industry standards. Document decisions for future reference. |

**Critical rule**: Never introduce new patterns unless explicitly requested by the user or specified in the implementation plan.
