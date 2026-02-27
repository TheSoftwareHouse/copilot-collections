# Common Patterns

Reusable formatting patterns for skill authors. Use these when structuring workflows, templates, decision points, and validation loops in SKILL.md files.

## Table of Contents

- [Common Patterns](#common-patterns)
  - [Table of Contents](#table-of-contents)
    - [Workflow with Checklist](#workflow-with-checklist)
    - [Template Pattern](#template-pattern)
    - [Conditional Workflow Pattern](#conditional-workflow-pattern)
    - [Feedback Loop Pattern](#feedback-loop-pattern)

### Workflow with Checklist

Break complex tasks into numbered steps with a trackable checklist:

```markdown
## Process

Use the checklist below and track your progress:

\```
Progress:
- [ ] Step 1: Gather context
- [ ] Step 2: Analyze findings
- [ ] Step 3: Produce output
\```

**Step 1: Gather context**

<detailed instructions for step 1>

**Step 2: Analyze findings**

<detailed instructions for step 2>
```

### Template Pattern

Provide output format templates. Match strictness to requirements:

```markdown
## Report Structure

ALWAYS use this exact template:

\```markdown
# [Title]

## Summary
[One-paragraph overview]

## Findings
- Finding 1
- Finding 2

## Recommendations
1. Recommendation 1
2. Recommendation 2
\```
```

### Conditional Workflow Pattern

Guide the agent through decision points:

```markdown
## Modification Workflow

1. Determine the type:
   **Creating new?** → Follow "Creation workflow" below
   **Editing existing?** → Follow "Editing workflow" below

2. Creation workflow:
   - <steps>

3. Editing workflow:
   - <steps>
```

### Feedback Loop Pattern

For quality-critical tasks that require iterative validation:

```markdown
## Validation Loop

1. Produce the output
2. Validate against <validation-criteria>
3. If validation fails:
   - Review the issues found
   - Fix the problems
   - Re-validate
4. Only proceed when validation passes
```
