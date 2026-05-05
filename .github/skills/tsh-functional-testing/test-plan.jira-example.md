# Jira Test Plan Template

Use this template when delivering a test plan to Jira (as a sub-task description or comment). This uses markdown formatting that renders correctly in Jira's editor.

**IMPORTANT:** Copy this structure exactly. Do not convert to wiki markup (h2., #, *). Jira's modern editor accepts markdown.

---

# Test Plan - [Current Date]

**Source:** [PROJ-123](https://your-domain.atlassian.net/browse/PROJ-123)

**Navigation:**
[Describe the breadcrumb or menu path to reach the feature]

**In Scope:**
- [Core functionality 1 to be tested]
- [Core functionality 2 to be tested]
- [Core functionality 3 to be tested]

**Out of Scope:**
- [Item not covered in this test, e.g., back-end DB validation]
- [Item not covered in this test, e.g., 3rd party API integration]

**Preconditions:**
- [What must be true before testing starts, e.g., User is logged in]
- [What must be true before testing starts, e.g., App is version X.Y.Z]

**Environment:**
- Samsung S21 v. 14
- Samsung Galaxy S24 Ultra v. 16
- iPhone 16 iOS v. 26
- iPad v. 26
- Version: [App version]

---

## Scenarios

**Scenario 1: [Short Title]**
- [Action step 1, e.g., Navigate to the feature page]
- [Action step 2, e.g., Click on the submit button]
- Verify that: [Specific success criteria]

**Scenario 2: [Short Title]**
- [Action step 1]
- [Action step 2]
- Verify that: [Specific success criteria]

**Scenario 3 (Edge Case): [Short Title]**
- [Action step simulating a negative scenario, e.g., Disconnect from network]
- Verify that: [Expected graceful handling]

**Scenario 4 (Edge Case): [Short Title]**
- [Action step simulating boundary condition]
- Verify that: [Expected behavior at boundary]

---

## Regression Focus Areas

**Areas Impacted by Current Changes:**
- [Functional area]: [Why retesting is needed]

**Related Bugs to Retest:**
- [Bug ID/Title]: [Regression risk from this bug]

---

## Security Considerations

- [ ] [Authorization / access control check]
- [ ] [Input validation scenario]
- [ ] [Error handling — no sensitive info leaked in error messages]
