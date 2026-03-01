---
name: code-reviewing
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
- [ ] Step 5: Run the available tests
- [ ] Step 6: Verify that solution follows the best practices
- [ ] Step 7: Run static code analysis tools and formatting tools
- [ ] Step 8: Validate the solution is secure
- [ ] Step 9: Validate the solution is scalable
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

**Step 5: Run the available tests**

Make sure that all of the tests are working properly.

**Step 6: Verify that solution follows the best practices**

Check the implemented solution. Make sure it follow the best development practices.

Take into account project standards and a practices like SOLID, SRP, DDD, DRY, KISS, Atomic Design.

Make sure that solution is not over engineered. Keep the cognitive complexity on a lower side.

**Step 7: Run static code analysis tools and formatting tools**

Make sure to run linters, static code analysis tools and formatting tools.

**Step 8: Validate the solution is secure**

Focus on security. Check for potential OWASP TOP10 issues. Check for potential critical security issues that allows other users to take control over the system.

**Step 9: Validate the solution is scalable**

Analyse if the implemented solution is scalable. Focus on areas like being able to scale it horizontaly, not having a stateful components, not having code with high computational complexity.

## Connected Skills

- `implementation-gap-analysing`
- `technical-context-discovering` - for understanding project conventions and standards to review against
- `sql-and-database-understanding` - for validating SQL quality, index coverage, query performance, schema design, and ORM usage patterns