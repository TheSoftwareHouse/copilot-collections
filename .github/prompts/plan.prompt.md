---
mode: "architect"
model: "Claude Sonnet 4.5"
description: "Prepare detailed implementation plan for given feature."
---

Analyze feature context file for provided task or Jira ID. Based on it prepare detailed implementation plan that software engineer can follow step by step to deliver the feature.

The file outcome should be a markdown file named after the task jira id in kebab-case format or after task name (if no jira task provided) with .plan.md suffix (e.g., user-authentication.plan.md). The file should be organized in a structured format, including sections for phases and tasks. The file should be placed in the specifications directory under a folder named after the research file of that task in kebab-case format.

Make sure to follow the steps below:

1. Analyze the feature context file thoroughly to understand the requirements and scope of the feature.
2. Understand the project best practices and quality standards to ensure the implementation plan aligns with them.
3. Prepare implementation plan with detailed code changes required to be implemented, broken down into phases.
4. For each phase, identify the specific tasks that need to be completed, providing a clear title, description, and definition of done for each task.
5. Consider any security aspects that need to be addressed during implementation and include them in the plan.
6. Provide guidelines for testing and validating the implementation to ensure it meets the defined requirements.
7. Save the implementation plan in a markdown file named after the task or feature in kebab-case format with .plan.md suffix.
8. Ensure that the implementation plan is clear, concise, and tailored to the needs of the development team.

The planning file should include:

1. Title: The title of the task or feature.
2. Description: A brief overview of the task or feature.
3. A phases as a list of checklists: A breakdown of the implementation into distinct phases, each represented as a checklist
   - Each phase should have a clear title and description.
   - Tasks: A detailed list of tasks under each phase, including:
     - Task Title: A concise title for the task.
     - Description: A brief description of what the task entails.
     - Definition of Done: Clear criteria that define when the task is considered complete.
     - A box to check when the task is done.
4. Security Considerations: Any security aspects that need to be addressed during implementation.
5. Quality Assurance: Guidelines for testing and validating the implementation to ensure it meets the defined requirements.
6. Domain areas that should have special focus during implementation.
7. Changelog: A section to document any changes made to the original plan during implementation.

Don't provide deployment plans, code pushing instructions, code review instructions.

In case of updates required during requirements clarification or implementation, make sure to document them clearly in the changelog section with timestamps.
