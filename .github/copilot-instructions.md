# Copilot Instructions for `copilot-collections`

## Repository purpose

This repository has two distinct layers that must stay cleanly separated: `.github/` contains Copilot customization artifacts published by The Software House, and `website/` contains the Docusaurus documentation site that explains and presents those artifacts. Treat `specifications/` as the planning layer for repository evolution, not as runtime artifact content.

## Top-level structure

- `.github/agents/` defines WHO executes work and how an agent behaves.
- `.github/skills/` defines HOW work is performed through reusable procedures in `SKILL.md` files.
- `.github/prompts/` defines WHAT user-invocable workflows trigger.
- `.github/internal-prompts/` is only for orchestrator or worker-only prompts that should not be exposed as public entry points.
- `.github/instructions/` holds scoped rules that refine this repository-level constitution for matching files.
- `website/` documents the collection; changes here should explain the artifacts without redefining their behavior, while documentation pages may mirror operational behavior precisely and in detail for accuracy, and `.github/` remains the canonical source of artifact behavior and must not be independently redefined, diverged from, or overridden by website documentation.
- `specifications/<feature>/` is where non-trivial repository changes should start with research, plan, and plan-review documents before artifact edits begin, using sibling artifacts such as `{task-name}.research.md`, `{task-name}.plan.md`, and `{task-name}.plan-review.md` in the same feature directory.

## Repository-specific rules

Keep the artifact model explicit and separate: agents describe behavior, skills describe procedures, prompts describe workflow triggers, and instructions describe rules. Do not move procedural workflow into instructions or encode repository rules inside prompts or agents.

### Approval terminology

- **Reviewer approval** is only the automated `tsh-plan-reviewer` verdict; it is never permission to implement.
- **Human approval** is an explicit user decision on the exact current plan revision and is the only plan-based authority for the first file-changing implementation delegation.
- Where the distinction matters, do not use unqualified “approved plan” wording; qualify it as Reviewer approval or Human approval.

For files under `.github/`, follow the scoped naming rule in `.github/instructions/naming-conventions.instructions.md`: artifact filenames, skill directories, and cross-references use the `tsh-` prefix. Reinforce that rule consistently, but keep the detailed naming policy in the scoped instruction file rather than duplicating it here.

Public prompts belong in `.github/prompts/`; internal orchestrator-only prompts belong in `.github/internal-prompts/`. Internal-only worker agents must declare `user-invocable: false`.

### Generated architect band variants

`.github/agents/tsh-architect.agent.md` is the single source of truth for all three architect agents. `.github/agents/tsh-architect-deep.agent.md` and `.github/agents/tsh-architect-fast.agent.md` are generated files: their bodies are byte-identical to the base, and only the `model`, `description`, and `user-invocable` frontmatter fields differ.

Never edit a variant file directly, and never change one architect without the others. Edit `tsh-architect.agent.md` only, then regenerate from the repository root as part of the same change:

```
node scripts/sync-architect-variants.mjs
```

A base edit that is not followed by a sync run leaves the variants stale and fails CI. To change a variant's model band, description, or `user-invocable` value, edit the `VARIANTS` table in `scripts/sync-architect-variants.mjs` and re-run it — never edit the generated file directly.

Band selection between the three architects is route-varying logic owned by `.github/skills/tsh-orchestrating-implementation/SKILL.md`; do not encode it in the agent files.

Both XML-like structural tags and Markdown headings are established and both are conforming under `.github/`; XML-like tags predominate among many `.agent.md` files and a small number of public prompts; Markdown headings predominate among remaining agents, most public prompts, all internal prompts, and `SKILL.md` bodies, with scoped XML-like blocks where an owned/localized semantic contract requires them; preserve each artifact’s existing structure and match nearest siblings; do not convert an artifact from one structure to the other as incidental cleanup. When prompts reference agents, skills, or related artifacts, use their prefixed names exactly.

Prompt files end with the repository version marker comment in the form `<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-<name>:v<n> -->`.

## Technology and workflow facts

The documentation site in `website/` uses npm (as evidenced by `website/package-lock.json`) with Docusaurus 3 (`^3.7.0`), React (`^18.3.1`), and TypeScript (`~5.7.0`) on Node `>=18.0`. Docusaurus scripts are defined in `website/package.json` and must be run from the `website/` directory: `start`, `build`, `serve`, and `clear`.

Repository maintenance scripts live in `scripts/` as dependency-free Node ESM modules run from the repository root with `node scripts/<name>.mjs`. `.github/workflows/ci.yml` runs on pull requests only and gates two things: the architect variants are in sync, and the documentation site builds.

## Validation guidance

For `.github/` artifact changes, validate placement, prefixed naming, cross-references, and structure against nearby existing artifacts and any applicable scoped instructions. Keep artifact intent aligned with its directory: public vs internal prompts, behavior vs procedure vs workflow vs rules. When the change touches `tsh-architect.agent.md`, validate by re-running `node scripts/sync-architect-variants.mjs` from the repository root and confirming it produces no further diff in the two generated variant files.

For `website/` changes, validate by running the docs build from `website/`; this is the main quality gate. `website/docusaurus.config.ts` sets `onBrokenLinks: 'throw'`, so broken links are build failures, not cosmetic issues. Ensure links, navigation targets, and documentation paths remain valid. If an artifact change affects public behavior or usage, update the matching docs layer rather than leaving `.github/` and `website/` out of sync.
