---
name: creating-instructions
description: "Creates custom instruction files (.instructions.md) for GitHub Copilot in VS Code. Covers repository-level instructions (copilot-instructions.md) and granular file-based instructions with applyTo glob patterns. Provides templates and decision framework for instruction vs. skill placement. Use when creating, reviewing, or updating .instructions.md files."
---

# Creating Instructions

Creates well-structured instruction files for GitHub Copilot in VS Code. Covers the repository-level constitution and granular scoped conventions, with clear guidance on what belongs in instructions versus skills.

## Core Design Principles

<principles>

<instruction-types>
Two types of instruction files exist:

**Repository-level instructions** (`.github/copilot-instructions.md`): A single file per repository — the "constitution." Defines architecture, directory structure, languages, frameworks, library versions, and fundamental project constraints. Applied to ALL Copilot interactions in the workspace. No frontmatter required. This is the first file any developer or AI agent should read to understand the project.

**Granular custom instructions** (`*.instructions.md`): Multiple files per repository. Support YAML frontmatter with `applyTo` glob patterns. Applied automatically when matching files are in context, or manually added to chat. Stored in `.github/instructions/` folder. These encode file-type-specific or directory-specific coding conventions.

| Aspect | Repository-level | Granular custom |
|---|---|---|
| File | `.github/copilot-instructions.md` | `*.instructions.md` |
| Count per repo | Exactly one | Multiple |
| Frontmatter | Not required | Recommended (`applyTo`, `name`, `description`) |
| Applied when | Every Copilot interaction | Files matching `applyTo` pattern are in context, or description semantically matches the task |
| Location | `.github/copilot-instructions.md` | `.github/instructions/` folder |
| Purpose | Project constitution — architecture, stack, fundamental rules | Scoped conventions — file-type or domain-specific rules |
</instruction-types>

<instructions-vs-skills>
Instructions define **RULES** — declarative constraints that Copilot must follow whenever they apply. They are project-specific, loaded automatically, and encode decisions for THIS repository.

Skills define **HOW** — procedural workflows loaded on-demand by agents to perform specific tasks. Skills are generic, reusable across projects, and encode expert knowledge.

| If the content is... | It belongs in... | Example |
|---|---|---|
| A project-specific rule or constraint | Instructions | "Use `date-fns` instead of `moment.js` — moment.js is deprecated" |
| A step-by-step workflow for performing a task | Skill | "How to perform code review with severity categorization" |
| A coding convention for specific file types | Instructions (granular) | "React components use functional style with hooks" |
| A reusable process template across projects | Skill | "How to create a new API endpoint with validation" |
| An architectural decision for this repository | Instructions (repo-level) | "This is a monorepo with apps/ and packages/ structure" |
| Domain knowledge needed to execute a task | Skill | "E2E testing patterns with Playwright Page Objects" |
| Technology stack and version requirements | Instructions (repo-level) | "TypeScript 5.4, React 19, Next.js 15" |
| A coding standard that linters don't enforce | Instructions (granular) | "Business logic must not import from UI layer" |

**Mental model**: Instructions are "the law" (always in force). Skills are "expert handbooks" (consulted for specific tasks).
</instructions-vs-skills>

<conciseness>
Instruction files compete for the context window with conversation history, skills, and the actual task.

- Keep instructions short and self-contained — each instruction should be a single, simple statement.
- Include the reasoning behind rules (e.g., "Use `date-fns` instead of `moment.js` — moment.js is deprecated and increases bundle size").
- Show preferred and avoided patterns with concrete code examples — AI responds more effectively to examples than abstract rules.
- Focus on non-obvious rules — skip conventions that standard linters/formatters already enforce.
- Whitespace between instructions is ignored — format for legibility.
</conciseness>

</principles>

## Creation Process

Use the checklist below and track progress:

```
Creation progress:
- [ ] Step 1: Determine the instruction type
- [ ] Step 2: Define the instruction scope
- [ ] Step 3: Gather content for the instruction file
- [ ] Step 4: Write the instruction file
- [ ] Step 5: Validate the instruction file
```

**Step 1: Determine the instruction type**

Determine from context or ask the user. Use the `vscode/askQuestions` tool to clarify the user's intent if it's ambiguous:
- Is this a NEW project needing its first `copilot-instructions.md`? → Create repository-level instructions.
- Are there existing `copilot-instructions.md` and file-specific rules are needed? → Create granular instructions.
- Unsure? → Check if `.github/copilot-instructions.md` exists. If not, recommend creating it first. The constitution comes before specific laws.

**Step 2: Define the instruction scope**

For **repository-level instructions**, the scope is always the entire project. Research by:
- Reading `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, or equivalent to identify languages, frameworks, and versions.
- Analyzing the directory structure to understand architecture (monorepo, feature-based, layered, etc.).
- Reading existing config files (`.eslintrc`, `tsconfig.json`, `.prettierrc`, etc.) to understand tooling.
- Checking for existing README or architectural documentation.

For **granular instructions**, determine:
- Which files they apply to (the `applyTo` glob pattern).
- What specific conventions exist for that file scope.
- Whether an existing instruction file already covers this scope (avoid overlapping `applyTo` patterns).

`applyTo` glob pattern reference:

| Pattern | Matches |
|---|---|
| `**/*.ts` | All TypeScript files |
| `**/*.test.ts` | All test files |
| `src/components/**` | All files under components directory |
| `**/*.{ts,tsx}` | All TypeScript and TSX files |
| `src/api/**` | All API-related files |
| `**` | All files (rarely needed for granular — use repo-level instead) |

**Step 3: Gather content for the instruction file**

For **repository-level instructions** (the constitution), research and document:
1. **Architecture** — Overall architecture pattern (monorepo, microservices, modular monolith, etc.), directory structure, and responsibility of each top-level directory.
2. **Technology Stack** — ALL languages, frameworks, and key libraries with specific versions. Critical — Copilot needs exact versions to generate compatible code.
3. **Coding Conventions** — Conventions NOT enforced by linters/formatters. Architectural rules (e.g., "business logic must not import from UI layer"), project-specific naming conventions, and agreed-upon patterns.
4. **Error Handling** — The project's error handling strategy.
5. **Testing Strategy** — Testing approach (unit, integration, E2E), frameworks, and key patterns.
6. **Development Workflow** — How developers interact with the project. Document task runners (Make, Taskfile, npm scripts, Turbo), containerization (Docker Compose commands), and common developer commands (build, test, lint, migrate, seed). Copilot should use the same scripts and tools a regular developer would — never raw commands when a script exists.

For **granular instructions**, research and document:
- Specific conventions for the target file scope.
- Preferred patterns with code examples.
- Anti-patterns to avoid with code examples.
- Reasoning behind non-obvious rules.

Use the `./assets/copilot-instructions.template.md` and `./assets/custom-instructions.template.md` templates as starting points.

**Step 4: Write the instruction file**

For **repository-level instructions**:
- Create the file at `.github/copilot-instructions.md`.
- No frontmatter required.
- Use clear Markdown headers to organize sections.
- Use the `./assets/copilot-instructions.template.md` template.

For **granular instructions**:
- Create the file in `.github/instructions/` directory.
- Name the file descriptively: `{scope}.instructions.md` (e.g., `python.instructions.md`, `react-components.instructions.md`, `api-endpoints.instructions.md`).
- Include YAML frontmatter with `name`, `description`, and `applyTo`.
- Use the `./assets/custom-instructions.template.md` template.

Frontmatter fields reference:

| Field | Required | Description |
|---|---|---|
| `name` | No | Display name shown in UI. Defaults to filename. |
| `description` | Recommended | Short description shown on hover. Also used for semantic matching — if description matches the current task, instructions may apply even without `applyTo` match. |
| `applyTo` | Recommended | Glob pattern relative to workspace root. If omitted, instructions are not applied automatically. |

**Step 5: Validate the instruction file**

```
Validation:
- [ ] File is in the correct location (`.github/copilot-instructions.md` or `.github/instructions/*.instructions.md`)
- [ ] Frontmatter (if present) is valid YAML
- [ ] `applyTo` pattern (if present) matches the intended files — verify with a glob tester
- [ ] Instructions are short and self-contained — each rule is a single statement
- [ ] Non-obvious rules include reasoning ("because...")
- [ ] Preferred/avoided patterns include concrete code examples
- [ ] No duplication of rules already enforced by linters/formatters
- [ ] No procedural workflow content (that belongs in skills)
- [ ] No agent personality or behavior definitions (that belongs in .agent.md)
- [ ] No prompt/workflow triggers (that belongs in .prompt.md)
- [ ] Repository-level file covers: architecture, stack with versions, key conventions
- [ ] Granular files have descriptive, non-overlapping `applyTo` patterns
```

## Quick Reference

### Instruction File Types

| Type | Location | Purpose | Setting |
|---|---|---|---|
| Repository instructions | `.github/copilot-instructions.md` | Project constitution | Always on by default |
| Custom instructions | `.github/instructions/*.instructions.md` | Scoped conventions | `chat.includeApplyingInstructions` |
| AGENTS.md | Workspace root | Multi-AI-agent instructions | `chat.useAgentsMdFile` |
| CLAUDE.md | Workspace root / `.claude/` | Claude Code compatibility | `chat.useClaudeMdFile` |
| Organization instructions | GitHub org level | Cross-repo shared rules | `github.copilot.chat.organizationInstructions.enabled` |

### Priority Order

Higher takes precedence on conflict:

1. Personal instructions (user-level) — highest
2. Repository instructions (`.github/copilot-instructions.md` or `AGENTS.md`)
3. Organization instructions — lowest

## Connected Skills

- `creating-agents` - to ensure agent files don't embed coding standards that belong in instructions
- `creating-skills` - to understand the boundary between procedural knowledge (skills) and declarative rules (instructions)
- `creating-prompts` - to ensure prompts reference instructions rather than duplicating conventions
- `technical-context-discovery` - the complementary skill that discovers and reads existing instruction files
- `codebase-analysis` - to analyze existing instruction files and identify patterns to follow
