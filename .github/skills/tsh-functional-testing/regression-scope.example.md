# Regression Scope — Output Templates

This template is the **planning artifact** — a concise risk analysis. The **execution artifact** (structured test case tables) uses `./regression-test-suite.example.md`.

## Risk Classification

| Risk Level | Criteria |
|------------|----------|
| 🔴 **High** | Direct dependency on changed code; critical user flow; area with history of bugs |
| 🟡 **Medium** | Indirect dependency; shared component or utility changed; area with moderate defect history |
| 🟢 **Low** | No dependency detected; change is isolated; area historically stable |

## Regression Scope Table

| Functional Area | Risk Level | Reason | Tickets |
|----------------|-----------|--------|---------|
| [Area] | 🔴/🟡/🟢 | [Why this area is affected] | [Ticket keys] |

## Risks Based on Existing Bugs

| Bug | Status | Risk | Notes |
|-----|--------|------|-------|
| [KEY — Title] | Done/Open | 🔴/🟡 | [How this bug relates to the current change] |

## Summary

| Risk Level | Areas | Test Cases |
|---|---|---|
| 🔴 Critical | [N] | [count] |
| 🟡 Important | [N] | [count] |
| 🟢 Low Risk | [N] | [count] |
| **Total** | **[N]** | **[count]** |
