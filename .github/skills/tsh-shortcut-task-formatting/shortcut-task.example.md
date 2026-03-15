# Shortcut Task Benchmark Template

This document defines the expected structure and fields for Shortcut epics and stories created by the business analyst agent.

---

## Epic Template

### Fields

| Field | Required | Description |
|---|---|---|
| Name | Yes | Short, descriptive title. Format: `<Domain Area>: <Business Capability>` |
| Description | Yes | Structured description (standard markdown with ## headings) |
| Acceptance Criteria | Yes | Business-oriented verifiable conditions |
| Labels | No | Domain or feature area labels relevant to the project |
| Shortcut ID | No | Shortcut epic ID. Populated after creation or import. |
| Workflow State | No | Current Shortcut workflow state (e.g., Unstarted, In Progress, Done). Populated from Shortcut during import or after push. Used to enforce the Protected Status Policy — tasks with a protected workflow state are read-only. |

### Description Format

```
## Overview

<2-3 sentence description of what this epic delivers and why it matters>

## Business Value

<What business problem does this solve? What value does it create for users or the organisation?>

## Success Metrics

- <Measurable outcome 1>
- <Measurable outcome 2>
```

### Acceptance Criteria Format

```
- [ ] <Verifiable business condition 1>
- [ ] <Verifiable business condition 2>
- [ ] <Verifiable business condition 3>
```

---

## Story Template

### Fields

| Field | Required | Description |
|---|---|---|
| Name | Yes | Short, action-oriented title. Format: `<User/Actor> can <action>` |
| Story Type | Yes | `feature`, `bug`, or `chore` |
| Epic | Yes | Reference to parent Epic |
| Description | Yes | Structured description (standard markdown) |
| Acceptance Criteria | Yes | Checklist of verifiable conditions |
| Estimate | No | Team estimates during refinement. Agent provides sizing guidance: Small (1), Medium (2-3), Large (5+) |
| Labels | No | Inherited from epic + story-specific labels |
| Shortcut ID | No | Shortcut story ID. Populated after creation or import. |
| Workflow State | No | Current Shortcut workflow state (e.g., Unstarted, In Progress, Done). Populated from Shortcut during import or after push. Used to enforce the Protected Status Policy — tasks with a protected workflow state are read-only. |

### Description Format

```
## Context

This story is part of the [<Epic Name>] epic. <1 sentence connecting this story to the epic's goal.>

## User Story

As a <role>, I want <capability> so that <benefit>.

## Requirements

1. <Specific requirement 1>
2. <Specific requirement 2>
3. <Specific requirement 3>

## Technical Notes

<High-level technical considerations discussed during the workshop. Write "No specific technical considerations discussed." if none were mentioned.>
```

### Acceptance Criteria Format

```
- [ ] <Verifiable condition 1>
- [ ] <Verifiable condition 2>
- [ ] <Verifiable condition 3>
```

---

## Formatting Guidelines

### General Rules

- **Business language only**: Descriptions should be understandable by any stakeholder without technical knowledge
- **No implementation details**: Do not specify technologies, frameworks, or code patterns in stories — that is the architect's responsibility
- **Consistent tone**: Use active voice and present tense ("User can create…" not "User should be able to create…")
- **Verifiable acceptance criteria**: Every criterion must be testable with a clear pass/fail condition

### Priority via Labels

Shortcut does not have a separate Priority field in the same way as other project management tools. Instead, priority is conveyed through labels and story ordering within the backlog. If the team wants explicit priority tracking, use labels with a `priority:` prefix:

| Workshop Priority | Shortcut Label | When to Use |
|---|---|---|
| Critical | `priority:critical` | Blocks all other work; must be done first |
| High | `priority:high` | Core functionality; needed for MVP |
| Medium | `priority:medium` | Important but not blocking; can follow MVP |
| Low | `priority:low` | Nice-to-have; can be deferred |

### Labels

Labels are project-specific. Suggest labels based on the epic's domain area, but do not hardcode values. Common patterns:
- Feature area: `auth`, `payments`, `dashboard`, `reporting`
- Type: `infrastructure`, `integration`, `ui`, `backend`
- Source: `workshop-<date>` to track which workshop produced the task
- Priority: `priority:critical`, `priority:high`, `priority:medium`, `priority:low`

### Handling Optional Fields

- If a field cannot be filled from the available materials, mark it as `TBD - to be discussed during refinement`
- Do not invent information to fill optional fields
- Flag all `TBD` fields for user review

### Shortcut ID Field

The `Shortcut ID` field is empty (`—`) when the task has not yet been pushed to Shortcut. It is populated automatically after story creation or when importing existing Shortcut stories. When a Shortcut ID is present, the push flow will **update** the existing story instead of creating a new one.

- Do not manually fill this field — it is managed by the agent
- After a successful push, the agent writes the Shortcut ID back into `formatted-tasks.md`
- After a successful import, the agent populates the Shortcut ID from the fetched stories

### Workflow State Field

The `Workflow State` field reflects the current Shortcut workflow state of the task (e.g., `Unstarted`, `Started`, `In Progress`, `Done`, `Completed`). It is empty (`—`) for tasks that have not been pushed to or imported from Shortcut.

- Do not manually fill this field — it is managed by the agent
- After a successful import, the agent populates the Workflow State from the fetched Shortcut story
- After a successful push (create or update), the agent records the current workflow state returned by Shortcut
- Tasks whose workflow state is **Done** or **Completed** are considered **protected** by default and are treated as read-only. The agent will not modify their content locally or push updates to Shortcut for them. The full list of protected states should be confirmed with the user for their specific Shortcut workflow configuration — refer to the agent's Protected Status Policy for full details.

---

## Example: Fully Populated Epic with Stories

> **Note:** Description content is wrapped in code blocks in this document for structural clarity. When pushing to Shortcut, the content inside the code blocks is used as the description.

### Epic: User Authentication: Secure Login and Account Access

**Shortcut ID**: —
**Workflow State**: —

**Description**:
```
## Overview

Enable users to securely log in, manage their accounts, and recover access if credentials are lost. This is the foundational epic that gates access to all application features.

## Business Value

Without authentication, the application cannot distinguish between users, enforce permissions, or protect user data. This epic enables personalised experiences and regulatory compliance (GDPR, SOC2).

## Success Metrics

- Users can register, log in, and access their personalised dashboard
- Password recovery flow resolves 95% of access issues without support intervention
- All authentication flows complete in under 3 seconds
```

**Acceptance Criteria**:

- [ ] Users can create an account with email and password
- [ ] Users can log in with valid credentials
- [ ] Users receive an error message for invalid credentials
- [ ] Users can reset their password via email
- [ ] Session timeout redirects users to the login page

**Labels**: `auth`, `priority:critical`, `workshop-2026-02-19`

---

### Story 1.1: User can register a new account

**Epic**: User Authentication: Secure Login and Account Access
**Story Type**: feature
**Shortcut ID**: 12345
**Workflow State**: In Progress
**Sizing Guidance**: Medium (2-3)

**Description**:
```
## Context

This story is part of the [User Authentication: Secure Login and Account Access] epic. It enables new users to create an account and gain access to the application.

## User Story

As a new user, I want to register an account with my email and password so that I can access the application's features.

## Requirements

1. Registration form collects email address and password
2. Email address must be unique across all accounts
3. Password must meet minimum security requirements (discussed: at least 8 characters)
4. User receives a confirmation email after registration
5. User is redirected to the dashboard after successful registration

## Technical Notes

Discussed during workshop: SSO integration may be added later as a separate story. For now, email/password registration only.
```

**Acceptance Criteria**:

- [ ] Registration form is accessible from the landing page
- [ ] Duplicate email addresses are rejected with a clear error message
- [ ] Passwords shorter than 8 characters are rejected with guidance
- [ ] Confirmation email is sent within 1 minute of registration
- [ ] Successful registration redirects to user dashboard

**Labels**: `auth`, `priority:critical`, `workshop-2026-02-19`

---

### Story 1.2: User can log in with existing credentials

**Epic**: User Authentication: Secure Login and Account Access
**Story Type**: feature
**Shortcut ID**: —
**Workflow State**: —
**Sizing Guidance**: Small (1)

**Description**:
```
## Context

This story is part of the [User Authentication: Secure Login and Account Access] epic. It allows returning users to access their account.

## User Story

As a returning user, I want to log in with my email and password so that I can access my account and data.

## Requirements

1. Login form collects email and password
2. Valid credentials grant access to the user dashboard
3. Invalid credentials display a clear error message without revealing which field is wrong
4. Session is created with appropriate timeout

## Technical Notes

No specific technical considerations discussed.
```

**Acceptance Criteria**:

- [ ] Login form is accessible from the landing page
- [ ] Valid credentials redirect to the user dashboard
- [ ] Invalid credentials show a generic error message
- [ ] Three consecutive failed attempts trigger a temporary lockout

**Labels**: `auth`, `priority:critical`, `workshop-2026-02-19`

---

### Story 1.3: User can reset forgotten password

**Epic**: User Authentication: Secure Login and Account Access
**Story Type**: feature
**Shortcut ID**: 12347
**Workflow State**: Unstarted
**Sizing Guidance**: Medium (2-3)

**Description**:
```
## Context

This story is part of the [User Authentication: Secure Login and Account Access] epic. It provides a self-service recovery path for users who forget their password.

## User Story

As a user who forgot my password, I want to reset it via email so that I can regain access to my account without contacting support.

## Requirements

1. "Forgot password" link is visible on the login page
2. User enters their email to request a password reset
3. Reset link is sent to the registered email
4. Reset link expires after a defined period
5. User can set a new password via the reset link

## Technical Notes

Discussed during workshop: Reset link should expire after 24 hours. Team to confirm exact duration during refinement.
```

**Acceptance Criteria**:

- [ ] "Forgot password" link is visible and accessible on the login page
- [ ] Password reset email is sent within 1 minute of request
- [ ] Reset link expires after the configured period
- [ ] Expired links show a clear message and option to request a new one
- [ ] New password must meet the same requirements as registration

**Labels**: `auth`, `priority:high`, `workshop-2026-02-19`
