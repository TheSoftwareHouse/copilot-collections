# Test Plan Example

Use this template when generating test plans.

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
_(Include when planning regression testing or when recent changes affect existing functionality)_

**Areas Impacted by Current Changes:**
- [Functional area]: [Why retesting is needed]

**Related Bugs to Retest:**
- [Bug ID/Title]: [Regression risk from this bug]

---

## Performance Considerations
_(Include when the feature involves data loading, heavy operations, or user-facing latency. List only the 3-5 highest-risk items.)_

- [ ] [Slow-loading page or heavy operation to verify]
- [ ] [Large data set scenario to test]
- [ ] [Long-running request or operation]
- [ ] [Action that may trigger multiple backend calls]
- [ ] [Area where users may experience delays]

---

## Security Considerations
_(Include when the feature involves authentication, authorization, user data, or input handling. List only the 3-5 highest-risk items.)_

- [ ] [Authorization / access control check]
- [ ] [User permission or role-based access verification]
- [ ] [Sensitive data visibility or exposure check]
- [ ] [Input validation scenario]
- [ ] [Error handling — no sensitive info leaked in error messages]

---

## API Testing Scenarios
_(Include ONLY if the user confirmed that API testing is relevant for this project/feature. If not confirmed, omit this section entirely.)_

- **Endpoint**: [API endpoint]
  - Positive: [Valid request and expected response]
  - Negative: [Invalid request and expected error handling]
  - Edge case: [Boundary or unusual input]
