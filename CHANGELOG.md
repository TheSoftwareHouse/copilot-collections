# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## 2026-04-01

### Changed

- Renamed Figma MCP server key from `figma-mcp-server` to `figma` across all agents, prompts, skills, MCP configuration, and documentation — aligns with Figma's recommended server naming in their official docs

## 2026-03-20

### Changed

- `/tsh-implement` prompt — Now auto-detects missing context and missing plan; delegates to `tsh-context-engineer` for research and `tsh-architect` for planning before implementation, with user confirmation between phases
- `/tsh-plan` prompt — Moved from public `.github/prompts/` to internal `.github/internal-prompts/`; no longer invoked directly by users — the Engineering Manager delegates to the Architect automatically when a plan is needed
- `/tsh-research` prompt — Moved from public `.github/prompts/` to internal `.github/internal-prompts/`; no longer invoked directly by users — the Engineering Manager delegates to the Context Engineer automatically when research is needed
- Engineering Manager agent (`tsh-engineering-manager`) — Added `tsh-context-engineer` to subagents; added structured workflow to decide between research, planning, and implementation phases; added delegation rules for `tsh-context-engineer` (missing context) and `tsh-architect` (missing plan); added Sequential Thinking usage for phase routing decisions
- Business Analyst agent (`tsh-business-analyst`) — Replaced "Deep-dive Research per Task" and "Prepare Implementation Plan" handoff buttons with single "Start Implementation" handoff routing to Engineering Manager
- Context Engineer agent (`tsh-context-engineer`) — Replaced "Prepare Implementation Plan" handoff button with "Start Implementation" handoff routing to Engineering Manager
- Updated website documentation: moved `/tsh-plan` and `/tsh-research` prompt pages from public to internal section; updated agents overview, prompts overview, workflow docs, and getting started pages

## 2026-03-17

### Added

- Engineering Manager agent (`tsh-engineering-manager`) — Orchestrates the implementation phase by delegating tasks to specialized agents (Software Engineer, E2E Engineer, DevOps Engineer, Architect, Code Reviewer, UI Reviewer) based on the implementation plan; uses Sequential Thinking for ambiguous routing; auto-triggers code review if no review phase is defined; tracks progress via plan checkboxes
- Internal prompts directory (`.github/internal-prompts/`) — Agent-only prompts not visible in the slash command menu, used exclusively for sub-agent delegation by the Engineering Manager
- Internal prompt `tsh-implement-common-task` — Base implementation workflow for Software Engineer delegated tasks (backend and non-Figma frontend)
- Internal prompt `tsh-implement-ui-common-task` — Extends `tsh-implement-common-task` with UI-specific behaviors for Figma-based frontend tasks
- Internal prompt `tsh-implement-ui` — Full UI implementation + verification loop orchestration for the Engineering Manager
- Documentation page for the Engineering Manager agent on the website
- Documentation pages for all new internal prompts on the website

### Changed

- `/tsh-implement` prompt — Rewritten to route through the Engineering Manager agent instead of Software Engineer; now delegates tasks to specialized agents based on plan task types (`[CREATE]`, `[MODIFY]`, `[REUSE]`)
- Architect agent (`tsh-architect`) — Handoff now routes to Engineering Manager instead of Software Engineer; removed "Start UI Implementation" handoff button (consolidated into single "Start Implementation"); reformatted tools list YAML; updated plan template to include `[REUSE]` UI verification tasks delegated to `tsh-ui-reviewer`
- Architecture Designing skill (`tsh-architecture-designing`) — Updated plan phases to run only fast tests/checks per phase (unit, integration, linters, build); added code review phase requirement using `tsh-code-reviewer` with `tsh-review.prompt.md`; added `[REUSE]` UI verification task pattern for Figma-based features
- UI Reviewer agent (`tsh-ui-reviewer`) — Removed "Start UI Implementation" and "Implement UI Fixes" handoff buttons (Engineering Manager now owns the verify-fix loop); added explicit dev server URL confirmation requirement; added authentication/login screen detection and escalation; added "reading source code is NOT verification" guardrail
- Code Reviewer agent (`tsh-code-reviewer`) — Added explicit mention of e2e tests alongside unit and integration tests in verification requirements
- Software Engineer agent (`tsh-software-engineer`) — Removed `atlassian/search` from tool access (Atlassian context now gathered by Engineering Manager)
- `/tsh-plan` prompt — Minor update
- `/tsh-review-ui` prompt — Minor update
- `/tsh-review` prompt — Minor update
- Prompts reorganized into public and internal categories on the documentation website with separate sidebar sections
- Moved 7 infrastructure/DevOps prompts from public `.github/prompts/` to internal `.github/internal-prompts/` (`tsh-deploy-kubernetes`, `tsh-implement-e2e`, `tsh-implement-observability`, `tsh-implement-pipeline`, `tsh-implement-terraform`)
- Updated agents overview documentation with Engineering Manager in the handoff diagram and agent summary table
- Updated prompts overview documentation with public/internal prompt distinction and delegation table
- Updated workflow documentation (standard flow, frontend flow, e2e flow) to reflect Engineering Manager orchestration

### Removed

- `/tsh-implement-ui` public prompt — Consolidated into `/tsh-implement`; UI implementation is now handled internally by the Engineering Manager's delegation to Software Engineer + UI Reviewer
- `/tsh-clean-transcript` prompt — Removed (functionality available through `/tsh-analyze-materials`)
- `/tsh-create-jira-tasks` prompt — Removed (functionality available through `/tsh-analyze-materials`)

## 2026-03-08

### Added

- Ensuring Accessibility skill (`tsh-ensuring-accessibility`) — WCAG 2.1 AA compliance, semantic HTML, ARIA patterns, keyboard navigation, focus management, screen reader support, and color contrast requirements
- Implementing Forms skill (`tsh-implementing-forms`) — Form architecture, schema-based validation, field composition, error handling, multi-step form flows, and accessible form patterns
- Frontend Optimization skill (`tsh-optimizing-frontend`) — Rendering optimization, code splitting, memoization strategies, bundle size control, asset optimization, and memory management with React-specific reference patterns
- Frontend Review skill (`tsh-reviewing-frontend`) — Frontend-specific code review criteria: component anti-patterns, hooks quality, rendering correctness, accessibility and performance spot-checks, module organization with React-specific reference checklist
- Writing Hooks skill (`tsh-writing-hooks`) — Custom hook and composable patterns: naming, composition, stable return shapes, lifecycle cleanup, and testing strategies with React-specific reference patterns
- React-specific reference files (`references/react-patterns.md`) for implementing-frontend, optimizing-frontend, reviewing-frontend, and writing-hooks skills
- Documentation pages for all 5 new skills on the website

### Changed

- Software Engineer agent (`tsh-software-engineer`) — Added 4 new frontend skills to skills list (`tsh-implementing-forms`, `tsh-writing-hooks`, `tsh-ensuring-accessibility`, `tsh-optimizing-frontend`); added `tsh-ui-reviewer` as subagent for verification delegation; reformatted tools list
- Code Reviewer agent (`tsh-code-reviewer`) — Added `tsh-reviewing-frontend` skill for frontend-specific review criteria
- UI Reviewer agent (`tsh-ui-reviewer`) — Rewritten to emphasize subagent usage pattern, mandatory tool-based verification (never mental comparison), transparent error reporting with LOW confidence; reformatted tools list
- Frontend Implementation skill (`tsh-implementing-frontend`) — Refactored to focus on component patterns and composition, moved accessibility to dedicated `tsh-ensuring-accessibility` skill; added React-specific reference file
- UI Verification skill (`tsh-ui-verifying`) — Rewritten with 5-step verification process, verification order (stop on first CRITICAL failure), and improved report format
- `/tsh-implement-ui` prompt — Rewritten to use `tsh-ui-reviewer` as subagent (not `/tsh-review-ui` prompt call); added `tsh-ensuring-accessibility` skill; clarified that SE must never verify UI itself
- `/tsh-review-ui` prompt — Simplified to delegate entirely to `tsh-ui-verifying` skill workflow; fixed "all differences" wording to align with skill's stop-on-critical-failure rule
- Updated website documentation for Software Engineer, Code Reviewer, UI Reviewer agents and `/tsh-implement-ui`, `/tsh-review-ui` prompts
- Updated skills overview: skill count 25 → 30, added new skills to Development and Quality tables, updated agent–skill matrix
- Fixed Architect agent docs — added 7 missing skills (multi-cloud, cloud cost, CI/CD, Terraform, secrets, Kubernetes, observability)
- Fixed DevOps Engineer agent docs — added missing `tsh-codebase-analysing` skill
- Fixed Frontend Flow workflow docs — added `tsh-ensuring-accessibility` to required skills, updated subagent terminology

## 2026-03-06

### Added

- DevOps Engineer agent (`tsh-devops-engineer`) — Senior DevOps Engineer and Consultant persona specializing in Golden Paths, automation, and Cloud governance; mandatory architect sub-agent delegation for all design decisions; multi-cloud guardrails with FinOps alerts (>10% cost increase triggers alert); three-option output strategy (Golden Path, Cost-Optimized, Velocity); mandatory skill-loading chains for 8 task types; tools include AWS API MCP, AWS Docs MCP, GCP gcloud/observability/storage MCPs, Context7, Sequential Thinking
- Multi-Cloud Architecture skill (`tsh-designing-multi-cloud-architecture`) for selecting and integrating services across AWS, Azure, and GCP with service comparison and multi-cloud pattern references
- CI/CD Implementation skill (`tsh-implementing-ci-cd`) for pipeline design patterns and deployment strategies
- Kubernetes Implementation skill (`tsh-implementing-kubernetes`) for deployment patterns, Helm charts, and cluster management
- Observability Implementation skill (`tsh-implementing-observability`) for logging, monitoring, alerting, and distributed tracing patterns
- Terraform Modules skill (`tsh-implementing-terraform-modules`) for reusable Terraform modules across AWS, Azure, and GCP with per-cloud module references
- Secrets Management skill (`tsh-managing-secrets`) for secrets management patterns in cloud and Kubernetes environments
- Cloud Cost Optimization skill (`tsh-optimizing-cloud-cost`) for rightsizing, tagging strategies, and spending analysis with tagging standards reference
- AWS cost analysis prompt (`/tsh-analyze-aws-costs`) for cost optimization and tagging compliance audit with hybrid IaC + live API approach
- GCP cost analysis prompt (`/tsh-analyze-gcp-costs`) for cost optimization and labeling compliance audit with hybrid IaC + live API approach
- Infrastructure audit prompt (`/tsh-audit-infrastructure`) for multi-scope audit (AWS/Azure/GCP/K8s/CI-CD) covering security, cost, and best practices
- Kubernetes deployment prompt (`/tsh-deploy-kubernetes`) for deployments, Helm charts, and workload configurations
- CI/CD pipeline prompt (`/tsh-implement-pipeline`) for pipelines with deployment stages and environment protection
- Terraform implementation prompt (`/tsh-implement-terraform`) for Terraform modules and cloud infrastructure provisioning
- Observability implementation prompt (`/tsh-implement-observability`) for metrics, logs, traces, and alerting solutions

### Changed

- Updated Architect agent (`tsh-architect`) with handoff to DevOps Engineer for infrastructure implementation
- Renamed 7 new infrastructure skill directories with `tsh-` prefix (continuation of 2026-03-05 prefix migration)
- Renamed 7 new infrastructure prompt files with `tsh-` prefix
- Updated all skill cross-references in architect agent, devops engineer agent, and all 7 infrastructure SKILL.md files
- Updated all skill references in 7 infrastructure prompt files

## 2026-03-05

### Changed

- Added `tsh-` prefix to all Copilot customization artifacts to prevent naming collisions when used alongside project-specific customizations
- Renamed all 18 skill directories to include `tsh-` prefix (e.g., `code-reviewing` → `tsh-code-reviewing`, `creating-agents` → `tsh-creating-agents`)
- Renamed all 15 prompt files to include `tsh-` prefix (e.g., `/create-custom-agent` → `/tsh-create-custom-agent`, `/implement` → `/tsh-implement`)
- Renamed worker agents to include `tsh-` prefix: `copilot-researcher` → `tsh-copilot-researcher`, `copilot-artifact-creator` → `tsh-copilot-artifact-creator`, `copilot-artifact-reviewer` → `tsh-copilot-artifact-reviewer`
- Updated all cross-references between artifacts to use prefixed names

### Added

- Naming convention instruction (`.github/instructions/naming-conventions.instructions.md`) enforcing `tsh-` prefix on all artifact filenames, frontmatter names, and cross-references
- `tsh-` prefix explanation note in README for external users

## 2026-03-02

### Added

- Custom agent creation prompt (`/create-custom-agent`) for creating new `.agent.md` files via the orchestrator — researches existing patterns, guides design decisions, creates and validates the agent file
- Custom skill creation prompt (`/create-custom-skill`) for creating new `SKILL.md` files via the orchestrator — enforces gerund naming, creates supporting resources alongside the skill file
- Custom prompt creation prompt (`/create-custom-prompt`) for creating new `.prompt.md` files via the orchestrator — identifies correct agent routing, ensures prompt follows established patterns
- Custom instructions creation prompt (`/create-custom-instructions`) for creating new `.instructions.md` or `copilot-instructions.md` files via the orchestrator — helps decide between repo-level and file-scoped instructions

### Changed

- Creating Agents, Creating Skills, Creating Prompts, and Creating Instructions skills marked as internal (agent-only) — hidden from the slash command menu via `user-invokable: false` in SKILL.md frontmatter while remaining accessible to agents
- New `/create-custom-*` prompts serve as the recommended user-facing entry points for Copilot customization workflows, replacing direct skill invocation

## 2026-03-01

### Changed

- Restructured README around the full product development lifecycle: Product Ideation → Development → Quality
- Reorganized Agents, Skills, and Prompts sections into lifecycle phase groups (Product Ideation, Development, Quality)
- Moved Context Engineer from Product Ideation to Development agents
- Renamed "Backlog" phase to "Product Ideation" across the entire README
- Updated workflow examples to show `/research` under Development (not Product Ideation)
- Replaced flat prompt/agent listings with per-phase tables in "Using This Repository" section
- Updated Summary to reflect full lifecycle framing
- Renamed agent: `tsh-workshop-analyst` → `tsh-business-analyst`
- Renamed agent: `tsh-business-analyst` → `tsh-context-engineer` (old Business Analyst became Context Engineer)
- Renamed prompt: `/workshop-analyze` → `/analyze-materials`
- Renamed prompt: `/transcript-clean` → `/clean-transcript`
- Renamed prompt: `/code-quality-check` → `/review-codebase`
- Renamed prompt: `/e2e` → `/implement-e2e`
- Renamed skill: `task-extraction` → `task-extracting`
- Renamed skill: `task-quality-review` → `task-quality-reviewing`
- Renamed skill: `frontend-implementation` → `implementing-frontend`
- Renamed skill: `ui-verification` → `ui-verifying`
- Renamed skill: `architecture-design` → `architecture-designing`
- Renamed skill: `code-review` → `code-reviewing`
- Renamed skill: `codebase-analysis` → `codebase-analysing`
- Renamed skill: `implementation-gap-analysis` → `implementation-gap-analysing`
- Renamed skill: `task-analysis` → `task-analysing`

## 2026-02-27

### Added

- Copilot Engineer agent (`tsh-copilot-engineer`) for designing, creating, reviewing, and improving all GitHub Copilot customization artifacts — custom agents, skills, prompts, and instructions
- Copilot Orchestrator agent (`tsh-copilot-orchestrator`) for coordinating complex, multi-step Copilot engineering tasks by decomposing work into focused subtasks and delegating to specialized workers
- Copilot Researcher worker agent (`copilot-researcher`) for gathering, analyzing, and summarizing information from codebases and documentation — read-only research specialist for orchestrator delegation
- Copilot Artifact Creator worker agent (`copilot-artifact-creator`) for building and modifying Copilot customization artifacts based on detailed specifications — creation specialist for orchestrator delegation
- Copilot Artifact Reviewer worker agent (`copilot-artifact-reviewer`) for evaluating Copilot customization artifacts against best practices, workspace consistency, and structural correctness — review specialist for orchestrator delegation
- Orchestrator pattern documentation (`docs/orchestrator-pattern.md`) describing the orchestrator + specialized workers architecture as an alternative to monolithic agents, addressing context window degradation in complex multi-step tasks
- Creating Agents skill (`creating-agents`) with agent file template, structural conventions, and validation checklist for building `.agent.md` files
- Creating Skills skill (`creating-skills`) with naming conventions, body structure guidelines, progressive disclosure patterns, templates, and examples for building `SKILL.md` files
- Creating Prompts skill (`creating-prompts`) with prompt file template, workflow focus guidelines, and validation checklist for building `.prompt.md` files
- Creating Instructions skill (`creating-instructions`) with templates for repository-level and granular instruction files, decision framework for instruction vs. skill placement

### Changed

- Adopted gerund-form naming convention (`verb-ing` + `object`) as the standard for all skill directories, documented in README and enforced by the Creating Skills skill
- Existing skills will be adapted to follow the new gerund-form naming convention in separate upcoming pull requests

## 2026-02-24

### Added

- Workshop Analyst agent (`tsh-workshop-analyst`) for converting discovery workshop materials (transcripts, designs, codebase context) into Jira-ready epics and user stories
- Transcript Processing skill (`transcript-processing`) for cleaning raw workshop/meeting transcripts and extracting structured business-relevant content
- Task Extraction skill (`task-extraction`) for identifying and structuring epics and user stories from workshop materials
- Task Quality Review skill (`task-quality-review`) for analyzing extracted tasks for quality gaps, missing edge cases, and improvement opportunities
- Jira Task Formatting skill (`jira-task-formatting`) for transforming extracted tasks into Jira-ready format with field mapping and markdown compatibility
- Workshop analysis prompts: `/workshop-analyze`, `/transcript-clean`, `/create-jira-tasks`

## 2026-02-18

### Added

- SQL & Database engineering skill covering schema design (naming conventions, primary key strategies, data types, normalisation), performant SQL writing, indexing strategies, join optimisation, locking mechanics, transactions, query debugging with EXPLAIN ANALYZE, and ORM integration (TypeORM, Prisma, Doctrine, Eloquent, Entity Framework, Hibernate, GORM). Applies to PostgreSQL, MySQL, MariaDB, SQL Server, and Oracle

## 2026-02-17

### Added

- Frontend Implementation skill (`frontend-implementation`) for accessibility, design system usage, component patterns, and performance guidelines
- UI Verification skill (`ui-verification`) for verification criteria, tolerances, checklists, and severity definitions

### Changed

- Consolidated `tsh-frontend-software-engineer` agent into `tsh-software-engineer` - frontend capabilities are now handled via skills
- Updated `tsh-software-engineer` tool guidelines with frontend-specific scenarios (Figma, Playwright, design tokens)
- Made skills tool-agnostic by removing hardcoded tool names
- Refactored `implement-ui.prompt.md` and `review-ui.prompt.md` to reference skills instead of duplicating content

### Removed

- `tsh-frontend-software-engineer` agent (replaced by `tsh-software-engineer` + frontend skills)

## 2026-02-15

### Added

- Code quality check prompt (`/code-quality-check`) for comprehensive repository analysis covering dead code detection, duplication identification, improvement opportunities, and architecture review

## 2026-02-08

### Added

- Technical context discovery skill for codebase exploration and understanding

### Changed

- Refactored agents, prompts, and skills to follow a consistent standard
- Improved architecture-design plan example with expanded detail
- Updated implementation-gap-analysis and task-analysis examples
- Streamlined agent definitions by extracting workflow logic into prompts and skills

## 2026-02-07

### Added

- Skills support for modular, domain-specific agent capabilities (architecture-design, code-review, codebase-analysis, e2e-testing, implementation-gap-analysis, task-analysis)

### Changed

- Cleaned up repository structure

## 2026-02-05

### Changed

- Switched default model to Claude Opus 4.6
- Updated documentation for VS Code 1.109 compatibility

## 2026-02-03

### Removed

- GitHub MCP integration
- Copilot Spaces usage from agents

## 2026-01-29

### Fixed

- Updated tool names to follow new VS Code naming pattern

## 2026-01-21

### Fixed

- Updated Atlassian MCP URL to new recommended endpoint

## 2026-01-15

### Changed

- Removed "(Preview)" label from model names in all prompt files for consistency

## 2026-01-08

### Changed

- Updated package name

## 2026-01-07

### Changed

- Updated agent tools for improved functionality and testing capabilities

## 2025-12-18

### Added

- Frontend Software Engineer agent with UI implementation workflow
- UI implementation prompt with iterative UI verification process

## 2025-12-16

### Changed

- Standardized tool names across all agents

## 2025-12-15

### Changed

- Separated workflow instructions from agent identity definitions

## 2025-12-12

### Added

- Language consistency guidelines for agents

### Changed

- Code reviewer now runs automatically after implementation

## 2025-12-11

### Added

- Copilot Pro license requirement documentation

## 2025-12-10

### Changed

- Updated review prompt model to Claude Opus 4.5

## 2025-12-08

### Added

- Domain-specific Copilot Spaces support for agents
- Code reviewer as a subagent of the software engineer

## 2025-12-02

### Added

- VS Code version requirement documentation (1.99+)

### Changed

- Generalized software engineer agent (previously backend-specific)
- Standardized agent descriptions and enforced instructions usage
- Switched agents to use Claude Opus

## 2025-11-28

### Added

- Figma MCP Server integration for UI verification
- Git-committer agent with automated commit message generation

## 2025-11-26

### Added

- `tsh-` prefix for all agent names for namespace consistency
- Atlassian resource accessibility checks

## 2025-11-23

### Added

- Detailed MCP tool usage guidelines for all agents (Context7, Playwright, Figma, Atlassian)

## 2025-11-21

### Added

- Sequential Thinking MCP integration for complex problem-solving
- Data Engineer agent

## 2025-11-20

### Added

- MCP server configurations (Playwright, Context7, Figma Dev Mode, Atlassian)
- UI/Figma verification agent and review workflow
- Frontend Software Engineer agent (initial base)

## 2025-11-19

### Added

- MCP configuration for workspace and user-level setups
- LICENSE file and updated README

## 2025-11-14

### Added

- Agent-based architecture with handoffs (Architect, Business Analyst, Software Engineer, Code Reviewer)

### Changed

- Updated models to GPT-5.1 across prompts
- Specified Figma MCP usage in research workflow

## 2025-11-05

### Changed

- Planning prompt now focuses on tasks only, excluding improvements

## 2025-11-03

### Added

- New operational mode and additional tools

## 2025-10-31

### Changed

- Narrowed Atlassian/Jira access scope
- Enhanced planning and research prompts with implementation analysis guidelines

## 2025-10-29

### Added

- Plan prompt with task-specific implementation focus

## 2025-10-28

### Added

- Initial project setup with EditorConfig, Prettier, Husky, and Copilot configurations
- Automated commit message generation prompt
- Security review configuration and documentation
