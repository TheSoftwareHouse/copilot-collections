---
name: tsh-task-analysing
description: "Analyse task description, perform gap analysis, expand the context for the task, analyse the current state of the system, help build PRD, create context for the task, gather information from different sources, and ensure acceptance criteria are test-ready before QA handoff. Use when analysing tasks, performing gap analysis, building PRD, or preparing acceptance criteria for testing."
---

# Task Analysis

This skill helps you gather and expand context about a specific task to be developed, looks for gaps in the task description, helps to understand the current state of the system, and ensures acceptance criteria are complete and test-ready before handoff to QA workflows.

## Task analysis process

Use the checklist below and track your progress:

```
Analysis progress:
- [ ] Step 0: Determine input source
- [ ] Step 1: Look for available external sources of information
- [ ] Step 2: Gather information from all sources
- [ ] Step 3: Identify gaps and ask clarification questions
- [ ] Step 3b: Ensure AC are test-ready
- [ ] Step 4: Based on the answers and gathered information finalize the research report
```

**Step 0: Determine input source**

Before gathering information, determine how the task context was provided:

- **Research & plan files exist** (`*.research.md`, `*.plan.md`): Read them as the primary source of requirements, acceptance criteria, scope, and definition of done.
- **Jira ID / task ID provided**: Use it to fetch task details from external tools (Step 1).
- **Context provided directly in the prompt**: When neither files nor a task ID are referenced, extract requirements, acceptance criteria, and scope from the user's message. Treat the prompt as the single source of truth. If critical information is missing, ask for clarification before proceeding.
- **PDF files attached or referenced**: Use the `pdf-reader` tool to extract content from PDF documents before analyzing them. Treat the extracted content as a primary source alongside research files and Jira tasks.

This determination affects how much of Steps 1–2 you need to execute — if the context is already fully provided inline or in files, skip redundant external lookups.

**Step 1: Look for available external sources of information**

Check what tools are available. Look for common task and knowledge management tools like:
- Atlassian Jira
- Atlassian Confluence
- Notion
- Linear
- Trello

Check if GitHub tools is available and look for Spaces matching task and project.

**Step 2: Gather information**

For each available tool look for task related information on it. Make sure to look for by ID if provided and in case it being absent look by task domain and jobs to be done. When having access to task management tools make sure to focus not only on a current task but also connected tasks, subtasks and epic.

In case of any external links, knowledge base link or designs, make sure to thoroughly check them through.

Analyse the code base based on task requirements. Look for areas that will be related to given task.

In case of any attached or referenced PDF files (requirements documents, client briefs, process descriptions, compliance documents), use the `pdf-reader` tool to extract their content and include relevant findings in the research report.

Find relevant information on knowledge base tools.

**Step 3: Identify gaps and ask clarification questions**

Based on the gathered information and task description, look for ambiguities or missing information. Create the questions and ask them to the user. Don't proceed until all questions are answered or you are directly told to continue.

**Step 3b: Ensure AC are test-ready**

Before finalizing the research report, verify that the acceptance criteria meet the **test-readiness** standard required by QA workflows (`tsh-functional-testing`). AC are test-ready when every user-facing behavior has:

- At least one clear expected outcome (what should happen)
- Identifiable preconditions (user state, data state, system state)
- Boundaries or constraints (max length, allowed roles, supported formats, error conditions)

If AC are missing any of these elements:
1. Identify the gaps
2. Ask the user clarifying questions to fill them (`vscode/askQuestions`)
3. Update the AC in the research report with the answers

This step ensures QA receives complete input and does not need to redirect the user back to the BA workflow. Requirement completion and scope definition are BA responsibilities — they must be resolved here, not downstream in QA.

**Step 4: Based on the answers and gathered information finalize the research report**

Generate a report following the `./research.example.md` structure. Make sure to provide all necessary information that you gathered, all findings and all answered questions.

Don't add or remove any sections from the template. Follow the structure and naming conventions strictly to ensure clarity and consistency.

## Connected Skills

- `tsh-codebase-analysing` — for analyzing the existing codebase in the context of task requirements
- `tsh-implementation-gap-analysing` — for understanding what already exists vs what needs to be built
- `tsh-functional-testing` — downstream consumer of the AC produced by this skill. AC must be test-ready (see Step 3b) before QA can generate test plans