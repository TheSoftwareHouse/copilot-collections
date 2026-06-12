---
sidebar_position: 3
title: Creating Implementation Plans
---

# Creating Implementation Plans

**Folder:** `.github/skills/tsh-creating-implementation-plans/`  
**Used by:** Architect via [`tsh-plan.prompt.md`](../prompts/internal/plan.md); consulted by Architect Reviewer via [`tsh-review-plan.prompt.md`](../prompts/internal/review-plan.md)

Turns a designed solution into a phased, verifiable implementation plan.

## Process

### Step 1: Confirm Inputs

Start from a designed solution, usually produced by `tsh-architecture-designing`, plus task research and any supporting context. Do not redesign the solution here.

### Step 2: Define the Wildly Important Goal

State one explicit Wildly Important Goal for the whole plan and add a short description of the overall approach.

### Step 3: Break the Work into Phases

Divide the work into small phases. Each phase needs a Goal, a Description, and tasks with checkboxes. Keep the plan testable with fast-running checks such as unit tests, integration tests, static analysis, linters, formatting, and builds.

### Step 4: Define Each Task

Give every task a Description, a Definition of Done checklist, and optional Clues such as file paths, line ranges, reference patterns, or gotchas.

### Step 5: Add Mandatory Cross-Cutting Tasks

Include the required shared tasks for code review, UI verification, and prompt engineering when those domains apply.

### Step 6: Save the Plan Using the Template

Write the plan as a document that follows `plan.example.md` exactly. Do not add or remove sections from the template.

## Key Rules

| Area | Rule |
| --- | --- |
| Goal hierarchy | Every plan has one explicit Wildly Important Goal. Every phase has a Goal that advances it, plus a Description. Every task has a Description, a Definition of Done checklist, and optional Clues. |
| Definition of Done | DoD items must not include deployment steps, manual QA, or anything a code reviewer cannot verify during review. |
| No real code | Do not include production implementation code. Use pseudo-code only when a complicated algorithm truly needs it; diagrams and explanatory context are encouraged. |
| Mandatory cross-cutting tasks | End with a code review phase handled by `tsh-code-reviewer`. Add `[REUSE]` UI verification tasks for Figma-based UI via `tsh-ui-reviewer`, and `[REUSE]` prompt engineering tasks for LLM prompts via `tsh-prompt-engineer`. Do not add deployment plans. |

## Connected Skills

- `tsh-architecture-designing` — designs the solution this skill turns into a plan
- `tsh-implementation-gap-analysing` — verifies what was already implemented before planning new work
- `tsh-technical-context-discovering` — populates the plan's Technical Context section
