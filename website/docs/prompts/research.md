---
sidebar_position: 2
title: /research
---

# /research

**Agent:** Business Analyst  
**File:** `.github/prompts/research.prompt.md`

Prepares a comprehensive context document for a task from a business analysis perspective.

## Usage

```text
/research <JIRA_ID or task description>
```

## What It Does

1. Gathers all information related to the task from the codebase, Jira, Confluence, and other sources.
2. Analyzes the task thoroughly, including parent tasks and subtasks.
3. Analyzes the tech stack, industry, and domain for best practices.
4. Checks external links and Confluence pages linked to the task.
5. Reviews Figma designs via Figma MCP (if linked to the task).
6. Identifies ambiguities and asks for clarification before finalizing.
7. Focuses on requirements, user stories, acceptance criteria, and key flows.

## Skills Loaded

- `task-analysis` — Structured research process and output template.
- `codebase-analysis` — Analyze existing codebase in the context of task requirements.

## Output

A `.research.md` file placed in `specifications/<task-name>/`:

```text
specifications/
  user-authentication/
    user-authentication.research.md
```

The file contains all relevant information needed to build comprehensive context: task summary, requirements, user stories, acceptance criteria, assumptions, open questions, and suggested next steps.

:::tip
Review the generated research document carefully. Verify accuracy and iterate as many times as needed until the context is complete and correct.
:::
