# <Workshop Topic> — Quality Review Report

## Review Context

| Field | Value |
|---|---|
| Review Date | <date> |
| Source Task List | `extracted-tasks.md` (Gate 1 approved) |
| Additional Sources | <cleaned-transcript.md, Figma designs, Jira board PROJ, etc. — or "None"> |
| Epics Reviewed | <number> |
| Stories Reviewed | <number> |
| Total Suggestions | <number> |
| Accepted | <number> |
| Rejected | <number> |

---

## Domain Model

### Actors

| Actor | Epics Involved | Key Capabilities |
|---|---|---|
| <role-name> | <epic numbers, e.g. 1, 2, 4> | <what this actor can do> |
| <role-name> | <epic numbers> | <capabilities> |

### Entities

| Entity | Created In | Read In | Updated In | Deactivated/Deleted In |
|---|---|---|---|---|
| <entity-name> | <story ref or "—"> | <story ref or "—"> | <story ref or "—"> | <story ref or "—"> |

### Key Relationships

- <Entity A> belongs to <Entity B> — managed in <story ref>
- <Entity C> depends on <Entity D> being in <state> — validated in <story ref or "not covered">

---

## Suggestions

### Epic 1: <Epic Title>

#### S-01 · High · ADD_ACCEPTANCE_CRITERION

**Target**: Story 1.3 — <Story Title>

**Finding** (Pass <X>: <Category Name>):
<1–2 sentence explanation of the gap and why it matters.>

**Proposed Change**:
Add to Story 1.3 acceptance criteria:
- [ ] <new verifiable condition>

**Decision**: ✅ Accepted

---

#### S-02 · Medium · NEW_STORY

**Target**: Epic 1 (new story)

**Finding** (Pass <X>: <Category Name>):
<1–2 sentence explanation of the gap.>

**Proposed Change**:
Add new story under Epic 1:

### Story 1.N: <Story Title>

**User Story**: As a <role>, I want <capability> so that <benefit>.

**Acceptance Criteria**:
- [ ] <verifiable condition>
- [ ] <verifiable condition>

**High-Level Technical Notes**: None

**Priority**: <priority>

**Decision**: ❌ Rejected — <user's stated reason, if any>

---

### Epic 2: <Epic Title>

#### S-03 · High · MODIFY_STORY

**Target**: Story 2.1 — <Story Title>

**Finding** (Pass <X>: <Category Name>):
<explanation>

**Proposed Change**:
Update Story 2.1 description to include: <proposed text change>

**Decision**: ✅ Accepted

---

### New Epics

#### S-04 · Medium · NEW_EPIC

**Finding** (Pass G: Platform Operations Perspective):
<explanation of why a new epic is warranted>

**Proposed Change**:
Add new epic:

## Epic N: <Epic Title>

**Business Description**: <description>

**Success Criteria**:
- <criterion>

### Story N.1: <Story Title>

**User Story**: As a <role>, I want <capability> so that <benefit>.

**Acceptance Criteria**:
- [ ] <verifiable condition>

**High-Level Technical Notes**: None

**Priority**: <priority>

**Decision**: ✅ Accepted

---

#### S-05 · High · NEW_STORY

**Target**: Epic 2 (new story)

**Finding** (Pass K: Decision Alignment):
DEC-001 (Payment provider: Stripe) has no affected stories. No story covers payment integration.

**Proposed Change**:
Add new story under Epic 2:

### Story 2.4: As a customer, I can pay using Stripe

**User Story**: As a customer, I want to pay using Stripe so that I can complete my purchase securely.

**Acceptance Criteria**:
- [ ] Customer can complete payment via Stripe checkout
- [ ] Payment confirmation is displayed after successful transaction

**Source Decisions**: DEC-001

**High-Level Technical Notes**: None

**Priority**: High

**Decision**: ✅ Accepted

---

#### S-06 · High · MODIFY_STORY

**Target**: Story 1.2 — <Story Title>

**Finding** (Pass K: Decision Alignment):
Story 1.2 (Login) describes password-based authentication, but DEC-002 specifies magic links.

**Proposed Change**:
Update Story 1.2 acceptance criteria to use magic links per DEC-002:
- [ ] User receives a magic link via email after entering their address
- [ ] User is authenticated upon clicking the magic link
- Remove: ~~User can log in with email and password~~

**Decision**: ✅ Accepted

---

#### S-07 · Medium · UPDATE_DECISION_LOG

**Target**: decision-log.md — DEC-003

**Finding** (Pass K: Decision Alignment):
DEC-003 is marked ⚠️ Unresolved — Stories 3.1 and 3.2 depend on notification channel decision.

**Proposed Change**:
Escalate DEC-003 to user for resolution before finalizing Stories 3.1 and 3.2. Update `decision-log.md` to add Stories 3.1 and 3.2 as affected stories and flag the dependency blocker.

**Decision**: ✅ Accepted

---

## Applied Changes Summary

| # | Suggestion | Action | Target |
|---|---|---|---|
| S-01 | <brief summary> | ADD_ACCEPTANCE_CRITERION | Story 1.3 |
| S-03 | <brief summary> | MODIFY_STORY | Story 2.1 |
| S-04 | <brief summary> | NEW_EPIC | Epic N (new) |
| S-05 | Payment integration story for DEC-001 (Stripe) | NEW_STORY | Story 2.4 (new) |
| S-06 | Update login to magic links per DEC-002 | MODIFY_STORY | Story 1.2 |
| S-07 | Resolve DEC-003 and link affected stories 3.1, 3.2 | UPDATE_DECISION_LOG | decision-log.md — DEC-003 |

**Updated Totals**: <X> epics (+<N> new), <Y> stories (+<M> new, <K> modified)

## Rejected Suggestions

| # | Suggestion | Confidence | Reason |
|---|---|---|---|
| S-02 | <brief summary> | Medium | <user's stated reason> |
