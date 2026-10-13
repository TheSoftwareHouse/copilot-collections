---
sidebar_position: 34
title: Implementing Backend
---

# Implementing Backend

**Folder:** `.github/skills/tsh-implementing-backend/`  
**Used by:** [Software Engineer](../agents/software-engineer)

Provides patterns for building backend API services with modular architecture, structured testing, and production-ready infrastructure following TSH best practices. Applies to Node.js, PHP, .NET, Java, and Go backends.

## Key Areas

| Area | Coverage |
|---|---|
| **Guiding Principles** | SRP, DRY, KISS, YAGNI, and pragmatism: follow patterns when they add value and document the reasoning when breaking them |
| **Architecture** | Vertical slice / modular structure organized by domain, with a `shared/` folder for cross-cutting concerns used by 3+ modules |
| **REST API Design** | Plural kebab-case resource names, standard HTTP methods and status codes, a standard error response format |
| **DataGrid Standard** | Mandatory `page`, `limit`, `sort[field]`, `filter[field]`, and `search` parameters, with a `meta` + `data` response envelope |
| **Auth** | JWT-based authentication, a `GET /me` endpoint, RBAC or ABAC checks before the controller action |
| **Database** | ORM with the Repository Pattern, reversible migrations, idempotent seeds for non-production environments only |
| **External Services** | Dedicated client/adapter classes that map external types to domain types, with retries and timeouts |
| **Testing** | Unit tests for business logic, integration tests for endpoints against a real test database, mocked external services |
| **Operations** | Swagger/OpenAPI docs at `/api-docs`, Docker and docker-compose, a public `GET /health` endpoint, structured JSON logging |
| **Security and Config** | OWASP Top 10 practices, horizontal scalability, environment-based configuration validated on startup |

## Implementation Procedure

1. Understand the requirements
2. Design the data model
3. Create migration(s)
4. Implement the domain layer (entities, services, repositories)
5. Implement the API layer (controllers, DTOs, validation)
6. Add authentication/authorization guards
7. Write integration tests for endpoints
8. Write unit tests for business logic
9. Document the API (Swagger)
10. Verify logging and error handling

## Technology References

The patterns are language-agnostic. Technology-specific guidance is loaded from reference files:

- **Node.js** — NestJS/Express, Jest/Supertest, Pino/Winston, TypeORM/Prisma
- **PHP** — Symfony/Laravel, PHPUnit, Monolog, Doctrine/Eloquent
- **.NET** — built-in DI, xUnit, Serilog, Entity Framework
- **Java** — Spring Boot, JUnit/REST Assured, SLF4J/Logback, Hibernate
- **Go** — Wire/Fx, Go testing, Zap, GORM

## Connected Skills

- `tsh-sql-and-database-understanding` — database schema design, query optimization, and ORM integration.
- `tsh-technical-context-discovering` — understand project conventions before implementing.
- `tsh-implementation-gap-analysing` — verify current state before making changes.
- `tsh-codebase-analysing` — understand existing architecture and patterns.
- `tsh-implementing-ci-cd` — CI/CD pipeline setup and deployment strategies.
- `tsh-implementing-observability` — logging, monitoring, and distributed tracing.
- `tsh-managing-secrets` — secure credential storage and rotation.
- `tsh-e2e-testing` — end-to-end testing with Playwright.
