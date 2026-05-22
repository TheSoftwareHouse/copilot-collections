---
agent: "tsh-qa-engineer"
model: "Claude Opus 4.6"
description: "Create a professional bug report with severity classification, steps to reproduce, and structured formatting."
argument-hint: "[Bug description or observed behavior]"
---

Create a professional, structured bug report from the provided bug description or observed behavior. The report follows the standard bug report template with severity classification, clear reproduction steps, and expected vs actual behavior.

## Required Skills

Before starting, load and follow these skills:
- `tsh-functional-testing` - provides the severity matrix and bug report template

## Workflow

1. Gather bug details from the user's description
2. Structure the report following the `bug-report.example.md` template from `tsh-functional-testing`, classifying severity using the skill's severity matrix
3. Review completeness — verify the report contains enough detail for a developer to reproduce the issue without additional context
4. Present the bug report in the conversation

## Constraints

- Every bug report must include numbered Steps to Reproduce — vague descriptions like "it doesn't work" are not acceptable.
- Severity must be classified using the severity matrix (Critical / High / Medium / Low) with justification.
- Do not speculate on root cause unless evidence is clear — focus on observable behavior.
- If the user provides insufficient information to write a complete report, ask for the missing details before generating.
