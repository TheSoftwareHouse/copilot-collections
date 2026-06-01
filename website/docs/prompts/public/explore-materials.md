---
sidebar_position: 10
title: /tsh-explore-materials
---

# /tsh-explore-materials

**Agent:** Business Analyst  
**File:** `.github/prompts/tsh-explore-materials.prompt.md`

Explores discovery workshop materials and produces a business/context summary before backlog extraction begins. Use this when the source material is still ambiguous or when you want to understand likely scope before committing to epics and stories.

## Usage

```text
/tsh-explore-materials <workshop materials>
```

## What It Does

1. **Review materials and baseline** — Reads workshop inputs, existing project baseline, and other reference materials.
2. **Clean transcript when needed** — Structures raw discussion notes before analysis.
3. **Synthesize business context** — Summarizes the workshop topic in stakeholder-facing language.
4. **Identify likely epic candidates** — Highlights main actors, business entities, and probable backlog areas.
5. **Spot overlap and ambiguity** — Notes likely duplication, risks, and unresolved questions.
6. **Recommend readiness** — Concludes whether the materials are ready for `intent-brief.md` and `/tsh-analyze-materials`.

## Skills Loaded

- `tsh-task-analysing` — Synthesize context, ambiguity, and backlog overlap.
- `tsh-transcript-processing` — Clean and structure raw transcript input.
- `tsh-codebase-analysing` — Understand existing system context when relevant.

## Output

Creates a focused summary in `specifications/<workshop-name>/`:

```text
specifications/
  user-onboarding/
    workshop-context-summary.md ← business/context synthesis before extraction
```

The output includes:

- Workshop/topic context
- Actors and business entities
- Existing backlog or baseline overlap
- Likely epic candidates
- Key ambiguities, risks, and open questions
- Recommendation on readiness for intent brief and extraction

:::tip
This mode does not create Jira-ready backlog items on its own. Continue with [`/tsh-analyze-materials`](./analyze-materials) when you are ready to move from exploration into intent brief approval and extraction.
:::