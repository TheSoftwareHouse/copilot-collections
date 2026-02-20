---
agent: "tsh-workshop-analyst"
model: "Claude Opus 4.6"
description: "Format extracted tasks into Jira-ready structure and create issues in Jira."
---

Take an existing extracted tasks file (`extracted-tasks.md`) and format the epics and stories into Jira-ready structure following the benchmark template. After user review, create the issues in Jira.

The file outcome should be a markdown file named `jira-tasks.md` placed in the same `specifications/<workshop-name>/` directory as the input `extracted-tasks.md` file.

## Required Skills

Before starting, load and follow this skill:
- `jira-task-formatting` - for the formatting process, benchmark template, and Jira push guidelines

## Workflow

1. Locate and read the `extracted-tasks.md` file provided by the user or referenced in the conversation.
2. Load the benchmark template (`jira-task.example.md`) from the `jira-task-formatting` skill.
3. Format each epic and story according to the benchmark template fields and structure.
4. Validate completeness — flag any tasks where required fields cannot be confidently filled.
5. Ask the user to resolve any flagged fields or ambiguities.
6. **Review Gate 1**: Present the formatted tasks as `jira-tasks.md` for user review. Iterate until approved.
7. **Review Gate 2**: Confirm the target Jira project key and get explicit approval to push.
8. Create epics first (to get Jira IDs), then create stories linked to their parent epics.
9. Report the created issue keys back to the user.

Follow the template structure and naming conventions strictly to ensure clarity and consistency.

Both review gates are mandatory — no data is pushed to Jira without explicit user approval.
