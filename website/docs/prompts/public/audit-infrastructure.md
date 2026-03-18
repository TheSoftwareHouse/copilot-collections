---
sidebar_position: 16
title: /tsh-audit-infrastructure
---

# /tsh-audit-infrastructure

**Agent:** DevOps Engineer
**File:** `.github/prompts/tsh-audit-infrastructure.prompt.md`

Performs a comprehensive infrastructure audit to identify security vulnerabilities, cost optimization opportunities, and best practices violations.

## Usage

```text
/tsh-audit-infrastructure <scope: AWS/Azure/GCP/Kubernetes/CI-CD> <focus: security/cost/best-practices/all>
```

## What It Does

### 1. IaC Analysis

- Scans Terraform, CloudFormation, Kubernetes manifests, and CI/CD configurations.
- Identifies security misconfigurations, missing encryption, and exposed resources.
- Checks for compliance with tagging policies and naming conventions.

### 2. Live Infrastructure Validation

- Queries cloud provider APIs to validate against actual deployed state.
- Identifies resources not captured in IaC (drift detection).
- Checks for unused or underutilized resources.

### 3. Report Generation

- Produces a prioritized audit report with findings categorized by severity.
- Includes specific remediation guidance for each finding.
- Provides cost impact estimates for optimization opportunities.

## Skills Loaded

- `tsh-optimizing-cloud-cost` — Cost optimization and resource rightsizing.
- `tsh-managing-secrets` — Secrets management security audit.
- `tsh-technical-context-discovering` — Project conventions and existing patterns.
