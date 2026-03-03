---
name: security-auditing
description: "Perform structured security audits of any codebase. Attack surface analysis. OWASP Top 10 checks. Platform-specific security patterns for mobile, backend, database, and infrastructure. Dependency scanning. Severity classification. Report generation."
---

# Security Auditing

Conduct structured security audits of any codebase. Follow the steps in order — each builds on the previous.

## Security Audit Process

```
Audit progress:
- [ ] Step 1: Define scope and attack surface
- [ ] Step 2: Scan secrets and configuration
- [ ] Step 3: Scan dependencies
- [ ] Step 4: OWASP Top 10 — systematic code review
- [ ] Step 5: Platform-specific checks
- [ ] Step 6: Classify and prioritize findings
- [ ] Step 7: Write the Security Assessment Report
```

**Step 1: Define scope and attack surface**

**Detect tech stack** — Before mapping the attack surface, identify the technology stack by scanning manifest files and project structure:

Scan manifest and configuration files to identify the stack. Read the dependency list in each manifest to determine the specific framework, ORM, and libraries in use:
- `package.json` → JS/TS ecosystem — check `dependencies` for framework (`express`, `@nestjs/core`, `next`, `react-native`, `@angular/core`, `vue`, etc.) and ORM (`typeorm`, `prisma`, `sequelize`, `drizzle`, etc.)
- `requirements.txt` / `pyproject.toml` / `Pipfile` → Python ecosystem — check for `django`, `flask`, `fastapi`, `sqlalchemy`, `tortoise-orm`, etc.
- `composer.json` → PHP ecosystem — check for `laravel/framework`, `symfony/*`, `doctrine/orm`, etc.
- `pom.xml` / `build.gradle` / `build.gradle.kts` → Java/Kotlin ecosystem — check for `spring-boot`, `hibernate`, `quarkus`, etc.
- `go.mod` → Go ecosystem — check for `gin`, `echo`, `fiber`, `gorm`, etc.
- `Gemfile` → Ruby ecosystem — check for `rails`, `sinatra`, `sequel`, `activerecord`, etc.
- `Cargo.toml` → Rust ecosystem — check for `actix-web`, `axum`, `rocket`, `diesel`, `sea-orm`, etc.
- `*.csproj` / `*.sln` → .NET ecosystem — check for `ASP.NET`, `Entity Framework`, `Dapper`, etc.
- `mix.exs` → Elixir ecosystem — check for `phoenix`, `ecto`, etc.
- `build.sbt` → Scala ecosystem — check for `play`, `slick`, etc.
- `pubspec.yaml` → Dart/Flutter ecosystem
- Native mobile — `Podfile` (iOS/Swift), `build.gradle` with Android SDK (Kotlin/Java)

If a manifest type is not listed above, identify it from the project structure and README. The goal is to discover what's actually used, not to match against a fixed list.

Additionally, identify:
- Auth mechanism — look for JWT libraries, OAuth2 integrations, session middleware, API key validation, SAML providers in the dependencies and auth-related code.
- Infrastructure — check for `Dockerfile`, `docker-compose.yml`, `kubernetes/` or `k8s/` directories, serverless configs (`serverless.yml`, `sam-template.yaml`, cloud function configs), CI/CD pipelines (`.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`).

Record the detected stack — it determines which platform-specific checks to apply in Step 5.

**Map what you're protecting:**
- Identify all **entry points**: HTTP endpoints, WebSocket handlers, deep link schemes, file upload handlers, webhook receivers.
- Identify **trust boundaries**: where unauthenticated requests become authenticated, where user data crosses service boundaries.
- Identify **sensitive data flows**: auth tokens, PII, payment data, API keys — trace from input to storage to output.
- Note the auth mechanism (e.g., JWT, OAuth2, session cookies, API keys) and access control model (guard-based, role-based, etc.).

**Step 2: Scan secrets and configuration**

Search the codebase for hardcoded secrets before reviewing logic. Check:
- Hardcoded API keys, tokens, passwords, private keys in source files — search for patterns: `sk_`, `Bearer `, `password =`, `secret =`, `API_KEY =`.
- `.env` files committed to version control.
- Secrets in test files, app manifests and platform config files (e.g., `app.json`, `google-services.json`, `GoogleService-Info.plist`, `application.yml`, `appsettings.json`, `.env.*`).
- Logging statements (e.g., `console.log`, `logger.debug`, `print()`, `Log.d()`) printing sensitive values (tokens, full request bodies).
- Environment variable validation — verify all required secrets are validated at startup (e.g., via a validation schema or startup check).

**Step 3: Scan dependencies**

Check for known vulnerable packages:
- Run the package manager's audit command (`npm audit`, `yarn audit`, `pip audit`, `cargo audit`, `dotnet list package --vulnerable`, `bundler-audit`, `mvn dependency-check:check`) and review the output.
- Cross-reference dependency manifests (both runtime and dev dependencies) against known CVEs using security advisories and CVE databases.
- Flag packages that are end-of-life, unmaintained (no commits > 2 years), or have known security advisories.
- Check for dependency confusion risks — private package names that could be hijacked on the public registry.

**Step 4: OWASP Top 10 — systematic code review**

Go through each category. Skip those not applicable to the stack.

| # | Category | What to look for |
|---|---|---|
| A01 | Broken Access Control | Missing auth middleware/guards on endpoints (NestJS: `@UseGuards()`, Django: `@permission_required`, Spring: `@PreAuthorize`, Express: middleware chain). No ownership validation — user can access other users' resources (IDOR). Mass assignment — accepting unvalidated fields from request body (NestJS: missing `whitelist` in ValidationPipe; Rails: missing `strong_parameters`; Django: unvalidated serializer fields). List endpoints without pagination limits (potential full table dump). Response objects leaking internal fields (password hashes, internal IDs, auth tokens — missing field exclusion or dedicated response DTOs). |
| A02 | Cryptographic Failures | Weak hashing algorithms (`MD5`, `SHA1` for passwords — should use `bcrypt`/`argon2`/`scrypt`). Sensitive data in unencrypted local storage (mobile: `AsyncStorage`, `SharedPreferences`; browser: `localStorage`). HTTP instead of HTTPS for sensitive endpoints. JWTs with `none` algorithm accepted. Missing or weak encryption for data at rest. |
| A03 | Injection | String concatenation/interpolation in SQL queries instead of parameterized queries (any ORM raw query mode, template literals, f-strings, string formatting). `eval()`, `exec()`, `Function()` with user input. OS command injection via `child_process`, `subprocess`, `Runtime.exec()`. Template injection (server-side template engines). LDAP/NoSQL injection where applicable. |
| A04 | Insecure Design | Missing rate limiting on auth and sensitive endpoints. No account lockout after failed login attempts. Business logic flaws (skipping validation on assumed-trusted input). ReDoS — user input passed to complex regex without length limits. Race conditions / TOCTOU — check-then-act without locking (e.g., double-submit on balance operations, concurrent job processing). |
| A05 | Security Misconfiguration | CORS `*` wildcard allowing any origin. API documentation (Swagger/OpenAPI) exposed in production. Auth bypass flags enabled outside development (`DISABLE_AUTH_GUARDS`, `DEBUG=True`). Verbose error messages/stack traces in production responses. Missing HTTP security headers (`Strict-Transport-Security`, `X-Content-Type-Options`, `X-Frame-Options`, `Content-Security-Policy`). Default credentials on admin panels or databases. |
| A06 | Vulnerable Components | Outdated packages with known CVEs (covered in Step 3). |
| A07 | Auth & Session Failures | JWT not validated properly (missing `exp`, `iss`, `aud` claim checks). Tokens stored insecurely (localStorage, AsyncStorage, cookies without `HttpOnly`/`Secure` flags). Refresh token rotation missing. Logout not invalidating tokens server-side. Session fixation. |
| A08 | Software & Data Integrity | No integrity checks on downloaded assets or external scripts. Unsafe HTML rendering without sanitization (React: `dangerouslySetInnerHTML`; Angular: `bypassSecurityTrustHtml`; server-side: unescaped template output). Unsigned webhooks or event payloads. Insecure deserialization of untrusted data. CI/CD pipeline without integrity verification of build artifacts. |
| A09 | Logging & Monitoring Failures | Insufficient logging of security events (login, logout, failed attempts, privilege changes). Sensitive data in log output (tokens, passwords, PII). No audit trail for destructive operations (deletion, permission changes). Missing alerting on suspicious activity patterns. |
| A10 | SSRF | User-supplied URLs passed to HTTP clients without allowlist validation (webhook handlers, avatar/image URL fetching, URL preview features). Internal service endpoints accessible via crafted URLs. Cloud metadata endpoint access (`169.254.169.254`). |

**Step 5: Platform-specific checks**

Based on the tech stack discovered in Step 1, apply the relevant sections below. Skip sections that don't match the detected stack.

**Mobile applications** (if mobile app detected)
- Insecure local storage — unencrypted key-value stores (React Native: `AsyncStorage`; Android: `SharedPreferences`; iOS: `UserDefaults`) used for auth tokens, PII, or secrets. Prefer secure storage (Keychain, Keystore, `react-native-keychain`, `flutter_secure_storage`).
- Deep link / URL scheme validation — verify handlers validate the full URL before acting. Check for open redirect or intent hijacking via custom URL schemes.
- Debug mode in production — dev flags (`__DEV__`, `BuildConfig.DEBUG`, `#if DEBUG`) should prevent debug overlays, verbose logs, or mock auth in release builds.
- Certificate pinning — verify HTTPS connections to sensitive APIs use certificate pinning where applicable.
- Bundle/binary secrets — JavaScript bundles, APK resources, and IPA assets should not embed API keys, private keys, or credentials. Check build configs and resource files.
- Clipboard and screenshot exposure — sensitive screens should prevent clipboard copy of secrets and use platform APIs to block screenshots (`FLAG_SECURE` on Android, screenshot prevention on iOS).
- Biometric authentication bypass — verify biometric prompts cannot be bypassed via fallback mechanisms without proper validation.

**Backend frameworks** (if server-side framework detected)
- Input validation pipeline — verify global validation is configured and enforced (NestJS: `ValidationPipe` with `whitelist`; Django: serializer validation; Spring: `@Valid` + `@Validated`; Express: validation middleware). Check for routes that bypass validation.
- Auth guard/middleware coverage — identify unprotected routes. Verify auth is applied globally or per-route for all sensitive endpoints. Check for bypass conditions.
- Configuration and secrets management — secrets should use typed/validated config injection, not raw `process.env` / `os.environ` string access that can silently return `undefined`/`None`.
- File upload restrictions — verify file size limits, MIME type validation, filename sanitization, and secure storage destination. Check for path traversal in upload paths.
- Background job / queue security — check input sanitization in job processors. Malicious payloads can persist in queues across restarts. Verify retry logic doesn't cause double execution of sensitive operations.
- Webhook signature validation — verify HMAC or equivalent signature validation with constant-time comparison to prevent timing attacks.
- HTTP security headers — verify security headers are applied (`Strict-Transport-Security`, `X-Content-Type-Options`, `X-Frame-Options`, `Content-Security-Policy`). Check for middleware (Helmet, SecurityMiddleware, etc.) or manual configuration.
- Response data leakage — verify API responses don't expose internal fields (password hashes, internal IDs, auth provider IDs, infrastructure details). Check for dedicated response DTOs/serializers vs raw entity/model exposure.
- Race conditions — check for TOCTOU patterns in financial/resource operations without database locking or optimistic concurrency. Especially in background job processors where retries can cause double execution.
- API pagination limits — list endpoints must enforce maximum page sizes to prevent full table dumps. Check default and maximum limits.

**Databases and ORMs** (if database layer detected)
- Raw query injection — verify all dynamic queries use parameterized queries or prepared statements. Flag string interpolation/concatenation in SQL.
- Migration safety — migrations should use raw SQL or framework migration tools, not application model code that may change after the migration is written.
- Connection credential management — database credentials should come from environment/secrets, not hardcoded in config files.
- Excessive permissions — application database user should have minimal required privileges (no `GRANT ALL`).
- Query result exposure — verify queries don't select more columns than needed (especially password hashes, tokens).

**Containers and infrastructure** (if deployment/infra configs detected)
- Dockerfile security — non-root user (`USER node`/`USER app`), minimal base image (Alpine/distroless), no secrets in build args or image layers, `.dockerignore` excludes `.env`/credentials/`node_modules`.
- Kubernetes security — pod security context, no privileged containers, network policies, secrets not in plain ConfigMaps.
- Cloud configuration — IAM least privilege, no public S3 buckets/storage, VPC/firewall rules, secrets in vault/secrets manager (not env vars in deployment configs).
- Health check endpoints — should not expose sensitive system information.
- CI/CD pipeline — secrets not logged, build artifacts verified, no credential leakage in build logs.

**Frontend web applications** (if web frontend detected)
- XSS via unsafe rendering — `dangerouslySetInnerHTML` (React), `bypassSecurityTrustHtml` (Angular), `v-html` (Vue) without sanitization.
- Sensitive data in client-side storage — `localStorage`/`sessionStorage` used for auth tokens (prefer `HttpOnly` cookies).
- CSP (Content Security Policy) — verify CSP headers prevent inline scripts and restrict sources.
- CSRF protection — verify anti-CSRF tokens for state-changing requests (especially with cookie-based auth).
- Exposed source maps — production builds should not ship source maps that reveal server-side logic.
- Third-party script trust — verify integrity attributes (`SRI`) on externally loaded scripts/styles.

**Step 6: Classify and prioritize findings**

Assign severity to each finding:

| Severity | Criteria | Examples |
|---|---|---|
| **Critical** | Remote code execution, authentication bypass, full data breach possible without auth | SQL injection with auth bypass, hardcoded admin credentials, JWT `none` algorithm accepted |
| **High** | Significant data exposure or privilege escalation, requires low effort to exploit | Missing ownership check (IDOR), API key in source code, unvalidated file upload type |
| **Medium** | Limited impact or requires some precondition to exploit | Missing rate limiting, verbose error messages, sensitive data in logs |
| **Low** | Minor risk, defense-in-depth improvement | Missing security header, weak but non-exploitable pattern, outdated non-vulnerable package |

Do not inflate severity — a medium should not be called critical to create urgency.

**Step 7: Write the Security Assessment Report**

Structure the report as follows:

1. **Executive Summary** — overall posture (Critical / High / Medium / Low), total count by severity, top 3 risk areas.
2. **Vulnerability Findings** — for each finding:
   - Severity | Category | Location (file + line) | Description | Impact | Recommendation | References (OWASP/CWE)
3. **Security Best Practices Review** — what is done well, what needs improvement, configuration notes.
4. **Dependency Analysis** — vulnerable packages with CVE IDs and upgrade recommendations.
5. **Action Items** — prioritized remediation list (quick wins first).
6. **Critical Vulnerability Warning** — if any Critical findings exist, end the report with exactly:
   ```
   THIS ASSESSMENT CONTAINS A CRITICAL VULNERABILITY
   ```

## Connected Skills

- `codebase-analysing` - to map the full architecture and identify all entry points before starting the audit.
- `technical-context-discovering` - to understand the technology stack, auth mechanisms, and project conventions that define which checks apply.
