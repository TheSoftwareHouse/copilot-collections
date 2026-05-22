---
name: tsh-functional-testing
description: "Shared QA foundations — severity matrix, bug report template, and test plan templates. This is a base skill referenced by tsh-planning-tests, tsh-analyzing-regression-risk, tsh-verifying-acceptance-criteria, and tsh-generating-test-data."
---

# Functional Testing — Shared Foundations

This skill provides shared templates and reference material used across the QA skill family. For specific workflows, use the focused skills listed below.

## Skill Index

| Capability | Skill | Trigger |
|-----------|-------|---------|
| Test plan generation + edge cases | `tsh-planning-tests` | `/test-plan`, `/edge-cases`, `/desktop` |
| Regression scope analysis | `tsh-analyzing-regression-risk` | `/regression`, `/regression-plan` |
| AC verification | `tsh-verifying-acceptance-criteria` | `/verify-ac` |
| Test data generation | `tsh-generating-test-data` | `/test-data` |
| Quality health reports | `tsh-analyzing-bugs` | `/quality-health-report` |
| Accessibility auditing | `tsh-accessibility-auditing` | `/audit-accessibility` |

## Severity Matrix

| Severity | Definition | Blocks Release? |
|----------|-----------|-----------------|
| 🔴 **Critical** | Feature is broken/unusable, data loss, or security vulnerability | Yes |
| 🟠 **High** | Major functionality impaired, no workaround available | Should block |
| 🟡 **Medium** | Functionality impaired but a workaround exists | Fix before next release |
| 🔵 **Low** | Cosmetic issue or minor UX inconsistency | Fix when convenient |

> **Note**: For accessibility audit severity, see `tsh-accessibility-auditing` which uses Critical/Serious/Moderate/Minor aligned with axe-core.

## Bug Reporting

When reporting bugs found during testing, use the bug report template at `./examples/bug-report.example.md`. The template structures reports with severity classification, numbered steps to reproduce, actual vs expected behavior, and environment details.

## Templates

This directory contains shared templates referenced by the focused skills (all in `./examples/`):

| Template | Used by |
|----------|---------|
| `test-plan.example.md` | `tsh-planning-tests` |
| `test-cases.example.md` | `tsh-planning-tests`, `tsh-analyzing-regression-risk` |
| `regression-test-suite.example.md` | `tsh-analyzing-regression-risk` |
| `regression-scope.example.md` | `tsh-analyzing-regression-risk` |
| `bug-report.example.md` | All QA skills |
| `test-report.example.md` | QA orchestrator |
