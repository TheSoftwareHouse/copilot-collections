---
name: tsh-shortcut-task-formatting
description: Transform extracted epics and user stories into Shortcut-ready format following a benchmark template. Handles field mapping, standard markdown formatting, two-gate user review, and guidance for story creation via Shortcut tools.
---

# Shortcut Task Formatting

This skill helps you transform an extracted task list (epics and user stories) into a Shortcut-ready format that can be directly pushed to Shortcut. It applies a consistent benchmark template to every task, validates completeness, and manages a two-gate review process before any stories are created.

## Shortcut Task Formatting Process

Use the checklist below and track your progress:

```
Formatting progress:
- [ ] Step 1: Load the benchmark template and extracted tasks
- [ ] Step 2: Format each epic for Shortcut
- [ ] Step 3: Format each story for Shortcut
- [ ] Step 4: Validate completeness against benchmark
- [ ] Step 5: Flag uncertain fields and ask user
- [ ] Step 6: Formatting Review — User reviews formatted markdown
- [ ] Step 7: Save the Shortcut-ready tasks document
- [ ] Step 8: Push Approval — User approves Shortcut push
- [ ] Step 9: Create stories in Shortcut
```

**Step 1: Load the benchmark template and extracted tasks**

Load two inputs:
- The **benchmark template** (`./shortcut-task.example.md`) which defines the expected structure and fields for Shortcut epics and stories
- The **extracted tasks document** (`extracted-tasks.md`) produced by the `tsh-task-extracting` skill

Review the benchmark template to understand:
- Required fields for epics and stories
- Formatting conventions
- How to handle optional fields
- The example tasks for reference quality and tone

**Step 2: Format each epic for Shortcut**

For each epic in the extracted tasks document, create a Shortcut-ready epic entry with:

> **Protected Status Guard**: If an epic has a protected workflow state (Done, Completed), preserve its content exactly as imported. Do not reformat, reword, or modify any fields. Mark it with `🔒` in the output and skip all formatting steps below for this epic. Note: The full list of protected states should be confirmed with the user for their specific Shortcut workflow configuration — refer to the agent's Protected Status Policy as the source of truth.

- **Name** (title): Follow the naming convention from the benchmark template
- **Description**: Structured using the benchmark epic description format, including:
  - Business overview
  - Business value statement
  - Success metrics / criteria
- **Acceptance criteria**: Transferred from extracted tasks, formatted as markdown checklists
- **Labels**: Suggest relevant labels based on the epic's domain (do not hardcode project-specific values)

**Step 3: Format each story for Shortcut**

For each user story, create a Shortcut-ready story entry with:

> **Protected Status Guard**: If a story has a protected workflow state (Done, Completed), preserve its content exactly as imported. Do not reformat, reword, or modify any fields. Mark it with `🔒` in the output and skip all formatting steps below for this story. Note: The full list of protected states should be confirmed with the user for their specific Shortcut workflow configuration — refer to the agent's Protected Status Policy as the source of truth.

- **Name** (title): Follow the naming convention from the benchmark template
- **Story Type**: `feature`, `bug`, or `chore`
- **Description**: Structured using the benchmark story description format, including:
  - Context paragraph linking to the parent epic
  - User story in "As a… I want… So that…" format
  - Requirements as a numbered list
  - High-level technical notes (only if present in extracted tasks)
- **Acceptance criteria**: Formatted as a markdown checklist
- **Estimate guidance**: Include a sizing suggestion (e.g., Small / Medium / Large) based on scope complexity — but note this is a suggestion, not an estimate. The team should estimate during refinement.
- **Labels**: Consistent with the parent epic's labels plus any story-specific labels. Shortcut does not have a separate Priority field — if the team wants priority tracking, suggest using labels like `priority:critical`, `priority:high`, `priority:medium`, `priority:low`.
- **Parent epic**: Reference to the parent epic by name (will be linked by ID after creation)

**Step 4: Validate completeness against benchmark**

> **Protected Status Guard**: Skip completeness validation for tasks with a protected workflow state (Done, Completed) — their content is preserved as-is and is not subject to benchmark compliance. Refer to the agent's Protected Status Policy for the full list of protected states.

Cross-check every formatted task against the benchmark template:
- Are all required fields populated?
- Do descriptions follow the expected structure?
- Are acceptance criteria written as verifiable conditions?
- Is the language business-oriented (not technical jargon)?
- Are labels consistent across related tasks?

Create a summary table showing completeness status for each task.

**Step 5: Flag uncertain fields and ask user**

> **Protected Status Guard**: Do not flag or ask the user about fields on tasks with a protected workflow state (Done, Completed). These tasks are read-only and their fields cannot be changed. Refer to the agent's Protected Status Policy for the full list of protected states.

For any task where:
- A required field could not be confidently filled from the source materials
- The story type is ambiguous
- The scope of a story is unclear
- Labels or categorisation is uncertain

Use `askQuestions` to get user input. Ask exactly **one question per `askQuestions` call**, each scoped to a single epic or story. The question must identify which task has the uncertain field and what field is missing (e.g., "[Epic 2: Payment Processing > Story 2.1: User can checkout] The story type for this story could not be determined from the workshop materials. Should it be `feature` or `chore`?"). Do not proceed to the review gate until all flags are resolved.

**Step 6: Formatting Review — User reviews formatted markdown**

Present the formatted output to the user for review. If changes were made during formatting (e.g., rewording, label adjustments), present each changed task individually using one `askQuestions` call per task, identifying the specific epic/story and the change made. Ask: "Is this change acceptable?"

After all individual changes are reviewed, ask one workflow-level question: "All formatting is complete. Are you happy with these tasks? Any final changes before I proceed to save and push?"

The user must explicitly approve before proceeding. If changes are requested, update and re-present the affected tasks individually.

**Step 7: Save the Shortcut-ready tasks document**

Generate the final output following the `./shortcut-task.example.md` template format.

Include the `Shortcut ID` field for every epic and story. For newly formatted tasks (not yet pushed to Shortcut), set the Shortcut ID to `—` as a placeholder. For tasks imported from Shortcut or previously pushed, preserve their existing Shortcut ID.

Save the file to `specifications/<workshop-name>/formatted-tasks.md`.

**Step 8: Push Approval — User approves Shortcut push**

Before creating any stories in Shortcut, confirm with the user:
- Target Shortcut workspace and project/team
- Whether to create all tasks at once or in batches
- Any final adjustments

This is the final gate — after this, stories will be created in Shortcut.

**Step 9: Create or update stories in Shortcut**

Before pushing, present a **sync summary** to the user:
- **(a)** Tasks to be **CREATED** (Shortcut ID is `—`) — list names and count
- **(b)** Tasks to be **UPDATED** (Shortcut ID is populated and workflow state is NOT protected) — list names, IDs, and count
- **(c)** Tasks **SKIPPED** (Shortcut ID is populated and workflow state is protected) — list names, IDs, workflow states, and count
- Get explicit user approval before proceeding.

Using the Shortcut tools, process tasks based on their Shortcut ID:

**For tasks without a Shortcut ID (create):**
1. Create all **epics** first (to get their Shortcut IDs)
2. After creating each epic, **immediately** update the corresponding entry in `formatted-tasks.md` with the returned Shortcut ID — do not wait until all tasks are created
3. Create all **stories** linked to their parent epics
4. After creating each story, **immediately** update `formatted-tasks.md` with its Shortcut ID
5. Add any **links** between stories (blocked-by, related-to relationships)

**For tasks with an existing Shortcut ID (update):**
1. First, check the task's Workflow State field. If the workflow state is protected (refer to the agent's Protected Status Policy), **skip this task** — do not send any update to Shortcut. It was already counted in the sync summary under category (c).
2. Update the existing Shortcut story/epic with the local content
3. Fields to update: Name, Description, Labels, Estimate
4. Fields NOT to update: Story Type, Epic link (unless the user explicitly requests re-linking)
5. If an update fails because the story no longer exists in Shortcut, inform the user and offer to create a new story instead

After all tasks are processed, report the final state back to the user — showing all Shortcut IDs in `formatted-tasks.md` and confirming which were created, updated, and skipped (with their workflow states).

If any story creation or update fails, inform the user immediately and ask how to proceed.

## Per-Change Modification Flow

When the user requests a change to a specific task outside of the main formatting workflow (e.g., "add acceptance criteria to Story 2.3" or "change the labels of Epic 1"):

0. **Check the task's Workflow State field**. If it is protected (refer to the agent's Protected Status Policy), inform the user that this task is protected and cannot be modified: _"This task has a protected workflow state ([state]). Per the Protected Status Policy, tasks with a protected workflow state cannot be modified. If this state is incorrect, please update it in Shortcut first, then re-import."_ Do not apply the change locally or in Shortcut. Stop here.
1. **Update the local `formatted-tasks.md` first** — apply the requested change to the file
2. **Ask the user**: "Do you want to push this change to Shortcut now?" (using one `askQuestions` call)
3. **If yes** — use the task's Shortcut ID to update the specific story/epic via Shortcut tools. If the task has no Shortcut ID (`—`), inform the user that the task has not been pushed yet and offer to create it
4. **If no** — the change remains local in `formatted-tasks.md` until the next batch push

## Shortcut Markdown Note

Shortcut uses standard Markdown natively. No markdown conversion is needed — the same markdown used in `formatted-tasks.md` is used when pushing to Shortcut.

## Import Mode: Shortcut → Local

This is an alternative entry point for the skill. Instead of formatting extracted tasks, the agent fetches existing Shortcut stories and converts them into the `formatted-tasks.md` format with Shortcut IDs pre-populated. This enables iterating on existing Shortcut backlogs using the agent's skills.

### Import Process

```
Import progress:
- [ ] Step I-1: Identify import target
- [ ] Step I-2: Fetch stories from Shortcut
- [ ] Step I-3: Map Shortcut fields to benchmark template
- [ ] Step I-4: Generate formatted-tasks.md
- [ ] Step I-5: Present imported tasks for user review
- [ ] Step I-6: Save to specifications directory
```

**Step I-1: Identify import target**

Ask the user to specify what to import. Accept any of these:
- A **Shortcut project or team name** — imports all epics and their linked stories
- **Specific epic IDs** — imports those epics and their child stories
- **Search terms or filters** — imports stories matching the search criteria

Use one `askQuestions` call to determine the import scope if the user hasn't specified it.

**Step I-2: Fetch stories from Shortcut**

Using the Shortcut tools:
1. Fetch the targeted epics and stories from Shortcut
2. For each epic, fetch its child stories (linked via epic reference)
3. Collect all fields: Name, Description, Story Type, Labels, Workflow State, Estimate, Shortcut ID, Epic link

**Step I-3: Map Shortcut fields to benchmark template**

Convert each fetched task into the benchmark template format:

| Shortcut Field | Template Field | Notes |
|---|---|---|
| Name | Name | Direct mapping |
| Description | Description sections | Parse into structured sections (Overview/Value/Metrics for epics; Context/User Story/Requirements/Technical Notes for stories). If the Shortcut description does not follow a structured format, restructure it to match the template as closely as possible. |
| Story Type | Story Type | Direct mapping (feature/bug/chore) |
| Labels | Labels | Direct mapping |
| Shortcut ID | Shortcut ID | Populate directly |
| Epic link | Parent epic reference | Map to parent epic name |
| Estimate | Estimate / Sizing Guidance | If estimated, include; otherwise mark as TBD |
| Workflow State | Workflow State | Direct mapping of the Shortcut workflow state (e.g., Unstarted, In Progress, Done). Used to enforce the Protected Status Policy. |

If an imported description cannot be cleanly restructured into the benchmark format, flag it for user review using one `askQuestions` call per flagged task.

> **Protected Status Handling on Import**: After mapping all fields, check each imported task's Workflow State. If the workflow state is protected (refer to the agent's Protected Status Policy — by default Done and Completed, but confirm with the user for their specific Shortcut workflow configuration), mark the task as read-only by adding a `🔒` indicator next to its name. These tasks are imported for visibility but must never be modified locally or pushed back to Shortcut. Preserve their content exactly as fetched.

**Step I-4: Generate formatted-tasks.md**

Create the `formatted-tasks.md` file with all imported tasks in the benchmark template format. Every task must have its `Shortcut ID` field populated with the actual Shortcut ID.

**Step I-5: Present imported tasks for user review**

Present each imported task to the user for review using one `askQuestions` call per task. Highlight any descriptions that were restructured or fields that could not be mapped cleanly. Ask: "Does this imported task look correct?"

**Step I-6: Save to specifications directory**

Save the final file to `specifications/<project-or-topic>/formatted-tasks.md`.

After import, the user can modify the local file. For each change, the agent asks whether to push it to Shortcut immediately (using the Per-Change Modification Flow above). The user can also batch-push all local changes later using the standard push flow (Step 8 → Step 9).

## Connected Skills

- `tsh-task-extracting` - provides the extracted tasks used as input for formatting
- `tsh-using-shortcut` - provides guidelines for Shortcut API interactions used during push and import flows
