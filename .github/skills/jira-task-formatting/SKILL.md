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

Use `askQuestions` to get user input. Ask exactly **one question per `askQuestions` call**, each scoped to a single epic or story. The question must identify which task has the uncertain field and what field is missing (e.g., "[Epic 2: Payment Processing > Story 2.1: User can checkout] The priority for this story could not be determined from the workshop materials. Should it be High (core MVP) or Medium (post-MVP)?"). Do not proceed to the review gate until all flags are resolved.

**Step 6: Formatting Review — User reviews formatted markdown**

Present the formatted output to the user for review. If changes were made during formatting (e.g., rewording, priority adjustments), present each changed task individually using one `askQuestions` call per task, identifying the specific epic/story and the change made. Ask: "Is this change acceptable?"

After all individual changes are reviewed, ask one workflow-level question: "All formatting is complete. Are you happy with these tasks? Any final changes before I proceed to save and push?"

The user must explicitly approve before proceeding. If changes are requested, update and re-present the affected tasks individually.

**Step 7: Save the Jira-ready tasks document**

Generate the final output following the `./jira-task.example.md` template format.

Include the `Jira Key` field for every epic and story. For newly formatted tasks (not yet pushed to Jira), set the Jira Key to `—` as a placeholder. For tasks imported from Jira or previously pushed, preserve their existing Jira key.

Save the file to `specifications/<workshop-name>/jira-tasks.md`.

**Step 8: Push Approval — User approves Jira push**

Before creating any issues in Jira, confirm with the user:
- Target Jira project key (e.g., "PROJ")
- Target board or backlog
- Whether to create all tasks at once or in batches
- Any final adjustments

This is the final gate — after this, issues will be created in Jira.

**Step 9: Create or update issues in Jira**

Before pushing, present a **sync summary** to the user:
- **(a)** Tasks to be **CREATED** (Jira Key is `—`) — list titles and count
- **(b)** Tasks to be **UPDATED** (Jira Key is populated, e.g., `PROJ-123`) — list titles, keys, and count
- Get explicit user approval before proceeding.

Using the Atlassian tools, process issues based on their Jira Key:

**For tasks without a Jira Key (create):**
1. Create all **epics** first (to get their Jira IDs)
2. After creating each epic, **immediately** update the corresponding entry in `jira-tasks.md` with the returned Jira issue key — do not wait until all issues are created
3. Create all **stories** linked to their parent epics
4. After creating each story, **immediately** update `jira-tasks.md` with its Jira key
5. Add any **links** between stories (blocked-by, related-to relationships)

**For tasks with an existing Jira Key (update):**
1. Update the existing Jira issue with the local content
2. Fields to update: Summary, Description, Acceptance Criteria, Priority, Labels
3. Fields NOT to update: Issue Type, Parent link (unless the user explicitly requests re-linking)
4. If an update fails because the issue no longer exists in Jira, inform the user and offer to create a new issue instead

After all issues are processed, report the final state back to the user — showing all Jira keys in `jira-tasks.md` and confirming which were created vs. updated.

If any issue creation or update fails, inform the user immediately and ask how to proceed.

## Per-Change Modification Flow

When the user requests a change to a specific task outside of the main formatting workflow (e.g., "add acceptance criteria to Story 2.3" or "change the priority of Epic 1"):

1. **Update the local `jira-tasks.md` first** — apply the requested change to the file
2. **Ask the user**: "Do you want to push this change to Jira now?" (using one `askQuestions` call)
3. **If yes** — use the task's Jira key to update the specific issue via Atlassian MCP. If the task has no Jira key (`—`), inform the user that the task has not been pushed yet and offer to create it
4. **If no** — the change remains local in `jira-tasks.md` until the next batch push

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

## Import Mode: Jira → Local

This is an alternative entry point for the skill. Instead of formatting extracted tasks, the agent fetches existing Jira issues and converts them into the `jira-tasks.md` format with Jira keys pre-populated. This enables iterating on existing Jira backlogs using the agent's skills.

### Import Process

```
Import progress:
- [ ] Step I-1: Identify import target
- [ ] Step I-2: Fetch issues from Jira
- [ ] Step I-3: Map Jira fields to benchmark template
- [ ] Step I-4: Generate jira-tasks.md
- [ ] Step I-5: Present imported tasks for user review
- [ ] Step I-6: Save to specifications directory
```

**Step I-1: Identify import target**

Ask the user to specify what to import. Accept any of these:
- A **Jira project key** (e.g., `PROJ`) — imports all epics and their linked stories
- **Specific epic keys** (e.g., `PROJ-10, PROJ-15`) — imports those epics and their child stories
- A **JQL query** — imports issues matching the query

Use one `askQuestions` call to determine the import scope if the user hasn't specified it.

**Step I-2: Fetch issues from Jira**

Using the Atlassian MCP tools:
1. Fetch the targeted epics and stories from Jira
2. For each epic, fetch its child stories (linked via parent field)
3. Collect all fields: Summary, Description, Acceptance Criteria, Priority, Labels, Issue Key, Parent link

**Step I-3: Map Jira fields to benchmark template**

Convert each fetched issue into the benchmark template format:

| Jira Field | Template Field | Notes |
|---|---|---|
| Summary | Title (Summary) | Direct mapping |
| Description | Description sections | Parse into structured sections (Overview/Value/Metrics for epics; Context/User Story/Requirements/Technical Notes for stories). If the Jira description does not follow a structured format, restructure it to match the template as closely as possible. |
| Priority | Priority | Direct mapping (Highest/High/Medium/Low) |
| Labels | Labels | Direct mapping |
| Issue Key | Jira Key | Populate directly (e.g., `PROJ-123`) |
| Parent link | Parent epic reference | Map to parent epic title |
| Story Points | Story Points / Sizing Guidance | If estimated, include; otherwise mark as TBD |

If an imported description cannot be cleanly restructured into the benchmark format, flag it for user review using one `askQuestions` call per flagged task.

**Step I-4: Generate jira-tasks.md**

Create the `jira-tasks.md` file with all imported tasks in the benchmark template format. Every task must have its `Jira Key` field populated with the actual Jira issue key.

**Step I-5: Present imported tasks for user review**

Present each imported task to the user for review using one `askQuestions` call per task. Highlight any descriptions that were restructured or fields that could not be mapped cleanly. Ask: "Does this imported task look correct?"

**Step I-6: Save to specifications directory**

Save the final file to `specifications/<project-or-topic>/jira-tasks.md`.

After import, the user can modify the local file. For each change, the agent asks whether to push it to Jira immediately (using the Per-Change Modification Flow above). The user can also batch-push all local changes later using the standard push flow (Step 8 → Step 9).

## Connected Skills

- `task-extraction` - provides the extracted tasks used as input for formatting
