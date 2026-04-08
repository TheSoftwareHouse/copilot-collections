# Node.js Implementation Patterns

Node.js-specific patterns for the `tsh-implementing-backend` skill. Load this reference when the project uses Node.js (NestJS, Express, Fastify).

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
| NestJS | Built-in NestJS DI (module-based, decorators) |
| Express | Awilix, tsyringe, or InversifyJS |
| Fastify | fastify-awilix or manual constructor injection |

### NestJS DI

```typescript
@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
    private readonly emailClient: EmailClient,
  ) {}
}

@Module({
  imports: [TypeOrmModule.forFeature([User])],
  providers: [UsersService, EmailClient],
  controllers: [UsersController],
})
export class UsersModule {}
```

### Express with Awilix

```typescript
const container = createContainer({ injectionMode: InjectionMode.CLASSIC });

container.register({
  usersService: asClass(UsersService).scoped(),
  usersRepository: asClass(UsersRepository).scoped(),
});

app.use(scopePerRequest(container));
```

## Testing Tools

| Level | Tools |
|---|---|
| Unit Tests | Jest, Vitest |
| Integration Tests | Supertest + Jest, Testcontainers |
| E2E Tests | Playwright |

### Integration Test Example (NestJS + Supertest)

```typescript
describe('POST /users', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const module = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();
    app = module.createNestApplication();
    await app.init();
  });

  it('should create a user and return 201', async () => {
    const response = await request(app.getHttpServer())
      .post('/users')
      .send({ email: 'test@example.com', name: 'Test User' });

    expect(response.status).toBe(201);
    expect(response.body.data.email).toBe('test@example.com');
  });
});
```

## Logging

| Logger | When to Use |
|---|---|
| Pino | High-performance, low-overhead — preferred for production |
| Winston | Feature-rich, multiple transports — good for complex logging needs |

- Use `pino-http` or `morgan` middleware for automatic request logging.
- In NestJS, use the built-in `Logger` service or integrate Pino via `nestjs-pino`.
- Never use `console.log` in production code.

## ORM & Database

| ORM | When to Use |
|---|---|
| TypeORM | NestJS projects, decorator-based entity definitions |
| Prisma | Schema-first approach, excellent type safety and migrations |
| MikroORM | Unit of Work pattern, better performance for complex queries |
| Knex.js | Query builder only — when full ORM is not needed |

### TypeORM Entity Example

```typescript
@Entity()
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column()
  name: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @DeleteDateColumn()
  deletedAt: Date | null;
}
```

### Prisma Schema Example

```prisma
model User {
  id        String   @id @default(uuid())
  email     String   @unique
  name      String
  createdAt DateTime @default(now()) @map("created_at")
  updatedAt DateTime @updatedAt @map("updated_at")
  deletedAt DateTime? @map("deleted_at")

  @@map("users")
}
```

## API Documentation

| Framework | Swagger Tool |
|---|---|
| NestJS | `@nestjs/swagger` (auto-generated from decorators) |
| Express | `swagger-jsdoc` + `swagger-ui-express` |
| Fastify | `@fastify/swagger` + `@fastify/swagger-ui` |

### NestJS Swagger Example

```typescript
@ApiTags('users')
@Controller('users')
export class UsersController {
  @Post()
  @ApiOperation({ summary: 'Create a new user' })
  @ApiResponse({ status: 201, type: UserResponseDto })
  @ApiResponse({ status: 400, description: 'Validation error' })
  create(@Body() dto: CreateUserDto): Promise<UserResponseDto> {
    return this.usersService.create(dto);
  }
}
```

## Security

### Input Validation

- **NestJS**: Configure `ValidationPipe` globally with strict settings:
  ```typescript
  app.useGlobalPipes(new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true, transform: true }));
  ```
- **Express**: Use `zod` or `joi` middleware per route. Validate before the handler runs — never inside business logic.

### Auth Guard Coverage

- **NestJS**: Apply `JwtAuthGuard` globally via `APP_GUARD` provider, then use `@Public()` decorator to opt out individual routes:
  ```typescript
  providers: [{ provide: APP_GUARD, useClass: JwtAuthGuard }]
  ```
- **Express**: Apply `authMiddleware` at the router level, not per-route. Use `router.use(authMiddleware)` before route definitions.

### File Uploads

- **NestJS**: Use `@UseInterceptors(FileInterceptor('file', { limits: { fileSize: 5 * 1024 * 1024 }, fileFilter }))` with MIME type allowlist in `fileFilter`.
- **Express**: Configure `multer({ limits: { fileSize: 5 * 1024 * 1024 }, fileFilter })`. Sanitize filenames with `path.basename()` — reject names containing `../`.

### Webhook HMAC Validation

Verify webhook signatures using `crypto.timingSafeEqual()` — **never** use `===` for signature comparison:
```typescript
const expected = crypto.createHmac('sha256', secret).update(rawBody).digest();
const signature = Buffer.from(req.headers['x-signature'], 'hex');
if (!crypto.timingSafeEqual(expected, signature)) throw new UnauthorizedException();
```

### Rate Limiting

- **NestJS**: Use `@nestjs/throttler` — `ThrottlerModule.forRoot({ throttlers: [{ ttl: 60000, limit: 10 }] })`. Apply `ThrottlerGuard` globally via `APP_GUARD`.
- **Express**: Use `express-rate-limit` middleware — `rateLimit({ windowMs: 60000, max: 10 })`.

### HTTP Security Headers

- Use `helmet` middleware: `app.use(helmet({ contentSecurityPolicy: { directives: { defaultSrc: ["'self'"], scriptSrc: ["'self'"] } } }))`.
- Configure CSP directives explicitly — do not rely on Helmet defaults for production.

## Docker

```dockerfile
# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM node:20-alpine
WORKDIR /app
RUN addgroup -g 1001 -S appgroup && adduser -S appuser -u 1001 -G appgroup
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
USER appuser
EXPOSE 3000
CMD ["node", "dist/main.js"]
```
