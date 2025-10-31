---
mode: "architect"
model: "Claude Sonnet 4.5"
description: "Prepare detailed implementation plan for given feature."
---

Analyze feature context file for provided task or Jira ID. Based on it prepare detailed implementation plan that software engineer can follow step by step to deliver the feature.

The file outcome should be a markdown file named after the task jira id in kebab-case format or after task name (if no jira task provided) with .plan.md suffix (e.g., user-authentication.plan.md). The file should be organized in a structured format, including sections for phases and tasks. The file should be placed in the specifications directory under a folder named after the research file of that task in kebab-case format.

Make sure to follow the steps below:

1. Analyze the feature context file thoroughly to understand the requirements and scope of the feature.
2. **Verify Current Implementation**: Before planning, perform a thorough analysis of the existing codebase:
   - Use semantic search to find components, functions, hooks, utilities, or files related to the feature requirements
   - Identify what is already implemented and functional
   - Identify what exists but needs modification or extension
   - Identify what needs to be created from scratch
   - Document your findings in the "Current Implementation Analysis" section of the plan
3. Understand the project best practices and quality standards to ensure the implementation plan aligns with them.
4. Prepare implementation plan with detailed code changes required to be implemented, broken down into phases.
5. For each phase, identify the specific tasks that need to be completed, providing a clear title, description, action type ([CREATE], [MODIFY], or [REUSE]), and definition of done for each task.
6. Consider any security aspects that need to be addressed during implementation and include them in the plan.
7. Provide guidelines for testing and validating the implementation to ensure it meets the defined requirements.
8. Save the implementation plan in a markdown file named after the task or feature in kebab-case format with .plan.md suffix.
9. Ensure that the implementation plan is clear, concise, and tailored to the needs of the development team.
10. **Focus only on changes specific to THIS task**: The implementation plan should ONLY include work directly related to the current task/Jira ticket. If the task requires prerequisite work or dependencies to be completed first, assume those are ALREADY DONE. Do not include implementation steps for prerequisites, dependencies, or related tasks - they should be tracked separately. Only plan what needs to be implemented for THIS specific task.
11. **Avoid duplicating existing work**: Never plan to create components, functions, or utilities that already exist. Always check the "Current Implementation Analysis" section and plan to reuse or modify existing code instead of recreating it.

The planning file should include:

1. Title: The title of the task or feature.
2. Description: A brief overview of the task or feature.
3. Current Implementation Analysis: A clear breakdown of what already exists vs what needs to be done:
   - **Already Implemented**: List of existing components, functions, utilities that will be reused (with file paths)
   - **To Be Modified**: List of existing code that needs changes or extensions (with file paths and description of changes)
   - **To Be Created**: List of new components, functions, utilities that need to be built from scratch
   - This section helps avoid duplicate work and ensures we build on existing solutions
4. A phases as a list of checklists: A breakdown of the implementation into distinct phases, each represented as a checklist
   - Each phase should have a clear title and description.
   - Tasks: A detailed list of tasks under each phase, including:
     - Task Title: A concise title for the task.
     - Description: A brief description of what the task entails.
     - **Action Type**: Clearly mark each task as [CREATE], [MODIFY], or [REUSE] to indicate the type of work
     - Definition of Done: Clear criteria that define when the task is considered complete.
     - A box to check when the task is done.
5. Security Considerations: Any security aspects that need to be addressed during implementation.
5. Quality Assurance: Guidelines for testing and validating the implementation to ensure it meets the defined requirements.
6. Domain areas that should have special focus during implementation.
7. Changelog: A section to document any changes made to the original plan during implementation.

Don't provide deployment plans, code pushing instructions, code review instructions.

In case of updates required during requirements clarification or implementation, make sure to document them clearly in the changelog section with timestamps.
