---
name: task-analysis
description: Analyse task description, performs gap analysis, expand the context for the task, analyse the current state of the system in the context of the task, helps build PRD, creates a context for the task, gathers information about the task from different sources.
---

# Task Analysis

This skills helps you gather and expand context about specific task to be developed, looks for gaps in tasks description and helps to understand the current state of the system.

## Task analysis process

Use the checklist below and track your progress:

```
Analysis progress:
- [ ] Step 1: Look for available external sources of information
- [ ] Step 2: Gather information from all sources
- [ ] Step 3: Identify gaps and ask clarification questions
- [ ] Step 4: Based on the answers and gathered information finalize the research report
```

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

Find relevant information on knowledge base tools.

**Step 3: Identify gaps and ask clarification questions**

Based on the gathered information and task description, look for ambiguities or missing information. Create questions and ask them to the user. Don't proceed until all questions are answered or you are directly told to continue.

**Step 4: Based on the answers and gathered information finalize the research report**

Generate a report following the `./research.example.md` structure. Make sure to provide all necessary information that you gathered, all findings and all answered questions.

Don't add or remove any sections from the template. Follow the structure and naming conventions strictly to ensure clarity and consistency.