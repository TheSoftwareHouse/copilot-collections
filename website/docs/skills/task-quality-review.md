---
sidebar_position: 14
title: Task Quality Review
---

# Task Quality Review

**Folder:** `.github/skills/tsh-task-quality-reviewing/`  
**Used by:** Business Analyst

Performs a systematic quality analysis on an approved task list (epics and user stories) to identify gaps, missing edge cases, and improvement opportunities. Runs 10 domain-agnostic analysis passes and produces structured suggestions the user can individually accept or reject.

## What It Produces

- **Suggestions** — Structured improvement proposals, each individually accept/reject.
- **Domain model** — An intermediate actor–entity–lifecycle map derived from the task list.
- **Quality review report** — Audit trail of all suggestions and decisions (`quality-review.md`).
- **Updated task list** — Accepted suggestions applied to `extracted-tasks.md` in-place.

## Analysis Passes

The quality review runs 10 independent analysis passes:

| Pass | Category | What It Checks | Confidence |
|---|---|---|---|
| A | Entity Lifecycle Completeness | CRUD operations for every business entity | High |
| B | Cross-Feature State Validation | State checking when features consume shared entities | High |
| C | Bulk Operation Idempotency | Pre-existing data and partial failure handling | High |
| D | Actor Dashboard Completeness | Metrics, configuration, and history for management UIs | Medium |
| E | Precondition Guards | Feature unlock dependencies and prerequisite enforcement | High |
| F | Third-Party Boundary Clarity | External integration points and failure modes | Medium |
| G | Platform Operations Perspective | Admin/operator tooling and monitoring | Medium |
| H | Error State & Edge Case Coverage | Failure, empty, and boundary conditions | High |
| I | Notification & Communication Gaps | Missing notifications for cross-actor state changes | High |
| J | Domain-Specific Research | Industry patterns and compliance requirements | Low–Medium |

## Suggestion Types

Each finding is classified into one of these action types:

| Action Type | Description |
|---|---|
| `ADD_ACCEPTANCE_CRITERION` | Add a missing condition to an existing story |
| `MODIFY_STORY` | Expand an existing story's scope |
| `ADD_TECHNICAL_NOTE` | Add clarity or documentation to a story |
| `NEW_STORY` | Create a new story for uncovered functionality |
| `NEW_EPIC` | Create a new epic for a major capability gap |

## Process

### Step 1: Load Inputs

Collect the Gate 1-approved `extracted-tasks.md`, cleaned transcript, and any other source materials.

### Step 2: Gather Jira Context (Optional)

If Atlassian tools are available, optionally fetch existing board context to cross-reference against.

### Step 3: Build Domain Model

Construct a lightweight domain model from the task list: actors, entities (with lifecycle mapping), and relationships.

### Step 4: Run Analysis Passes

Execute all 10 passes against the domain model and task list. Each pass produces zero or more findings.

### Step 5: Classify Suggestions

Transform findings into structured suggestions with confidence levels, action types, and proposed changes.

### Step 6: User Review (Gate 1.5)

Present suggestions one at a time for individual accept/reject decisions. Each suggestion is self-contained with full context.

### Step 7: Apply Accepted Changes

Apply accepted suggestions to `extracted-tasks.md` and save the quality review report to `quality-review.md`.

## Connected Skills

- `tsh-task-extracting` — Provides the extracted tasks used as primary input.
- `tsh-task-formatting` — Consumes the updated task list after quality review.
