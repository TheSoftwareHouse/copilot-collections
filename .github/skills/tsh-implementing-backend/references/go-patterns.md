# Go Implementation Patterns

Go-specific patterns for the `tsh-implementing-backend` skill. Load this reference when the project uses Go.

## Table of Contents

- [Dependency Injection](#dependency-injection)
- [Testing Tools](#testing-tools)
- [Logging](#logging)
- [ORM & Database](#orm--database)
- [API Documentation](#api-documentation)
- [Security](#security)
- [Docker](#docker)

## Dependency Injection

| Approach | When to Use |
|---|---|
| Manual constructor injection | Simple projects, few dependencies |
| Wire (Google) | Compile-time DI with code generation |
| Fx (Uber) | Runtime DI with lifecycle management |

### Manual Constructor Injection

```go
type UsersService struct {
    repo   UsersRepository
    mailer EmailClient
}

func NewUsersService(repo UsersRepository, mailer EmailClient) *UsersService {
    return &UsersService{repo: repo, mailer: mailer}
}
```

### Wire Example

```go
// wire.go
//go:build wireinject

func InitializeApp(cfg *config.Config) (*App, error) {
    wire.Build(
        NewUsersRepository,
        NewUsersService,
        NewUsersHandler,
        NewApp,
    )
    return nil, nil
}
```

### Fx Example

```go
func main() {
    fx.New(
        fx.Provide(
            config.New,
            database.New,
            NewUsersRepository,
            NewUsersService,
            NewUsersHandler,
        ),
        fx.Invoke(StartServer),
    ).Run()
}
```

## Testing Tools

| Level | Tools |
|---|---|
| Unit Tests | `testing` (stdlib), `testify/assert`, `testify/mock` |
| Integration Tests | `net/http/httptest`, Testcontainers-Go |
| E2E Tests | Playwright |

### Integration Test Example

```go
func TestCreateUser(t *testing.T) {
    app := setupTestApp(t)
    defer app.Cleanup()

    payload := `{"email":"test@example.com","name":"Test User"}`
    req := httptest.NewRequest(http.MethodPost, "/api/users", strings.NewReader(payload))
    req.Header.Set("Content-Type", "application/json")

    rec := httptest.NewRecorder()
    app.Router.ServeHTTP(rec, req)

    assert.Equal(t, http.StatusCreated, rec.Code)

    var body map[string]interface{}
    json.Unmarshal(rec.Body.Bytes(), &body)
    assert.Equal(t, "test@example.com", body["data"].(map[string]interface{})["email"])
}
```

### Table-Driven Tests

```go
func TestValidateEmail(t *testing.T) {
    tests := []struct {
        name  string
        email string
        valid bool
    }{
        {"valid email", "user@example.com", true},
        {"missing @", "userexample.com", false},
        {"empty string", "", false},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            err := validateEmail(tt.email)
            if tt.valid {
                assert.NoError(t, err)
            } else {
                assert.Error(t, err)
            }
        })
    }
}
```

## Logging

| Logger | When to Use |
|---|---|
| Zap (Uber) | High-performance structured logging — preferred for production |
| zerolog | Zero-allocation JSON logging — alternative to Zap |
| slog (stdlib) | Go 1.21+ — standard library structured logging |

### Zap Setup

```go
func NewLogger(env string) (*zap.Logger, error) {
    if env == "production" {
        return zap.NewProduction()
    }
    return zap.NewDevelopment()
}

// Usage with context fields
logger.Info("user created",
    zap.String("userId", user.ID),
    zap.String("email", user.Email),
    zap.String("requestId", ctx.Value("requestId").(string)),
)
```

- Use middleware to inject `requestId` and log every request.
- Never use `fmt.Println` or `log.Println` in production.
- Use `zap.Sugar()` only in non-performance-critical paths.

## ORM & Database

| ORM | When to Use |
|---|---|
| GORM | Full ORM — most popular in Go ecosystem |
| sqlx | Enhanced `database/sql` — struct scanning, named params |
| Ent (Facebook) | Code-generation ORM with type-safe graph traversals |
| `database/sql` | Standard library — maximum control, zero overhead |

### GORM Model Example

```go
type User struct {
    ID        uuid.UUID      `gorm:"type:uuid;primaryKey;default:gen_random_uuid()"`
    Email     string         `gorm:"uniqueIndex;not null"`
    Name      string         `gorm:"not null"`
    CreatedAt time.Time
    UpdatedAt time.Time
    DeletedAt gorm.DeletedAt `gorm:"index"`
}
```

### Migrations

Use `golang-migrate/migrate` or `goose`:

```
migrations/
├── 000001_create_users_table.up.sql
├── 000001_create_users_table.down.sql
├── 000002_add_status_to_orders.up.sql
├── 000002_add_status_to_orders.down.sql
```

```bash
migrate -path migrations -database "$DATABASE_URL" up
```

## API Documentation

| Tool | Integration |
|---|---|
| swaggo/swag | Auto-generates OpenAPI from Go comments |
| oapi-codegen | Generates Go server/client from OpenAPI spec (spec-first) |

### swaggo Example

```go
// @Summary Create a new user
// @Tags users
// @Accept json
// @Produce json
// @Param user body CreateUserDto true "User data"
// @Success 201 {object} UserResponse
// @Failure 400 {object} ErrorResponse
// @Router /api/users [post]
func (h *UsersHandler) Create(c *gin.Context) {
    // ...
}
```

## Security

### Auth Middleware

- **Gin**: Apply auth middleware to route groups — `authorized := router.Group("/api"); authorized.Use(authMiddleware())`. Public routes go outside the group.
- **Chi**: Apply middleware to subrouter — `r.Route("/api", func(r chi.Router) { r.Use(authMiddleware); ... })`.
- **Echo**: Use `e.Use(middleware.KeyAuth(...))` or custom JWT middleware at the group level.

### Input Validation

- Use `go-playground/validator` struct tags: `binding:"required,email"` (Gin) or `validate:"required,email"`. Always validate request structs before processing — never trust client input.

### File Uploads

- Limit upload size with `http.MaxBytesReader(w, r.Body, maxSize)` before parsing. Validate MIME type via `http.DetectContentType(buf)` (reads first 512 bytes). Sanitize filenames with `filepath.Base()` — reject names containing `..`.
- **Gin**: Use `c.ShouldBind()` with `binding:"required"` and set `MaxMultipartMemory` on the router.

### Webhook HMAC Validation

Verify webhook signatures using `subtle.ConstantTimeCompare()` — **never** use `==` or `bytes.Equal()`:
```go
mac := hmac.New(sha256.New, []byte(secret))
mac.Write(rawBody)
expected := mac.Sum(nil)
signature, _ := hex.DecodeString(r.Header.Get("X-Signature"))
if subtle.ConstantTimeCompare(expected, signature) != 1 {
    http.Error(w, "invalid signature", http.StatusUnauthorized)
    return
}
```

### Rate Limiting

- **In-process**: Use `golang.org/x/time/rate` — `rate.NewLimiter(rate.Every(time.Minute), 10)`. Apply as middleware.
- **Distributed**: Use `ulule/limiter` with Redis store for multi-instance deployments.

### HTTP Security Headers

- Use `rs/cors` for CORS configuration — never use `AllowAllOrigins` in production.
- Set security headers via middleware: `Strict-Transport-Security`, `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`, `Content-Security-Policy`.

## Docker

```dockerfile
# Build stage
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /out/server ./cmd/server

# Production stage
FROM alpine:3.19
WORKDIR /app
RUN apk --no-cache add ca-certificates
COPY --from=builder /out/server .
RUN addgroup -g 1001 -S appgroup && adduser -S appuser -u 1001 -G appgroup
USER appuser
EXPOSE 8080
ENTRYPOINT ["./server"]
```
