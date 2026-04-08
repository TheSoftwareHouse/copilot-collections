# Java Implementation Patterns

Java-specific patterns for the `tsh-implementing-backend` skill. Load this reference when the project uses Java (Spring Boot).

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
| Spring Boot | Built-in Spring IoC container with annotation-based wiring |

### Spring DI

```java
@Service
public class UsersService {
    private final UsersRepository usersRepository;
    private final EmailClient emailClient;

    public UsersService(UsersRepository usersRepository, EmailClient emailClient) {
        this.usersRepository = usersRepository;
        this.emailClient = emailClient;
    }
}
```

- Prefer constructor injection over field injection (`@Autowired` on fields).
- Use `@Service`, `@Repository`, `@Component` stereotypes for automatic scanning.
- Use `@Configuration` + `@Bean` for third-party or complex wiring.
- Use `@Profile` for environment-specific bean registration.

## Testing Tools

| Level | Tools |
|---|---|
| Unit Tests | JUnit 5, Mockito, AssertJ |
| Integration Tests | Spring Boot Test, REST Assured, Testcontainers |
| E2E Tests | Playwright |

### Integration Test Example

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class UsersControllerTest {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    void shouldCreateUserAndReturn201() {
        var payload = Map.of("email", "test@example.com", "name", "Test User");

        var response = restTemplate.postForEntity("/api/users", payload, Map.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(response.getBody()).containsEntry("email", "test@example.com");
    }
}
```

### REST Assured Example

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class UsersApiTest {

    @LocalServerPort
    private int port;

    @Test
    void shouldCreateUser() {
        given()
            .port(port)
            .contentType(ContentType.JSON)
            .body(Map.of("email", "test@example.com", "name", "Test User"))
        .when()
            .post("/api/users")
        .then()
            .statusCode(201)
            .body("data.email", equalTo("test@example.com"));
    }
}
```

## Logging

| Logger | When to Use |
|---|---|
| SLF4J + Logback | Standard for Spring Boot — built-in integration |
| Log4j2 | Alternative with async logging performance benefits |

- Use `@Slf4j` (Lombok) or manual `LoggerFactory.getLogger()` per class.
- Configure structured JSON output via `logback-spring.xml` with `LogstashEncoder`.
- Use MDC (Mapped Diagnostic Context) for `requestId`, `userId`, `correlationId`.
- Spring Boot auto-configures request logging — customize via `server.tomcat.accesslog`.

## ORM & Database

| ORM | When to Use |
|---|---|
| Hibernate (Spring Data JPA) | Full ORM — standard for Spring Boot projects |
| jOOQ | Type-safe SQL — for complex queries and reporting |
| JDBC Template | Low-level — when ORM overhead is not justified |

### Hibernate Entity Example

```java
@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String name;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private Instant createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private Instant updatedAt;

    @Column(name = "deleted_at")
    private Instant deletedAt;
}
```

### Spring Data Repository

```java
public interface UsersRepository extends JpaRepository<User, UUID> {
    Optional<User> findByEmail(String email);

    @Query("SELECT u FROM User u WHERE u.deletedAt IS NULL")
    Page<User> findAllActive(Pageable pageable);
}
```

### Migrations

Use Flyway (preferred) or Liquibase:

```
src/main/resources/db/migration/
├── V1__create_users_table.sql
├── V2__add_status_column_to_orders.sql
```

## API Documentation

| Tool | Integration |
|---|---|
| springdoc-openapi | Auto-generates OpenAPI 3 from Spring MVC annotations |
| Springfox | Legacy — use springdoc-openapi for new projects |

### springdoc-openapi Example

```java
@Tag(name = "Users")
@RestController
@RequestMapping("/api/users")
public class UsersController {

    @Operation(summary = "Create a new user")
    @ApiResponse(responseCode = "201", description = "User created")
    @ApiResponse(responseCode = "400", description = "Validation error")
    @PostMapping
    public ResponseEntity<UserResponse> create(@Valid @RequestBody CreateUserDto dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(usersService.create(dto));
    }
}
```

## Security

### Auth & Authorization

- Configure `SecurityFilterChain` bean for route-level security. Use `@PreAuthorize("hasRole('ADMIN')")` for method-level authorization. Extract the current user with `@AuthenticationPrincipal UserDetails user`.
- Apply security globally — all endpoints require authentication by default. Explicitly permit public routes:
  ```java
  http.authorizeHttpRequests(auth -> auth
      .requestMatchers("/api/public/**", "/health").permitAll()
      .anyRequest().authenticated());
  ```

### Input Validation

- Use `@Valid` on controller `@RequestBody` parameters. Define constraints on DTO fields with Jakarta Bean Validation: `@NotNull`, `@Email`, `@Size(max = 255)`. Use `@Validated` on the class for method-level validation. Handle errors via `BindingResult` or global `@ControllerAdvice`.
- Create custom validators with `ConstraintValidator<A, T>` for domain-specific rules.

### File Uploads

- Configure max size in `application.properties`: `spring.servlet.multipart.max-file-size=5MB`, `spring.servlet.multipart.max-request-size=10MB`.
- Validate `MultipartFile`: check `file.getContentType()` against MIME allowlist, sanitize filename with `StringUtils.cleanPath(file.getOriginalFilename())` — reject names containing `..`.

### Webhook HMAC Validation

Verify webhook signatures using `MessageDigest.isEqual()` — **never** use `Arrays.equals()` or `String.equals()`:
```java
Mac mac = Mac.getInstance("HmacSHA256");
mac.init(new SecretKeySpec(secret.getBytes(UTF_8), "HmacSHA256"));
byte[] expected = mac.doFinal(rawBody);
byte[] signature = HexFormat.of().parseHex(request.getHeader("X-Signature"));
if (!MessageDigest.isEqual(expected, signature))
    throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid signature");
```

### Rate Limiting

- Use `Bucket4j` for rate limiting — integrates with Spring via `bucket4j-spring-boot-starter`. Configure per-route or per-user limits.
- Monitor request rates with Spring Boot Actuator metrics.

### HTTP Security Headers

- Spring Security auto-configures HSTS, X-Content-Type-Options, X-Frame-Options, and cache control headers. Customize via `http.headers(h -> h.contentSecurityPolicy(csp -> csp.policyDirectives("default-src 'self'")))`.
- Configure CORS via `CorsConfigurationSource` bean or `@CrossOrigin` per controller — never use `allowedOrigins("*")` in production.

## Docker

```dockerfile
# Build stage
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app
COPY pom.xml mvnw ./
COPY .mvn .mvn
RUN ./mvnw dependency:resolve
COPY src src
RUN ./mvnw package -DskipTests

# Production stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
RUN addgroup -g 1001 -S appgroup && adduser -S appuser -u 1001 -G appgroup
USER appuser
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```
