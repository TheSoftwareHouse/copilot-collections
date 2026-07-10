---
agent: "tsh-business-analyst"
model: ["GPT-5.6 Terra", "GPT-5.4"]
description: "Explore workshop materials for business context before backlog extraction."
---

Explore the provided workshop materials and produce a business/context summary before any backlog extraction begins. Use this when the user explicitly wants exploration first, or when the materials are too ambiguous to commit to epics and stories yet.

The expected outcome is a focused `workshop-context-summary.md` placed in `specifications/<workshop-name>/` that captures the business context, likely epics, open questions, and a recommendation on whether the work is ready for `intent-brief.md` and extraction.

This workflow starts from workshop materials such as transcripts, Figma/FigJam designs, PDFs, codebase context, or other reference documents. If a project baseline already exists, use it as continuity context.

Exploration may be delegated to the internal analysis worker, but the results always return through the BA orchestrator before anything moves toward extraction.

Do not create epics, stories, or Jira-ready backlog items in this mode unless the user explicitly asks to continue after the exploration summary.

## Required Skills

- `tsh-task-analysing` - to synthesize workshop context, spot ambiguities, and compare the materials with any existing backlog baseline.
- `tsh-transcript-processing` - to clean and structure raw transcript input when present.
- `tsh-codebase-analysing` - to understand existing system context when it helps interpret the workshop materials.

## Workflow

1. Review the provided materials and any existing project baseline if available.
2. Clean the transcript first if raw discussion notes are present.
3. Summarize the workshop/topic context in business language.
4. Identify the main actors, business entities, and likely epic candidates.
5. Note any overlap with existing backlog or baseline items if available.
6. Capture ambiguities, risks, and open questions that should be resolved before extraction.
7. Conclude with a recommendation on whether the materials are ready for `intent-brief.md` and task extraction.

## Output Specification

Create `specifications/<workshop-name>/workshop-context-summary.md` with at least these sections:
- Workshop/topic context
- Actors and business entities
- Existing backlog or baseline overlap
- Likely epic candidates
- Key ambiguities, risks, and open questions
- Recommendation on readiness for intent brief / extraction

Keep the output business-facing. Do not create Jira-ready epics or stories in this mode unless the user explicitly asks to continue.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-explore-materials:v2 -->