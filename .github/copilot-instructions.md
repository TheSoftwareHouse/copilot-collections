# Copilot Instructions for `copilot-collections`

## Repository purpose

This repository has two distinct layers that must stay cleanly separated: `.github/` contains Copilot customization artifacts published by The Software House, and `website/` contains the Docusaurus documentation site that explains and presents those artifacts. Treat `specifications/` as the planning layer for repository evolution, not as runtime artifact content.

## Top-level structure

- `.github/agents/` defines WHO executes work and how an agent behaves.
- `.github/skills/` defines HOW work is performed through reusable procedures, user-invokable command skills, and private workflow skills in `SKILL.md` files.
- `.github/instructions/` holds scoped rules that refine this repository-level constitution for matching files.
- `website/` documents the collection; changes here should explain the artifacts without redefining their behavior.
- `specifications/<feature>/` is where non-trivial repository changes should start with research and plan documents before artifact edits begin.

## Repository-specific rules

Keep the artifact model explicit and separate: agents describe behavior, skills describe reusable procedures and workflows, and instructions describe rules. Do not move procedural workflow into instructions or encode repository rules inside agents.

- **Command skills** are user-invokable skills with `user-invocable: true`; they provide stable public workflow entry points.
- **Private workflow skills** use `user-invocable: false`; they may be model-loaded for designated-agent workflows but must not be exposed as public commands.
- General reusable skills retain their procedural role; do not merge, rename, or change their invocation state when migrating an identically themed workflow.

### Approval terminology

- **Reviewer approval** is only the automated `tsh-plan-reviewer` verdict; it is never permission to implement.
- **Human approval** is an explicit user decision on the exact current plan revision and is the only plan-based authority for the first file-changing implementation delegation.
- Where the distinction matters, do not use unqualified “approved plan” wording; qualify it as Reviewer approval or Human approval.

For files under `.github/`, follow the scoped naming rule in `.github/instructions/naming-conventions.instructions.md`: artifact filenames, skill directories, and cross-references use the `tsh-` prefix. Reinforce that rule consistently, but keep the detailed naming policy in the scoped instruction file rather than duplicating it here.

Internal-only worker agents and private workflow skills must declare `user-invocable: false`. Public command-handler identity belongs in an in-body directive naming the designated agent, not in unsupported skill frontmatter.

Structured bodies in `.agent.md` and `SKILL.md` use the repository’s XML-like tag style consistently. When agents or skills reference related artifacts, use their prefixed names exactly.

The 26 skills migrated from prompt workflows end with `<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-<name>:v<n> -->`, preserving the source workflow marker version. Do not impose this marker requirement on unrelated reusable skills.

## Technology and workflow facts

The documentation site in `website/` uses npm (as evidenced by `website/package-lock.json`) with Docusaurus 3 (`^3.7.0`), React (`^18.3.1`), and TypeScript (`~5.7.0`) on Node `>=18.0`. Repository scripts are defined only in `website/package.json` and must be run from the `website/` directory: `start`, `build`, `serve`, and `clear`.

## Validation guidance

For `.github/` artifact changes, validate placement, prefixed naming, cross-references, and structure against nearby existing artifacts and any applicable scoped instructions. Keep artifact intent aligned with its role: agent behavior, reusable procedure, public command skill, private workflow skill, or repository rule.

For `website/` changes, validate by running the docs build from `website/`; this is the main quality gate. `website/docusaurus.config.ts` sets `onBrokenLinks: 'throw'`, so broken links are build failures, not cosmetic issues. Ensure links, navigation targets, and documentation paths remain valid. If an artifact change affects public behavior or usage, update the matching docs layer rather than leaving `.github/` and `website/` out of sync.
