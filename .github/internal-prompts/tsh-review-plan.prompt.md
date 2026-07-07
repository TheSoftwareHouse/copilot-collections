Stress-test the implementation plan for the provided task. Assume the architect likely produced a basically correct plan, then look for the strongest reasons it could still fail in implementation, create expensive rework, or give false confidence. The primary deliverable is the full structured review document saved as `specifications/{task-name-or-id}/{task-name}.plan-review.md`, alongside the plan in the same directory.

## Required Skills

Before starting, load and follow these skills:

- `tsh-architecture-designing` - evaluate whether the proposed shape, phasing, and trade-offs are likely to fail in execution or create costly rework
- `tsh-creating-implementation-plans` - verify the plan complies with the owned plan template, structure, and definition-of-done rules
- `tsh-codebase-analysing` - verify critical references, dependencies, and abstractions against actual codebase state
- `tsh-technical-context-discovering` - check repo conventions or established abstractions only when they materially affect execution risk
- `tsh-implementation-gap-analysing` - validate what exists vs what the plan assumes must already be available
- `tsh-sql-and-database-understanding` - when the plan includes schema changes, migrations, data backfills, indexing, or query risks

## Workflow

1. **Read the research file** (`.research.md`) — understand the full set of requirements, acceptance criteria, and constraints that the plan must address.

2. **Read the plan file** (`.plan.md`) — understand the proposed architecture, phases, tasks, and definitions of done. Stop immediately if any row in `## Open Questions` has Status = `❓ Open`; this is a blocker and review cannot proceed until the architect resolves it.

3. **Challenge-domains pass** — Before diving into general failure modes, systematically attack the plan's most consequential decisions using the challenge domains defined in the agent. For each domain, explicitly state whether an issue was found or not. Pay special attention to technology/stack choices that deviate from research context or prior iterations — these are the highest-value challenges.

4. **Failure-modes pass** — Find the strongest reasons the plan may fail during implementation or cause major rework. Prioritize substantive risks such as integration mismatches, unsafe migrations, coordination traps, weak rollout strategies, and brittle task breakdowns.

5. **Hidden-assumptions pass** — Identify assumptions that are unproven in this repository. Flag beliefs about files, abstractions, contracts, environment behavior, team coordination, or data shape that the plan depends on but does not verify.

6. **Codebase-reality pass** — For every critical file, component, function, class, abstraction, or dependency the plan relies on:
   - Search the codebase to verify it exists
   - Read the file to verify it has the expected interface/behavior
   - Flag any reference that doesn't match reality or is weaker/more constrained than the plan assumes

7. **Sequencing-and-feasibility pass** — Identify order-of-operations traps, risky migrations, rollback gaps, coordination issues, and test or rollout blind spots. Focus on how the plan could break when executed step by step.

8. **Execution-critical decision gate** — Before final verdict, explicitly check for unresolved provider, vendor, stack, framework, auth, privacy, security, integration-contract, or migration-prerequisite decisions that sit on the critical path or lock in downstream work. These cannot be waved through as harmless notes.

9. **Decision-and-revision-history handling** — Always build and maintain a `Decision and Revision History` section as a compact chronological Markdown table, ordered from oldest to newest, including on the first review iteration. On iteration 1, capture the initial plan-shaping decisions the reviewer challenged, why they matter, the current architect position, and the current status. On later iterations, read the existing `.plan-review.md` first and update the same table to show what changed since the prior review, whether the reviewer's concerns were resolved, and which issues remain open. Prefer appending new rows for new developments; update an existing row only when that keeps the table clearer and more maintainable. Keep entries as short summaries with phrase-length cells, not prose blocks, transcripts, or exhaustive changelogs. Explicitly classify prior high-signal issues with compact statuses such as `open`, `changed`, `resolved`, `kept`, or `dropped`. If an issue is downgraded or dropped, explain why briefly in the row. Do not reduce challenge intensity because one issue was fixed. The architect fixing one thing does not mean new issues should not be found.

10. **Produce the report and binary verdict** — Save the full failure-oriented review report with final verdict (`APPROVED` or `REVISIONS NEEDED`) as `specifications/{task-name-or-id}/{task-name}.plan-review.md`, in the same directory as the plan. Do not reduce the persisted artifact to a short verdict memo or manager-style synthesis.

## Review Requirements

- Target 5-10 substantive findings when the evidence supports them; if fewer are found, state why the plan appears unusually robust.
- Attribute at least 2-3 findings to the challenge-domains pass when the evidence supports them.
- Do not pad the report with cosmetic, wording, or style-only notes.
- Do not fall back to generic quality audits or pattern-consistency checks.
- Flag any `❓ Open` item in the plan's `## Open Questions` table as a blocker requiring resolution before approval.
- Treat unexplained deviations from research context or prior established direction as likely `BLOCKERS` until justified.

<output-specification>
The full structured review report is the primary deliverable. Save it as `specifications/{task-name-or-id}/{task-name}.plan-review.md`, alongside the plan in the same directory, and structure it as follows:

- `# Plan Review: {plan-file-name}`
- Reviewed plan path, research file path, review date, and verdict (`APPROVED` or `REVISIONS NEEDED`)
- Summary counts for blockers, warnings, and suggestions
- `Challenge Domains` — One entry per domain with finding or explicit `no issue` note
- `Decision and Revision History` — Always present, including on the first review. It is concise evidence of reviewer impact on the plan and must preserve the high-signal, non-transcript standard. Format it as a compact Markdown table sorted chronologically from oldest to newest with these columns: `Date`, `Iteration`, `Decision / Topic`, `Problem / Challenge`, `Plan Decision / Change`, `Status`. Keep cells phrase-length where possible, not paragraph prose. Use compact `Status` values such as `open`, `changed`, `resolved`, `kept`, or `dropped`.
- `Top Failure Modes` — the strongest reasons this plan may fail or create expensive rework
- `Unproven Assumptions` — assumptions the architect must verify or tighten
- `Most Likely Rework Triggers` — the parts most likely to send implementation back for redesign or patch-up work
- `Questions the Architect Must Answer Before Coding` — the unresolved questions that materially affect execution
- Findings grouped under `BLOCKERS`, `WARNINGS`, and `SUGGESTIONS`, with concise reasoning, evidence, and the action needed
- `Verdict` — final binary decision: `APPROVED` or `REVISIONS NEEDED`
  </output-specification>

## Key Principles

- **Failure orientation** — look first for why the plan may break, stall, or trigger major rework.
- **Verify, don't assume** — always search the codebase before flagging phantom references. The architect may have found something you haven't.
- **Compressed decision history over completeness** — keep the `Decision and Revision History` section concise and decision-oriented on every iteration as a compact chronological table, preserving only the decisions, reviewer challenges, plan changes, and outcomes that still matter for the current verdict.
- **Pragmatism over permissiveness** — issues can exist and the verdict can still be `APPROVED`, but not when execution-critical open decisions remain unresolved. In those cases, default to `REVISIONS NEEDED`.
- **Scope discipline** — never suggest adding features or requirements not in the research file.
- **Carry critical issues forward** — unresolved execution-critical issues stay live across iterations until genuinely closed; repeated survival is a reason to escalate, not soften.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-review-plan:v3 -->
