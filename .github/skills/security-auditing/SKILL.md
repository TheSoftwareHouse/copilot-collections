---
name: security-auditing
description: Perform structured security audits of TypeScript, React Native, and NestJS codebases. Attack surface analysis. OWASP Top 10 checks. Mobile-specific React Native security patterns. Dependency scanning. Severity classification. Report generation.
---

# Security Auditing

This skill helps you conduct security audits of TypeScript/React Native/NestJS codebases in a structured way. Follow the steps in order — each builds on the previous.

## Security Audit Process

```
Audit progress:
- [ ] Step 1: Define scope and attack surface
- [ ] Step 2: Scan secrets and configuration
- [ ] Step 3: Scan dependencies
- [ ] Step 4: OWASP Top 10 — systematic code review
- [ ] Step 5: Platform-specific checks (React Native / NestJS)
- [ ] Step 6: Classify and prioritize findings
- [ ] Step 7: Write the Security Assessment Report
```

**Step 1: Define scope and attack surface**

Before looking at code, map what you're protecting:
- Identify all **entry points**: HTTP endpoints, WebSocket handlers, deep link schemes, file upload handlers, webhook receivers.
- Identify **trust boundaries**: where unauthenticated requests become authenticated, where user data crosses service boundaries.
- Identify **sensitive data flows**: auth tokens, PII, payment data, API keys — trace from input to storage to output.
- Note the auth mechanism (e.g., Auth0 JWT, session cookies) and access control model (guard-based, role-based, etc.).

**Step 2: Scan secrets and configuration**

Search the codebase for hardcoded secrets before reviewing logic. Check:
- Hardcoded API keys, tokens, passwords, private keys in source files — search for patterns: `sk_`, `Bearer `, `password =`, `secret =`, `API_KEY =`.
- `.env` files committed to version control.
- Secrets in test files, config files, `app.json`, `google-services.json`, `GoogleService-Info.plist`.
- `console.log` / `logger.debug` statements printing sensitive values (tokens, full request bodies).
- Environment variable validation — verify all required secrets are validated at startup (e.g., via a validation schema in `env.validation.ts`).

**Step 3: Scan dependencies**

Check for known vulnerable packages:
- Run `npm audit` (or `yarn audit`) and review the output.
- Cross-reference `package.json` (both `dependencies` and `devDependencies`) against known CVEs using context7 for specific versions.
- Flag packages that are end-of-life, unmaintained (no commits > 2 years), or have known security advisories.
- Check for dependency confusion risks — private package names that could be hijacked on the public registry.

**Step 4: OWASP Top 10 — systematic code review**

Go through each category. Skip those not applicable to the stack.

| # | Category | What to look for in TypeScript/NestJS/React Native |
|---|---|---|
| A01 | Broken Access Control | Missing `@UseGuards()`, no ownership checks (user can access other users' data), mass assignment via `@Body()` without `@Exclude()`, list endpoints without pagination limits (full table dump), response DTOs leaking internal fields (`password_hash`, internal IDs, tokens — missing `@Exclude()` on entity or no dedicated response DTO) |
| A02 | Cryptographic Failures | Weak algorithms (`MD5`, `SHA1`), sensitive data in `AsyncStorage` without encryption, HTTP instead of HTTPS, JWTs with `none` algorithm |
| A03 | Injection | Raw SQL strings (`queryRunner.query` with interpolated values), `eval()`, `exec()` with user input, template literals in queries |
| A04 | Insecure Design | Missing rate limiting on auth endpoints, no account lockout, business logic flaws (e.g., skipping validation on trusted input), ReDoS — user input passed to complex regex without length limit, race conditions / TOCTOU (check-then-act without locking, e.g., double-submit on balance operations) |
| A05 | Security Misconfiguration | CORS `*` wildcard, Swagger exposed in production, `DISABLE_AUTH_GUARDS=true` outside dev, verbose error messages in prod responses, missing HTTP security headers (no `Helmet` or manual CSP/HSTS/X-Frame-Options/X-Content-Type-Options) |
| A06 | Vulnerable Components | Outdated packages with CVEs (covered in Step 3) |
| A07 | Auth & Session Failures | JWT not validated (missing `exp`, `iss`, `aud` checks), tokens stored insecurely, refresh token rotation missing, logout not invalidating tokens |
| A08 | Software Integrity Failures | No integrity checks on downloaded assets, `dangerouslySetInnerHTML` in React without sanitization |
| A09 | Logging Failures | Insufficient logging of auth events (login, logout, failed attempts), sensitive data in logs, no audit trail for destructive actions |
| A10 | SSRF | User-supplied URLs passed to HTTP clients without allowlist validation (e.g., in webhook handlers, avatar URL fetching) |

**Step 5: Platform-specific checks**

**React Native (mobile)**:
- `AsyncStorage` — unencrypted key-value store. Flag any auth tokens, PII, or secrets stored here. Should use `react-native-keychain` or equivalent.
- Deep links — verify URL scheme handlers validate the full URL before acting. Check for open redirect or intent hijacking.
- Debug mode checks — `__DEV__` guards should prevent debug overlays, verbose logs, or mock auth from reaching production builds.
- Certificate pinning — verify HTTPS connections use pinning for sensitive APIs if applicable.
- Biometric auth — verify biometric prompts cannot be bypassed (check for fallback PIN/password policies).
- Bundle exposure — JavaScript bundle is not obfuscated but verify it doesn't embed private keys or credentials.
- Clipboard & screenshot exposure — sensitive screens (tokens, passwords, PII) should prevent clipboard copy of secrets and use `FLAG_SECURE` (Android) / screenshot prevention to avoid leaking data via screen capture or recent apps.

**NestJS (backend)**:
- `ValidationPipe` with `whitelist: true` and `forbidNonWhitelisted: true` — prevents mass assignment.
- Guards applied globally vs. per-route — check for unprotected routes.
- `ConfigService` / typed config — secrets should never use raw string keys or fall through to `undefined`.
- File upload limits — `multer` config should restrict file size, MIME type, and destination.
- Bull queue jobs — check for input sanitization in job processors; malicious payloads can persist across restarts.
- Webhook signature validation — HMAC-SHA256 or equivalent; constant-time comparison to prevent timing attacks.
- HTTP security headers — verify `Helmet` middleware is applied (or equivalent manual headers: `Strict-Transport-Security`, `X-Content-Type-Options`, `X-Frame-Options`, `Content-Security-Policy`).
- Response data leakage — verify response DTOs don't expose internal fields (entity `password_hash`, `auth0_user_id`, internal DB IDs). Check that entities use `@Exclude()` or dedicated response mappers.
- Race conditions — check for TOCTOU patterns in financial/resource operations (check-then-act without database locking or optimistic concurrency). Especially in Bull queue job processors where retries can cause double execution.
- Docker / container security — if `Dockerfile` exists: verify non-root user (`USER node`), minimal base image, no secrets in build args, `.dockerignore` excludes `.env`/`node_modules`, health check configured.
- API pagination limits — list endpoints must enforce `maxResults` / `limit` to prevent full table dumps. Check default and maximum page sizes.

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
