---
name: task-extracting
description: Identify and structure epics and user stories from workshop materials (cleaned transcripts, Figma designs, codebase analysis, and other documents). Produces a business-oriented task breakdown with dependencies, assumptions, and open questions.
---

# Task Extraction

This skill helps you identify discrete pieces of work (epics and user stories) from discovery workshop materials and structure them into a clear, business-oriented task breakdown. The output is intended for stakeholder review and eventual Jira creation — it is NOT a technical specification or implementation plan.

## What This Skill Produces

- **Epics**: High-level work streams with business descriptions and success criteria
- **User Stories**: Discrete deliverables in "As a… I want… So that…" format with acceptance criteria
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
- [ ] Step 2: Identify high-level work streams (epics)
- [ ] Step 3: Break down epics into user stories
- [ ] Step 4: Write business-oriented descriptions
- [ ] Step 5: Map dependencies between tasks
- [ ] Step 6: Identify assumptions and out-of-scope items
- [ ] Step 7: Flag ambiguities and ask clarifying questions
- [ ] Step 8: Present task list for user validation
- [ ] Step 9: Save the extracted tasks document
```

**Step 1: Gather and review all input materials**

Collect and thoroughly review all available workshop materials:
- **Cleaned transcript** (`cleaned-transcript.md`): Primary source — review all discussion topics, decisions, action items, and open questions
- **Figma/FigJam designs**: If available, analyze screens, flows, and annotations for functional requirements
- **Existing codebase**: Use `codebase-analysing` skill to understand what already exists and what needs to be built
- **Other documents**: Confluence pages, shared documents, email threads, or any other reference materials provided by the user
- **PDF documents**: If available, read PDF files using the `pdf-reader` tool to extract requirements, process descriptions, business rules, or any other relevant content provided by the client

Create a mental model of the full scope discussed during the workshop before proceeding to extraction.

**Step 2: Identify high-level work streams (epics)**

From the gathered materials, identify distinct work streams that represent major deliverables or feature areas:
- Look for natural groupings of related functionality
- Each epic should represent a cohesive business capability (e.g., "User Authentication", "Payment Processing", "Reporting Dashboard")
- Epics should be independent enough to be delivered and validated separately where possible
- Aim for 3-10 epics per workshop (if you find more, some may be too granular; if fewer, some may be too broad)

For each epic, draft:
- A clear, business-oriented title
- A 2-3 sentence business description explaining the value
- High-level success criteria (what "done" looks like from a business perspective)

**Step 3: Break down epics into user stories**

For each epic, identify the individual user stories that compose it:
- Each story should represent a single, deliverable piece of user-facing functionality
- Stories should be small enough to be completed in a single sprint (as a guideline)
- Look for stories in: feature descriptions, user workflows, business rules, data requirements, integration points
- Include non-functional stories where explicitly discussed (e.g., "As an admin, I want audit logging so that compliance requirements are met")

**Step 4: Write business-oriented descriptions**

For each user story, write:
- **Title**: Short, descriptive, action-oriented (e.g., "User can reset password via email link")
- **User story**: "As a [role], I want [capability] so that [benefit]"
- **Acceptance criteria**: Checklist of verifiable conditions from a business/user perspective
- **High-level technical notes**: Brief notes ONLY where the workshop discussion explicitly mentioned technical considerations (e.g., "Discussed using SSO integration", "Needs to support 10k concurrent users"). Do NOT invent technical details
- **Priority suggestion**: Based on discussion emphasis and dependencies (Critical / High / Medium / Low)

**Important**: Keep descriptions in business language. Avoid implementation jargon. The goal is for any stakeholder to understand what will be delivered without technical knowledge.

**Step 5: Map dependencies between tasks**

Identify relationships between epics and stories:
- **Blocked by**: Story A cannot start until Story B is complete
- **Related to**: Stories that share context but don't block each other
- **Epic dependencies**: When one epic must be delivered before another can begin

Use clear notation (e.g., "Story 1.2 is blocked by Story 1.1") in the dependencies section.

**Step 6: Identify assumptions and out-of-scope items**

Document:
- **Assumptions**: Decisions you made based on interpretation of the materials where the intent was not 100% clear. Label each assumption clearly so stakeholders can confirm or correct it.
- **Out of scope**: Items that were explicitly excluded during the workshop, or that you identified as beyond the current discussion scope. This prevents scope creep and sets clear boundaries.

**Step 7: Flag ambiguities and ask clarifying questions**

Review all extracted tasks and identify:
- Stories where you are not confident about the scope or intent
- Conflicting information between different materials (e.g., transcript says one thing, Figma shows another)
- Missing information that would significantly affect the task breakdown

Use `askQuestions` to clarify these items with the user. Ask exactly **one question per `askQuestions` call**. Each question must clearly identify the specific epic or story it relates to — include the story identifier and title in the question header and context (e.g., "[Epic: User Auth > Story 1.2: User can log in] The transcript mentions SSO but the Figma shows email/password only. Which scope is correct?"). This ensures each popup is self-contained and the user can focus on one decision at a time.

**Step 8: Present task list for user validation**

Present each story to the user individually for validation using one `askQuestions` call per story. Each question should include the story's full context: parent epic title, story title, and a brief summary of the acceptance criteria. Ask: "Is this story correct? Should it be split, merged, modified, or removed?"

After presenting all stories, ask one final workflow-level question: "Did I miss any tasks that should be added?"

Iterate based on feedback until the user approves the task list.

This is **Review Gate 1** — the user must approve the task list before proceeding to Jira formatting.

**Step 9: Save the extracted tasks document**

Generate the final output following the `./extracted-tasks.example.md` template.

Save the file to `specifications/<workshop-name>/extracted-tasks.md`.

## Connected Skills

- `transcript-processing` - provides the cleaned transcript used as primary input
- `codebase-analysing` - for understanding existing system context when analyzing scope
