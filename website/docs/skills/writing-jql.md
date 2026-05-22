---
sidebar_position: 33
title: JQL Writing
---

# JQL Writing

**Folder:** `.github/skills/tsh-writing-jql/`  
**Used by:** Jira Admin

Domain-knowledge reference skill for writing, explaining, simplifying, optimizing, and debugging JQL (Jira Query Language) across Jira Cloud, Jira Data Center, and Jira Service Management.

## Topics Covered

### 1. Query Construction Patterns

- Field + Operator + Value query structure.
- AND/OR/NOT logic and parenthetical grouping.
- ORDER BY clauses.
- Reference tables for all JQL operators and built-in functions.

### 2. Common Query Patterns

Ready-to-use JQL templates for frequent needs:

| Pattern | Example |
|---|---|
| Unassigned tickets | `project = X AND assignee is EMPTY` |
| Recent tickets | `created >= -48h AND status != Done` |
| By request type (JSM) | `"Customer Request Type" = "Access Request"` |
| Status changes in range | `status CHANGED TO "In Progress" DURING (startOfWeek(), now())` |
| Overdue tickets | `due < now() AND status != Done` |
| Linked issues | `issue in linkedIssuesOf("PROJ-123")` |

### 3. JSM-Specific JQL

- Customer Request Type, Request channel, Satisfaction fields.
- SLA fields: Time to resolution, Time to first response.
- Organizations and Request participants.
- Queue JQL patterns vs. regular filter JQL.
- Approval-related queries.

### 4. Optimization Patterns

- Index-friendly vs. index-unfriendly queries.
- When to use `=` vs. `~` (text search).
- Performance considerations for large instances (100k+ issues).
- Splitting complex queries for better performance.

### 5. Cloud vs. Data Center Differences

| Aspect | Cloud | Data Center |
|---|---|---|
| Custom field syntax | Field name in quotes | `cf[10001]` syntax also common |
| Available functions | Newer built-in functions | Some functions unavailable |
| Text search behavior | Atlas-based search | Lucene-based search |
| Performance | Managed infrastructure | Instance-dependent |

### 6. Response Format

Every JQL response includes: the query, a plain-English clause explanation, at least one variant, edge cases, and where to use it (queue, filter, dashboard, or ad hoc search).

## Connected Skills

- [Troubleshooting Jira](./troubleshooting-jira) — JQL queries used as investigation tools during troubleshooting.
- [Administering Jira](./administering-jira) — JQL is central to queue definitions, dashboard filters, and audits.
