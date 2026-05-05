---
agent: "tsh-qa-engineer"
model: "Claude Opus 4.6"
description: "Run the full QA workflow — test planning, test cases, regression planning, test reporting, and quality health reporting — as a guided, step-by-step process with checkpoints between each phase."
argument-hint: "[Jira ticket ID, feature description, or acceptance criteria]"
---

<goal>
Run the complete QA workflow as a guided, sequential process. Each phase builds on the previous one and ends with a checkpoint where the user decides the next step. The primary flow is:

1. **Plan Testing** — generate a functional test plan
2. **Create Test Cases** — produce detailed executable test cases from the plan
3. **Plan Regression** — build a prioritized regression checklist for affected areas
4. **Create Test Report** — summarize test execution results into a Go/No-Go verdict
5. **Create Quality Health Report** — analyze bug data for quality trends and risk indicators

At every checkpoint the user can also branch into:
- **Report a Bug** — file a structured bug report for any issue found during the phase
- **Audit Accessibility** — run a WCAG 2.2 Level AA accessibility audit on a URL or the codebase

The workflow is not all-or-nothing. The user can stop, skip ahead, or branch at any checkpoint.
</goal>

<required-skills>

## Required Skills

Load skills **lazily** — only when their phase is reached. Do NOT load all skills upfront.

| Skill | Load when |
|-------|-----------|
| `tsh-functional-testing` | Phase 0 (always — needed for AC gate and test plan) |
| `tsh-analyzing-bugs` | Phase 5 only, or when user selects "Quality Health Report" |
| `tsh-accessibility-auditing` | Only when user selects "Audit Accessibility" at any checkpoint |

</required-skills>

<workflow>

## Workflow

### Checkpoint Pattern (applies to all phases)

After each phase delivers its artifact, present a checkpoint via `vscode/askQuestions` with:
- **Phase-specific options** (listed under each phase below)
- **Always include**: "Report a Bug", "Audit Accessibility", "Stop here"

Do not repeat the full option descriptions at each checkpoint — use short labels. The side-flow sections below define what happens when those options are selected.

### Phase 0 — Kickoff

**Phase 0 is entirely silent.** Do not produce any chat output — no narration, no status updates, no "let me fetch…", no tool-call commentary. The first visible output the user sees must be either (a) the kickoff questions in Step 3, or (b) an AC-gap list if the gate fails. Everything before that happens behind the scenes.

1. **Gather input** — accept the user's input (Jira ticket ID, feature description, or acceptance criteria). If a Jira ticket ID is provided, silently call the `atlassian` tools to fetch `cloudId`, issue type metadata, and ticket details. Extract only the description (containing AC) and status. Discard everything else. Do NOT echo any ticket content, tool responses, or intermediate steps to the user.
2. **Validate AC completeness** — silently apply the AC Completeness Gate from `tsh-functional-testing`. If AC **are** test-ready, proceed to Step 3 without comment. If AC are **not** test-ready, list only the specific gaps found and redirect the user to `/tsh-analyze-materials`. Do not proceed until AC are complete.
3. **Batch kickoff questions** — use a **single** `vscode/askQuestions` call to ask both:
   - **Delivery destination**: Do not assume a destination; the user must choose: Chat only / Add to Jira ticket / Create Jira sub-tasks / Publish to Confluence (ask for space name + parent page title, or a Confluence page URL)
   - **API testing**: Include API test scenarios? Yes / No (only ask if the feature involves backend interaction)

   This avoids multiple round-trips. The delivery destination applies to Phases 1 and 2 only — Phases 3, 4, and 5 each ask their own delivery destination. If the user selects a destination but cannot provide the required identifiers, ask for them before proceeding.

---

### Phase 1 — Plan Testing

4. **Generate the test plan** per `tsh-functional-testing` skill's test plan workflow and `test-plan.example.md` template (or `test-plan.jira-example.md` for Jira delivery). Include at least 2 negative/edge-case scenarios.
5. **Deliver** to chosen destination. If Jira, confirm with just the ticket key and link — do not echo the test plan content back into chat.
6. **Checkpoint 1** — phase-specific options: "Continue to Phase 2: Create Test Cases" (recommended), "Skip to Phase 3: Plan Regression"

---

### Phase 2 — Create Test Cases

7. **Generate test cases** from the test plan per `tsh-functional-testing` skill and `test-cases.example.md` template. Cover every AC. Include at least 2 negative/edge-case test cases. Group by functional area.
8. **Deliver** to chosen destination. When delivering to Jira sub-tasks, add the test cases as a **comment** on the QA sub-task created in Phase 1 (using `addCommentToJiraIssue`) — do **not** create a separate sub-task for test cases. Confirm with the sub-task key and link only.
9. **Checkpoint 2** — phase-specific options: "Continue to Phase 3: Plan Regression" (recommended), "Skip to Phase 4: Create Test Report"

---

### Phase 3 — Plan Regression

10. **Ask for regression scope, delivery destination, and data sources** — use a **single** `vscode/askQuestions` call with three questions:

    - **Regression scope** (what recent work should regression cover):
      - **Sprint / Board** — all tickets from a specific sprint (paste board URL or sprint name).
      - **Date range** — all tickets created or resolved between two dates (e.g., "2026-01-01 to 2026-04-30").
      - **Specific tickets** — a hand-picked list of ticket keys (comma-separated).
      - **Current ticket only** — regression scoped to just HIB-15 (smallest scope, for single-feature releases).

      Phrase the question as: **"Which changes should this regression cover?"** — not technical jargon about "determining" changes.

    - **Regression delivery destination**: Do not assume a destination; the user must choose: Chat only / Confluence page (ask for space name + parent page title, or a page URL) / Jira ticket (ask for ticket key) / Confluence + Jira. If the user selects a destination but cannot provide the required identifiers, ask for them before proceeding.

    - **Data sources for cross-reference**: Jira / Confluence / Both / Neither. These are used to enrich the regression plan with bug history, existing regression checklists, and documentation — separate from the scope question above.

    The regression plan is a standalone artifact that often lives separately from the test plan — do **not** silently reuse the Phase 0 delivery destination.

11. **Fetch scope tickets** — based on the user's scope choice:
    - **Sprint / Board**: Use `searchJiraIssuesUsingJql` with `sprint = "[name]"` or `sprint in openSprints()` to fetch all tickets in the sprint.
    - **Date range**: Use JQL like `project = [KEY] AND (created >= "[start]" OR resolved >= "[start]") AND (created <= "[end]" OR resolved <= "[end]") ORDER BY created DESC` to fetch all tickets in the window.
    - **Specific tickets**: Fetch each provided ticket key.
    - **Current ticket only**: Use the ticket already in context from Phase 0.

    Extract the functional areas touched by all in-scope tickets. This gives a broader, release-aware regression scope rather than single-ticket analysis.

12. **Generate the regression plan** per `tsh-functional-testing` skill's Regression Scope Analysis workflow. The scope tickets from Step 11 replace Step 1 of the skill's regression process (identifying changed scope). Produce two artifacts:
    - **Regression scope analysis** (planning view) — concise risk table + bug cross-reference per `regression-scope.example.md`. Present this in chat as a brief summary.
    - **Regression test suite** (execution view) — structured test case tables per `regression-test-suite.example.md`. This is the deliverable that goes to the chosen destination.

13. **Deliver** the regression test suite to the destination chosen in Step 10. If Confluence, create a subpage under the parent (extract numeric `pageId` from the user-provided URL, resolve `spaceId` via ARI, then call `createConfluencePage` with ADF body). If Jira, add as a comment or description on the specified ticket. Confirm with page/ticket link only — do not echo the full test suite content back into chat. Present only the scope summary in chat.

14. **Checkpoint 3** — phase-specific options: "Continue to Phase 4: Create Test Report" (recommended), "Generate regression test cases", "Skip to Phase 5: Quality Health Report"

---

### Phase 4 — Create Test Report

15. **Ask for delivery destination and gather test results** — use a **single** `vscode/askQuestions` call with two questions:
    - **Test report delivery destination**: Do not assume a destination; the user must choose: Chat only / Confluence page (ask for space name + parent page title, or page URL) / Jira ticket (ask for key) / Create Jira sub-task. If the user selects a destination but cannot provide the required identifiers, ask for them before proceeding.
    - **Test results source**: "I'll paste results" / "Check Jira for results" (specify ticket key) / "Use Confluence results" (specify page URL).

    Do not fabricate results. If the user points to a Confluence page or Jira ticket, fetch and extract pass/fail data from it.
16. **Generate the test report** per `tsh-functional-testing` skill's `test-report.example.md` template. Include verdict (Go/No-Go/Conditional).
17. **Deliver** to the destination chosen in Step 15. If Confluence, create a subpage under the specified parent (extract `pageId` from URL, resolve `spaceId` via ARI, use ADF body format) or update the specified page (fetch current version first). If Jira, add as a comment on the specified ticket. Confirm with page/ticket link only — do not echo the full report back into chat. Show the verdict summary in chat.
18. **Checkpoint 4** — show verdict in checkpoint message. Phase-specific options: "Continue to Phase 5: Quality Health Report" (recommended)

---

### Phase 5 — Create Quality Health Report

19. **Load `tsh-analyzing-bugs` skill now** (not before). Use a **single** `vscode/askQuestions` call to ask:
    - **Bug scope** (which bugs to include in the report):
      - **All bugs** — analyze the entire project's bug history.
      - **Date range** — bugs created or resolved between two dates (e.g., "2026-01-01 to 2026-04-30").
      - **Sprint / Board** — bugs from a specific sprint.
      - **Current release only** — bugs related to tickets in the current Phase 3 regression scope (if already established).
    - **Delivery destination**: Chat only / HTML file / Confluence page / Jira ticket.

    The user may skip this step — if skipped, default to all bugs + chat delivery. Apply the chosen scope as a date filter in the JQL query (e.g., `AND created >= "2026-01-01"`).

    **Important:** The JQL search is paginated (returns ~10-25 results per call). You MUST paginate until all matching bugs are fetched before generating the report. Use `AND key < "{lastKey}"` to fetch subsequent pages. Never generate a report from partial data.

20. **Generate the report** per the skill's workflow, including the 🐛 Bugs vs 📖 Story Bugs classification.
21. **Deliver and checkpoint 5 (final)** — phase-specific options: "Re-run a specific phase", "Done"

---

### Side-flow: Report a Bug

Follow `tsh-functional-testing` skill's bug report process (`bug-report.example.md`). Classify severity using the skill's severity matrix. Always ask for delivery destination: Chat only / Create Jira bug / Add to Jira ticket / Publish to Confluence. The user may skip — if skipped, deliver in chat. If a source ticket is in context, offer to link the bug. Return to the triggering checkpoint afterward.

### Side-flow: Audit Accessibility

**Load `tsh-accessibility-auditing` skill now** (not before). Follow its full audit process. After delivering the report, return to the triggering checkpoint.

</workflow>

<constraints>

## Constraints

Rules specific to this workflow (agent-level constraints like WCAG 4.1.1, E2E handoff, and AC redirection are already defined in `tsh-qa-engineer.agent.md` — do not duplicate):

- **Phase 0 must be silent**: no chat messages, no narration of tool calls, no status updates, no "fetching ticket…" commentary. The first user-visible output is the kickoff questions (Step 3) or the AC-gap list. This is a hard rule — any text emitted before that point is a violation.
- Do not skip the AC Completeness Gate in Phase 0.
- Do not fabricate test results in Phase 4.
- Each phase must deliver its artifact before the checkpoint is shown.
- The delivery destination from Phase 0 applies to Phases 1 and 2 only. Phases 3, 4, and 5 each ask their own delivery destination question — do not silently reuse Phase 0's choice.
- When delivering to Jira, confirm with ticket key + link only — do not echo artifact content back into chat.

## Jira Integration Optimization

Follow `tsh-atlassian-mcp` instruction file for correct tool call patterns. Session-level caching rules:

- **Fetch `cloudId` once** via `getAccessibleAtlassianResources` at workflow start. Reuse for all calls.
- **Fetch issue type metadata once** via `getJiraProjectIssueTypesMetadata` when project key is known. Cache subtask type name.
- **Use correct parameter names**: `projectKey`, `issueTypeName`, `parent` (not `parentKey`).
- **Minimize output tokens**: Do not echo Jira API responses, ticket content, or metadata into chat. Consume silently. Only surface details when AC gaps are found or user explicitly requests a summary.

## Confluence Delivery Rules

Follow `tsh-atlassian-mcp` instruction file for Confluence tool patterns. Key rules:

- **Ask for a Confluence page URL OR a space name + parent page title** — the user should never need to know numeric IDs. If they provide a URL, extract `pageId` from it. If they provide a space name and page title, use `searchConfluenceUsingCql` to find the page ID.
- **Resolve `spaceId` via `getConfluencePage`** — call `getConfluencePage(cloudId, pageId)` and read `spaceId` directly from the response. Do NOT use the space key as `spaceId`.
- **Page body must be ADF JSON** — never send markdown or XHTML to `createConfluencePage` or `updateConfluencePage`. Build a valid `{"type":"doc","version":1,"content":[...]}` structure.
- **Cache `spaceId`** for the session after first resolution — do not re-resolve for each page operation.
- **For page updates**, fetch the current page version with `getConfluencePage` first, then increment the version number.

</constraints>
