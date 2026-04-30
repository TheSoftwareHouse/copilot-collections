# Regression Scope — Output Templates

## Risk Classification

| Risk Level | Criteria |
|------------|----------|
| 🔴 **High** | Direct dependency on changed code; critical user flow; area with history of bugs |
| 🟡 **Medium** | Indirect dependency; shared component or utility changed; area with moderate defect history |
| 🟢 **Low** | No dependency detected; change is isolated; area historically stable |

## Regression Scope Table

| Functional Area | Risk Level | Reason | Suggested Manual Scenarios |
|----------------|-----------|--------|---------------------------|
| [Area] | 🔴/🟡/🟢 | [Why this area is affected] | [Key manual scenarios to retest] |

## Manual Regression Checklist

**🔴 Critical — Must Retest**
- [ ] [Scenario]: [Brief description] — [Why it's critical]
- [ ] [Scenario]: [Brief description] — [Why it's critical]

**🟡 Important — Should Retest**
- [ ] [Scenario]: [Brief description] — [Why it matters]

**🟢 Low Risk — Retest If Time Permits**
- [ ] [Scenario]: [Brief description]

**Areas Impacted by Recent Changes**
- [Area]: [What changed and why retesting is needed]

**Risks Based on Existing Bugs**
- [Bug ID/Title]: [How this bug relates to the current change and why regression is likely]
