---
agent: "tsh-business-analyst"
model: "Claude Opus 4.6"
description: "Prepare a context for a specific task or feature from a business analysis perspective."
---

Research the task based on the provided Jira ID or task description.

The file outcome should be a markdown file named after the task Jira ID in kebab-case format or after task name (if no Jira task provided) with `.research.md` suffix (e.g., `user-authentication.research.md`). The file should be placed in the `specifications` directory under a folder named after the issue ID or the shortened task name in kebab-case format.

It should contain every relevant information needed to build a comprehensive context for the task or feature.

## Required Skills

Before starting, load and follow these skills:
- `task-analysis` - for the structured research process and output template
- `codebase-analysis` - for analyzing the existing codebase in the context of task requirements

## Workflow

1. Gather all information related to the task from the codebase, Atlassian tools (Jira, Confluence) and other relevant sources.
2. Analyze the task thoroughly, including its parents and subtasks if applicable, to get the full picture of the requirements.
3. Analyse the tech stack, industry and domain of the project to understand best practices that should be applied during implementation.
4. Check all external links added to the task. Make sure to check the confluence pages linked to the task to gather more information about requirements and processes.
5. Unless asked to research only non-frontend aspects, in case there are Figma designs linked to the task, review all of them using `figma-mcp-server` (it's very important) and include relevant information in the context.
6. Analyze if there are any ambiguities or missing information in the task description. If there are any ask for clarification before finalizing the context.
7. Don't provide implementation details, focus on gathering requirements, user stories, acceptance criteria and key flows.
8. Save the gathered information following the `research.example.md` template from the `task-analysis` skill.
9. Ensure that the research file is clear, concise, and tailored to the needs of the development team.

Follow the template structure and naming conventions strictly to ensure clarity and consistency.

In case of any ambiguities or missing information in the task description, ask for clarification before finalizing the context.

Update the research file after each interaction if new information is gathered.
