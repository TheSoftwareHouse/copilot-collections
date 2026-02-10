---
name: architecture-design
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

**Step 2: Analyse the current codebase**
Perform a current codebase analysis to get a full picture of a current system in a context of the task.
Make sure to understand the project and domain best practices.

**Step 3: Ask questions about ambiguous parts**
After getting a full picture of the codebase and the task, ask any remaining questions.
Don't continue until you get all of the answers.

**Step 4: Design a solution**
Based on your findings design a solution architecture.

Follow the best security and software design patterns. 

Your goal is to design a solution that is not overengineered and easy to comprehend by developers, that is at the same time scalable, secure and easy to maintain.

The example patterns you should check (but you are not limited to only use those):
- Dont repeat yourself
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

Make sure to use `implementation-gap-analysis` skill to verify what was already implemented from your plan and what should be added. Make sure to include the result in final plan.

Make sure to divide the plan into a small phases. Each phase should be runnable on it's own and immediately have all quality gates ready. Each phase should have a list of tasks with special place to mark the finished tasks later on.

The plan has to include code review phase at the end fully done by `tsh-code-reviewer` agent.

Don't provide deployment plans, code pushing instructions, code review instructions on repository.

**Step 5: Create a implementation plan document**

Save the plan as a document following the `./plan.example.md` template.

Don't add or remove any sections from the template. Follow the structure and naming conventions strictly to ensure clarity and consistency.

## Connected Skills

- `codebase-analysis` - for analyzing the existing architecture, components, and patterns
- `implementation-gap-analysis` - for verifying what was already implemented and what should be added
- `technical-context-discovery` - for establishing project conventions and existing patterns before designing
- `sql-and-database` - for designing database schemas, data models, normalisation strategies, and indexing as part of the solution architecture