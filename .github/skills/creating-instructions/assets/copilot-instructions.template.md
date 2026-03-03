<!-- 
  Repository-Level Copilot Instructions
  ======================================
  This is the project constitution — the single source of truth for 
  architecture, technology stack, and fundamental coding conventions.
  
  Place this file at: .github/copilot-instructions.md
  
  Guidelines:
  - Keep instructions short and self-contained
  - Include reasoning behind non-obvious rules
  - Show preferred/avoided patterns with code examples
  - Focus on what linters and formatters don't enforce
  - Update when architecture or stack changes
-->

> **This file is the project constitution.** Every rule below is a hard constraint — not a suggestion, not a guideline. Copilot must follow these rules in all interactions with this repository without exception. When in doubt, these instructions take precedence over general knowledge or external best practices.

# Architecture

<!-- Describe the overall architecture pattern and directory structure -->
<!-- Example: "This is a monorepo managed by Turborepo with apps/ for deployable applications and packages/ for shared libraries." -->

# Technology Stack

<!-- List ALL languages, frameworks, and key libraries with exact versions -->
<!-- Example:
- TypeScript 5.4 (strict mode enabled)
- React 19 with Server Components
- Next.js 15 (App Router)
- Tailwind CSS 4
- Prisma 6 (PostgreSQL)
- Vitest 3 for unit tests
- Playwright 1.50 for E2E tests
-->

# Coding Conventions

<!-- Document conventions NOT enforced by linters/formatters -->
<!-- Focus on architectural rules, naming conventions, and team agreements -->
<!-- Example:
- Business logic must not import from the UI layer directly — use shared interfaces from packages/types
- API route handlers must validate input using Zod schemas before processing
- All database queries must go through the repository pattern — no direct Prisma calls in route handlers
-->

# Error Handling

<!-- Describe the project's error handling strategy -->
<!-- Example:
- Use custom AppError class hierarchy for all application errors
- API errors must return { error: { code: string, message: string } } format
- Never expose internal error details in production responses
-->

# Testing Strategy

<!-- Overview of testing approach, frameworks, and key patterns -->
<!-- Example:
- Unit tests: Vitest with React Testing Library for components
- E2E tests: Playwright with Page Object pattern
- Test files collocated with source: `*.test.ts` next to `*.ts`
- Minimum 80% branch coverage for business logic modules
-->

# Development Workflow

<!-- Document how developers interact with the project — Copilot should use the same tools and scripts -->
<!-- Cover: how to start the project, task runners, common commands -->
<!-- Example:
- Local development uses Docker Compose: `docker compose up` starts all services
- Use the Makefile for all common tasks — do not run raw commands:
  - `make build` — build all services
  - `make test` — run unit tests
  - `make lint` — run linter
  - `make migrate` — run database migrations
  - `make seed` — seed the database with test data
- Never install dependencies directly — use `make install` which runs inside the container
- CI pipeline runs `make ci` which executes lint, test, and build in sequence
-->
