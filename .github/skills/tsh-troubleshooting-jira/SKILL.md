---
name: tsh-troubleshooting-jira
description: "Structured investigation workflows for diagnosing Jira Cloud, Data Center, and JSM issues — automation failures, permission problems, ticket routing, queue placement, workflow transitions, SLA breaches, and unexpected behavior. Use when diagnosing why tickets were created, routed, assigned, delayed, hidden, or failed in automation."
---

# Jira Troubleshooting

This skill provides structured investigation workflows for diagnosing issues in Jira Cloud, Jira Data Center, and Jira Service Management. Each investigation type follows a consistent checklist approach to ensure thorough root-cause analysis.

## General Troubleshooting Process

Use the checklist below and track your progress:

```
Investigation progress:
- [ ] Step 1: Understand the reported symptom
- [ ] Step 2: Identify the investigation type
- [ ] Step 3: Follow the type-specific checklist
- [ ] Step 4: Write investigation JQL
- [ ] Step 5: Document findings and assumptions
- [ ] Step 6: Propose safe next steps
- [ ] Step 7: Draft stakeholder summary if needed
```

**Step 1: Understand the reported symptom**

Clarify what the user is seeing vs. what they expected to happen. Gather the specific ticket key, project key, issue type, and timestamp of the observed behavior. If any of these are missing, ask before proceeding — do not assume values. Look for screenshots, audit log excerpts, or error messages that narrow the scope.

**Step 2: Identify the investigation type**

Map the reported symptom to one of the specific investigation types below:

| Symptom pattern | Investigation type |
|---|---|
| Ticket not appearing in a queue, wrong queue, or missing from filters | 1. Queue and Routing Issues |
| Automation rule didn't fire, fired incorrectly, or produced wrong result | 2. Automation Troubleshooting |
| User can't see, edit, transition, or comment on an issue | 3. Permission Issues |
| Issue stuck in wrong status, transition unavailable, or post-function failed | 4. Workflow Issues |
| SLA clock wrong, escalation didn't fire, or breach reported incorrectly | 5. SLA and Escalation Issues |

If multiple types apply, prioritize the one closest to the root cause. For example, if a ticket is missing from a queue because an automation rule failed to set a required field, start with Automation Troubleshooting.

**Step 3: Follow the type-specific checklist**

Use the appropriate checklist from the sections below. Work through each item in order. Mark items as checked once confirmed or ruled out — do not skip items without evidence.

**Step 4: Write investigation JQL**

Construct JQL queries to isolate affected tickets, verify the scope of the issue, and test hypotheses. Reference `tsh-writing-jql` for query construction patterns, clause explanation, and variant generation. Always explain each clause in the query so the user understands what is being filtered.

Example investigation queries:

- Scope check: find all tickets matching the suspected condition in the affected project within the relevant time window.
- Comparison: find tickets that were correctly routed/processed to contrast with the failing ones.
- Audit: find tickets modified by the automation actor or specific user in the time range.

**Step 5: Document findings and assumptions**

Clearly separate confirmed facts from assumptions. For each finding, list:

- What was observed (evidence)
- What it means (interpretation)
- Confidence level (confirmed / likely / speculative)

Do not mix confirmed facts with guesses. If a hypothesis cannot be verified with available tools, state that explicitly.

**Step 6: Propose safe next steps**

Recommend reversible, low-risk actions first. For any proposed change, include:

- **What** the change is
- **Impact** — what will be affected
- **Dependencies** — what else relies on the thing being changed
- **Rollback** — how to undo the change if it causes problems
- **Validation** — how to confirm the change worked

Never recommend bulk changes, scheme reassignments, or workflow modifications without explicit confirmation from the user.

**Step 7: Draft stakeholder summary**

If the issue affects operations or end users, draft a plain-English summary suitable for non-technical stakeholders. Include:

- What happened (symptom)
- Why it happened (root cause)
- Who/what was affected (scope)
- What was done or will be done (resolution)
- How to prevent recurrence (if applicable)

## 1. Queue and Routing Issues

Use this checklist when tickets are not appearing in the expected queue, appearing in the wrong queue, or missing from filters and boards.

```
Queue/Routing investigation:
- [ ] Check request type or issue type assumptions
- [ ] Review queue JQL or filter logic
- [ ] Verify required fields and labels are present
- [ ] Check assignment logic or automation rules
- [ ] Verify permissions and issue security
- [ ] Check workflow status constraints
- [ ] Check SLA or team ownership side effects
```

**Check request type or issue type assumptions** — Confirm the ticket's actual issue type and request type match what the queue expects. In JSM, the request type displayed to the customer may differ from the underlying issue type. Use `issuetype` and `"Customer Request Type"` fields in JQL to verify.

**Review queue JQL or filter logic** — Read the queue's JQL definition. Compare each clause against the ticket's actual field values. Pay attention to status filters, component filters, label conditions, and custom field checks. A single non-matching clause excludes the ticket.

**Verify required fields and labels are present** — Check that all fields referenced in the queue JQL are populated on the ticket. Empty fields will fail equality and `in` checks. Look for labels, components, priority, and custom fields.

**Check assignment logic or automation rules** — Determine if the ticket was assigned before queue evaluation. In some configurations, assigned tickets are excluded from unassigned queues. Check automation rules that fire on creation — they may set assignee, priority, or labels that change queue placement.

**Verify permissions and issue security** — Check if an issue security level is set on the ticket. If agents are not in the security level's allowed list, the ticket will be invisible in their queue even if the JQL matches. Check the issue security scheme for the project.

**Check workflow status constraints** — Verify the ticket's current status matches what the queue JQL expects. If the queue filters by specific statuses (e.g., `status = "Waiting for Support"`), a ticket in a different status will not appear.

**Check SLA or team ownership side effects** — Some queue configurations depend on SLA state or custom "team" fields. Verify these are set correctly, especially if recent automation or bulk changes may have altered them.

Common causes:
- Queue JQL doesn't match the issue type or request type
- Required field is empty so the ticket doesn't match queue conditions
- Automation assigned the ticket before queue evaluation
- Issue security scheme hides the ticket from queue agents
- Workflow status doesn't match queue JQL status filter

## 2. Automation Troubleshooting

Use this checklist when an automation rule didn't fire, fired on the wrong tickets, or produced unexpected results.

```
Automation investigation:
- [ ] Verify trigger assumptions (event type, scope)
- [ ] Check conditions and branching logic
- [ ] Compare expected vs. actual field values
- [ ] Verify smart values and data availability
- [ ] Check rule scope and project scope
- [ ] Verify actor permissions
- [ ] Check timing, race conditions, or duplicate rules
- [ ] Review audit log evidence
```

**Verify trigger assumptions** — Confirm the rule's trigger matches the actual event. Common mismatch: rule triggers on "Issue created" but the expected event is "Issue transitioned" or "Field value changed." Check if the trigger has additional filters (e.g., specific issue types or JQL conditions on the trigger itself).

**Check conditions and branching logic** — Walk through each condition and branch in the rule. For each condition, verify the ticket's actual field values at the time the rule evaluated. Remember that conditions evaluate at execution time, not at the time the issue was last viewed.

**Compare expected vs. actual field values** — For each action in the rule, compare what the rule tried to set against what the ticket actually shows. If values differ, look for subsequent rules or manual edits that overwrote the value.

**Verify smart values and data availability** — Smart values (e.g., `{{issue.summary}}`, `{{triggerIssue.priority.name}}`) resolve to empty if the referenced field doesn't exist on the issue type's screen or isn't populated. Check that all smart values in the rule reference fields that exist and are populated at trigger time.

**Check rule scope and project scope** — Verify whether the rule is project-scoped or global. A project-scoped rule won't fire on issues in other projects. A global rule may fire on projects where it shouldn't. Check if the rule was recently moved between project and global scope.

**Verify actor permissions** — Automation rules execute as the rule actor (usually "Automation for Jira" app user or a configured service account). Verify this actor has the necessary permissions in the project's permission scheme and any issue security levels. In Data Center, check the user's application access as well.

**Check timing, race conditions, or duplicate rules** — If multiple automation rules share the same trigger, they may race. One rule's action may change a field that another rule's condition depends on. Check rule execution order and look for rules that fire on the same event in the same project.

**Review audit log evidence** — Check the automation audit log for the specific rule and ticket. The audit log shows whether the rule fired, which branch was taken, which conditions passed or failed, and what actions were executed. This is the most reliable source of truth.

Common causes:
- Trigger fires on wrong event (e.g., "Issue created" vs. "Issue transitioned")
- Condition checks a field that isn't populated at trigger time
- Smart value resolves to empty because the field doesn't exist on the screen or issue type
- Rule is scoped to wrong project or has global scope when it should be project-specific
- Service account or automation actor lacks permissions
- Two automation rules racing on the same trigger
- Audit log shows the rule fired but a condition branch excluded the issue

## 3. Permission Issues

Use this checklist when users cannot see, edit, transition, or comment on issues they expect to have access to.

```
Permission investigation:
- [ ] Identify who is affected (user, group, role)
- [ ] Identify what exact action is blocked
- [ ] Check project role and group membership
- [ ] Check permission scheme assignments
- [ ] Check issue security scheme or request visibility
- [ ] Check workflow property or transition restrictions
- [ ] Determine if problem is global, project-level, or issue-level
```

**Identify who is affected** — Get the specific username, group memberships, and project roles of the affected user. Determine if the problem affects one user, a group, or all users in a role.

**Identify what exact action is blocked** — Distinguish between "can't see the issue at all," "can see but can't edit," "can't transition," "can't comment," and "can't assign." Each maps to different permission entries.

**Check project role and group membership** — Verify the user is in the expected project role (e.g., Developers, Service Desk Team, Administrators). In JSM, verify whether the user is an agent or a customer — these have fundamentally different permission models.

**Check permission scheme assignments** — Find the permission scheme assigned to the project. Verify the specific permission entry for the blocked action. Permissions can be granted to project roles, groups, or individual users. Check for "Any logged in user" vs. specific grants.

**Check issue security scheme or request visibility** — If the user can't see the issue, check if an issue security level is set. The issue security scheme controls which users can view issues at each security level. In JSM, also check customer request visibility settings (organizations, request participants).

**Check workflow property or transition restrictions** — If the user can see the issue but can't transition it, check the workflow transition's conditions. Transitions can be restricted to specific groups, project roles, or users. Also check for validators that may reject the transition based on field values.

**Determine if problem is global, project-level, or issue-level** — Narrow the scope. If the user can't see any issues in the project, it's likely a project-level permission or role issue. If they can see some issues but not others, it's likely an issue security level. If they can see and edit but can't transition, it's likely a workflow restriction.

Common causes:
- User not in the correct project role
- Permission scheme grants access to a group the user isn't in
- Issue security level restricts visibility
- Workflow transition has a condition that checks group membership
- Customer vs. agent visibility in JSM

## 4. Workflow Issues

Use this checklist when issues are stuck in the wrong status, transitions are unavailable, or post-functions are producing unexpected results.

```
Workflow investigation:
- [ ] Map current status vs. expected status
- [ ] Check available transitions from current status
- [ ] Verify transition conditions (validators, permissions)
- [ ] Check post-functions on transitions
- [ ] Verify workflow scheme assignment to issue type
- [ ] Check if workflow was recently modified
```

**Map current status vs. expected status** — Confirm the issue's actual current status. Compare it to the status the user expects. Check the workflow diagram to verify the expected path exists between the two statuses.

**Check available transitions from current status** — List all transitions available from the current status. If the expected transition is missing, the workflow may not define a path, the transition may have conditions that hide it, or the issue type may be using a different workflow than assumed.

**Verify transition conditions** — Check conditions on the target transition. Conditions can restrict transitions to specific groups, project roles, or based on field values. Also check validators — these run after the user clicks the transition and can reject it with an error message.

**Check post-functions on transitions** — If the transition fires but produces wrong results, examine the post-functions. Post-functions execute in order after a successful transition. A post-function may fail silently if it tries to set a field that doesn't exist on the issue type's screen, or if it references a user or group that doesn't exist.

**Verify workflow scheme assignment to issue type** — Check which workflow scheme is assigned to the project and which workflow within that scheme handles the affected issue type. A common cause of confusion is that different issue types in the same project may use different workflows.

**Check if workflow was recently modified** — In Jira Cloud, workflow changes are applied immediately. In Data Center, workflow changes create a draft that must be published. If a workflow was recently edited but the draft wasn't published, the active workflow is still the old version.

Common causes:
- Issue type uses a different workflow than expected
- Transition has a validator that blocks the move
- Post-function fails silently (e.g., sets a field that doesn't exist)
- Workflow was edited but not published (drafts vs. active in Data Center)

## 5. SLA and Escalation Issues

Use this checklist when SLA clocks are incorrect, escalation rules didn't fire, or SLA breaches are reported unexpectedly.

```
SLA investigation:
- [ ] Verify SLA configuration (start, pause, stop conditions)
- [ ] Check if calendar/business hours are correct
- [ ] Verify the issue matches the SLA's goal conditions
- [ ] Check if status changes paused/resumed the SLA clock
- [ ] Verify escalation rules are triggering
```

**Verify SLA configuration** — Review the SLA's start, pause, and stop conditions. Confirm that the triggering event (e.g., issue created, specific transition) matches what actually happened. Check the SLA goal conditions to verify the affected issue type and priority are included.

**Check if calendar/business hours are correct** — SLAs use calendars to calculate time. Verify the correct calendar is assigned, the timezone is correct, and business hours/holidays are accurately configured. A misconfigured calendar is a common cause of incorrect SLA calculations.

**Verify the issue matches the SLA's goal conditions** — SLA goals can be scoped to specific request types, priorities, or JQL conditions. Confirm the issue matches all goal conditions. If the issue doesn't match, the SLA won't apply.

**Check if status changes paused/resumed the SLA clock** — SLA clocks pause and resume based on status category or specific statuses defined in the SLA configuration. Review the issue's status change history to verify pause/resume events align with the SLA definition. A transition to a status not recognized as a pause state will keep the clock running.

**Verify escalation rules are triggering** — If an escalation was expected but didn't happen, check the escalation rule's conditions, timing threshold, and actions. Verify the rule is active and scoped to the correct project and SLA. Check the automation audit log for evidence of the escalation firing or being suppressed.

## Response Format

For every troubleshooting response, follow this structure:

```
Troubleshooting Response:
1. What is likely happening
2. Most likely causes (ranked)
3. What to check first
4. JQL or investigation queries
5. Safe next steps
6. Risks or side effects
7. Stakeholder summary (if applicable)
```

## Connected Skills

- `tsh-writing-jql` — Construct investigation queries to isolate and verify issues.
- `tsh-administering-jira` — Translate findings into configuration changes, runbooks, or improvement plans.
