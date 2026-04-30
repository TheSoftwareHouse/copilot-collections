---
sidebar_position: 14
title: /tsh-report-bug
---

# /tsh-report-bug

**Agent:** QA Engineer  
**File:** `.github/prompts/tsh-report-bug.prompt.md`

Creates a professional, structured bug report with severity classification and Jira-ready formatting.

## Usage

```text
/tsh-report-bug <bug description or observed behavior>
```

## What It Does

1. **Gathers bug details** — Extracts information from the provided description. If a Jira ticket ID is mentioned, fetches related context.
2. **Structures the report** — Uses the standard bug report template with title, severity, environment, preconditions, steps to reproduce, actual vs expected behavior, and additional notes.
3. **Classifies severity** — Applies the severity matrix (Critical / High / Medium / Low) with justification.
4. **Reviews completeness** — Ensures the report contains enough detail for a developer to reproduce the issue.
5. **Offers Jira integration** — If a Jira ticket is in context, offers to create the bug as a linked issue.

## Skills Loaded

- `tsh-functional-testing` — Provides the severity matrix for bug classification.

## Output

Formatted bug report following the standard template, ready for Jira or team communication.

## Severity Matrix

| Severity | Definition | Blocks Release? |
|---|---|---|
| 🔴 **Critical** | Feature broken/unusable, data loss, security vulnerability | Yes |
| 🟠 **High** | Major functionality impaired, no workaround | Should block |
| 🟡 **Medium** | Functionality impaired, workaround exists | Fix before next release |
| 🔵 **Low** | Cosmetic or minor UX inconsistency | Fix when convenient |
