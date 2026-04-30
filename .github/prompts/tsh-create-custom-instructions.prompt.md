---
agent: "tsh-copilot-orchestrator"
model: "Claude Opus 4.6"
description: "Create custom instructions (.instructions.md or copilot-instructions.md) for VS Code Copilot. Analyzes existing project conventions, determines the appropriate instruction type and scope, creates the instructions file, and validates against best practices."
---

Create custom instructions for VS Code Copilot. There are two types: repository-level instructions (`copilot-instructions.md`) that apply to all Copilot interactions, and file-scoped instructions (`.instructions.md` with `applyTo` glob patterns) that target specific files or directories. The user's message following this prompt may contain specific requirements or conventions to encode.

## Required Skills

Before starting, load and follow these skills:
- `tsh-creating-instructions` - for instructions file creation workflow, type selection, scope decisions, and validation checklist
- `tsh-technical-context-discovering` - for discovering project conventions and workspace patterns before creating
- `tsh-codebase-analysing` - for analyzing workspace for existing coding conventions and patterns

## Workflow

1. **Research workspace conventions**: Analyze the workspace for existing coding standards and conventions:
   - Project structure and technology stack
   - Existing coding patterns and standards
   - Any existing instruction files (`.instructions.md` or `copilot-instructions.md`)
   - Note: this repository currently has NO instruction files of either type
2. **Determine instruction type**: Help the user choose the appropriate instruction type:
   - **Repo-level** (`copilot-instructions.md`): applies to all Copilot interactions in the workspace
   - **File-scoped** (`.instructions.md` with `applyTo` glob patterns): applies only to interactions involving matching files
   - Guide the decision based on the user's needs and scope
3. **Clarify requirements**: Determine what conventions, standards, or behaviors to encode:
   - Coding standards and style preferences
   - Framework-specific patterns and conventions
   - Behavioral guidelines for Copilot in this workspace
   - If the user's message already contains requirements, confirm understanding before proceeding
4. **Create the instructions file**: Create the instructions file with appropriate type, scope, and content. Apply the `tsh-creating-instructions` skill workflow for structure and validation.
5. **Review and validate**: Review the created instructions against best practices:
   - Verify scope is appropriate for the instruction type
   - Confirm guidelines are clear and actionable for Copilot
   - Check that file-scoped `applyTo` patterns match intended files (if applicable)

## Guidelines

- **Repo-level instructions** (`copilot-instructions.md`): Place in `.github/` directory. Apply to all Copilot interactions — use for project-wide coding standards, naming conventions, architecture decisions.
- **File-scoped instructions** (`.instructions.md` with `applyTo`): Place alongside the code they govern. Use `applyTo` glob patterns to target specific files or directories.
- This repository currently has NO instruction files — the user is starting from scratch. Communicate this context during the research step.

If the user attaches files or provides a description, use them as input for instruction design.

When in doubt about the instruction type or scope, ask the user for clarification rather than guessing.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-create-custom-instructions:v1 -->
