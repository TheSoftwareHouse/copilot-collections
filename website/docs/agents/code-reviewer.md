---
sidebar_position: 6
title: Code Reviewer
---

# Code Reviewer Agent

**File:** `.github/agents/tsh-code-reviewer.agent.md`

The Code Reviewer agent performs structured code reviews against the implementation plan, requirements, and project standards.

## Responsibilities

- Verifying code **correctness** — functions as intended, meets requirements.
- Checking **code quality** — clean, efficient, maintainable, follows standards.
- Identifying **security** vulnerabilities and verifying proper security measures.
- Verifying **testing** — appropriate tests covering necessary scenarios.
- Ensuring **documentation** — well-documented code with comments.
- Checking **acceptance criteria** — verifying each item from the plan's checklist.

## Review Process

1. Reads coding guidelines from `copilot-instructions.md` and related `*.instructions.md` files.
2. Understands project coding standards and best practices.
3. Loads relevant skills for the review domain.
4. Runs all necessary checks and tests.
5. Produces a structured review with findings categorized by severity.

## What It Produces

A structured review containing:

- **Pass/Blocker/Suggestion** classification for each finding.
- Acceptance criteria verification (each item checked individually).
- Security, reliability, performance, and maintainability analysis.
- Recommended actions for each blocker.

## Tool Access

| Tool                      | Usage                                                                              |
| ------------------------- | ---------------------------------------------------------------------------------- |
| **Atlassian**             | Verify requirements and context from Jira or Confluence                            |
| **Context7**              | Verify framework API usage, check for known vulnerabilities                        |
| **Figma**                 | Verify frontend implementation matches visual designs                              |
| **Sequential Thinking**   | Analyze complex security vulnerabilities, performance bottlenecks, race conditions |
| **Terminal**              | Run tests, linters, and build commands for verification                            |
| **File Read/Edit/Search** | Read, modify, and search workspace files                                           |
| **VS Code Commands**      | Execute VS Code commands and preview in browser                                    |
| **Sub-agents**            | Delegate subtasks to specialized agents                                            |
| **Todo**                  | Track review progress with structured checklists                                   |

## Skills Loaded

- `tsh-code-reviewing` — Structured review process covering correctness, quality, security, testing, and scalability.
- `tsh-reviewing-frontend` — Frontend-specific review: component quality, hooks correctness, rendering, accessibility and performance spot-checks.
- `tsh-implementation-gap-analysing` — Compare implementation against the plan and verify completeness.
- `tsh-technical-context-discovering` — Understand project conventions and patterns.
- `tsh-sql-and-database-understanding` — Review database-related code for SQL quality, indexes, migrations, and ORM usage.
- `tsh-engineering-prompts` — Review LLM prompt code: injection defenses, delimiter separation, output format specification, prompt file and LLM client usage patterns.

## Handoffs

After review, the Code Reviewer can hand off to:

- **Software Engineer** → `/tsh-implement` (implement changes requested after code review)
