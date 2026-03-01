---
name: task-quality-reviewing
description: Analyze extracted epics and user stories for quality gaps, missing edge cases, and improvement opportunities. Runs domain-agnostic analysis passes, optionally enriches findings with Jira board context, and produces accept/reject suggestions that refine the task list before Jira formatting.
---

# Task Quality Review

This skill performs a systematic quality analysis on an approved task list (epics and user stories) to identify gaps, missing edge cases, and improvement opportunities. It runs 10 domain-agnostic analysis passes, optionally enriches findings with existing Jira board context, and produces a structured list of suggestions the user can individually accept or reject.

The output is a **quality review report** documenting all suggestions, their dispositions, and any changes applied to the task list.

## What This Skill Produces

- **Suggestions**: Structured improvement proposals, each individually accept/reject
- **Domain model**: An intermediate actor–entity–lifecycle map derived from the task list (used for analysis)
- **Quality review report**: Audit trail of all suggestions and decisions (`quality-review.md`)
- **Updated task list**: Accepted suggestions are applied to `extracted-tasks.md` in-place

## What This Skill Does NOT Do

- Does not make technical architecture decisions (that is the architect's responsibility)
- Does not add scope that is not implied by the source materials or common patterns
- Does not estimate effort or change priorities
- Does not invent domain-specific requirements without research backing
- Does not modify tasks without explicit user approval
- Does not create, modify, or delete Jira issues (read-only access for enrichment)

## Task Quality Review Process

Use the checklist below and track your progress:

```
Quality review progress:
- [ ] Step 1: Load inputs and establish context
- [ ] Step 2: Gather Jira board context (optional)
- [ ] Step 3: Build domain model from the task list
- [ ] Step 4: Run analysis passes
- [ ] Step 5: Enrich with domain research
- [ ] Step 6: Classify and structure suggestions
- [ ] Step 7: Present suggestions for user review
- [ ] Step 8: Apply accepted suggestions
- [ ] Step 9: Save quality review report
```

---

**Step 1: Load inputs and establish context**

Collect and review all available materials:

- **`extracted-tasks.md`** (mandatory): The Gate 1-approved epic and story list. This is the primary input.
- **`cleaned-transcript.md`** (if available): Cross-reference for details that may have been lost or simplified during task extraction.
- **Other source materials**: Figma designs, codebase analysis, Confluence pages, or any other documents referenced during extraction.

Build a complete picture of the project scope, actors, and features before proceeding to analysis.

**Step 2: Gather Jira board context (optional)**

If Atlassian tools are available and the user has indicated a Jira project (either in their initial message or during the workflow):

1. Check available Atlassian resources by calling `List accessible Resources`.
2. If multiple resources exist, ask the user which one to use.
3. If the user provided a Jira project key, use it. If not, ask once: "I have access to Jira. Would you like me to check an existing board for additional context? If so, what is the project key?" If the user declines, skip this step entirely.
4. Fetch existing epics and stories from the board.
5. Note: naming conventions, label usage, priority patterns, and any existing work that relates to the extracted tasks.

This enrichment is **entirely optional**. The skill works identically without Jira access. Do not block the review process if Jira is unavailable or the user declines.

**Step 3: Build domain model from the task list**

Before running analysis passes, construct a lightweight domain model from the extracted tasks. This model is the foundation for systematic gap detection.

Identify and document:

**Actors** — Every distinct role mentioned across all stories:

| Actor | Epics Involved | Key Capabilities |
|---|---|---|
| _<role name>_ | _<epic numbers>_ | _<what this actor can do>_ |

**Entities** — Every distinct business object or concept managed by the system:

| Entity | Created In | Read In | Updated In | Deactivated/Deleted In |
|---|---|---|---|---|
| _<entity name>_ | _<story ref or "—">_ | _<story ref or "—">_ | _<story ref or "—">_ | _<story ref or "—">_ |

**Relationships** — How entities relate to each other and which features depend on which entities being in a valid state.

This model is derived entirely from the task list content. It is not a technical data model — it is a business-oriented map of what the system manages and who interacts with it.

**Step 4: Run analysis passes**

> **Protected Status Filter**: Before running analysis passes, filter out all tasks (epics and stories) whose Status field is Done, Cancelled, or PO APPROVE. These tasks are considered immutable and must not generate findings or suggestions. They may still be referenced as dependencies by other tasks, but they themselves are excluded from all analysis.

Execute each of the following analysis passes against the domain model and task list. Each pass is independent and produces zero or more findings. A finding is a potential gap or improvement that will become a suggestion.

---

**Pass A: Entity Lifecycle Completeness**

For each entity identified in the domain model, verify that its full lifecycle is covered:
- **Creation**: Is there a story where this entity is created?
- **Reading/listing**: Can the relevant actor view or list instances of this entity?
- **Updating**: Can the relevant actor modify this entity after creation?
- **Deactivation/deletion**: Can the relevant actor remove or deactivate this entity?

A finding is generated when any lifecycle operation is missing for an entity that logically requires it.

_Example patterns_: A system manages "locations" but has no story for editing or deleting a location. A system creates "promotions" but has no story for viewing promotion history.

---

**Pass B: Cross-Feature State Validation**

When one feature consumes an entity that is managed by another feature, verify that the consuming feature validates the entity's readiness state.

For each dependency in the task list:
- Does the downstream feature check that the upstream entity is in a valid/active state?
- What happens if the upstream entity is incomplete, deactivated, or in an error state?

A finding is generated when a feature uses an entity from another feature without validating its state.

_Example patterns_: A public-facing page displays data from an entity that could be deactivated — the page should handle the "inactive" case. A workflow depends on a user completing a verification step — the workflow should block or show a message if verification is incomplete.

---

**Pass C: Bulk Operation Idempotency**

For any story that involves bulk or batch operations (imports, mass updates, batch processing):
- Does the story handle the case where some items already exist?
- Does the story handle partial failures (some items succeed, some fail)?
- Is the user informed of the outcome (success count, failure count, error details)?

A finding is generated when a bulk operation does not account for pre-existing data or partial failure scenarios.

_Example patterns_: A CSV import creates new records but does not specify what happens when a record with the same identifier already exists. A batch invitation does not clarify whether already-registered users are skipped or re-invited.

---

**Pass D: Actor Dashboard Completeness**

For every actor that has a management interface (dashboard, panel, admin area):
- **Metrics/statistics**: Does the actor have visibility into key performance indicators or activity summaries for their domain?
- **Configuration**: Can the actor manage settings and preferences relevant to their role?
- **History/audit**: Can the actor view historical data or activity logs?

A finding is generated when an actor has a dashboard but is missing one of these three dimensions.

_Example patterns_: An employer can manage workers and locations but has no way to see tipping statistics or activity trends. A worker can view recent transactions but has no summary or aggregate view.

---

**Pass E: Precondition Guards**

When one feature enables or unlocks another feature, verify that:
- The enabling feature enforces the precondition (blocks access or shows a message if prerequisites are not met)
- The user is informed about what they need to do to unlock the dependent feature
- The system does not allow the dependent feature to operate in an invalid state

A finding is generated when a feature dependency exists but the precondition is not explicitly guarded in the stories.

_Example patterns_: A feature generates a QR code for a worker, but the worker has not completed identity verification — the QR code should not be generated or displayed until verification is done. A feature requires a paid plan, but no story covers what the user sees if they are on the free plan.

---

**Pass F: Third-Party Boundary Clarity**

For every story that involves an external system, service, or third-party provider:
- Is it clear which parts of the workflow are handled by the external system vs. built in-house?
- Are integration points documented (what data goes in, what comes back)?
- Are failure modes for the external system covered (timeout, rejection, downtime)?

A finding is generated when a story references a third-party system but does not clearly delineate the boundary or address failure scenarios.

_Example patterns_: A story says "verification is handled by the payment processor" but does not specify what the system does when verification fails or times out. A story integrates with an e-commerce platform but does not clarify whether the integration is embedded, linked, or API-based.

---

**Pass G: Platform Operations Perspective**

Verify whether the task list includes any management, monitoring, or administrative capability for the platform operators themselves (not the end users):
- Can platform operators view system health, key metrics, or user statistics?
- Can platform operators intervene (e.g., change account status, resolve disputes)?
- Can platform operators troubleshoot issues (e.g., view transaction logs, audit trails)?

A finding is generated when no epic or story addresses the platform operator perspective. This is a common gap — workshop discussions typically focus on end-user features and overlook internal tooling.

_Example patterns_: A marketplace platform has stories for buyers and sellers but none for the marketplace operators. A subscription service has stories for subscribers but none for the billing team to manage accounts.

---

**Pass H: Error State and Edge Case Coverage**

For each story that describes a happy-path user flow:
- What happens when the action fails (network error, invalid input, permission denied)?
- What does the user see when data is empty (no records yet, no results found)?
- What happens at boundary conditions (maximum limits, minimum values, expired items)?

A finding is generated when a story describes only the success path and does not address failure, empty, or boundary states either as acceptance criteria or as separate stories.

_Example patterns_: A story covers "user can view transaction history" but does not specify what appears when there are no transactions yet. A story covers "user can submit payment" but does not specify what happens on insufficient funds or expired card.

---

**Pass I: Notification and Communication Gaps**

For each state change that affects an actor other than the one performing the action:
- Is the affected actor notified of the change?
- Is the notification method specified (email, in-app, push notification)?
- Are notification preferences or opt-out options addressed?

A finding is generated when a state change impacts another actor but no notification is mentioned in any story.

_Example patterns_: An employer deactivates a worker, but there is no story for notifying the worker. A system processes a payout, but the worker is not notified when funds arrive. An account status changes, but the account holder is not informed.

---

**Pass J: Domain-Specific Research**

Based on the project's domain (identified from the extracted tasks and source materials):
- Research common patterns, standards, and regulatory requirements for that domain
- Identify industry-specific features that are commonly expected but may not have been discussed
- Check for compliance requirements that could create additional stories

Use available research tools (context7, documentation search) to find relevant industry patterns. Flag findings with **Medium** or **Low** confidence since they are based on external research rather than explicit workshop discussion.

A finding is generated when external research reveals a common domain pattern or requirement that is not covered in the task list.

_Example patterns_: A financial application does not include audit logging, which is a regulatory expectation. A healthcare application does not address data retention policies. An e-commerce application does not cover order cancellation or refund flows.

---

**Step 5: Enrich with domain research**

If domain-specific research tools are available (context7, web search):
- Identify the project's primary domain from the extracted tasks
- Research common features, compliance requirements, and industry patterns for that domain
- Cross-reference research findings with the task list to identify gaps
- Add any new findings to the Pass J results

If no research tools are available, rely solely on the other nine passes.

**Step 6: Classify and structure suggestions**

Transform each finding from the analysis passes into a structured suggestion:

1. **Assign a confidence level** based on the source:
   - **High**: The finding is based on a universal pattern (entity lifecycle, error states, notification gaps). Virtually every project benefits from addressing it.
   - **Medium**: The finding depends on business context or domain (admin panels, compliance, domain-specific regulations). Important but may not apply to all projects.
   - **Low**: The finding is based on external research or speculation. May be out of scope or irrelevant to the project's current phase.

2. **Determine the action type**:
   - `ADD_ACCEPTANCE_CRITERION`: The gap is about a missing condition in an existing story. The story's scope does not change, but a new verifiable criterion is added.
   - `MODIFY_STORY`: The gap requires expanding an existing story's scope (adding requirements or changing the description).
   - `ADD_TECHNICAL_NOTE`: The gap is about clarity or documentation, not functional scope. A note is added to an existing story.
   - `NEW_STORY`: The gap represents entirely new functionality that does not fit in any existing story.
   - `NEW_EPIC`: The gap represents a new capability area that warrants its own epic (rare — typically only for platform operations or major compliance requirements).

3. **Write the proposed change**: Draft the exact text to be added or modified. For new stories, follow the format established in `extracted-tasks.md`. For acceptance criteria, follow the checklist format. This ensures that accepting a suggestion immediately produces valid task list content.

4. **Deduplicate**: If multiple passes produce findings that overlap, merge them into a single suggestion and note all contributing categories.

5. **Enrich with Jira context** (if available from Step 2): Cross-reference each suggestion with existing Jira issues. If a suggestion duplicates or overlaps with an existing issue, note the Jira issue key and adjust the suggestion (e.g., "This is already tracked as PROJ-123 — consider linking rather than creating a new story").

**Step 7: Present suggestions for user review**

> **Protected Status Safety Net**: Before presenting suggestions, verify that no suggestion targets a task with a protected status (Done, Cancelled, or PO APPROVE). If any such suggestion exists, drop it silently — it should not have been generated (see Step 4 guard), but this acts as a defensive safety net.

Present all suggestions to the user for individual accept/reject decisions:

1. **Order suggestions**: Order by epic, then by confidence within each epic (High first, then Medium, then Low). If a suggestion proposes a new epic, present it after all existing-epic suggestions.

2. **One suggestion per popup**: Present exactly **one suggestion per `askQuestions` call**. Each popup must be self-contained — the user should be able to make a decision without needing context from a previous popup. For each suggestion, show:
   - The parent epic title and affected story title/ID (e.g., "[Epic: User Auth > Story 1.2: User can log in]")
   - The suggestion summary and rationale
   - The confidence level (High / Medium / Low)
   - The action type (what will change if accepted)
   - Options: Accept / Reject

3. **Iterate**: Continue until all suggestions have been decided. The user may also provide feedback that modifies a suggestion before accepting it.

4. **Record decisions**: Track which suggestions were accepted and which were rejected (with any stated reason).

**Step 8: Apply accepted suggestions**

> **Protected Status Final Guard**: Before applying any accepted suggestion, re-check the target task's Status field. If the status is Done, Cancelled, or PO APPROVE, do not apply the change. Log it in the quality review report as "Skipped — task has protected status".

For each accepted suggestion, apply the proposed change to `extracted-tasks.md`:

- `ADD_ACCEPTANCE_CRITERION`: Add the new criterion to the specified story's acceptance criteria list.
- `MODIFY_STORY`: Update the story's description, requirements, or scope as proposed.
- `ADD_TECHNICAL_NOTE`: Append the note to the specified story's technical notes section.
- `NEW_STORY`: Add the new story under the appropriate epic, following the existing numbering convention (e.g., if Epic 2 has stories 2.1-2.7, a new story becomes 2.8).
- `NEW_EPIC`: Add the new epic at the end of the document with the proposed stories, update the Epics Overview table, and update the Dependencies section if applicable.

After applying all changes, update the Workshop Summary table in `extracted-tasks.md` (total stories count, total epics count) to reflect the additions.

**Step 9: Save quality review report**

Generate the final quality review report following the `./quality-review.example.md` template.

Save the file to `specifications/<workshop-name>/quality-review.md`.

The report serves as an audit trail documenting:
- The domain model constructed during analysis
- All suggestions generated (not just accepted ones)
- The user's decision for each suggestion (accepted/rejected)
- A summary of changes applied to `extracted-tasks.md`

## Analysis Categories Reference

| Pass | Category | Confidence Default | Typical Action |
|---|---|---|---|
| A | Entity Lifecycle Completeness | High | NEW_STORY or MODIFY_STORY |
| B | Cross-Feature State Validation | High | ADD_ACCEPTANCE_CRITERION or MODIFY_STORY |
| C | Bulk Operation Idempotency | High | ADD_ACCEPTANCE_CRITERION or MODIFY_STORY |
| D | Actor Dashboard Completeness | Medium | NEW_STORY |
| E | Precondition Guards | High | ADD_ACCEPTANCE_CRITERION or MODIFY_STORY |
| F | Third-Party Boundary Clarity | Medium | ADD_TECHNICAL_NOTE or MODIFY_STORY |
| G | Platform Operations Perspective | Medium | NEW_EPIC or NEW_STORY |
| H | Error State & Edge Case Coverage | High | ADD_ACCEPTANCE_CRITERION |
| I | Notification & Communication Gaps | High | NEW_STORY or ADD_ACCEPTANCE_CRITERION |
| J | Domain-Specific Research | Low–Medium | Varies |

## Connected Skills

- `task-extracting` — provides the extracted tasks used as primary input for the quality review
- `jira-task-formatting` — consumes the updated task list after quality review suggestions are applied
