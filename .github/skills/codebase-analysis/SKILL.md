---
name: codebase-analysis
description: Analyse the codebase of the system. Look for dependencies. Understand how the business logic is implemented. Look for duplications.
---

# Codebase Analysis

This helps you analyze the codebase in a structured way, getting the most out of it. It focuses on architecture, patterns, code style, module separation, testing approach, dependencies, and infrastructure.

## Codebase Analysis Process

Use the checklist below and track your progress:

```
Analysis progress:
- [ ] Step 1: Check repository structure
- [ ] Step 2: Check dependencies
- [ ] Step 3: Check available scripts
- [ ] Step 4: Check high level architecture
- [ ] Step 5: Check backend code
- [ ] Step 6: Check frotnend code
- [ ] Step 7: Check infrastructure code
- [ ] Step 8: Check third party integrations
- [ ] Step 9: Check testing approach
- [ ] Step 10: Check the security approach
- [ ] Step 11: Look for potential improvements
- [ ] Step 12: Check for deadcode and duplications
```

**Step 1: Check repository structure**

Go through the whole repository to identify and understand the structure of the repository. 
Find out what type of repository we work with. Is it monorepo or single system repository.
Find out what type of the system in contains - frontend apps, backend apps, shared packages, infrastructure etc.
Find out where dependencies and scripts files are stored.
Find out where tests are stored (e2e, unit, integration).
Find out where are the most crucial directories for each system.

**Step 2: Check dependencies**

Analyse all dependencies.
Make sure to fully understand what frameworks, libraries, authentication systems etc are used.
Make sure to note which dependencies are out of date and could be an issue later on.

**Step 3: Check available scripts**

Check all available scripts.
Find out what app running scripts we have.
Find out what quality assurance scripts we have (tests, linting, formatting etc.)
Understand the remaining scripts.

**Step 4: Check high level architecture**

Understand how the app architecture looks like based on the services, integrations and libraries.
Create a diagram of the architecture you can figure out based on the code itself.
Make sure to understand the internal and external communication patterns and practices used.

**Step 5: Check backend code**

Check what backend technology we use.
Check what framework we use.
Check how the code architecture looks like - MVC, CQRS, DDD, Hexagonal Architecture, Layered architecture etc.
Check if the code is divided based on a module (all module related code is in a single parent directory and has its own controllers, entities etc) or based on responsibilities (or controllers in a single directory etc.)
Understand the database schema and the pattern used (is it ORM, direct SQL etc.).
Make sure to understand what library we use for database communication.
Understand how the backend is deployed.
Understand how the authentication and authorisation works.

**Step 6: Check frotnend code**

Check what framework we use.
Understand what communication pattern (REST, Websocket, Graphql etc) we use.
Understand what UI libraries we use.
Understand what additional libraries we use for authentication, queries and other common areas.
Understand the code architecture. Do we follow matomic design or other approach.
Understand how the app is deployed.

**Step 7: Check infrastructure code**

Check how we manage infrastructure (IaC or manual). What technology we use for infrastructure?
How the app is deployed? Cloud, on-premise etc.
Understand if app is containerised.
Make sure to understand how scalable the infrastructure is.

**Step 8: Check third party integrations**

Check what third parties we use.
List all of the 3rd party libraries and their purpose in a system.
Understand how tightly they intergrate into the system and how hard it will be to exchange them in the future.

**Step 9: Check testing approach**

Check what type of tests we have (e2e, unit, integration, contract etc.)
Understand the testing strategy. Do we test everything, only controller, only endpoints, only backend, only frontend etc.
Understand the current test coverage

**Step 10: Check the security approach**

Check what security approach the repository has.
Understand how authentication and authorisation is implemented.
What type of security 3rd parties and libraries we use.
Check how secure the database and endpoints are.
Find out which endpoints are publicly accessible.
Rate the general security approach.

**Step 11: Look for potential improvements**

Based on all finding propose a potential improvements.
Divide them into Critical, To be implemented nut not critical, Nice to have

Save the results into a separate structure document.
Each step should be covered in separate section.

**Step 12: Check for deadcode and duplications**

Analyse imports and dependencies to find out if there are any dead code or duplications in the codebase.
Look for unused imports, functions, components, files etc.
Look for duplicated code, functions, components etc. that can be extracted to a common place and reused.
Look for components that are very similar and can be merged into one with some configuration.
Look for code that is only used in their own test files and can be moved there or removed if not used at all outside of tests.

## Large codebase

The process might take a while and because of that create a document containing a section for each step.

During the processing make sure to update the document over the time.