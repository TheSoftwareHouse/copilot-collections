---
sidebar_position: 6
title: Sequential Thinking
---

# Sequential Thinking MCP

**Server key:** `sequential-thinking`  
**Type:** stdio  
**Package:** `@modelcontextprotocol/server-sequential-thinking`

Provides structured reasoning capabilities for tackling complex problems that benefit from step-by-step analysis.

## Capabilities

- Break complex problems into sequential reasoning steps.
- Revise previous conclusions when new information appears.
- Branch from earlier thoughts to explore alternative approaches.
- Compare multiple implementation strategies systematically.

## Which Agents Use It

| Agent | When |
|---|---|
| **Business Analyst** | Analyzing complex business rules, identifying edge cases, mapping dependencies |
| **Architect** | Designing complex architectures, evaluating trade-offs, breaking down features |
| **Software Engineer** | Implementing complex algorithms, debugging issues, planning refactoring |
| **Code Reviewer** | Analyzing security vulnerabilities, performance bottlenecks, race conditions |
| **E2E Engineer** | Analyzing complex test scenarios, debugging flaky tests, planning mocking strategies |

## Configuration

```json
{
  "sequential-thinking": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
    "type": "stdio"
  }
}
```

## Advanced Features

### Revision

Use `isRevision` to pivot when an approach hits a blocker:

- Implementation approach doesn't work → revise strategy.
- Requirement conflicts discovered → adjust scope.
- Deeper analysis reveals hidden issue → update conclusions.

### Branching

Use `branchFromThought` to compare alternatives:

- Multiple implementation strategies (e.g., recursive vs iterative).
- Different test approaches (e.g., mock vs real API).
- Trade-off analysis (e.g., performance vs maintainability).

## Authentication

No authentication required. Sequential Thinking runs locally via `npx` as a stdio process.

## Official Documentation

- [Sequential Thinking MCP on GitHub](https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking)

## When NOT to Use

- Trivial code changes (renaming variables, updating text).
- Writing simple boilerplate code.
- Simple test cases with straightforward assertions.
- Style nitpicks (indentation, naming conventions).
