# <task-name> - Implementation Plan

## Task Details

| Field            | Value                   |
| ---------------- | ----------------------- |
| Jira ID          | <jira-id>               |
| Title            | <task-title>            |
| Description      | <task-description>      |
| Priority         | <priority>              |
| Related Research | <link-to-research-file> |

## Wildly Important Goal

<one-sentence-statement-of-the-single-most-important-outcome-this-plan-must-achieve>

## Proposed Solution

<description-of-proposed-solution-explaining-the-approach-and-the-why-for-reviewers-and-implementors>

<necessary-diagrams>

> Note: The plan must not contain real implementation code or full implementation bodies/function logic. Pseudo-code is allowed only to explain genuinely complicated algorithms or ideas, and task-boundary seam artifacts such as type definitions, function signatures, DTOs, interfaces, and API shapes are allowed when they clarify the contract without supplying implementation bodies. Diagrams, explanations, and the Technical Context chapter content are allowed and encouraged.

## Current Implementation Analysis

### Already Implemented

List of existing components, functions, utilities that will be reused (with file paths):

- <component/function> - `<file-path>` - <brief description>

### To Be Modified

List of existing code that needs changes or extensions (with file paths and description of changes):

- <component/function> - `<file-path>` - <what needs to change>

### To Be Created

List of new components, functions, utilities that need to be built from scratch:

- <component/function> - <brief description of what it does>

## Open Questions

| #   | Question   | Answer   | Status                |
| --- | ---------- | -------- | --------------------- |
| 1   | <question> | <answer> | ✅ Resolved / ❓ Open |

## Technical Context

Project conventions, coding standards, and patterns discovered during planning. Downstream agents MUST read this section instead of re-discovering the same context.

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

## Implementation Plan

### Phase 1: <phase-name>

**Goal**: <how-this-phase-advances-the-wildly-important-goal>

**Description**: <broader-explanation-of-what-should-be-done-and-why>

#### Task 1.1 - [CREATE/MODIFY/REUSE] <task-name>

**Description**: <brief description of what the task entails>

**Files:** `src/<feature>.ts` (create), `src/<feature>.types.ts` (reuse)

**Definition of Done**:

- [ ] <specific verifiable criterion in the listed files>
- [ ] Run `tsc --noEmit`

**Stop Rule:** <optional one-sentence condition telling the implementor to stop, report, and not improvise if the task cannot proceed safely or an expected seam is missing>

**Clues**: <optional-hints-for-the-implementor-file-paths-reference-patterns-gotchas>

#### Task 1.2 - [CREATE/MODIFY/REUSE] <task-name>

**Description**: <brief description>

**Files:** `src/<feature>.ts` (modify — created in Task 1.1), `src/<feature>.test.ts` (reuse)

**Definition of Done**:

- [ ] <specific verifiable criterion in the listed files>
- [ ] Run `npm run test:unit -- <spec>`

**Stop Rule:** <optional one-sentence condition telling the implementor to stop, report, and not improvise if the task cannot proceed safely or an expected seam is missing>

**Clues**: <optional-hints-for-the-implementor-file-paths-reference-patterns-gotchas>

### Phase 2: <ui-phase-name>

**Goal**: <how-this-phase-advances-the-wildly-important-goal>

**Description**: <broader-explanation-of-what-should-be-done-and-why>

#### Task 2.1 - [CREATE/MODIFY] <ui-component-name>

**Description**: <implementation of the UI component based on Figma design>

**Files:** `src/components/<ui-component-name>.tsx` (modify), `src/components/<ui-component-name>.types.ts` (reuse)

**Figma URL**: <figma-url-for-this-component>

**Definition of Done**:

- [ ] <specific verifiable criterion in the listed files>
- [ ] Run `npm run test:unit -- <ui-spec>`

**Stop Rule:** <optional one-sentence condition telling the implementor to stop, report, and not improvise if the task cannot proceed safely or an expected seam is missing>

**Clues**: <optional-hints-for-the-implementor-file-paths-reference-patterns-gotchas>

#### Task 2.2 - [REUSE] UI Verification of <ui-component-name> by `tsh-ui-reviewer` agent

**Description**: Run `tsh-ui-reviewer` agent via `tsh-review-ui.prompt.md` to verify <ui-component-name> against Figma design. Pass the Figma URL and dev server URL. If verification fails, delegate fix to `tsh-software-engineer` and re-verify (max 5 iterations per component).

**Files:** `src/components/<ui-component-name>.tsx` (reuse), `src/components/<ui-component-name>.test.tsx` (reuse)

**Figma URL**: <figma-url-for-this-component>

**Definition of Done**:

- [ ] Run `npm run test:e2e -- <ui-spec>`
- [ ] UI verification passes or escalated to user after 5 iterations
- [ ] Verification report documented in Changelog

**Stop Rule:** <optional one-sentence condition telling the implementor to stop, report, and not improvise if the task cannot proceed safely or an expected seam is missing>

**Clues**: <optional-hints-for-the-implementor-file-paths-reference-patterns-gotchas>

### Phase 3: <phase-name>

**Goal**: <how-this-phase-advances-the-wildly-important-goal>

**Description**: <broader-explanation-of-what-should-be-done-and-why>

#### Task 3.1 - [CREATE/MODIFY/REUSE] <task-name>

**Description**: <brief description>

**Files:** `src/<feature>.ts` (modify — created in Task 1.1), `src/<feature>.spec.ts` (reuse)

**Definition of Done**:

- [ ] <specific verifiable criterion in the listed files>
- [ ] Run `npm run lint`

**Stop Rule:** <optional one-sentence condition telling the implementor to stop, report, and not improvise if the task cannot proceed safely or an expected seam is missing>

**Clues**: <optional-hints-for-the-implementor-file-paths-reference-patterns-gotchas>

### Phase 4: Code Review

**Goal**: <how-verified-quality-of-the-delivered-changes-secures-the-wildly-important-goal>

**Description**: Final verification of the full implementation. This phase is mandatory and always comes last.

#### Task 4.1 - [REUSE] Code review by `tsh-code-reviewer` agent

**Description**: Run `tsh-code-reviewer` agent via `tsh-review.prompt.md` to review the complete implementation. Pass e2e test execution to that agent as part of the prompt — do not run e2e tests outside this review.

**Files:** `src/<feature>.ts` (reuse), `src/<feature>.spec.ts` (reuse)

**Definition of Done**:

- [ ] Run `npm run lint`
- [ ] Code review passes with no blocking findings
- [ ] E2e tests executed by the reviewer pass
- [ ] Review outcome documented in Changelog

**Stop Rule:** <optional one-sentence condition telling the implementor to stop, report, and not improvise if the task cannot proceed safely or an expected seam is missing>

**Clues**: <optional-pointers-to-review-scope-or-risk-areas>

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
