# Jira Task Benchmark Template

This document defines the expected structure and fields for Jira epics and stories created by the workshop analyst agent.

---

## Epic Template

### Fields

| Field | Required | Description |
|---|---|---|
| Summary | Yes | Short, descriptive title. Format: `<Domain Area>: <Business Capability>` |
| Issue Type | Yes | `Epic` |
| Description | Yes | Structured description (see format below) |
| Acceptance Criteria | Yes | Business-oriented verifiable conditions |
| Priority | Yes | Highest / High / Medium / Low |
| Labels | No | Domain or feature area labels relevant to the project |

### Description Format

```
h2. Overview

<2-3 sentence description of what this epic delivers and why it matters>

h2. Business Value

<What business problem does this solve? What value does it create for users or the organisation?>

h2. Success Metrics

* <Measurable outcome 1>
* <Measurable outcome 2>
```

### Acceptance Criteria Format

```
(/) <Verifiable business condition 1>
(/) <Verifiable business condition 2>
(/) <Verifiable business condition 3>
```

---

## Story Template

### Fields

| Field | Required | Description |
|---|---|---|
| Summary | Yes | Short, action-oriented title. Format: `<User/Actor> can <action>` |
| Issue Type | Yes | `Story` |
| Parent | Yes | Reference to parent Epic |
| Description | Yes | Structured description (see format below) |
| Acceptance Criteria | Yes | Checklist of verifiable conditions |
| Priority | Yes | Highest / High / Medium / Low |
| Labels | No | Inherited from epic + story-specific labels |
| Story Points | No | Team estimates during refinement. Agent provides sizing guidance: Small (1-3), Medium (5-8), Large (13+) |

### Description Format

```
h2. Context

This story is part of the [<Epic Title>] epic. <1 sentence connecting this story to the epic's goal.>

h2. User Story

As a <role>, I want <capability> so that <benefit>.

h2. Requirements

# <Specific requirement 1>
# <Specific requirement 2>
# <Specific requirement 3>

h2. Technical Notes

<High-level technical considerations discussed during the workshop. Write "No specific technical considerations discussed." if none were mentioned.>
```

### Acceptance Criteria Format

```
(/) <Verifiable condition 1>
(/) <Verifiable condition 2>
(/) <Verifiable condition 3>
```

---

## Formatting Guidelines

### General Rules

- **Business language only**: Descriptions should be understandable by any stakeholder without technical knowledge
- **No implementation details**: Do not specify technologies, frameworks, or code patterns in stories — that is the architect's responsibility
- **Consistent tone**: Use active voice and present tense ("User can create…" not "User should be able to create…")
- **Verifiable acceptance criteria**: Every criterion must be testable with a clear pass/fail condition

### Priority Mapping

| Workshop Priority | Jira Priority | When to Use |
|---|---|---|
| Critical | Highest | Blocks all other work; must be done first |
| High | High | Core functionality; needed for MVP |
| Medium | Medium | Important but not blocking; can follow MVP |
| Low | Low | Nice-to-have; can be deferred |

### Labels

Labels are project-specific. Suggest labels based on the epic's domain area, but do not hardcode values. Common patterns:
- Feature area: `auth`, `payments`, `dashboard`, `reporting`
- Type: `infrastructure`, `integration`, `ui`, `backend`
- Source: `workshop-<date>` to track which workshop produced the task

### Handling Optional Fields

- If a field cannot be filled from the available materials, mark it as `TBD - to be discussed during refinement`
- Do not invent information to fill optional fields
- Flag all `TBD` fields for user review

---

## Example: Fully Populated Epic with Stories

### Epic: User Authentication: Secure Login and Account Access

**Priority**: Highest

**Description**:
```
h2. Overview

Enable users to securely log in, manage their accounts, and recover access if credentials are lost. This is the foundational epic that gates access to all application features.

h2. Business Value

Without authentication, the application cannot distinguish between users, enforce permissions, or protect user data. This epic enables personalised experiences and regulatory compliance (GDPR, SOC2).

h2. Success Metrics

* Users can register, log in, and access their personalised dashboard
* Password recovery flow resolves 95% of access issues without support intervention
* All authentication flows complete in under 3 seconds
```

**Acceptance Criteria**:
```
(/) Users can create an account with email and password
(/) Users can log in with valid credentials
(/) Users receive an error message for invalid credentials
(/) Users can reset their password via email
(/) Session timeout redirects users to the login page
```

**Labels**: `auth`, `workshop-2026-02-19`

---

### Story 1.1: User can register a new account

**Parent**: User Authentication: Secure Login and Account Access
**Priority**: Highest
**Sizing Guidance**: Medium (5-8)

**Description**:
```
h2. Context

This story is part of the [User Authentication: Secure Login and Account Access] epic. It enables new users to create an account and gain access to the application.

h2. User Story

As a new user, I want to register an account with my email and password so that I can access the application's features.

h2. Requirements

# Registration form collects email address and password
# Email address must be unique across all accounts
# Password must meet minimum security requirements (discussed: at least 8 characters)
# User receives a confirmation email after registration
# User is redirected to the dashboard after successful registration

h2. Technical Notes

Discussed during workshop: SSO integration may be added later as a separate story. For now, email/password registration only.
```

**Acceptance Criteria**:
```
(/) Registration form is accessible from the landing page
(/) Duplicate email addresses are rejected with a clear error message
(/) Passwords shorter than 8 characters are rejected with guidance
(/) Confirmation email is sent within 1 minute of registration
(/) Successful registration redirects to user dashboard
```

**Labels**: `auth`, `workshop-2026-02-19`

---

### Story 1.2: User can log in with existing credentials

**Parent**: User Authentication: Secure Login and Account Access
**Priority**: Highest
**Sizing Guidance**: Small (1-3)

**Description**:
```
h2. Context

This story is part of the [User Authentication: Secure Login and Account Access] epic. It allows returning users to access their account.

h2. User Story

As a returning user, I want to log in with my email and password so that I can access my account and data.

h2. Requirements

# Login form collects email and password
# Valid credentials grant access to the user dashboard
# Invalid credentials display a clear error message without revealing which field is wrong
# Session is created with appropriate timeout

h2. Technical Notes

No specific technical considerations discussed.
```

**Acceptance Criteria**:
```
(/) Login form is accessible from the landing page
(/) Valid credentials redirect to the user dashboard
(/) Invalid credentials show a generic error message
(/) Three consecutive failed attempts trigger a temporary lockout
```

**Labels**: `auth`, `workshop-2026-02-19`

---

### Story 1.3: User can reset forgotten password

**Parent**: User Authentication: Secure Login and Account Access
**Priority**: High
**Sizing Guidance**: Medium (5-8)

**Description**:
```
h2. Context

This story is part of the [User Authentication: Secure Login and Account Access] epic. It provides a self-service recovery path for users who forget their password.

h2. User Story

As a user who forgot my password, I want to reset it via email so that I can regain access to my account without contacting support.

h2. Requirements

# "Forgot password" link is visible on the login page
# User enters their email to request a password reset
# Reset link is sent to the registered email
# Reset link expires after a defined period
# User can set a new password via the reset link

h2. Technical Notes

Discussed during workshop: Reset link should expire after 24 hours. Team to confirm exact duration during refinement.
```

**Acceptance Criteria**:
```
(/) "Forgot password" link is visible and accessible on the login page
(/) Password reset email is sent within 1 minute of request
(/) Reset link expires after the configured period
(/) Expired links show a clear message and option to request a new one
(/) New password must meet the same requirements as registration
```

**Labels**: `auth`, `workshop-2026-02-19`
