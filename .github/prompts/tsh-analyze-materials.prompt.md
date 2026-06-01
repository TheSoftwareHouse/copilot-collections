---
agent: "tsh-business-analyst"
model: "GPT-5.4"
description: "Process discovery workshop materials and create Jira-ready epics and user stories, or iterate on an existing Jira backlog."
---

Analyze the provided workshop materials (transcripts, Figma designs, PDF documents, codebase context, or other reference documents) and convert them into structured, Jira-ready epics and user stories. Alternatively, import an existing Jira backlog for local iteration and improvement.

The file outcomes should be markdown files placed in the `specifications` directory under a folder named after the workshop topic in kebab-case format (e.g., `specifications/user-onboarding/`):
- `cleaned-transcript.md` — Cleaned and structured transcript
- `workshop-context-summary.md` — Optional context-only synthesis when Explore Mode is used
- `intent-brief.md` — Required scope brief that must be approved before extraction
- `extracted-tasks.md` — Extracted epics and stories (updated after quality review)
- `quality-review.md` — Quality review report with all suggestions and decisions
- `jira-tasks.md` — Final Jira-ready tasks
- `specifications/projects/<project-name>/task-baseline.md` — Optional project-level continuity baseline that may be maintained for future workshops

## Required Skills

Before starting, load and follow these skills in order:
- `tsh-task-analysing` - for business/context exploration, ambiguity resolution, and continuity baseline review
- `tsh-transcript-processing` - for cleaning and structuring raw transcripts
- `tsh-task-extracting` - for identifying epics and user stories from all materials
- `tsh-task-quality-reviewing` - for analyzing extracted tasks for gaps, edge cases, and improvements
- `tsh-jira-task-formatting` - for formatting tasks per the benchmark template and managing Jira push
- `tsh-codebase-analysing` - for understanding the existing codebase when relevant

## Workflow

Determine the entry point based on what the user provides:

**If the user provides existing Jira issue keys or a project key instead of workshop materials**, skip transcript processing and task extraction. Use the `tsh-jira-task-formatting` **Import Mode** to fetch and convert existing tasks into `jira-tasks.md`. Then proceed to quality review (Step 5) and formatting.

**Explore Mode branch:** If the user explicitly wants exploration first, or the available materials are ambiguous enough that backlog extraction would be premature, create `workshop-context-summary.md` first. This mode is business/context discovery only; it does not create epics or stories for Jira unless the user explicitly asks to continue.

**Standard workflow (workshop materials provided):**

1. **Process transcript**: If a raw transcript is provided, clean it using the `tsh-transcript-processing` skill. Remove small talk, structure by topics, extract decisions and action items. Save as `cleaned-transcript.md`.
2. **Analyze additional materials and baseline**: Review Figma designs (using `figma` tool), read PDF documents (using `pdf-reader` tool), existing codebase (using `tsh-codebase-analysing` skill), any other reference documents provided, and load the project baseline if `specifications/projects/<project-name>/task-baseline.md` already exists.
3. **Draft intent brief**: Using the `tsh-task-extracting` skill, synthesize an `intent-brief.md` that captures goal, scope, exclusions, stakeholders, likely epics, baseline overlap, and open questions.
4. **Review Gate 0**: Present the intent brief to the user for validation. Confirm scope, intent, and candidate epics before extraction. Iterate until the user approves.
5. **Extract tasks**: Using the `tsh-task-extracting` skill, identify epics and user stories from all processed materials and the approved intent brief. Save as `extracted-tasks.md`.
6. **Review Gate 1**: Present the extracted task list to the user for validation. Ask if any tasks were missed, should be split, merged, or removed. Iterate until the user approves.
7. **Quality review**: Using the `tsh-task-quality-reviewing` skill, run Lite or Full analysis passes against the approved task list. Build the domain model, identify gaps, and produce structured suggestions. This step runs automatically after Gate 1 approval — do not ask the user whether to run it.
8. **Review Gate 1.5**: Present all quality review suggestions to the user, grouped by epic and ordered by confidence. The user accepts or rejects each suggestion individually. Apply accepted suggestions to `extracted-tasks.md` and save the quality review report as `quality-review.md`.
9. **Confirm updated tasks**: After applying accepted suggestions, briefly summarize the changes made to `extracted-tasks.md` (new stories added, criteria added, stories modified). If the user wants to review the full updated task list, present it. Proceed when the user confirms.
10. **Format for Jira**: Using the `tsh-jira-task-formatting` skill, apply the benchmark template to format all tasks for Jira while preserving source traceability. Save as `jira-tasks.md`.
11. **Review Gate 2**: Present the final formatted tasks to the user. Confirm the target Jira project and get explicit approval before pushing.
12. **Push to Jira**: Create or update issues in Jira. For new tasks (no Jira key), create epics first, then stories linked to their parent epics. For tasks with existing Jira keys, update the corresponding issues. Present a sync summary before pushing. Report created/updated issue keys back to the user.
13. **Post-push verification**: Read back the created or updated Jira issues and verify the summary, parent epic linkage, acceptance criteria, description sections, and current status.
14. **Archive and baseline refresh**: If verification succeeds, archive the session artifacts and refresh the project-level task baseline for continuity.

## Important

- Output must be **business-oriented** — no technical implementation details beyond what was explicitly discussed in the workshop.
- Use `askQuestions` proactively whenever confidence is low about scope, priority, or intent.
- Both review gates are mandatory — no data is pushed to Jira without explicit user approval.
- Gate 0 is mandatory whenever an intent brief is created. The brief must be approved before extraction begins.
- The quality review step (Gate 1.5) runs automatically after Gate 1 approval. The user reviews and accepts/rejects individual suggestions, but does not need to opt-in to the review itself.
- The BA orchestrator may route transcript cleanup, analysis, extraction, quality review, and formatting to internal model-specialized BA workers, but all user-facing approval gates and final Jira actions still run through `tsh-business-analyst`.
- When working with imported Jira tasks, the quality review step still applies — it can identify gaps in existing backlogs just as with newly extracted tasks.
- After import or initial creation, individual task changes trigger a "Push to Jira now?" prompt. Batch pushes follow the standard Gate 2 approval.
- If exploration is requested, keep the output focused on business context and readiness for extraction rather than creating backlog items prematurely.
- If no transcript is provided (e.g., user provides structured notes or direct requirements), skip the transcript processing step and proceed directly to task extraction.

Follow the template structures and naming conventions from each skill strictly to ensure clarity and consistency.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-analyze-materials:v3 -->
