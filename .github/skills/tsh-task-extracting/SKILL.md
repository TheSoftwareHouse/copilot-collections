---
name: tsh-task-extracting
description: Identify and structure epics and user stories from workshop materials (cleaned transcripts, Figma designs, codebase analysis, and other documents). Produces a business-oriented task breakdown with dependencies, assumptions, and open questions.
user-invocable: false
---

# Task Extraction

This skill helps you identify discrete pieces of work (epics and user stories) from discovery workshop materials and structure them into a clear, business-oriented task breakdown. The output is intended for stakeholder review and eventual Jira creation — it is NOT a technical specification or implementation plan.

## What This Skill Produces

- **Intent brief**: A short business-first scope brief that is approved before extraction begins
- **Epics**: High-level work streams with business descriptions and success criteria
- **User Stories**: Discrete deliverables in "As a… I want… So that…" format with source traceability and scenario-based acceptance criteria
- **Dependencies**: Relationships between epics and stories
- **Assumptions & Open Questions**: Gaps that need stakeholder input

## What This Skill Does NOT Produce

- Technical architecture or implementation details (use `tsh-architect` agent for that)
- Detailed acceptance criteria from a QA perspective (use `tsh-context-engineer` agent for that)
- Story point estimates (left for team estimation sessions)
- Sprint or release planning

## Task Extraction Process

Use the checklist below and track your progress:

```
Extraction progress:
- [ ] Step 1: Gather and review all input materials
- [ ] Step 2: Draft the intent brief
- [ ] Step 3: Review Gate 0 with the user and approve the intent brief
- [ ] Step 4: Identify high-level work streams (epics)
- [ ] Step 5: Break down epics into user stories
- [ ] Step 6: Write business-oriented descriptions with source traceability
- [ ] Step 7: Map dependencies between tasks
- [ ] Step 8: Identify assumptions and out-of-scope items
- [ ] Step 9: Flag ambiguities and ask clarifying questions
- [ ] Step 10: Present task list for user validation
- [ ] Step 11: Save the intent brief and extracted tasks documents
```

**Step 1: Gather and review all input materials**

Collect and thoroughly review all available workshop materials:
- **`workshop-context-summary.md`** (if available): Explore Mode summary that captures business context, likely epics, and ambiguities before extraction
- **Cleaned transcript** (`cleaned-transcript.md`): Primary source — review all discussion topics, decisions, action items, and open questions
- **Figma/FigJam designs**: If available, analyze screens, flows, and annotations for functional requirements
- **Existing codebase**: Use `tsh-codebase-analysing` skill to understand what already exists and what needs to be built
- **Other documents**: Confluence pages, shared documents, email threads, or any other reference materials provided by the user
- **PDF documents**: If available, read PDF files using the `pdf-reader` tool to extract requirements, process descriptions, business rules, or any other relevant content provided by the client
- **Project baseline** (`specifications/projects/<project-name>/task-baseline.md`, if present): Review for continuity, overlap, and existing backlog context

Create a mental model of the full scope discussed during the workshop before proceeding to extraction.

**Step 2: Draft the intent brief**

Before extracting tasks, draft an `intent-brief.md` that captures the business intent of the workshop. Keep it concise and focused on scope decisions, not backlog detail.

Include at least:
- Goal
- In scope
- Out of scope
- Key stakeholders / actors
- Likely epic candidates
- Baseline overlap or existing backlog notes
- Open questions

If the user requested Explore Mode, this draft may be accompanied by a `workshop-context-summary.md`, but it still must not become a backlog artifact.

**Step 3: Review Gate 0 with the user and approve the intent brief**

Present the intent brief to the user for validation before backlog extraction begins. Ask whether the scope, exclusions, and candidate epics are correct. Iterate until the user approves.

This is **Gate 0**. Do not proceed to extraction until the user approves the intent brief.

**Step 4: Identify high-level work streams (epics)**

From the gathered materials, identify distinct work streams that represent major deliverables or feature areas:
- Look for natural groupings of related functionality
- Each epic should represent a cohesive business capability (e.g., "User Authentication", "Payment Processing", "Reporting Dashboard")
- Epics should be independent enough to be delivered and validated separately where possible
- Aim for 3-10 epics per workshop (if you find more, some may be too granular; if fewer, some may be too broad)

For each epic, draft:
- A clear, business-oriented title
- A 2-3 sentence business description explaining the value
- High-level success criteria (what "done" looks like from a business perspective)

**Step 5: Break down epics into user stories**

For each epic, identify the individual user stories that compose it:
- Each story should represent a single, deliverable piece of user-facing functionality
- Stories should be small enough to be completed in a single sprint (as a guideline)
- Look for stories in: feature descriptions, user workflows, business rules, data requirements, integration points
- Include non-functional stories where explicitly discussed (e.g., "As an admin, I want audit logging so that compliance requirements are met")

**Step 6: Write business-oriented descriptions with source traceability**

For each user story, write:
- **Title**: Short, descriptive, action-oriented (e.g., "User can reset password via email link")
- **User story**: "As a [role], I want [capability] so that [benefit]"
- **Source**: A concise traceability field that points back to the workshop material(s), baseline entry, or context summary used to derive the story
- **Acceptance criteria**: Checklist of verifiable business conditions, written primarily as concise `GIVEN / WHEN / THEN` scenarios
- **High-level technical notes**: Brief notes ONLY where the workshop discussion explicitly mentioned technical considerations (e.g., "Discussed using SSO integration", "Needs to support 10k concurrent users"). Do NOT invent technical details
- **Priority suggestion**: Based on discussion emphasis and dependencies (Critical / High / Medium / Low)
- **Additional acceptance checks**: Optional non-scenario checks when a `GIVEN / WHEN / THEN` statement is not sufficient

**Important**: Keep descriptions in business language. Avoid implementation jargon. The goal is for any stakeholder to understand what will be delivered without technical knowledge.

**Step 7: Map dependencies between tasks**

Identify relationships between epics and stories:
- **Blocked by**: Story A cannot start until Story B is complete
- **Related to**: Stories that share context but don't block each other
- **Epic dependencies**: When one epic must be delivered before another can begin

Use clear notation (e.g., "Story 1.2 is blocked by Story 1.1") in the dependencies section.

**Step 8: Identify assumptions and out-of-scope items**

Document:
- **Assumptions**: Decisions you made based on interpretation of the materials where the intent was not 100% clear. Label each assumption clearly so stakeholders can confirm or correct it.
- **Out of scope**: Items that were explicitly excluded during the workshop, or that you identified as beyond the current discussion scope. This prevents scope creep and sets clear boundaries.

**Step 9: Flag ambiguities and ask clarifying questions**

Review all extracted tasks and identify:
- Stories where you are not confident about the scope or intent
- Conflicting information between different materials (e.g., transcript says one thing, Figma shows another)
- Missing information that would significantly affect the task breakdown

Use `askQuestions` to clarify these items with the user. Ask exactly **one question per `askQuestions` call**. Each question must clearly identify the specific epic or story it relates to — include the story identifier and title in the question header and context (e.g., "[Epic: User Auth > Story 1.2: User can log in] The transcript mentions SSO but the Figma shows email/password only. Which scope is correct?"). This ensures each popup is self-contained and the user can focus on one decision at a time.

**Step 10: Present task list for user validation**

Present each story to the user individually for validation using one `askQuestions` call per story. Each question should include the story's full context: parent epic title, story title, and a brief summary of the acceptance criteria. Ask: "Is this story correct? Should it be split, merged, modified, or removed?"

After presenting all stories, ask one final workflow-level question: "Did I miss any tasks that should be added?"

Iterate based on feedback until the user approves the task list.

This is **Review Gate 1** — the user must approve the task list before proceeding to Jira formatting.

**Step 11: Save the intent brief and extracted tasks documents**

Generate the final outputs following the `./intent-brief.example.md` and `./extracted-tasks.example.md` templates.

Save `intent-brief.md` and `extracted-tasks.md` to `specifications/<workshop-name>/`.

The extracted tasks document must preserve source traceability in each story and keep acceptance criteria in business-friendly scenario form.

## Connected Skills

- `tsh-transcript-processing` - provides the cleaned transcript used as primary input
- `tsh-codebase-analysing` - for understanding existing system context when analyzing scope
- `tsh-task-analysing` - for business-context exploration, baseline comparison, and intent brief drafting before extraction
