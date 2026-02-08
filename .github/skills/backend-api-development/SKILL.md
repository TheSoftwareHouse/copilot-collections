---
name: backend-api-development
description: Backend API service development patterns, standards, and procedures. Use for building REST/GraphQL APIs, implementing CRUD endpoints, database handling, authentication, testing strategies, external service integrations, filtering/pagination (DataGrid), logging, Docker setup, and modular architecture. Applies to Node.js, PHP, .NET, Java, and Go backends.
---

# Backend API Development

This skill provides standards and procedures for building backend API services following TSH best practices. It is language-agnostic and applies to Node.js, PHP, .NET, Java, and Go projects.

## When to Use

- Building new REST or GraphQL API endpoints
- Implementing CRUD operations with filtering, sorting, and pagination
- Setting up authentication and authorization (JWT)
- Integrating with external/third-party services
- Writing integration tests for endpoints or unit tests for business logic
- Configuring database migrations, seeding, or repository patterns
- Setting up Docker and docker-compose for local development
- Implementing logging and observability
- Documenting APIs with Swagger/OpenAPI
- Designing modular architecture with vertical slices

## Guiding Principles

| Principle | Application |
|---|---|
| **SRP** | Each class/module has one reason to change. Controllers handle HTTP, services handle business logic, repositories handle data access. |
| **DRY** | Extract shared logic into reusable services or utilities. Do not duplicate validation, mapping, or query logic. |
| **KISS** | Prefer simple, readable solutions. Avoid over-engineering. Do not add abstractions until they are needed. |
| **YAGNI** | Do not build features or infrastructure "just in case". Implement what is needed now. |
| **Pragmatism** | Follow patterns when they add value. Break rules when strict adherence creates unnecessary complexity. Document the reasoning. |

## Architecture: Vertical Slice / Modular Structure

Organize code by **domain/feature**, not by technical layer. All artifacts related to a domain live in the same directory.

```
src/
├── users/
│   ├── users.controller.ts      # HTTP layer (routes, request/response)
│   ├── users.service.ts          # Business logic
│   ├── users.repository.ts       # Data access
│   ├── users.module.ts           # Module registration / DI wiring
│   ├── dto/
│   │   ├── create-user.dto.ts
│   │   └── update-user.dto.ts
│   ├── entities/
│   │   └── user.entity.ts
│   ├── tests/
│   │   ├── users.integration.test.ts
│   │   └── users.service.unit.test.ts
│   └── users.swagger.yml         # (if using separate swagger files)
├── orders/
│   ├── orders.controller.ts
│   ├── orders.service.ts
│   ├── orders.repository.ts
│   └── ...
├── shared/                       # Cross-cutting concerns only
│   ├── middleware/
│   ├── guards/
│   ├── filters/
│   ├── interceptors/
│   └── utils/
└── config/
    ├── database.config.ts
    ├── auth.config.ts
    └── app.config.ts
```

**Rules:**
- A module should be self-contained. Moving or removing a feature module should not break other modules.
- Cross-module communication goes through well-defined interfaces (service interfaces, events), never direct imports of internal classes.
- Shared utilities go in `shared/` only when used by 3+ modules. Otherwise keep them in the feature module.

## REST API Design

### Resource Naming & HTTP Methods

| Method | Path | Purpose | Success Code |
|---|---|---|---|
| `GET` | `/resources` | List with filtering, sorting, pagination | `200` |
| `GET` | `/resources/:id` | Single resource details | `200` |
| `POST` | `/resources` | Create resource | `201` |
| `PATCH` | `/resources/:id` | Partial update | `200` |
| `PUT` | `/resources/:id` | Full replace (use sparingly) | `200` |
| `DELETE` | `/resources/:id` | Remove resource | `204` |

**Naming conventions:**
- Use plural nouns for resource names: `/users`, `/orders`, `/products`
- Use kebab-case for multi-word resources: `/order-items`
- Nest sub-resources max 1 level deep: `/users/:id/orders` (avoid deeper nesting)
- Use query parameters for filtering, not path segments

### Standard Error Response Codes

| Code | Meaning |
|---|---|
| `400` | Validation errors (malformed request body, missing fields) |
| `401` | Unauthenticated (missing or invalid token) |
| `403` | Unauthorized (valid token but insufficient permissions) |
| `404` | Resource not found |
| `409` | Conflict (e.g. duplicate unique field) |
| `422` | Business logic errors (foreign key violation, state conflict) |
| `500` | Unexpected server error (never expose stack traces in production) |

### Standard Error Response Format

```json
{
  "statusCode": 400,
  "error": "Bad Request",
  "message": "Validation failed",
  "details": [
    { "field": "email", "message": "must be a valid email address" }
  ]
}
```

## DataGrid: Filtering, Sorting & Pagination (TSH Standard)

Every list endpoint returning paginated data **MUST** follow this schema.

### Request Query Parameters

| Parameter | Format | Description |
|---|---|---|
| `page` | `page=1` | Page number (starting from 1) |
| `limit` | `limit=10` | Max results per page |
| `sort[field]` | `sort[lastName]=ASC` | Sort by field, direction: `ASC` or `DESC` |
| `filter[field]` | `filter[firstName]=John` | Filter by field value |
| `search` | `search=john` | General text search (implementation-specific: LIKE, full-text, etc.) |

**Example:** `GET /users?page=1&limit=10&sort[lastName]=ASC&filter[status]=active&search=john`

### Filter Behavior

- **Same field, multiple values** → interpreted as `OR`:
  ```
  ?filter[firstName]=Ewa&filter[firstName]=Adam
  → WHERE (firstName = 'Ewa' OR firstName = 'Adam')
  ```
- **Different fields** → interpreted as `AND`:
  ```
  ?filter[firstName]=Ewa&filter[lastName]=Kowalska
  → WHERE (firstName = 'Ewa' AND lastName = 'Kowalska')
  ```
- **LIKE search** → use URL-encoded `%25` suffix:
  ```
  ?filter[lastName]=Now%25
  → WHERE lastName LIKE 'Now%'
  ```

### Advanced Filter Operators (when applicable)

| Operator | SQL Equivalent | Example |
|---|---|---|
| `eq` | `=` | `filter[status][eq]=active` |
| `neq` | `<>` | `filter[status][neq]=deleted` |
| `lt`, `lte` | `<`, `<=` | `filter[age][lt]=30` |
| `gt`, `gte` | `>`, `>=` | `filter[age][gte]=18` |
| `include` | `LIKE %val%` | `filter[name][include]=john` |
| `in` | `IN (...)` | `filter[status][in]=active,pending` |

### Response Format (Mandatory)

```json
{
  "meta": {
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 57,
      "totalPages": 6
    },
    "filter": {
      "status": "active"
    },
    "sort": {
      "lastName": "ASC"
    },
    "search": "john"
  },
  "data": [{ "..." }]
}
```

**Rules:**
- `meta` always reflects the actual applied parameters back to the client.
- Invalid filter/sort field names are **silently ignored** (no error thrown), but not applied.
- Default `limit` should be defined in app configuration (e.g. 20 or 50).
- Maximum `limit` should be capped to prevent abuse (e.g. 100 or 250).

## Authentication & Authorization

### JWT-Based Authentication

- Use **JSON Web Tokens (JWT)** for stateless authentication.
- Token is passed in the `Authorization` header: `Bearer <token>`.
- Validate the token signature, expiration (`exp`), and issuer (`iss`) on every protected request.
- Store secrets/keys in environment variables, never in code.
- Use short-lived access tokens (15-60 minutes) with refresh token rotation where appropriate.

### Current User Endpoint

- Expose a `GET /me` endpoint that returns the profile of the currently authenticated user.
- This endpoint should extract the user identity from the JWT (e.g. `sub` claim) and return the full user profile.
- Do **not** accept user ID as a parameter — always derive from the token.

```
GET /me
Authorization: Bearer <token>
→ 200 { "id": "...", "email": "...", "roles": [...] }
```

### Authorization

- Implement role-based access control (RBAC) or attribute-based access control (ABAC) depending on project complexity.
- Authorization checks happen via middleware/guards **before** reaching the controller action.
- Always validate that the authenticated user has permission to access/modify the specific resource (not just the endpoint).

## Dependency Injection

- **Always use a DI container.** Register services, repositories, and infrastructure in a central container/module.
- Inject dependencies via constructor injection.
- Depend on **interfaces/abstractions**, not concrete implementations.
- DI enables testability: in tests, swap real implementations with mocks/stubs.

**Language-specific recommendations:**
| Language | DI Approach |
|---|---|
| Node.js (Express) | Awilix, tsyringe, or InversifyJS |
| Node.js (NestJS) | Built-in NestJS DI |
| PHP (Symfony/Laravel) | Built-in service container |
| .NET | Built-in `Microsoft.Extensions.DependencyInjection` |
| Java (Spring) | Built-in Spring IoC |
| Go | Wire, Fx, or manual constructor injection |

## Database Handling

### ORM & Repository Pattern

- Use the project's ORM for all database operations (TypeORM, MikroORM, Doctrine, Entity Framework, Hibernate, GORM, etc.).
- Implement the **Repository Pattern**: all database queries go through repository classes, never directly from services or controllers.
- Repositories return domain entities/models, not raw database rows.
- Use **transactions** for operations that modify multiple tables/records.

### Migrations

- **All** database schema changes go through migration files. Never modify the database manually.
- Each migration must have both `up` (apply) and `down` (revert) methods.
- Migrations run automatically on application startup (for containerized apps) or via a dedicated migration command/lambda (for serverless).
- Never modify an existing migration that has been deployed. Create a new migration instead.
- Name migrations descriptively: `2025-02-08-add-status-column-to-orders`.

### Seeding

- Provide seed data for **development, test, and staging** environments only.
- **Never** seed production or UAT environments with test data.
- Seeds should be idempotent — running them multiple times produces the same result.
- Separate seed files by domain (e.g. `seed-users.ts`, `seed-products.ts`).

### Database Best Practices

- Use `UUID` or `ULID` for primary keys where appropriate (better for distributed systems).
- Define proper indexes for foreign keys, frequently queried columns, and unique constraints.
- Use snake_case naming for tables and columns (e.g. `order_items`, `created_at`).
- Always define `created_at` and `updated_at` timestamps.
- Use soft deletes (`deleted_at`) when business rules require record retention.

## External Service Adapters (Third-Party Clients)

When integrating with external APIs, **always create a dedicated client/adapter class**.

### Pattern

```
src/
├── integrations/
│   ├── payment-gateway/
│   │   ├── payment-gateway.client.ts   # HTTP calls, request/response mapping
│   │   ├── payment-gateway.types.ts    # External API types/interfaces
│   │   └── payment-gateway.module.ts   # DI registration
│   ├── email-provider/
│   │   ├── email-provider.client.ts
│   │   └── ...
```

### Rules

1. **Isolate all HTTP communication** with external services into a client class. Never call HTTP clients (Axios, fetch, HttpClient) directly from services or controllers.
2. **Map external types** to internal domain types at the adapter boundary. The rest of the application should not know about the external API's data format.
3. **Store configuration** (API URLs, keys, tokens) in environment variables and inject via config.
4. **Handle errors gracefully**: catch HTTP errors, map them to domain-specific exceptions, and log the details.
5. **Make clients testable**: depend on an interface so the client can be mocked in tests.
6. **Add retry logic and timeouts** for resilience. Use circuit breaker patterns for critical integrations.

## Testing Strategy

### Test Pyramid

| Level | What to Test | Tools |
|---|---|---|
| **Unit Tests** | Pure business logic in services, domain models, utility functions. Mock all external dependencies. | Jest, Mocha, xUnit, JUnit, PHPUnit, Go testing |
| **Integration Tests** | API endpoints end-to-end (HTTP request → response). Use a real test database. | Supertest, REST Assured, Testcontainers |
| **E2E Tests** | Critical user flows across the full stack. | Playwright, Cypress (for frontend) |

### Integration Tests for Endpoints

- Test every endpoint with valid and invalid inputs.
- Use a dedicated **test database** (same engine as production, e.g. PostgreSQL).
- Each test should set up its own data (arrange), call the endpoint (act), and verify the response (assert).
- Clean up test data after each test (use transactions or truncation).
- Verify: HTTP status code, response body structure, side effects (database state, events emitted).

```
describe('POST /users', () => {
  it('should create a user and return 201', async () => {
    // Arrange
    const payload = { email: 'test@example.com', name: 'Test User' };

    // Act
    const response = await request(app).post('/users').send(payload);

    // Assert
    expect(response.status).toBe(201);
    expect(response.body.data.email).toBe('test@example.com');
  });

  it('should return 400 for invalid email', async () => {
    const response = await request(app).post('/users').send({ email: 'invalid' });
    expect(response.status).toBe(400);
  });
});
```

### Unit Tests for Business Logic

- Test services and domain models in isolation.
- Mock repositories, external clients, and infrastructure.
- Focus on edge cases, error paths, and business rules.
- Keep unit tests fast — no database, no network, no filesystem.
- Use descriptive test names: `should throw InsufficientFundsError when balance is below transfer amount`.

### Testing Rules

- Every new endpoint or business rule **must** have tests before merging.
- Aim for meaningful coverage of critical paths, not arbitrary percentage targets.
- Integration tests are the primary quality gate for API behavior.
- Unit tests are the primary quality gate for business logic.
- Mock external services (payment gateways, email providers) — never call real external APIs in tests.

## API Documentation

### Swagger / OpenAPI

- **Every API must be documented** using OpenAPI/Swagger specification.
- Prefer auto-generated docs from code annotations/decorators when the framework supports it (e.g. NestJS `@nestjs/swagger`, Spring `springdoc-openapi`, .NET Swashbuckle).
- If auto-generation is not available, maintain a separate `swagger.yml` file split by domain.
- Serve documentation at `/api-docs` endpoint.
- Document: request/response schemas, query parameters, authentication requirements, error responses, and example values.
- Keep documentation in sync with the actual API — stale docs are worse than no docs.

## Docker & Local Development

### Docker Setup

- Every project **must** include a `Dockerfile` and `docker-compose.yml` for local development.
- The `docker-compose.yml` should include all required services: app, database (PostgreSQL), cache (Redis), mail catcher (Mailhog), etc.
- Use `docker-compose.override.yml` for developer-specific customizations (additional ports, volumes, debug settings).
- Application should be fully runnable with a single `docker-compose up` command.

### Dockerfile Best Practices

- Use multi-stage builds to keep images small.
- Pin base image versions (e.g. `node:20-alpine`, not `node:latest`).
- Install only production dependencies in the final stage.
- Use `.dockerignore` to exclude `node_modules`, `.git`, test files, etc.
- Run as a non-root user in the container.

## Health Check

Every application **must** expose a `GET /health` endpoint:
- Placed **before** all middleware and auth guards.
- Publicly accessible (no authentication required).
- Returns `200` with status information.

```json
{
  "status": "ok"
}
```

For more thorough health checks, optionally verify database connectivity and critical service availability.

## Logging & Observability

### Structured Logging

- Use a **structured logger** (Winston, Pino, Serilog, SLF4J/Logback, Zap) — never `console.log` in production.
- Log in **JSON format** for machine parseability.
- Include contextual fields in every log entry: `timestamp`, `level`, `requestId`/`correlationId`, `userId` (if authenticated), `service`.

### Log Levels

| Level | When to Use |
|---|---|
| `error` | Unexpected failures, unhandled exceptions, critical issues |
| `warn` | Recoverable issues, deprecation notices, approaching limits |
| `info` | Significant business events: user created, order placed, payment processed |
| `debug` | Detailed diagnostic information (disabled in production) |

### What to Log

- **Always log**: incoming requests (method, path, status code, duration), authentication failures, authorization failures, external service calls (URL, status, duration), errors with stack traces.
- **Never log**: passwords, tokens, API keys, credit card numbers, PII (personally identifiable information) unless encrypted or masked.

### Request Logging

- Log every HTTP request with: method, path, status code, response time, and correlation/request ID.
- Use middleware (Morgan, express request logger, or framework equivalent) for automatic request logging.
- Propagate a `correlationId` / `requestId` header through the entire request lifecycle for tracing.

## Scalability & Security

### Scalability

- Design for **horizontal scaling**: no in-memory state, no sticky sessions.
- Never store temporary data in application memory — use Redis or an external cache.
- Use message queues (SQS, RabbitMQ, Bull) for async operations (email sending, PDF generation, data processing).
- Use database connection pooling.
- Apply rate limiting on public endpoints.
- Implement pagination on all list endpoints (never return unbounded result sets).

### Security (OWASP TOP 10)

- **Input validation**: Validate and sanitize all user input at the API boundary (request body, query params, headers).
- **SQL Injection**: Always use parameterized queries / ORM. Never concatenate user input into SQL.
- **Authentication**: Use short-lived JWTs, validate signatures, handle token expiration.
- **Authorization**: Enforce at every endpoint. Check resource ownership, not just role membership.
- **Sensitive data**: Never expose stack traces, internal paths, or database details in error responses.
- **CORS**: Configure explicitly — never use `*` in production.
- **Security headers**: Use Helmet (Node.js) or equivalent to set security headers (CSP, X-Frame-Options, etc.).
- **Dependencies**: Regularly audit and update dependencies. Use tools like `npm audit`, Snyk, or Dependabot.
- **Rate limiting**: Apply on authentication and public endpoints.
- **Secrets**: Store in environment variables or a secrets manager. Never commit to source control.

## Configuration & Environment

- Use `.env` files for local development with a `.env.dist` (or `.env.example`) template committed to the repo.
- **Validate all configuration** on application startup (using Joi, Zod, class-validator, or equivalent). Fail fast on missing required config.
- Group configuration by concern: `database`, `auth`, `cache`, `externalServices`.
- Never hardcode environment-specific values. Everything must come from environment variables.

## Implementation Procedure

When implementing a new backend feature, follow this workflow:

```
Implementation progress:
- [ ] Step 1: Understand the requirements
- [ ] Step 2: Design the data model
- [ ] Step 3: Create migration(s)
- [ ] Step 4: Implement the domain layer (entities, services, repositories)
- [ ] Step 5: Implement the API layer (controllers, DTOs, validation)
- [ ] Step 6: Add authentication/authorization guards
- [ ] Step 7: Write integration tests for endpoints
- [ ] Step 8: Write unit tests for business logic
- [ ] Step 9: Document the API (Swagger)
- [ ] Step 10: Verify logging and error handling
```

**Step 1: Understand the requirements**
Read the task description, acceptance criteria, and any research documents. Clarify ambiguities before starting.

**Step 2: Design the data model**
Define entities, relationships, indexes, and constraints. Review with the team if the model is non-trivial.

**Step 3: Create migration(s)**
Generate migration files for all schema changes. Ensure both `up` and `down` are implemented. Run and verify locally.

**Step 4: Implement the domain layer**
Create entity classes, repository interfaces and implementations, and service classes with business logic. Follow vertical slice structure.

**Step 5: Implement the API layer**
Create controllers with proper HTTP methods. Define DTOs for request/response. Add input validation. Follow the DataGrid standard for list endpoints.

**Step 6: Add authentication/authorization guards**
Apply JWT validation middleware. Add role/permission checks as needed. Implement resource-level authorization.

**Step 7: Write integration tests**
Test every endpoint: success and error paths. Verify response structure, status codes, and database side effects.

**Step 8: Write unit tests**
Test business logic in services. Mock dependencies. Cover edge cases and error scenarios.

**Step 9: Document the API**
Add or update Swagger/OpenAPI documentation. Verify docs render correctly at `/api-docs`.

**Step 10: Verify logging and error handling**
Ensure requests are logged, errors produce structured log entries, and no sensitive data leaks in logs or responses.

## Connected Skills

- `technical-context-discovery` — for establishing project conventions before implementing
- `architecture-design` — for designing complex feature architectures
- `code-review` — for validating implemented code against these standards
- `e2e-testing` — for E2E test patterns when full-stack testing is needed
