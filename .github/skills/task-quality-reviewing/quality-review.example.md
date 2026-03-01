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

## Applied Changes Summary

| # | Suggestion | Action | Target |
|---|---|---|---|
| S-01 | <brief summary> | ADD_ACCEPTANCE_CRITERION | Story 1.3 |
| S-03 | <brief summary> | MODIFY_STORY | Story 2.1 |
| S-04 | <brief summary> | NEW_EPIC | Epic N (new) |

**Updated Totals**: <X> epics (+<N> new), <Y> stories (+<M> new, <K> modified)

## Rejected Suggestions

| # | Suggestion | Confidence | Reason |
|---|---|---|---|
| S-02 | <brief summary> | Medium | <user's stated reason> |
