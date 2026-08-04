---
name: tsh-analyze-gcp-costs
description: "Perform a comprehensive GCP cost optimization and labeling compliance audit — checks IaC code first, then validates everything against live infrastructure via API."
user-invocable: true
argument-hint: "[GCP Project ID, Region, or 'all'] [focus: specific service or 'everything']"
---
<routing>Run this workflow through the designated agent: `tsh-devops-engineer`.</routing>

Perform an exhaustive GCP cost optimization and labeling compliance audit. Analyze Terraform/IaC first when available, then validate live GCP infrastructure through read-only APIs. Audit the requested scope, defaulting to all services when no narrow focus is provided.

<required-skills>
- `tsh-technical-context-discovering` - identify IaC and labeling conventions.
- `tsh-codebase-analysing` - inspect infrastructure structure and drift sources.
- `tsh-optimizing-cloud-cost` - apply cost, labeling, rightsizing, and storage-tiering criteria.
- `tsh-designing-multi-cloud-architecture` - load for service alternatives.
- `tsh-implementing-terraform-modules` - load when Terraform is present.
- `tsh-managing-secrets` - apply security and credential-handling checks.
</required-skills>

<workflow>
1. Validate project, region, and optional service focus.
2. Inspect IaC and project conventions before live validation.
3. Inventory live resources read-only, cross-reference IaC, and identify drift and shadow resources.
4. Assess compute, storage, databases, networking, containers, serverless, AI/ML, security, logs, messaging, and data transfer.
5. Check Core 5 labels (`cost_center`, `environment`, `service`, `owner`, `data_class`) and produce Golden, Cost-Optimized, and Velocity paths.
6. Save a polished `gcp-cost-audit-<project>-<region>-YYYY-MM-DD.md` report before presenting the summary.
7. Ask only whether Terraform code should be generated; do not modify code without explicit opportunity selection.
</workflow>

<constraints>Use read-only cloud operations for analysis, warn before production changes, and never execute remediation automatically.</constraints>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-analyze-gcp-costs:v1 -->
