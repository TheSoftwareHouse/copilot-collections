# <task-name> - Implementation Plan

## Task Details

| Field            | Value                   |
| ---------------- | ----------------------- |
| Jira ID          | <jira-id>               |
| Title            | <task-title>            |
| Description      | <task-description>      |
| Priority         | <priority>              |
| Related Research | <link-to-research-file> |

## Proposed Solution

<description-of-proposed-solution>

<necessary-diagrams>

## Current Implementation Analysis

### Already Implemented

List of existing components, functions, utilities, or documented behaviors that will be reused.

| Artifact / Behavior | Status | Evidence | Current Value |
| --- | --- | --- | --- |
| <component/function> | `verified` | `<file-path>` | <brief description of what can be reused> |

### Requires Modification

List of existing code or documentation that needs changes or extensions.

| Artifact | Status | Current Gap | Why It Must Change |
| --- | --- | --- | --- |
| `<file-path>` | `verified` | <what is incomplete or outdated> | <why this change is required> |

### New / Expanded Behavior Needed

List any new behaviors, artifacts, or implementation capabilities that do not exist yet.

| Needed Behavior | Status | Reason |
| --- | --- | --- |
| <new component / workflow / capability> | `missing` / `inferred from research` | <why it must be introduced> |

## Open Questions

| #   | Question   | Answer   | Status                |
| --- | ---------- | -------- | --------------------- |
| 1   | <question> | <answer> | ✅ Resolved / ❓ Open |

## Glossary / Ubiquitous Language

Use this always-present section to define domain terms, role names, acronyms, and plan-specific language that a downstream implementor must understand without reopening the research file.

| Term | Plain-language definition | File Reference / Relevance |
| --- | --- | --- |
| <term> | <what it means in this task and why it matters> | `<file-path>` / <where it appears or why it matters> |

## Technical Context

Project conventions, coding standards, and patterns discovered during planning. Downstream agents MUST read this section instead of re-discovering the same context. Embed the key rules inline here; file references are secondary support, not the primary source of truth.

### Project Instructions

- <summary of relevant `.instructions.md` rules — file path + key rules>

### Architecture & Patterns

- <framework, layering, module organization, folder structure conventions>
- <naming conventions, file naming patterns>

### Tech Stack

- <language, framework, key libraries with versions>
- <package manager, build tool, test runner>

### Code Style & Standards

- <formatting, linting rules, import conventions>
- <error handling patterns, validation approach>

### Testing Patterns

- <test framework, test file naming, mocking strategy>
- <test commands: unit, integration, e2e, lint, build>

### Database Patterns

- <ORM, migration tool, entity conventions (if applicable)>

### Additional Context

- <any other project-specific conventions relevant to implementation>

## Traps and Warnings

Use this always-present section to capture non-obvious failure modes, misleading paths, legacy constraints, and explicit "do not do this" guidance that would otherwise be rediscovered during implementation.

| Trap / Warning | Why it is dangerous | Required guardrail |
| --- | --- | --- |
| <trap or warning> | <how it can cause rework, bugs, or bad assumptions> | <how the implementor must avoid it> |

## Implementation Plan

Plans are non-executable guidance artifacts only. They must not contain real / production code. Allowed formats are prose, tables, diagrams, contracts, and clearly labeled non-executable pseudocode.

### Phase 1: <phase-name>

| Preamble | Details |
| --- | --- |
| Purpose | <why this phase exists and what decision or implementation boundary it covers> |
| State Before | <what is true before this phase starts> |
| State After | <what will be true when this phase is complete> |
| Dependencies / Risks | <what this phase depends on and what can go wrong if sequencing is wrong> |

#### Task 1.1 - [CREATE/MODIFY/REUSE] <task-name>

**Context**: <what the implementor needs to understand before starting this task>

**Approach**: <how to execute the task, including boundaries, sequencing, or constraints>

**References**: <relevant files, docs, diagrams, contracts, or labeled pseudocode to consult>

**Traps**: <task-specific pitfalls, misleading options, or things to avoid>

**Definition of Done**:

- [ ] <specific verifiable criterion>
- [ ] <specific verifiable criterion>

#### Task 1.2 - [CREATE/MODIFY/REUSE] <task-name>

**Context**: <what the implementor needs to understand before starting this task>

**Approach**: <how to execute the task>

**References**: <relevant files, docs, diagrams, contracts, or labeled pseudocode>

**Traps**: <task-specific pitfalls or things to avoid>

**Definition of Done**:

- [ ] <specific verifiable criterion>

### Phase 2: <ui-phase-name>

| Preamble | Details |
| --- | --- |
| Purpose | <why this phase exists and what visible outcome it delivers> |
| State Before | <what is true before this phase starts> |
| State After | <what will be true when this phase is complete> |
| Dependencies / Risks | <what this phase depends on and what could invalidate verification> |

#### Task 2.1 - [CREATE/MODIFY] <ui-component-name>

**Context**: <implementation of the UI component based on Figma design and relevant product constraints>

**Approach**: <how the component should be built, integrated, and prepared for verification>

**References**: <figma-url-for-this-component>, <relevant files>, <contracts or labeled pseudocode>

**Traps**: <layout, accessibility, state, or orchestration pitfalls to avoid>

**Figma URL**: <figma-url-for-this-component>

**Definition of Done**:

- [ ] <specific verifiable criterion>
- [ ] <specific verifiable criterion>

#### Task 2.2 - [REUSE] UI Verification of <ui-component-name> by `tsh-ui-reviewer` agent

**Context**: Verification is required for every visible UI output so the plan is complete only when design parity is proven or explicitly escalated.

**Approach**: Run `tsh-ui-reviewer` agent via `tsh-review-ui.prompt.md` to verify <ui-component-name> against Figma design. Pass the Figma URL and dev server URL. If verification fails, delegate fix to `tsh-software-engineer` and re-verify (max 5 iterations per component).

**References**: `tsh-review-ui.prompt.md`, verification report, <figma-url-for-this-component>

**Traps**: Do not treat source inspection as sufficient verification. Escalate after 5 failed iterations instead of silently accepting drift.

**Figma URL**: <figma-url-for-this-component>

**Definition of Done**:

- [ ] UI verification passes or escalated to user after 5 iterations
- [ ] Verification report documented in Changelog

### Phase 3: <phase-name>

| Preamble | Details |
| --- | --- |
| Purpose | <why this phase exists> |
| State Before | <what is true before this phase starts> |
| State After | <what will be true when this phase is complete> |
| Dependencies / Risks | <what this phase depends on and what could block it> |

#### Task 3.1 - [CREATE/MODIFY/REUSE] <task-name>

**Context**: <what the implementor needs to know before starting this task>

**Approach**: <how to execute the task>

**References**: <relevant files, docs, diagrams, contracts, or labeled pseudocode>

**Traps**: <task-specific pitfalls or things to avoid>

**Definition of Done**:

- [ ] <specific verifiable criterion>

## Security Considerations

- <security consideration relevant to this task>

## Quality Assurance

Acceptance criteria checklist to verify the implementation meets the defined requirements:

- [ ] <acceptance criterion 1>
- [ ] <acceptance criterion 2>
- [ ] <acceptance criterion 3>

## Improvements (Out of Scope)

Potential improvements identified during planning that are not part of the current task:

- <improvement description>

## Changelog

| Date   | Change Description   |
| ------ | -------------------- |
| <date> | Initial plan created |
