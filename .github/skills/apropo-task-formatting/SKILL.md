---
name: apropo-task-formatting
description: Transform extracted epics and user stories into Apropo-ready format following a benchmark template. Handles field mapping, formatting for Apropo CSV import compatibility. Use when formatting extracted tasks for Apropo board import or generating Apropo-compatible CSV files.
---

# Apropo Task Formatting

This skill helps you transform an extracted task list (epics and user stories) into an Apropo-ready format that can be directly imported into Apropo. It applies a consistent benchmark template to every task, and validates completeness before any file is created.

## Apropo Task Formatting Process

Use the checklist below and track your progress:

```
Formatting progress:
- [ ] Step 1: Load the benchmark template and extracted tasks
- [ ] Step 2: Group similar stories
- [ ] Step 3: Organize stories into levels
- [ ] Step 4: Extract technical stories
- [ ] Step 5: Validate completeness against benchmark
- [ ] Step 6: Flag uncertain fields and ask user
- [ ] Step 7: Generate CSV file for Apropo import
```

**Step 1: Load the benchmark template and extracted tasks**

Load two inputs:
- The **benchmark template** (`./apropo-import.example.md`) which defines the expected structure and fields for Apropo epics and stories
- The **extracted tasks document** (`extracted-tasks.md`) produced by the `task-extracting` skill

Review the benchmark template to understand:
- Required fields for epics and stories
- Formatting conventions
- How to handle optional fields
- The example tasks for reference quality and tone

**Step 2: Group similar stories**

Combine similar stories into a single story with multiple acceptance criteria. For example, if there are three stories that all relate to "User can edit entity", combine them into one story with list of fields that need to be editable. When combining, ensure the summary reflects the combined scope (e.g., "User can edit entity") and the description provides context for all acceptance criteria. Each acceptance criterion should be clear and testable.

Split stories if:
- They have distinct scopes that cannot be easily combined into a single summary and description
- They have different priorities or labels that would be lost if combined
- They could be implemented independently by different teams
- They could be from different phases of the project (e.g., MVP vs post-MVP)
- They are related to external integrations

**Step 3: Organize stories into levels**
To create a clear hierarchy and organization for the tasks, group related stories under epics. Each epic should represent a larger feature or theme, while stories represent specific functionalities or requirements within that epic.

If system is large you can split tasks into:
- level_1 e.g. phase
- level_2 e.g. module
- level_3 e.g. epic
- level_4 e.g. story

You don't have to use all levels of grouping.
If the system is small, you can have all stories under level_1 and level_2 or even only level_1.
Decide based on tasks or instructions from user.

**Step 4: Extract technical stories**

Extract technical stories that are implied by the workshop materials but not explicitly stated. For example, if there is a story about "User can checkout", there may be an implied technical story about "Implement payment gateway integration". Create these technical stories with appropriate summaries and descriptions:

Technical stories need separate epic ("Technical").


In technical stories can be:
- Authentication and authorization
- Data migration
- RBAC 
- Integrations with external systems

**Step 5: Validate completeness against benchmark**

Cross-check every formatted task against the benchmark template:
- Do descriptions follow the expected structure and content guidelines?
- Is the language business-oriented (not technical jargon except technical modules)?
- Are technical stories clearly identified and separated from user-facing stories?
- Are tasks organized into appropriate levels (epics, stories) based on their scope and complexity?
- Are there any missing fields or information that would be required for estimation and implementation?

Create a summary table showing completeness status for each task.

**Step 6: Flag uncertain fields and ask user**

For any task where:
- The scope of a story is unclear
- Not sure if a story should be an epic or a story
- Not sure if we should combine or split stories
- Technical task is uncertain

Use `askQuestions` to get user input. Ask exactly **one question per `askQuestions` call**, each scoped to a single epic or story. The question must identify which task has the uncertain field and what information is missing (e.g., "[Payment Integration] This should be under Admin module or technical module?"). Do not proceed to the review gate until all flags are resolved.

**Step 7: Generate CSV file for Apropo import**
Generate the final output following the `./apropo-import.example.md` templates.

Save the file to `specifications/<workshop-name>/apropo-import.csv`.

## CSV Compatibility
Ensure the generated CSV file is compatible with Apropo's import requirements:
- Use the correct column headers (e.g., `level_1`, `level_2`, `Description`)
- Properly format the description field to include key information without full sentences
- Ensure that technical stories are clearly identified and separated from user-facing stories
- Format CSV for UTF-8 encoding and proper line breaks

## Connected Skills

- `task-extracting` - provides the extracted tasks used as input for formatting
