---
name: reviewing-code
description: "Evaluate code changes for quality, correctness, and adherence to project standards. Use when reviewing pull requests, verifying implementations against acceptance criteria, or auditing code for best practices."
---

# Reviewing Code

Evaluates code changes against project conventions, correctness, and maintainability. Focuses on actionable findings rather than stylistic nitpicks.

<principles>

<constructive-feedback>
Every finding must include a concrete suggestion. Identifying a problem without proposing a fix adds noise, not value.
</constructive-feedback>

<severity-over-volume>
Prioritize correctness and security issues over style preferences. A single missed null check matters more than ten formatting inconsistencies.
</severity-over-volume>

</principles>

## Review Process

Use the checklist below and track progress:

```
Progress:
- [ ] Step 1: Gather context
- [ ] Step 2: Analyze code changes
- [ ] Step 3: Produce review report
- [ ] Step 4: Validate findings
```

**Step 1: Gather context**

- Read the task description, acceptance criteria, and implementation plan if available.
- Identify the scope of changes — which files were added, modified, or deleted.
- Check project conventions by reading linter configs, existing patterns, and style guides.

**Step 2: Analyze code changes**

- Verify each change implements the stated requirements without unintended side effects.
- Check error handling, edge cases, and boundary conditions.
- Assess naming clarity, function length, and separation of concerns.
- Flag security risks: unvalidated input, exposed secrets, injection vectors.

**Step 3: Produce review report**

- Group findings by severity: critical, warning, suggestion.
- Each finding must reference the specific file and line range.
- Include a recommended fix or alternative approach for every issue raised.

**Step 4: Validate findings**

- Re-read each finding to confirm it is accurate and reproducible.
- Remove false positives and duplicate observations.
- Verify that critical findings are not masked by lower-severity noise.

## Connected Skills

- `codebase-analysis` - to understand project structure and patterns before reviewing
- `architecture-design` - to evaluate architectural decisions in the reviewed code
