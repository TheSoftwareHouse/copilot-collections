---
name: tsh-analyze-materials
description: "Process discovery workshop materials and create Jira-ready epics and user stories, or iterate on an existing Jira backlog."
user-invocable: true
---
<routing>Run this workflow through the designated agent: `tsh-business-analyst`.</routing>

Analyze workshop materials, transcripts, designs, PDFs, codebase context, and existing Jira backlogs into structured business artifacts under `specifications/<workshop-name>/`.

<required-skills>
- `tsh-task-analysing` - explore context and resolve ambiguity.
- `tsh-transcript-processing` - clean raw transcripts.
- `tsh-task-extracting` - identify epics and user stories.
- `tsh-task-quality-reviewing` - find gaps and edge cases.
- `tsh-jira-task-formatting` - format and manage Jira synchronization.
- `tsh-codebase-analysing` - understand relevant existing systems.
</required-skills>

<workflow>
1. Select standard workshop, import, or Explore Mode from the supplied inputs.
2. Process transcripts and supporting materials, including the project baseline.
3. Create and obtain approval for `intent-brief.md` before extraction.
4. Extract tasks, run the mandatory quality review, and obtain review-gate decisions.
5. Format final tasks, obtain push approval, synchronize Jira, verify results, and refresh the baseline.
</workflow>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-analyze-materials:v3 -->
