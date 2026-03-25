---
name: tsh-architecture-designing
description: Design the architecture to solve a given task. Propose the solutions to be used to deliver the task following the best practices and standards.
---

# Architecture Design

This skill helps you design the architecture that follows best practices and solves the actual business goal.

## Architecture Design Process

Use the checklist below and track your progress:

```
Analysis progress:
- [ ] Step 1: Understand the goal of the task
- [ ] Step 2: Analyse the current codebase
- [ ] Step 3: Ask questions about ambiguous parts
- [ ] Step 4: Design a solution
- [ ] Step 5: Create an implementation plan document
```

**Step 1: Understand the goal of the task**
Thoroughly process the conversation history and task `*.research.md` file to fully understand the business goal of the task.

If the task or research file references PDF documents (technical specifications, API documentation, architecture documents, compliance requirements), use the `pdf-reader` tool to extract and review their content.

**Step 2: Analyse the current codebase**
Perform a current codebase analysis to get a full picture of a current system in a context of the task.
Make sure to understand the project and domain best practices.

**Step 3: Ask questions about ambiguous parts**
After getting a full picture of the codebase and the task, ask any remaining questions.
Don't continue until you get all of the answers.

**Step 4: Design a solution**
Based on your findings design a solution architecture.

Follow the best security and software design patterns.

Your goal is to design a solution that is not over-engineered and easy to comprehend by developers, that is at the same time scalable, secure and easy to maintain.

The example patterns you should check (but you are not limited to only use those):

- Don't repeat yourself
- Keep It Simple Stupid
- Domain Driven Design
- Test Driven Design
- Modular Architecture / Hexagonal Architecture / Layered Architecture
- Queue / Messaging systems
- Single Responsibility
- CQRS

Make sure to follow the best UI/UX patterns:

- Atomic Design
- Accessibility patterns (WCAG)

Make sure to follow security best practices like OWASP TOP10

The design has to meet quality assurance criteria, meaning it has to be fully tested using combination of e2e, unit and integration tests.

Don't duplicate any work.

Make sure to use `tsh-implementation-gap-analysing` skill to verify what was already implemented from your plan and what should be added. Make sure to include the result in final plan.

Make sure to divide the plan into a small phases.Each phase should have a list of tasks with special place to mark the finished tasks later on. After phase is finished only the fast running tests and quality checks should be run to verify that the implementation is on the right track - unit tests, integration tests, static code analysis, linters, formatting check and project build.

The plan has to include code review phase at the end, fully done by `tsh-code-reviewer` agent using [`tsh-review.prompt.md`](../../prompts/tsh-review.prompt.md). Make sure to pass e2e execution to that agent as a part of the prompt and do not run those tests by yourself.

For features with UI components based on Figma designs, each UI implementation task should be followed by a `[REUSE]` UI verification task delegated to `tsh-ui-reviewer` agent using [`tsh-review-ui.prompt.md`](../../prompts/tsh-review-ui.prompt.md). Include the Figma URL in every verification task. Do not run UI verification from the software engineer level — let the engineering manager orchestrate the verify-fix loop.

For features involving LLM application prompts (system prompts, RAG templates, tool-calling instructions, classification/extraction prompts), add a `[REUSE]` prompt engineering task delegated to `tsh-prompt-engineer` agent using [`tsh-engineer-prompt.prompt.md`](../../prompts/tsh-engineer-prompt.prompt.md). Separate prompt design from application code — the software engineer implements the integration code, the prompt engineer designs the prompt content. Include the use case, target model, and any existing prompt drafts in the task description.

Don't provide deployment plans, code pushing instructions, code review instructions on repository.

**Step 5: Create a implementation plan document**

Save the plan as a document following the `./plan.example.md` template.

Don't add or remove any sections from the template. Follow the structure and naming conventions strictly to ensure clarity and consistency.

## Connected Skills

- `tsh-codebase-analysing` - for analyzing the existing architecture, components, and patterns
- `tsh-implementation-gap-analysing` - for verifying what was already implemented and what should be added
- `tsh-technical-context-discovering` - for establishing project conventions and existing patterns before designing
- `tsh-sql-and-database-understanding` - for designing database schemas, data models, normalisation strategies, and indexing as part of the solution architecture
