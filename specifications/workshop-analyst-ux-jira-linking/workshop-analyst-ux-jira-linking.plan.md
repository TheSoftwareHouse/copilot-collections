# Workshop Analyst: Question UX & Jira Linking - Implementation Plan

## Task Details

| Field | Value |
|---|---|
| Jira ID | N/A |
| Title | Workshop Analyst: Single-Question Popups & Bidirectional Jira Linking |
| Description | Two improvements to the `tsh-workshop-analyst` agent and its skills: (1) Each `askQuestions` popup should contain exactly one question scoped to a single story/epic, applied across all gates. (2) Bidirectional Jira integration via Atlassian MCP — `jira-tasks.md` is a rich local working copy with Jira keys. Agent stores keys after push, imports existing Jira tasks, updates issues via MCP, and prompts the user \"Push to Jira now?\" after each local change. |
| Priority | High |
| Related Research | N/A — requirements gathered directly from user conversation |

## Proposed Solution

### Feature 1: Single-Question Popups

Replace all "batch questions together" instructions across the agent and skills with a strict "one question per `askQuestions` call" rule. Each popup must include clear context identifying which epic or story the question relates to (e.g., "[Epic 2: Payment Processing > Story 2.3: User can refund payment]"). This applies to all gates and question-asking scenarios.

The rationale is readability: when multiple questions about different stories are grouped into one popup, the user loses context about which story each question belongs to.

### Feature 2: Bidirectional Jira Integration via Atlassian MCP

Establish a persistent connection between local markdown files and Jira issues via a `Jira Key` field added inline to each epic and story in `jira-tasks.md`. The local file serves as the rich working copy (full descriptions, acceptance criteria, etc.) and changes are pushed to Jira on demand via the Atlassian MCP tool.

The core model:

1. **`jira-tasks.md` is the working copy**: Contains full task content (descriptions, AC, technical notes, etc.) plus a `Jira Key` field per task. This file can be edited locally by the user or by the agent.
2. **Jira keys enable direct modification**: After initial push, each task's Jira key is stored locally. When the user later says "modify Story X," the agent updates the local file and asks "Push this change to Jira now?" — using the Atlassian MCP to update the specific Jira issue directly.
3. **Two entry points, same workflow**: Whether tasks were created by this agent or already exist in Jira, the agent fetches their IDs into the local file. From that point, the modification flow is identical.

The interaction pattern for modifications:
1. User requests a change (e.g., "add new acceptance criteria to Story 2.3")
2. Agent updates the local `jira-tasks.md`
3. Agent asks: "Do you want to push this change to Jira now?"
4. If yes → agent uses Atlassian MCP to update the specific issue (by its stored Jira key)
5. If no → change stays local, can be pushed later

## Current Implementation Analysis

### Already Implemented
- `tsh-workshop-analyst.agent.md` — Agent definition with `askQuestions` tool guidelines, 3-gate review process, Atlassian tool usage
- `jira-task-formatting/SKILL.md` — Full 9-step formatting/push workflow with `askQuestions` in Steps 5, 6, 8
- `jira-task-formatting/jira-task.example.md` — Benchmark template for epic/story fields without Jira Key field
- `task-extraction/SKILL.md` — 9-step extraction workflow with `askQuestions` in Steps 7, 8
- `task-quality-review/SKILL.md` — 9-step quality review with `askQuestions` in Step 7 (batch suggestion presentation)
- `workshop-analyze.prompt.md` — Orchestration prompt for the full workshop-to-Jira workflow
- `create-jira-tasks.prompt.md` — Standalone prompt for formatting and pushing extracted tasks to Jira

### To Be Modified
- `tsh-workshop-analyst.agent.md` — Update `askQuestions` tool guidelines (remove batching, add single-question rule); add Jira iteration mode; update Atlassian tool guidelines for import, update, and per-change push
- `jira-task-formatting/SKILL.md` — Update Step 5 (question approach), Step 9 (write-back keys, update-or-create with per-change prompt), add import entry point
- `jira-task-formatting/jira-task.example.md` — Add `Jira Key` field to epic and story templates, add example with key populated
- `task-extraction/SKILL.md` — Update Step 7 (question approach)
- `task-quality-review/SKILL.md` — Update Step 7 (suggestion presentation approach)
- `create-jira-tasks.prompt.md` — Add import/iterate workflow mode
- `workshop-analyze.prompt.md` — Add workflow branch for existing Jira tasks

### To Be Created
- Nothing — all changes are modifications to existing files

## Open Questions

| # | Question | Answer | Status |
|---|----------|--------|--------|
| 1 | Should each askQuestions call be one question per story, or strictly one question per call? | Strictly one question per call always | ✅ Resolved |
| 2 | Should the single-question rule apply to all gates or specific ones? | All gates and scenarios | ✅ Resolved |
| 3 | Should Jira linking be bidirectional (import + export) or one-way? | Both directions | ✅ Resolved |
| 4 | Where to store Jira keys — inline in jira-tasks.md or separate file? | Inline in jira-tasks.md | ✅ Resolved |
| 5 | Should jira-tasks.md be a lightweight tracker or rich working copy? | Rich local file with full content, push on demand | ✅ Resolved |
| 6 | When user modifies a task, should the agent auto-push or prompt? | Agent asks "Push to Jira now?" after each local change | ✅ Resolved |

## Implementation Plan

### Phase 1: Single-Question Popup UX

Update all question-asking instructions across the agent and skills to enforce one question per `askQuestions` call with clear story/epic context.

#### Task 1.1 - [MODIFY] Update askQuestions tool guidelines in agent definition
**Description**: In `tsh-workshop-analyst.agent.md`, replace the `vscode/askQuestions` tool usage section to enforce one question per call with mandatory story/epic context. Remove the "Batch related questions together (max 4 per interaction)" instruction.

**Definition of Done**:
- [x] The `vscode/askQuestions` IMPORTANT section explicitly states "Ask exactly one question per `askQuestions` call"
- [x] Instructions require the question header to identify the specific epic/story (e.g., `"[Story 1.2]"`)
- [x] Instructions require the question text to start with context identifying the parent epic and story title
- [x] The "max 4 per interaction" batching instruction is removed
- [x] A note explains the rationale: each popup should be self-contained so the user can focus on one decision at a time
- [x] Instructions clarify that workflow-level questions (e.g., "Which Jira project?", "Approve push?") that are not story-specific remain as single standalone questions

#### Task 1.2 - [MODIFY] Update question approach in task-extraction skill
**Description**: In `task-extraction/SKILL.md`, update Step 7 (Flag ambiguities and ask clarifying questions) to use single-question popups instead of grouped questions. Also update Step 8 (Present task list for user validation) to present one story at a time for approval.

**Definition of Done**:
- [x] Step 7 replaces "Group related questions together to minimize back-and-forth" with instruction to ask one question per `askQuestions` call
- [x] Step 7 requires each question to identify the specific epic/story it relates to
- [x] Step 8 instructions specify presenting each story for validation individually, with the question including the story's full context (parent epic, title, acceptance criteria summary)

#### Task 1.3 - [MODIFY] Update question approach in jira-task-formatting skill
**Description**: In `jira-task-formatting/SKILL.md`, update Step 5 (Flag uncertain fields and ask user) to use single-question popups. Also update Step 6 (Formatting Review) and Step 8 (Push Approval) to be consistent.

**Definition of Done**:
- [x] Step 5 replaces "Group related questions together" with instruction to ask one question per `askQuestions` call, each scoped to one epic or story
- [x] Step 5 requires the question to identify which task has the uncertain field and what field is missing
- [x] Step 6 review gate instructions are consistent with the single-question pattern (one question per task for change approval, if changes were made)
- [x] Step 8 push approval remains a single workflow-level question (not story-specific)

#### Task 1.4 - [MODIFY] Update suggestion presentation in task-quality-review skill
**Description**: In `task-quality-review/SKILL.md`, update Step 7 (Present suggestions for user review) to present each suggestion as its own individual `askQuestions` call instead of batching. Each popup should provide full context about the affected story, the suggestion, and accept/reject options.

**Definition of Done**:
- [x] Step 7 replaces "Present suggestions in batches (respecting the tool's limits)" with instruction to present exactly one suggestion per `askQuestions` call
- [x] Each suggestion popup includes: the parent epic title, the affected story title and ID, the suggestion summary, the confidence level, the action type, and Accept/Reject options
- [x] The "Group by epic" instruction is replaced with "Order suggestions by epic, then by confidence within each epic" to maintain logical flow across sequential popups
- [x] Instructions note that each popup is self-contained — the user should be able to make a decision without needing context from a previous popup

---

### Phase 2: Bidirectional Jira Integration via Atlassian MCP

Unified Jira integration: add `Jira Key` field to the template, persist keys after push, import existing Jira tasks, update issues on demand via MCP with per-change push prompts.

#### Task 2.1 - [MODIFY] Add Jira Key field to benchmark template
**Description**: In `jira-task-formatting/jira-task.example.md`, add a `Jira Key` field to both the epic and story field tables. Update the example tasks to show the field in both empty (pre-push) and populated (post-push) states.

**Definition of Done**:
- [x] Epic template Fields table includes `Jira Key` row: `| Jira Key | No | Jira issue key (e.g., PROJ-123). Populated after issue creation or import. |`
- [x] Story template Fields table includes `Jira Key` row with same description
- [x] The example epic shows `**Jira Key**: —` (pre-push placeholder)
- [x] At least one example story shows `**Jira Key**: PROJ-124` (post-push populated example) and another shows `**Jira Key**: —`
- [x] A note in the Formatting Guidelines section explains: "The `Jira Key` field is empty (`—`) when the task has not yet been pushed to Jira. It is populated automatically after issue creation or when importing existing Jira issues. When a Jira key is present, the push flow will UPDATE the existing issue instead of creating a new one."

#### Task 2.2 - [MODIFY] Update jira-task-formatting skill for key persistence and update-or-create logic
**Description**: In `jira-task-formatting/SKILL.md`, update Step 7 (Save) to include the Jira Key field, and update Step 9 (Push) to: (a) write keys back to `jira-tasks.md` after creation, (b) detect existing keys and update instead of create, (c) present a sync summary before pushing. Also add per-change push prompt instructions.

**Definition of Done**:
- [x] Step 7 mentions that the `Jira Key` field should be included in the saved file with `—` placeholder for new tasks
- [x] Step 9 title changed from "Create issues in Jira" to "Create or update issues in Jira"
- [x] Step 9 includes logic: "For each task, check the `Jira Key` field. If populated (e.g., `PROJ-123`), update the existing Jira issue. If empty (`—`), create a new issue."
- [x] Step 9 includes a sync summary sub-step before the actual push: "Present to the user: (a) tasks to be CREATED (no Jira key), (b) tasks to be UPDATED (existing key), (c) total counts. Get user approval."
- [x] Step 9 specifies key write-back after each individual issue creation (not batched at the end) to preserve progress on interruption
- [x] Step 9 specifies which fields are updated on existing issues: Summary, Description, Acceptance Criteria, Priority, Labels. Issue Type and Parent link are NOT updated unless the user explicitly requests it.
- [x] Step 9 handles deleted issues: "If an update fails because the issue no longer exists in Jira, inform the user and offer to create a new issue instead."
- [x] A new instruction is added for per-change modifications: "When the user requests a change to a specific task (e.g., 'add acceptance criteria to Story 2.3'), update the local `jira-tasks.md` first, then ask the user: 'Do you want to push this change to Jira now?' If yes, use the task's Jira key to update the specific issue via Atlassian MCP. If no, the change remains local until the next push."

#### Task 2.3 - [MODIFY] Add import flow to jira-task-formatting skill
**Description**: In `jira-task-formatting/SKILL.md`, add a new "Import Mode" section that describes an alternative entry point. When triggered with existing Jira issue keys or a project key, the skill fetches the issues and converts them into the `jira-tasks.md` format with Jira keys pre-populated.

**Definition of Done**:
- [x] A new section titled "## Import Mode: Jira → Local" is added after the main process section
- [x] The import flow has clear steps: (1) Identify target — accept Jira project key, epic keys, or a JQL query from the user; (2) Fetch issues from Jira using Atlassian MCP tools; (3) Map Jira fields to the benchmark template format; (4) Generate `jira-tasks.md` with all Jira keys populated; (5) Present the imported tasks to the user for review; (6) Save to `specifications/<project-or-topic>/jira-tasks.md`
- [x] The import flow includes field mapping guidance: Jira Summary → title, Jira Description → parse into structured sections, Jira Priority → priority field, Jira Labels → labels, Jira parent link → Parent epic reference
- [x] Instructions note that imported descriptions may not match the benchmark format perfectly — the agent should restructure them to match the template where possible and flag any that need user input
- [x] The import flow populates the `Jira Key` field for every imported task
- [x] A note clarifies: "After import, the user can modify the local file. For each change, the agent asks whether to push it to Jira immediately. The user can also batch-push all local changes later using the standard push flow."

#### Task 2.4 - [MODIFY] Add Jira iteration mode to agent definition
**Description**: In `tsh-workshop-analyst.agent.md`, update the agent's role to support two modes (workshop materials and existing Jira backlogs), update Atlassian tool guidelines for import/update/per-change push, and update skills usage.

**Definition of Done**:
- [x] Agent role description acknowledges a secondary mode: working with existing Jira backlogs, not just workshop materials
- [x] Atlassian tool MUST use section adds: "Fetching existing epics and stories from Jira when the user wants to iterate on an existing backlog"
- [x] Atlassian tool MUST use section adds: "Updating individual Jira issues when the user modifies a task that has a Jira key in `jira-tasks.md`"
- [x] Atlassian tool IMPORTANT section adds: "Before batch-pushing, check each task's `Jira Key` field. Tasks with existing keys are updated, not recreated. Present a sync summary showing creates vs. updates."
- [x] Atlassian tool IMPORTANT section adds: "When the user modifies a specific task, update the local `jira-tasks.md` first, then ask the user whether to push the change to Jira now."
- [x] The SHOULD NOT section adds: "Creating duplicate issues when a Jira key already exists in `jira-tasks.md`"
- [x] Skills usage for `jira-task-formatting` mentions both the standard formatting flow and the import mode

#### Task 2.5 - [MODIFY] Add import/iterate workflow to create-jira-tasks prompt
**Description**: Update `create-jira-tasks.prompt.md` to support both the existing "format and push" workflow and the new "import from Jira → iterate → push changes" workflow.

**Definition of Done**:
- [x] Prompt description updated to mention bidirectional capability: "Format extracted tasks for Jira push, import existing Jira tasks for local iteration, or push modifications to existing Jira issues"
- [x] Workflow section adds a decision point at the start: "If the user provides Jira issue keys or a project key to import, use the `jira-task-formatting` import mode. If the user provides an `extracted-tasks.md` file, use the standard formatting flow. If a `jira-tasks.md` with Jira keys already exists, resume in iteration mode."
- [x] Import workflow steps are listed: (1) Determine import scope (project, specific epics, JQL); (2) Fetch and convert using import mode; (3) Present for user review; (4) Save locally
- [x] A note explains that after import or creation, the user can request modifications to individual tasks — each change triggers a "push now?" prompt

#### Task 2.6 - [MODIFY] Add import/iterate branch to workshop-analyze prompt
**Description**: Update `workshop-analyze.prompt.md` to support starting from existing Jira tasks and iterating on them.

**Definition of Done**:
- [x] Workflow section adds an initial decision point: "If the user provides existing Jira issue keys or a project key instead of workshop materials, skip transcript processing and task extraction. Use the `jira-task-formatting` import mode to fetch and convert existing tasks into `jira-tasks.md`. Then proceed to quality review (Gate 1.5) and formatting."
- [x] The Important section notes: "When working with imported Jira tasks, the quality review step still applies — it can identify gaps in existing backlogs just as with newly extracted tasks"
- [x] Instructions clarify: "After import, the standard gates still apply for modifications. Individual task changes trigger a 'push to Jira now?' prompt. Batch pushes follow the standard Gate 2 approval."

---

### Phase 3: Code Review

#### Task 3.1 - Code Review by `tsh-code-reviewer`
**Description**: Review all modified files for consistency, correctness, and alignment with the requirements.

**Definition of Done**:
- [x] All modified files use consistent language for the single-question rule
- [x] No conflicting instructions exist across agent definition, skills, and prompts
- [x] The Jira Key field is consistently referenced across the template, skill, and agent
- [x] Import flow instructions are complete and do not leave ambiguous steps
- [x] Update-or-create logic is clearly specified with edge cases covered
- [x] Per-change push prompt ("Push to Jira now?") is consistently documented across skill and agent
- [x] No instructions reference deprecated patterns (e.g., "batch questions together")

## Security Considerations

- **Jira key exposure**: Jira issue keys (e.g., `PROJ-123`) stored in local markdown files are not sensitive data — they are identifiers, not credentials. No additional security measures needed beyond existing file access controls.
- **Atlassian API permissions**: Import, update, and per-change push flows use the same Atlassian MCP tool and permissions already configured. No new authentication or elevated permissions required.
- **Data integrity on push**: The update flow modifies existing Jira issues. Two safeguards prevent unintended changes: (1) the sync summary before batch pushes shows creates vs. updates, and (2) the per-change "Push to Jira now?" prompt ensures the user approves each individual modification. The agent must never update a Jira issue without explicit user approval.

## Quality Assurance

Acceptance criteria checklist to verify the implementation meets the defined requirements:

- [x] The `askQuestions` tool is called with exactly one question in every scenario across all modified skills and the agent definition — no batching instructions remain
- [x] Every question popup includes sufficient context (epic/story identifier and title) for the user to make a decision without external reference
- [x] The `jira-task.example.md` template includes the `Jira Key` field for both epics and stories
- [x] After a successful Jira push, `jira-tasks.md` contains populated Jira keys for all created issues
- [x] The import flow successfully converts Jira issues into the benchmark template format with Jira keys populated
- [x] When `jira-tasks.md` contains tasks with existing Jira keys, the push flow updates those issues instead of creating duplicates
- [x] A sync summary (creates vs. updates) is presented to the user before any batch push
- [x] When the user modifies a specific task, the agent updates the local file and asks "Push to Jira now?" before touching the Jira issue
- [x] All instructions are consistent across the agent definition, skills, and prompts — no conflicting guidance

## Improvements (Out of Scope)

Potential improvements identified during planning that are not part of the current task:

- **Conflict detection**: Detect when a Jira issue has been modified directly in Jira since the last local edit, and present a diff to the user before overwriting
- **Selective sync**: Allow the user to choose which specific tasks to push/update rather than all-or-nothing on batch push
- **Jira status sync**: Import and display Jira issue statuses (To Do, In Progress, Done) in the local file
- **Bidirectional field sync**: Pull Jira field updates (e.g., story points estimated during refinement) back into the local file
- **JQL-based import filters**: Advanced import using JQL queries to filter which issues to import
- **Dedicated import prompt**: Create a standalone `import-jira-tasks.prompt.md` prompt if the combined prompt becomes too complex
- **Extracted-tasks.md linking**: Extend Jira key tracking to `extracted-tasks.md` (not just `jira-tasks.md`) for full traceability from extraction through formatting
- **Change diffing on push**: Show the user a field-by-field diff of what changed locally vs. what’s currently in Jira before pushing an update

## Changelog

| Date | Change Description |
|------|-------------------|
| 2026-02-23 | Initial plan created |
| 2026-02-23 | Restructured: merged Phases 2-4 into unified Phase 2 (Bidirectional Jira Integration via Atlassian MCP). Added per-change push prompt, rich local file model. Renumbered Phase 5 to Phase 3. |
| 2026-02-23 | Implementation complete. Phase 1 (Tasks 1.1-1.4), Phase 2 (Tasks 2.1-2.6), and Phase 3 (Task 3.1 code review) all done. All 7 files modified, no issues found during review. |
