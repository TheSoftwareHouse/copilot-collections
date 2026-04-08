# PHP Implementation Patterns

PHP-specific patterns for the `tsh-implementing-backend` skill. Load this reference when the project uses PHP (Symfony, Laravel).

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
| Symfony | Built-in service container with autowiring |
| Laravel | Built-in IoC container with automatic resolution |

### Symfony DI

```php
// services.yaml — autowiring enabled by default
services:
    _defaults:
        autowire: true
        autoconfigure: true

    App\Service\UsersService: ~
    App\Repository\UsersRepository: ~
```

```php
class UsersService
{
    public function __construct(
        private readonly UsersRepository $usersRepository,
        private readonly EmailClientInterface $emailClient,
    ) {}
}
```

### Laravel DI

```php
// AppServiceProvider.php
public function register(): void
{
    $this->app->bind(EmailClientInterface::class, SendgridEmailClient::class);
}

class UsersService
{
    public function __construct(
        private readonly UsersRepository $usersRepository,
        private readonly EmailClientInterface $emailClient,
    ) {}
}
```

## Testing Tools

| Level | Tools |
|---|---|
| Unit Tests | PHPUnit, Pest |
| Integration Tests | PHPUnit + WebTestCase (Symfony), Laravel HTTP Tests |
| E2E Tests | Playwright |

### Integration Test Example (Symfony)

```php
class UsersControllerTest extends WebTestCase
{
    public function testCreateUser(): void
    {
        $client = static::createClient();
        $client->request('POST', '/api/users', [], [], [
            'CONTENT_TYPE' => 'application/json',
        ], json_encode(['email' => 'test@example.com', 'name' => 'Test User']));

        $this->assertResponseStatusCodeSame(201);
        $response = json_decode($client->getResponse()->getContent(), true);
        $this->assertEquals('test@example.com', $response['data']['email']);
    }
}
```

### Integration Test Example (Laravel)

```php
class UsersControllerTest extends TestCase
{
    use RefreshDatabase;

    public function test_create_user(): void
    {
        $response = $this->postJson('/api/users', [
            'email' => 'test@example.com',
            'name' => 'Test User',
        ]);

        $response->assertStatus(201)
                 ->assertJsonPath('data.email', 'test@example.com');
    }
}
```

## Logging

| Logger | When to Use |
|---|---|
| Monolog | Standard for both Symfony and Laravel — built-in integration |

- Symfony: Configure channels in `config/packages/monolog.yaml`.
- Laravel: Configure channels in `config/logging.php`.
- Use structured JSON logging for production (`JsonFormatter`).
- Use fingerscrossed handler (Symfony) to buffer logs and only flush on errors.

## ORM & Database

| ORM | When to Use |
|---|---|
| Doctrine (Symfony) | Full ORM with Unit of Work, migrations, DQL |
| Eloquent (Laravel) | Active Record pattern, built-in to Laravel |

### Doctrine Entity Example

```php
#[ORM\Entity(repositoryClass: UserRepository::class)]
#[ORM\Table(name: 'users')]
class User
{
    #[ORM\Id]
    #[ORM\Column(type: 'uuid')]
    #[ORM\GeneratedValue(strategy: 'CUSTOM')]
    #[ORM\CustomIdGenerator(class: UuidGenerator::class)]
    private string $id;

    #[ORM\Column(type: 'string', unique: true)]
    private string $email;

    #[ORM\Column(type: 'string')]
    private string $name;

    #[ORM\Column(type: 'datetime_immutable')]
    private \DateTimeImmutable $createdAt;

    #[ORM\Column(type: 'datetime_immutable')]
    private \DateTimeImmutable $updatedAt;
}
```

### Eloquent Model Example

```php
class User extends Model
{
    use SoftDeletes;

    protected $fillable = ['email', 'name'];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
        'deleted_at' => 'datetime',
    ];

    public function orders(): HasMany
    {
        return $this->hasMany(Order::class);
    }
}
```

## API Documentation

| Framework | Swagger Tool |
|---|---|
| Symfony | NelmioApiDocBundle or API Platform |
| Laravel | L5-Swagger (darkaonline/l5-swagger) or Scramble |

- API Platform (Symfony) auto-generates OpenAPI docs from entity annotations.
- L5-Swagger uses OpenAPI annotations in controllers.

## Security

### Auth & Authorization

- **Symfony**: Configure firewall rules in `config/packages/security.yaml` with `access_control` for route-level restrictions. Use Voters for resource-level authorization:
  ```php
  $this->denyAccessUnlessGranted('EDIT', $post); // triggers PostVoter
  ```
- **Laravel**: Use `Gate::define()` for simple ability checks. Use `Policy` classes for resource authorization. Call `$this->authorize('update', $post)` in controllers.

### Input Validation & CSRF

- **Symfony**: Use `symfony/validator` constraints on DTOs. Forms include CSRF token by default — never disable it for state-changing forms.
- **Laravel**: Use `FormRequest` classes for validation. The `VerifyCsrfToken` middleware is enabled by default — use `@csrf` directive in Blade templates.

### File Uploads

- **Symfony**: Validate `UploadedFile` using `getMimeType()` (allowlist), `getSize()` (enforce max), and sanitize `getClientOriginalName()` — strip path components.
- **Laravel**: Use `FormRequest` rules: `'file' => 'required|mimes:pdf,jpg,png|max:2048'`. Access file via `$request->file('file')`. Store with `Storage::putFile()` — never use client-provided paths directly.

### Webhook HMAC Validation

Verify webhook signatures using `hash_equals()` — **never** use `===` for signature comparison:
```php
$expected = hash_hmac('sha256', $rawBody, $secret);
$signature = $request->headers->get('X-Signature');
if (!hash_equals($expected, $signature)) {
    throw new AccessDeniedHttpException('Invalid signature');
}
```

### Rate Limiting

- **Symfony**: Use `RateLimiter` component — configure limiters in `config/packages/rate_limiter.yaml`. Apply via `#[IsGranted]` or custom event listener.
- **Laravel**: Use `throttle` middleware — `Route::middleware('throttle:10,1')` for 10 requests per minute.

### HTTP Security Headers

- **Symfony**: Use `nelmio/cors-bundle` for CORS. Add security headers via `NelmioCorsBundle` configuration or custom `EventSubscriber` on `kernel.response`.
- **Laravel**: Configure CORS in `config/cors.php`. Add security headers via middleware or `spatie/laravel-csp` for Content Security Policy.

## Docker

```dockerfile
# Build stage
FROM php:8.3-fpm-alpine AS builder
WORKDIR /app
RUN apk add --no-cache $PHPIZE_DEPS \
    && docker-php-ext-install pdo pdo_pgsql opcache
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-scripts
COPY . .
RUN composer dump-autoload --optimize

# Production stage
FROM php:8.3-fpm-alpine
WORKDIR /app
RUN apk add --no-cache \
    && docker-php-ext-install pdo pdo_pgsql opcache
COPY --from=builder /app /app
RUN addgroup -g 1001 -S appgroup && adduser -S appuser -u 1001 -G appgroup
USER appuser
EXPOSE 9000
CMD ["php-fpm"]
```
