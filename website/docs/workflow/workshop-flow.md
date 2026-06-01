---
sidebar_position: 5
title: Workshop Analysis Flow
---

# Workshop Analysis Flow

For converting discovery workshop materials into structured, Jira-ready epics and user stories, use the Workshop Analysis workflow. This flow can start with exploration when the source material is still ambiguous, then moves through intent brief approval, extraction, quality review, Jira formatting, and verified Jira sync.

## Command Sequence

```text
0️⃣ /tsh-explore-materials <workshop materials> (optional)
   ↳ 📖 Review business context, likely epics, overlap, and ambiguities
   ↳ ✅ Decide whether the materials are ready for extraction

1️⃣ /tsh-analyze-materials <workshop materials>
   ↳ 📝 Agent processes transcript and supporting materials
   ↳ 📄 Agent drafts `intent-brief.md`

2️⃣ Gate 0 — Intent Brief Review
   ↳ 📖 Review scope, exclusions, and candidate epics
   ↳ ✅ Approve before extraction starts

3️⃣ Gate 1 — Task Review
   ↳ 📖 Review extracted tasks — check epic/story breakdown
   ↳ ✅ Approve, or request splits/merges/removals

4️⃣ Gate 1.5 — Quality Review (automatic)
   ↳ 🔍 Agent runs Lite or Full quality review; Full mode runs 10 analysis passes
   ↳ 📖 Review each suggestion — accept or reject individually
   ↳ ✅ Agent applies accepted suggestions to the task list

5️⃣ Gate 2 — Jira Push Approval
   ↳ 📖 Review final formatted tasks
   ↳ ✅ Confirm target Jira project and approve push
   ↳ 🚀 Agent creates/updates issues in Jira

6️⃣ Verification & Continuity
   ↳ 🔎 Agent reads Jira back and verifies key fields
   ↳ ♻️ Agent refreshes session archive and project baseline after verified sync
```

## Workflow Diagram

```
┌─────────────────────────────┐
│  Raw Workshop Materials     │
│  (transcript, Figma, notes) │
└──────────┬──────────────────┘
           ▼
┌─────────────────────────────┐
│  Optional Explore Mode      │
│  → workshop-context-summary │
└──────────┬──────────────────┘
           ▼
┌─────────────────────────────┐
│  Transcript + Material      │
│  Analysis                   │
│  → cleaned-transcript.md    │
└──────────┬──────────────────┘
           ▼
┌─────────────────────────────┐
│  Intent Brief               │
│  → intent-brief.md          │
└──────────┬──────────────────┘
           ▼
┌─────────────────────────────┐
│  ★ Gate 0: User Review      │
└──────────┬──────────────────┘
           ▼
┌─────────────────────────────┐
│  Task Extraction            │
│  → extracted-tasks.md       │
└──────────┬──────────────────┘
           ▼
┌─────────────────────────────┐
│  ★ Gate 1: User Review      │
└──────────┬──────────────────┘
           ▼
┌─────────────────────────────┐
│  Quality Review (Lite/Full) │
│  → quality-review.md        │
└──────────┬──────────────────┘
           ▼
┌─────────────────────────────┐
│  ★ Gate 1.5: Accept/Reject  │
└──────────┬──────────────────┘
           ▼
┌─────────────────────────────┐
│  Jira Formatting            │
│  → jira-tasks.md            │
└──────────┬──────────────────┘
           ▼
┌─────────────────────────────┐
│  ★ Gate 2: Push Approval    │
└──────────┬──────────────────┘
           ▼
┌─────────────────────────────┐
│  Push + Verify in Jira      │
│  → baseline refresh         │
└─────────────────────────────┘
```

## Quality Review Modes

The quality review step runs in one of two modes:

| Mode | Default Use | Passes |
|---|---|---|
| Lite | Smaller, lower-risk workshops | A, B, E, H, I |
| Full | Larger workshops, regulated domains, or higher-risk scope | A through J |

## Quality Review Passes

Full mode runs 10 domain-agnostic analysis passes against the approved task list:

| Pass | Category | What It Checks |
|---|---|---|
| A | Entity Lifecycle | CRUD completeness for every business entity |
| B | Cross-Feature State | State validation when features consume shared entities |
| C | Bulk Operations | Idempotency and partial failure handling for batch operations |
| D | Actor Dashboards | Metrics, configuration, and history for management interfaces |
| E | Precondition Guards | Feature dependencies and prerequisite enforcement |
| F | Third-Party Boundaries | External system integration clarity and failure modes |
| G | Platform Operations | Admin/operator tooling and monitoring capabilities |
| H | Error States | Failure, empty, and boundary condition coverage |
| I | Notifications | Communication gaps when state changes affect other actors |
| J | Domain Research | Industry-specific patterns and compliance requirements |

## Import Mode

To iterate on an existing Jira backlog instead of workshop materials:

```text
/tsh-analyze-materials PROJ-123
```

The agent fetches existing issues from Jira, converts them into the local format, then runs quality review and formatting. Approved changes can be pushed back to Jira individually or in batch and verified after sync.

## Connecting to the Standard Flow

After workshop analysis, individual tasks can flow into the standard delivery workflow:

```text
/tsh-analyze-materials  →  /tsh-implement PROJ-123  →  /tsh-review
```

Use the **Start Implementation** handoff to transition the current task to the Engineering Manager for research, planning, and implementation.

:::warning Important
Each gate requires your review and approval. The Business Analyst produces business-oriented outputs — validate that the extracted tasks accurately reflect workshop discussions and that no critical topics were missed. AI assistance does not replace stakeholder judgment.
:::
