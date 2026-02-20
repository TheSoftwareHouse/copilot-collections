---
name: jira-task-formatting
description: Transform extracted epics and user stories into Jira-ready format following a benchmark template. Handles field mapping, formatting for Jira markdown compatibility, two-gate user review, and guidance for Jira issue creation via Atlassian tools.
---

# Jira Task Formatting

This skill helps you transform an extracted task list (epics and user stories) into a Jira-ready format that can be directly pushed to Jira. It applies a consistent benchmark template to every task, validates completeness, and manages a two-gate review process before any issues are created.

## Jira Task Formatting Process

Use the checklist below and track your progress:

```
Formatting progress:
- [ ] Step 1: Load the benchmark template and extracted tasks
- [ ] Step 2: Format each epic for Jira
- [ ] Step 3: Format each story for Jira
- [ ] Step 4: Validate completeness against benchmark
- [ ] Step 5: Flag uncertain fields and ask user
- [ ] Step 6: Formatting Review — User reviews formatted markdown
- [ ] Step 7: Save the Jira-ready tasks document
- [ ] Step 8: Push Approval — User approves Jira push
- [ ] Step 9: Create issues in Jira
```

**Step 1: Load the benchmark template and extracted tasks**

Load two inputs:
- The **benchmark template** (`./jira-task.example.md`) which defines the expected structure and fields for Jira epics and stories
- The **extracted tasks document** (`extracted-tasks.md`) produced by the `task-extraction` skill

Review the benchmark template to understand:
- Required fields for epics and stories
- Formatting conventions
- How to handle optional fields
- The example tasks for reference quality and tone

**Step 2: Format each epic for Jira**

For each epic in the extracted tasks document, create a Jira-ready epic entry with:
- **Summary** (title): Follow the naming convention from the benchmark template
- **Description**: Structured using the benchmark epic description format, including:
  - Business overview
  - Business value statement
  - Success metrics / criteria
- **Acceptance criteria**: Transferred from extracted tasks, formatted for Jira compatibility
- **Labels**: Suggest relevant labels based on the epic's domain (do not hardcode project-specific values)
- **Priority**: Map from the extracted task priority (Critical → Highest, High → High, Medium → Medium, Low → Low)

**Step 3: Format each story for Jira**

For each user story, create a Jira-ready story entry with:
- **Summary** (title): Follow the naming convention from the benchmark template
- **Description**: Structured using the benchmark story description format, including:
  - Context paragraph linking to the parent epic
  - User story in "As a… I want… So that…" format
  - Requirements as a numbered list
  - High-level technical notes (only if present in extracted tasks)
- **Acceptance criteria**: Formatted as a checklist compatible with Jira markdown
- **Story points guidance**: Include a sizing suggestion (e.g., Small / Medium / Large) based on scope complexity — but note this is a suggestion, not an estimate. The team should estimate during refinement.
- **Labels**: Consistent with the parent epic's labels plus any story-specific labels
- **Parent epic**: Reference to the parent epic by title (will be linked by ID after creation)
- **Priority**: Mapped from extracted task priority

**Step 4: Validate completeness against benchmark**

Cross-check every formatted task against the benchmark template:
- Are all required fields populated?
- Do descriptions follow the expected structure?
- Are acceptance criteria written as verifiable conditions?
- Is the language business-oriented (not technical jargon)?
- Are priorities and labels consistent across related tasks?

Create a summary table showing completeness status for each task.

**Step 5: Flag uncertain fields and ask user**

For any task where:
- A required field could not be confidently filled from the source materials
- The priority is ambiguous
- The scope of a story is unclear
- Labels or categorisation is uncertain

Use `askQuestions` to get user input. Group related questions together. Do not proceed to the review gate until all flags are resolved.

**Step 6: Formatting Review — User reviews formatted markdown**

Present the complete formatted output to the user for review:
- Show all epics and stories in their final Jira-ready format
- Highlight any changes made during formatting (e.g., rewording, priority adjustments)
- Ask: "Are you happy with these tasks? Any changes before I push to Jira?"

The user must explicitly approve before proceeding. If changes are requested, update and re-present.

**Step 7: Save the Jira-ready tasks document**

Generate the final output following the `./jira-task.example.md` template format.

Save the file to `specifications/<workshop-name>/jira-tasks.md`.

**Step 8: Push Approval — User approves Jira push**

Before creating any issues in Jira, confirm with the user:
- Target Jira project key (e.g., "PROJ")
- Target board or backlog
- Whether to create all tasks at once or in batches
- Any final adjustments

This is the final gate — after this, issues will be created in Jira.

**Step 9: Create issues in Jira**

Using the Atlassian tools, create issues in order:
1. Create all **epics** first (to get their Jira IDs)
2. Create all **stories** linked to their parent epics
3. Add any **links** between stories (blocked-by, related-to relationships)
4. Report the created issue keys back to the user with links

If any issue creation fails, inform the user immediately and ask how to proceed.

## Jira Markdown Compatibility

When formatting descriptions and acceptance criteria for Jira:
- Use `h2.`, `h3.` for headings (not `##`, `###`)
- Use `*bold*` for bold text (not `**bold**`)
- Use `_italic_` for italic text (not `*italic*`)
- Use `* item` for bullet lists (with space after asterisk)
- Use `# item` for numbered lists
- Use `{noformat}` or `{code}` blocks for preformatted text
- Acceptance criteria should use `(/) criterion` for checklist items (Jira checkbox format)

Note: The markdown file saved locally uses standard markdown. The Jira-specific formatting is applied only when creating the actual issues.

## Connected Skills

- `task-extraction` - provides the extracted tasks used as input for formatting
