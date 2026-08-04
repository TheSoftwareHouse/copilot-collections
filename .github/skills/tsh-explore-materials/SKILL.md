---
name: tsh-explore-materials
description: "Explore workshop materials for business context before backlog extraction."
user-invocable: true
---
<routing>Run this workflow through the designated agent: `tsh-business-analyst`.</routing>

Explore workshop materials and produce a focused `workshop-context-summary.md` before creating Jira backlog items.

<required-skills>
- `tsh-task-analysing` - synthesize context and ambiguities.
- `tsh-transcript-processing` - clean raw transcripts.
- `tsh-codebase-analysing` - interpret relevant system context.
</required-skills>

<workflow>
1. Review materials and existing project baseline.
2. Clean transcripts and summarize business context, actors, entities, and likely epics.
3. Record overlap, risks, and open questions.
4. Save `specifications/<workshop-name>/workshop-context-summary.md` and recommend readiness for intent briefing and extraction.
</workflow>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-explore-materials:v2 -->
