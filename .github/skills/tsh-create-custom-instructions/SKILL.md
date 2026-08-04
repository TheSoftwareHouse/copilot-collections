---
name: tsh-create-custom-instructions
description: "Create custom instructions (.instructions.md or copilot-instructions.md) for VS Code Copilot. Analyzes existing project conventions, determines the appropriate instruction type and scope, creates the instructions file, and validates against best practices."
user-invocable: true
---
<routing>Run this workflow through the designated agent: `tsh-copilot-orchestrator`.</routing>

Create repository-level or scoped Copilot instructions from project conventions, with explicit scope and validation.

<required-skills>
- `tsh-creating-instructions` - instruction type, scope, and validation.
- `tsh-technical-context-discovering` - project conventions.
- `tsh-codebase-analysing` - existing standards and patterns.
</required-skills>

<workflow>
1. Research structure, stack, existing instruction files, and applicable conventions.
2. Select repository-level or file-scoped instruction scope.
3. Encode declarative rules only; keep procedures in skills and behavior in agents.
4. Validate YAML frontmatter, `applyTo`, clarity, and absence of workflow triggers.
</workflow>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-create-custom-instructions:v1 -->
