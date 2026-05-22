---
name: tsh-writing-jql
description: "JQL writing, explanation, simplification, optimization, and debugging for Jira Cloud, Data Center, and JSM queues. Covers query construction, clause explanation, variants, edge cases, and usage context guidance (queue, filter, dashboard, ad hoc). Use when writing, reviewing, optimizing, or explaining JQL queries."
---

# JQL Writing and Optimization

This skill provides patterns for writing, explaining, optimizing, and debugging JQL (Jira Query Language) queries across Jira Cloud, Jira Data Center, and Jira Service Management contexts.

## Guiding Principles

| Principle | Rationale |
|---|---|
| **Start specific, broaden later** | Overly broad queries cause performance issues and noisy results. Start with the tightest filter that matches the need. |
| **Explain every clause** | Users often inherit JQL they don't understand. Always provide plain-English explanation alongside the query. |
| **Provide variants** | Different contexts (queue, filter, dashboard) may need different query shapes. Always offer at least one variant. |
| **Document edge cases** | JQL behavior differs between Cloud and Data Center, and between standard and JSM fields. Flag these. |
| **Prefer functions over hardcoded values** | Use functions like `currentUser()`, `startOfDay()`, `endOfWeek()` instead of hardcoded dates or usernames. |
| **Test before deploying to queues** | Queue JQL affects agent workflow. Always recommend testing in ad hoc search first. |

---

## 1. Query Construction Patterns

### Standard JQL Structure

Every JQL query follows the pattern:

```
field operator value [AND|OR field operator value ...] [ORDER BY field ASC|DESC]
```

**Key structural rules:**
- Use `AND` / `OR` to combine clauses
- Use `NOT` to negate a clause
- Use parentheses `()` to control evaluation order — `AND` binds tighter than `OR` without parentheses
- `ORDER BY` is always the last clause and accepts `ASC` (default) or `DESC`

**Example — combining clauses with grouping:**

```jql
project = "SUPPORT" AND (status = "Open" OR status = "In Progress") AND assignee = currentUser() ORDER BY created DESC
```

**Plain-English:** Find all issues in the SUPPORT project that are either Open or In Progress, assigned to me, newest first.

### Operators Reference

| Operator | Meaning | Field Types | Example |
|---|---|---|---|
| `=` | Equals | All | `status = "Done"` |
| `!=` | Not equals | All | `assignee != currentUser()` |
| `IN` | Matches any value in list | All | `status IN ("Open", "In Progress")` |
| `NOT IN` | Matches none of the values in list | All | `priority NOT IN ("Trivial", "Minor")` |
| `~` | Contains text (fuzzy match) | Text fields | `summary ~ "login error"` |
| `!~` | Does not contain text | Text fields | `description !~ "duplicate"` |
| `IS` | Checks for EMPTY | All | `assignee IS EMPTY` |
| `IS NOT` | Checks for non-EMPTY | All | `fixVersion IS NOT EMPTY` |
| `>` | Greater than | Date, number, priority | `created > "2025-01-01"` |
| `<` | Less than | Date, number, priority | `due < now()` |
| `>=` | Greater than or equal | Date, number, priority | `priority >= "High"` |
| `<=` | Less than or equal | Date, number, priority | `created <= endOfDay()` |
| `WAS` | Field had this value at any point | Status, assignee, priority, etc. | `status WAS "In Progress"` |
| `WAS IN` | Field had any of these values | Status, assignee, priority, etc. | `status WAS IN ("Open", "Reopened")` |
| `WAS NOT` | Field never had this value | Status, assignee, priority, etc. | `status WAS NOT "Done"` |
| `CHANGED` | Field changed (optionally with FROM/TO/DURING/AFTER/BEFORE) | Status, assignee, priority, etc. | `status CHANGED FROM "Open" TO "In Progress" DURING ("2025-01-01", "2025-03-31")` |

### Common JQL Functions

| Function | Returns | Example Usage |
|---|---|---|
| `currentUser()` | Logged-in user | `assignee = currentUser()` |
| `membersOf("group")` | Members of a Jira group | `assignee IN membersOf("developers")` |
| `startOfDay()` | Start of today (midnight) | `created >= startOfDay()` |
| `endOfDay()` | End of today (23:59:59) | `due <= endOfDay()` |
| `startOfWeek()` | Start of current week | `created >= startOfWeek()` |
| `endOfWeek()` | End of current week | `due <= endOfWeek()` |
| `startOfMonth()` | Start of current month | `created >= startOfMonth()` |
| `endOfMonth()` | End of current month | `due <= endOfMonth()` |
| `now()` | Current date/time | `due < now()` |
| `updatedBy("user")` | Issues updated by a specific user | `issue IN updatedBy("jsmith")` |
| `linkedIssuesOf("query")` | Issues linked to results of a sub-query | `issue IN linkedIssuesOf("project = CORE AND type = Bug")` |
| `issueHistory()` | Issues the current user has recently viewed | `issue IN issueHistory()` |

**Note:** Date functions accept offset arguments: `startOfDay(-7d)` returns midnight 7 days ago. Units: `d` (days), `w` (weeks), `m` (months), `y` (years). Offsets use the format `(±Nunit)`, e.g. `startOfMonth(-1m)`.

---

## 2. Common Query Patterns

### Unassigned tickets in a project

```jql
project = "SUPPORT" AND assignee IS EMPTY AND status != "Done" ORDER BY created DESC
```

All open unassigned issues in SUPPORT, newest first.

### Tickets created in the last N days

```jql
project = "CORE" AND created >= startOfDay(-7d) ORDER BY created DESC
```

Issues created in the last 7 days. **Variant for hours:** `created >= "-4h"` (relative time strings work for short durations).

### Tickets in specific statuses

```jql
project = "PLATFORM" AND status IN ("To Do", "In Progress", "In Review") ORDER BY priority DESC, created ASC
```

All active-workflow issues sorted by priority then creation date.

### Tickets by request type (JSM)

```jql
"Customer Request Type" = "Hardware Request" AND statusCategory != "Done" ORDER BY created ASC
```

Open hardware requests in a JSM project. **Note:** The field name `"Customer Request Type"` must be quoted and is case-sensitive.

### Tickets with specific labels or components

```jql
project = "WEB" AND labels IN ("security", "urgent") AND component = "Auth Service" ORDER BY priority DESC
```

Issues tagged with security or urgent labels in the Auth Service component.

### Tickets updated by a specific user

```jql
project = "API" AND issue IN updatedBy("jsmith") AND updated >= startOfWeek() ORDER BY updated DESC
```

Issues that jsmith has modified this week.

### Tickets linked to another issue

```jql
issue IN linkedIssuesOf("key = CORE-1234")
```

All issues linked to CORE-1234. **Variant with link type:** `issue IN linkedIssuesOf("key = CORE-1234", "is blocked by")`.

### Overdue tickets (due date)

```jql
due < now() AND statusCategory != "Done" ORDER BY due ASC
```

All incomplete issues past their due date, most overdue first.

**Variant — overdue SLA (JSM):**

```jql
"Time to resolution" = breached() AND statusCategory != "Done" ORDER BY created ASC
```

### Tickets that changed status in a date range

```jql
project = "OPS" AND status CHANGED FROM "In Progress" TO "Done" DURING ("2025-01-01", "2025-03-31") ORDER BY updated DESC
```

Issues completed in Q1 2025. **Edge case:** The `CHANGED` operator is not available on all custom fields — it works on status, assignee, priority, and resolution by default.

### Tickets visible in a specific queue (JSM)

Queue JQL queries typically combine project, request type, and status filters:

```jql
project = "ITSM" AND statusCategory != "Done" AND "Customer Request Type" IN ("VPN Access", "Software Install") ORDER BY created ASC
```

**Note:** Queue JQL in JSM does not support all operators. The `WAS` and `CHANGED` operators are not allowed in queue definitions.

---

## 3. JSM-Specific JQL

### JSM Fields Reference

| Field | Description | Example |
|---|---|---|
| `"Customer Request Type"` | The request type selected by the customer on the portal | `"Customer Request Type" = "New Employee Onboarding"` |
| `"Request channel origin"` | How the request was created (portal, email, api, jira) | `"Request channel origin" = "email"` |
| `"Satisfaction"` | Customer satisfaction rating | `"Satisfaction" = "1 star"` or `"Satisfaction" IS NOT EMPTY` |
| `"Time to resolution"` | SLA for total resolution time | `"Time to resolution" = breached()` |
| `"Time to first response"` | SLA for initial response time | `"Time to first response" = running()` |
| `"Organizations"` | Customer organization associated with the request | `"Organizations" = "Acme Corp"` |
| `"Request participants"` | Additional users watching the request | `"Request participants" = "jdoe"` |

### SLA Functions

SLA fields in JSM support special functions:

| Function | Meaning | Example |
|---|---|---|
| `breached()` | SLA has been breached | `"Time to first response" = breached()` |
| `running()` | SLA clock is currently active | `"Time to resolution" = running()` |
| `paused()` | SLA clock is paused (e.g., waiting on customer) | `"Time to resolution" = paused()` |
| `completed()` | SLA has been completed (met or breached) | `"Time to resolution" = completed()` |
| `withinCalendarHours()` | Current time is within SLA calendar hours | `"Time to resolution" = withinCalendarHours()` |
| `elapsed()` | Compare elapsed SLA time | `"Time to first response" > elapsed("2h")` |
| `remaining()` | Compare remaining SLA time | `"Time to resolution" < remaining("1h")` |

### Queue JQL Patterns

Queue JQL defines which issues appear in a JSM agent queue. Queue JQL has restrictions compared to regular search JQL:

**Supported in queues:**
- Standard field comparisons (`project`, `status`, `assignee`, `priority`, etc.)
- JSM fields (`"Customer Request Type"`, `"Request channel origin"`, etc.)
- SLA functions (`breached()`, `running()`, etc.)
- `AND`, `OR`, `NOT`, parentheses
- `IN`, `NOT IN`, `IS`, `IS NOT`

**NOT supported in queues:**
- `WAS`, `WAS IN`, `WAS NOT`, `CHANGED` (history-based operators)
- `ORDER BY` (queue ordering is configured separately in queue settings)
- `linkedIssuesOf()`, `issueHistory()`, `updatedBy()` functions

**Escalation queue example:**

```jql
project = "SD" AND "Time to resolution" = breached() AND statusCategory != "Done"
```

Shows all issues with breached resolution SLA that are still open.

### Approvals JQL

```jql
project = "ITSM" AND "Pending approval status" = "pending" ORDER BY created ASC
```

Issues waiting for approval. **Note:** `"Pending approval status"` values are `pending`, `approved`, and `declined`. This field is only available in JSM projects with approval steps configured.

---

## 4. Optimization Patterns

### Index-Friendly vs. Index-Unfriendly Queries

| Pattern | Performance | Recommendation |
|---|---|---|
| `project = "X"` | Fast — indexed field | Always include a `project` clause when possible |
| `status = "Open"` | Fast — indexed field | Use specific status values, not `statusCategory` when filtering large instances |
| `assignee = currentUser()` | Fast — indexed field | Prefer over `assignee = "username"` for portability |
| `summary ~ "search text"` | Moderate — text index | Use specific phrases; avoid single-character or very common words |
| `description ~ "text"` | Slow — full-text search on large field | Combine with `project` and `type` filters to reduce scan scope |
| `comment ~ "text"` | Slow — scans all comments | Avoid on large instances; filter by project and date range first |
| `labels = "x"` | Fast — indexed | Prefer `labels` over text search for categorization |
| Custom text field `~ "text"` | Slow — depends on indexing | Check if the custom field is indexed; if not, combine with indexed filters |

### Optimization Decision Matrix

| Situation | Optimization |
|---|---|
| Query returns too many results | Add `project`, `issuetype`, or `statusCategory` filters to narrow scope |
| Query is slow on text search (`~`) | Narrow with indexed fields (`project`, `type`, `status`) before the text clause |
| Dashboard gadget loads slowly | Simplify JQL; remove `ORDER BY` on custom fields; reduce result set with tighter filters |
| Queue JQL is slow | Remove text search operators; use indexed fields; avoid complex `OR` groupings |
| Filter used by automation rules | Keep JQL simple — automation evaluates the filter on every trigger; expensive JQL causes delays |
| Large instance (100k+ issues) | Always include `project` filter; avoid `~` on description/comments without additional indexed filters; use `updated >= startOfDay(-30d)` to limit temporal scope |

### When to Split Queries

Split a complex query into multiple simpler queries when:
- The query combines unrelated conditions with `OR` at the top level
- Dashboard gadgets need different sort orders for the same base query
- Performance degrades due to complex nested `OR` + `AND` groupings
- You need to use operators not supported in queues (move the complex logic to a saved filter and reference it separately)

---

## 5. Cloud vs. Data Center Differences

| Aspect | Jira Cloud | Jira Data Center |
|---|---|---|
| **Text search operator `~`** | Uses Atlassian's cloud search engine; supports basic phrase matching | Uses Lucene-based search; supports Lucene syntax (`*`, `?`, `AND`, `OR`, `~` for fuzzy) |
| **`issueHistory()` function** | Available | Not available on all DC versions; check version compatibility |
| **`updatedBy()` function** | Available (Cloud-only in some versions) | Available on DC 8.x+ |
| **Custom field syntax** | Field name in quotes: `"My Custom Field" = "value"` | Field name in quotes or `cf[10001]` syntax: `cf[10001] = "value"` |
| **Board/Sprint JQL** | `sprint = "Sprint 1"` or `sprint IN openSprints()` | Same syntax; `openSprints()`, `closedSprints()`, `futureSprints()` available on both |
| **`openSprints()` behavior** | Returns sprints marked as active | Same behavior, but performance may differ on large boards |
| **Performance characteristics** | Managed by Atlassian; limited tuning options | Configurable Lucene index, JVM tuning, database query optimization |
| **SLA fields (JSM)** | Always available in JSM projects | Available in JSM Data Center; function syntax is identical |
| **Field ID lookup** | Use Jira admin → Issues → Custom fields to find field names | Use `cf[NNNNN]` syntax from admin or REST API (`/rest/api/2/field`) |
| **`properties[]` searching** | Supported via `issue.property[key].path = value` | Not available |
| **`approvals` JQL** | `"Pending approval status"` field available | Same field available in JSM DC |
| **JQL autocomplete** | Built into the search bar | Available but may be slower on large instances |

**Rule:** When writing JQL intended for both Cloud and Data Center, avoid Cloud-only features (`properties[]`, etc.) and use field names in quotes rather than `cf[]` syntax for portability. When writing for a known platform, use platform-specific optimizations.

---

## 6. Response Format

For every JQL response, follow this structure:

```
JQL Response Checklist:
- [ ] Query provided as a fenced code block
- [ ] Plain-English explanation of each clause
- [ ] At least one variant provided (different context, simplified, or alternative approach)
- [ ] Edge cases documented (empty fields, permission issues, field availability)
- [ ] Usage context specified (queue / filter / dashboard / ad hoc)
- [ ] Cloud vs. DC differences noted if relevant
```

**Example output structure:**

**Query:**

```jql
project = "SUPPORT" AND status = "Waiting for Customer" AND updated < startOfDay(-5d) ORDER BY updated ASC
```

**Explanation:** Find all issues in the SUPPORT project that are in "Waiting for Customer" status and haven't been updated in the last 5 days, oldest first. This helps identify stale tickets that may need follow-up or auto-closure.

**Variant (for a JSM queue — no ORDER BY):**

```jql
project = "SUPPORT" AND status = "Waiting for Customer" AND updated < startOfDay(-5d)
```

**Edge cases:**
- The status name must match exactly including case; check the project's workflow for the exact status name
- `updated` reflects any change (comment, field edit, transition) — not just customer responses

**Usage context:** Filter (for a dashboard gadget or scheduled notification). Remove `ORDER BY` for queue usage.

## Connected Skills

- `tsh-troubleshooting-jira` — Use JQL queries as investigation tools during Jira troubleshooting workflows.
- `tsh-administering-jira` — JQL is central to queue definitions, dashboard filters, and configuration audits.
