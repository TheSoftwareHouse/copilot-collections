# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

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
