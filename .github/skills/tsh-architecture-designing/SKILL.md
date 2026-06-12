---
name: tsh-architecture-designing
description: "Design the architecture to solve a given task: analyse the codebase, resolve ambiguities, and propose a solution following best practices and standards. Produces the solution design that tsh-creating-implementation-plans turns into an implementation plan."
user-invocable: false
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

**Step 5: Hand off to plan creation**

Turn the designed solution into an implementation plan document using the `tsh-creating-implementation-plans` skill. That skill owns the plan template (`plan.example.md`), the plan structure, and the definition-of-done rules — you MUST load and follow it when authoring the plan.

## Connected Skills

- `tsh-codebase-analysing` - for analyzing the existing architecture, components, and patterns
- `tsh-implementation-gap-analysing` - for verifying what was already implemented and what should be added
- `tsh-technical-context-discovering` - for establishing project conventions and existing patterns before designing
- `tsh-creating-implementation-plans` - for turning the designed solution into a phased implementation plan document
- `tsh-sql-and-database-understanding` - for designing database schemas, data models, normalisation strategies, and indexing as part of the solution architecture
