# Java Spring Boot Implementation Patterns

Java Spring Boot–specific patterns for the `tsh-implementing-backend` skill. Load this reference when the project uses Java with Spring Boot.

## Table of Contents

- [Dependency Injection](#dependency-injection)
- [Testing Tools](#testing-tools)
- [Logging](#logging)
- [ORM & Database](#orm--database)
- [API Documentation](#api-documentation)
- [Security](#security)
- [Async Messaging (Spring Cloud Stream)](#async-messaging-spring-cloud-stream)
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
    @ResponseStatus(HttpStatus.CREATED)
    public UserResponse create(@Valid @RequestBody CreateUserDto dto) {
        return usersService.create(dto);
    }
}
```

## Security

- Use Spring Security with JWT filter chain for authentication.
- Use `@PreAuthorize` / `@Secured` for method-level authorization.
- Use `@Valid` + Jakarta Bean Validation (`@NotNull`, `@Email`, `@Size`) for input validation.
- Use BCrypt via `PasswordEncoder` for password hashing.
- Use `mvn dependency:analyze` and OWASP Dependency Check for scanning.
- Configure CORS via `WebMvcConfigurer.addCorsMappings()`.

## Async Messaging (Spring Cloud Stream)

Use Spring Cloud Stream for binder-agnostic async messaging (Kafka, RabbitMQ). Prefer it over direct `@KafkaListener` / `@RabbitListener` to keep business logic portable.

| Approach | When to Use |
|---|---|
| Spring Cloud Stream (`Consumer<>` / `StreamBridge`) | Default — binder-agnostic, easy to swap Kafka ↔ Rabbit |
| `@KafkaListener` directly | Only when you need Kafka-specific features (manual offset commit, headers access beyond SCS capabilities) |

### Maven dependency

```xml
<!-- Kafka binder -->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-stream-binder-kafka</artifactId>
</dependency>
<!-- or RabbitMQ binder -->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-stream-binder-rabbit</artifactId>
</dependency>
```

### Consumer — receiving messages

Declare a `@Bean` of type `Consumer<Message<T>>` — Spring Cloud Stream wires it to the binding automatically via the bean name.

```java
@Configuration
public class OrderEventConsumers {

    @Bean
    public Consumer<Message<OrderCreatedEvent>> orderCreated(OrderService orderService) {
        return message -> {
            var event = message.getPayload();
            var correlationId = message.getHeaders().get("correlationId", String.class);

            MDC.put("correlationId", correlationId);
            MDC.put("eventType", "OrderCreated");
            try {
                orderService.handleOrderCreated(event);
            } finally {
                MDC.remove("correlationId");
                MDC.remove("eventType");
            }
        };
    }
}
```

Binding name convention: `<beanName>-in-0` (e.g. `orderCreated-in-0`).

### Publisher — sending messages via StreamBridge

```java
@Service
@RequiredArgsConstructor
public class OrderEventsPublisher {

    private final StreamBridge streamBridge;

    public void publishOrderCreated(OrderCreatedEvent event, String correlationId) {
        var message = MessageBuilder.withPayload(event)
            .setHeader("correlationId", correlationId)
            .setHeader("eventType", "OrderCreated")
            .setHeader("occurredAt", Instant.now().toString())
            .build();

        streamBridge.send("orderPublisher-out-0", message);
    }
}
```

### Configuration (application.yml)

**Critical:** Always declare `spring.cloud.function.definition` to explicitly register function beans (Consumer, Supplier, Function). Without it, Spring Cloud Stream cannot distinguish your handlers from other beans in the classpath, causing initialization errors.

```yaml
spring:
  cloud:
    function:
      definition: orderCreated;orderPublisher    # semicolon-separated list of bean names
    stream:
      bindings:
        # Consumer binding: <beanName>-in-<index>
        orderCreated-in-0:
          destination: orders.created            # topic / exchange name
          group: order-service                   # consumer group (enables durable subscription)
          content-type: application/json
        # Publisher binding: explicit name used in StreamBridge.send()
        # (Or Supplier<Message<OrderCreatedEvent>> bean if triggered on schedule/poll)
        orderPublisher-out-0:
          destination: orders.created
          content-type: application/json
      kafka:
        bindings:
          orderCreated-in-0:
            consumer:
              enable-dlq: true                   # dead-letter queue on processing failure
              dlq-name: orders.created.dlq
              start-offset: latest
        binder:
          brokers: ${KAFKA_BROKERS:localhost:9092}
      default:
        consumer:
          max-attempts: 3                        # retry attempts before DLQ
          back-off-initial-interval: 1000
          back-off-multiplier: 2.0
```


### Event record (Java 16+)

```java
public record OrderCreatedEvent(
    UUID orderId,
    UUID customerId,
    BigDecimal totalAmount,
    Instant occurredAt
) {}
```

### Rules

- **Always declare `spring.cloud.function.definition`** in `application.yml` — list all Consumer/Supplier/Function bean names separated by semicolons. Without it, Spring Cloud Stream may fail to recognize your handlers or pick up beans from other libraries unintentionally.
- Always propagate `correlationId` from message headers into MDC for structured logging.
- Use `group` on every consumer binding — without it, each restart creates a new ephemeral subscription (messages lost).
- Enable DLQ (`enable-dlq: true`) for all consumers to prevent message loss on unhandled exceptions.
- Never throw unchecked exceptions in a `Consumer` without a DLQ configured — it will cause infinite retry loops.
- Use `StreamBridge` over producing via `Supplier<>` beans when publishing is triggered by an API call or business event (not a scheduled poll).

## Docker

### Standard JVM image

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

### Native image (GraalVM)

Native compilation produces a standalone binary with ~10× faster startup and lower memory footprint. Use it for short-lived workloads (serverless, CLIs, high-density containers) or when cold-start latency matters.

**Prerequisites in `pom.xml`:**

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.3.x</version>
</parent>

<build>
    <plugins>
        <plugin>
            <groupId>org.graalvm.buildtools</groupId>
            <artifactId>native-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

**Dockerfile (uses Spring Boot's built-in native buildpack pipeline):**

```dockerfile
# Build stage — requires GraalVM JDK (not standard Temurin)
FROM ghcr.io/graalvm/native-image-community:21 AS builder
WORKDIR /app
COPY pom.xml mvnw ./
COPY .mvn .mvn
RUN ./mvnw dependency:resolve -q
COPY src src
# Compiles to a native binary; -DskipTests to keep build times reasonable in CI
RUN ./mvnw native:compile -Pnative -DskipTests

# Production stage — distroless for minimal attack surface
FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=builder /app/target/your-app-name ./app
EXPOSE 8080
ENTRYPOINT ["./app"]
```

**Trade-offs:**

| | JVM | Native (GraalVM) |
|---|---|---|
| Startup time | seconds | milliseconds |
| Memory usage | higher | significantly lower |
| Build time | fast | slow (minutes) |
| Peak throughput (JIT) | higher over time | slightly lower |
| Reflection / dynamic proxies | works out of the box | requires hints (`reflect-config.json`) |
| Debugging | standard tooling | limited |

**Rules:**
- Prefer native for **serverless / AWS Lambda / GCP Cloud Run** deployments where cold-start matters.
- Stick with JVM for **long-running services** where JIT warm-up pays off.
- Libraries using dynamic reflection (e.g. some Hibernate features, certain serialization libs) may need `--initialize-at-build-time` hints or GraalVM reachability metadata — verify with `native:test` in CI.
- Spring Boot 3.x has first-class native support; Spring Boot 2.x does not.

