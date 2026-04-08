---
name: tsh-code-reviewing
description: Perform code review. Quality analysis. Acceptance criteria verification. Best practices review.
---

# Code review

This skill helps you verify that the implemented code follows all best practices and quality standards.

## Code Review Process

Use the checklist below and track your progress:

```
Analysis progress:
- [ ] Step 1: Understand the task description
- [ ] Step 2: Understand the plan to implement task
- [ ] Step 3: Analyse the implemented solution and compare that to task description and implementation plan
- [ ] Step 4: Verify that solution has implemented all necessary tests
- [ ] Step 5: Run all unit tests
- [ ] Step 6: Run all integrations tests
- [ ] Step 7: Run all e2e tests
- [ ] Step 8: Verify that solution follows the best practices
- [ ] Step 9: Run static code analysis tools and formatting tools
- [ ] Step 10: Validate the solution is secure
- [ ] Step 11: Validate the solution is scalable
```

**Step 1: Understand the task description**

Look for `*.research.md` file to fully understand the business goal of the task.
In case of task being connected to task management tool make sure to use that tool to access even more context.

In case of missing research file, follow the conversation to understand the goal.

**Step 2: Understand the plan to implement task**

Look for `*.plan.md` file to understand the planned solution implementation.

In case of missing it follow the conversation to understand the goal.

**Step 3: Analyse the implemented solution and compare that to task description and implementation plan**

Based on implementation plan and task description, compare it to actually implementation.

Focus not only on files that were actually changed or added, but also those that claim to be already implemented.

**Step 4: Verify that solution has implemented all necessary tests**

Make sure that all critical paths of the solutions are fully tested by combination of different tests - e2e, unit, integration.

**Step 5: Run all unit tests**

Find unit tests and run them. Make sure they are passing. 

**Step 6: Run all integration tests**

Find integration tests and run them. Make sure they are passing. 

**Step 7: Run all e2e tests**

Find end-to-end tests and run them. Make sure they are passing. 

**Step 8: Verify that solution follows the best practices**

Check the implemented solution. Make sure it follow the best development practices.

Take into account project standards and a practices like SOLID, SRP, DDD, DRY, KISS, Atomic Design.

Make sure that solution is not over engineered. Keep the cognitive complexity on a lower side.

**Step 9: Run static code analysis tools and formatting tools**

Make sure to run linters, static code analysis tools and formatting tools.

**Step 10: Validate the solution is secure**

Review the code for the following security concerns. Each item is a concrete check — not a category to "think about".

1. **Authentication coverage**
   - Are all sensitive endpoints protected by auth middleware/guards?
   - Look for endpoints that should require authentication but don't — especially new endpoints added in this PR.
   - Search for custom auth-bypass flags (`DISABLE_AUTH`, `skipAuth`, `isPublic` without safeguards) that could leak to production.

2. **Authorization & ownership**
   - Does the code verify that the authenticated user owns or has permission to access the resource they're requesting (IDOR prevention)?
   - Check that role/permission checks are enforced — not just authentication.
   - Look for direct database lookups by user-supplied ID without filtering by the current user's scope.
   - Anti-pattern: `findById(req.params.id)` without verifying `userId` matches the authenticated user.

3. **Input validation**
   - Is user input validated at the API boundary (controller/handler level), not deep inside business logic?
   - Are validation rules using an allowlist approach (`whitelist: true`, accept known-good fields) rather than a blocklist (reject known-bad)?
   - Check for routes that bypass the global validation pipeline.

4. **Secrets exposure**
   - No hardcoded API keys, tokens, or passwords in source code.
   - No secrets printed in log statements (`console.log`, `logger.debug`, `Log.d`).
   - `.env` files are not committed to version control.
   - Secrets come from environment variables or a secrets manager — not from config files with default values.

5. **Response data leakage**
   - Do API responses exclude internal fields (password hashes, internal IDs, infrastructure details, auth provider tokens)?
   - Are dedicated response DTOs or serializers used instead of returning raw database entities?
   - Anti-pattern: `res.json(user)` returning the full entity instead of a mapped response object.

6. **Injection vectors**
   - No string interpolation/concatenation in SQL queries — use parameterized queries or ORM methods.
   - No `eval()`, `exec()`, `Function()`, or `child_process`/`subprocess` calls with user-supplied input.
   - No unsanitized user content rendered as HTML (`dangerouslySetInnerHTML`, `v-html`, `bypassSecurityTrustHtml`).
   - No OS command injection via user-controlled arguments to shell commands.

7. **Dependency vulnerabilities**
   - Are newly added dependencies free of known CVEs?
   - Was the relevant audit tool run (`npm audit`, `composer audit`, `dotnet list package --vulnerable`, `pip audit`, `cargo audit`)?
   - Flag end-of-life or unmaintained packages (no commits > 2 years).

8. **CORS & security headers**
   - No `Access-Control-Allow-Origin: *` in production configuration.
   - Security headers are configured: `Strict-Transport-Security`, `X-Content-Type-Options`, `X-Frame-Options`, `Content-Security-Policy`.
   - Verify the framework's security middleware (Helmet, SecurityMiddleware, etc.) is applied and not disabled.

**Step 11: Validate the solution is scalable**

Analyse if the implemented solution is scalable. Focus on areas like being able to scale it horizontally, not having a stateful components, not having code with high computational complexity.

## Connected Skills

- `tsh-implementation-gap-analysing`
- `tsh-technical-context-discovering` - for understanding project conventions and standards to review against
- `tsh-sql-and-database-understanding` - for validating SQL quality, index coverage, query performance, schema design, and ORM usage patterns
- `tsh-engineering-prompts` - for reviewing LLM prompt code: prompt structure, injection defenses, delimiter separation, output format, and anti-patterns