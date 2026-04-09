# .NET Implementation Patterns

.NET-specific patterns for the `tsh-implementing-backend` skill. Load this reference when the project uses .NET (ASP.NET Core).

## Table of Contents

- [Dependency Injection](#dependency-injection)
- [Testing Tools](#testing-tools)
- [Logging](#logging)
- [ORM & Database](#orm--database)
- [API Documentation](#api-documentation)
- [Security](#security)
- [Docker](#docker)

## Dependency Injection

| Framework | DI Approach |
|---|---|
| ASP.NET Core | Built-in `Microsoft.Extensions.DependencyInjection` |

### Registration

```csharp
// Program.cs
builder.Services.AddScoped<IUsersRepository, UsersRepository>();
builder.Services.AddScoped<IUsersService, UsersService>();
builder.Services.AddHttpClient<IPaymentGatewayClient, PaymentGatewayClient>();
```

### Constructor Injection

```csharp
public class UsersService : IUsersService
{
    private readonly IUsersRepository _usersRepository;
    private readonly IEmailClient _emailClient;

    public UsersService(IUsersRepository usersRepository, IEmailClient emailClient)
    {
        _usersRepository = usersRepository;
        _emailClient = emailClient;
    }
}
```

### Service Lifetimes

| Lifetime | Registration | When to Use |
|---|---|---|
| Transient | `AddTransient` | Lightweight, stateless services |
| Scoped | `AddScoped` | Per-request services (repositories, DB contexts) |
| Singleton | `AddSingleton` | Shared state, caches, configuration |

## Testing Tools

| Level | Tools |
|---|---|
| Unit Tests | xUnit, NUnit, Moq, NSubstitute |
| Integration Tests | `WebApplicationFactory<T>`, Testcontainers |
| E2E Tests | Playwright |

### Integration Test Example

```csharp
public class UsersControllerTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public UsersControllerTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task CreateUser_ReturnsCreated()
    {
        var payload = new { email = "test@example.com", name = "Test User" };
        var content = new StringContent(
            JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");

        var response = await _client.PostAsync("/api/users", content);

        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
    }
}
```

## Logging

| Logger | When to Use |
|---|---|
| Serilog | Structured logging with rich sinks — preferred |
| Built-in `ILogger<T>` | Simple scenarios, or combined with Serilog as provider |

### Serilog Setup

```csharp
builder.Host.UseSerilog((context, config) =>
    config.ReadFrom.Configuration(context.Configuration)
          .Enrich.FromLogContext()
          .WriteTo.Console(new JsonFormatter()));
```

- Use `ILogger<T>` interface consistently — Serilog plugs in as provider.
- Use `Serilog.AspNetCore` for automatic request logging.
- Configure structured properties: `RequestId`, `UserId`, `CorrelationId`.

## ORM & Database

| ORM | When to Use |
|---|---|
| Entity Framework Core | Full ORM — standard for ASP.NET Core projects |
| Dapper | Micro-ORM — for performance-critical raw SQL queries |

### Entity Framework Core Entity Example

```csharp
public class User
{
    public Guid Id { get; set; }
    public string Email { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
    public DateTime? DeletedAt { get; set; }
}

public class UserConfiguration : IEntityTypeConfiguration<User>
{
    public void Configure(EntityTypeBuilder<User> builder)
    {
        builder.ToTable("users");
        builder.HasKey(u => u.Id);
        builder.HasIndex(u => u.Email).IsUnique();
        builder.HasQueryFilter(u => u.DeletedAt == null);
    }
}
```

### Migrations

```bash
dotnet ef migrations add AddStatusColumnToOrders
dotnet ef database update
```

## API Documentation

| Tool | Integration |
|---|---|
| Swashbuckle | Auto-generates OpenAPI from controllers and XML docs |
| NSwag | Alternative with client generation support |

### Setup

```csharp
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "API", Version = "v1" });
    c.IncludeXmlComments(Path.Combine(AppContext.BaseDirectory, "Api.xml"));
});
```

## Security

- Use `[Authorize]` attribute with policy-based authorization.
- Use `FluentValidation` or `DataAnnotations` for input validation.
- Use `ASP.NET Core Identity` or custom JWT middleware for authentication.
- Use `BCrypt.Net-Next` or `Microsoft.AspNetCore.Identity` for password hashing.
- Use `dotnet list package --vulnerable` for dependency scanning.
- Configure CORS explicitly in `Program.cs`.

## Docker

```dockerfile
# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS builder
WORKDIR /app
COPY *.csproj ./
RUN dotnet restore
COPY . .
RUN dotnet publish -c Release -o /out

# Production stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=builder /out .
RUN addgroup --gid 1001 appgroup && adduser --uid 1001 --gid 1001 --disabled-password appuser
USER appuser
EXPOSE 8080
ENTRYPOINT ["dotnet", "Api.dll"]
```
