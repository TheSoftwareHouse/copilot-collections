---
name: tsh-audit-infrastructure
description: "Audit infrastructure for security gaps, cost waste, and best practices violations."
user-invocable: true
argument-hint: "[scope: AWS/Azure/GCP/Kubernetes/CI-CD] [focus: security/cost/best-practices/all]"
---
<routing>Run this workflow through the designated agent: `tsh-devops-engineer`.</routing>

Perform a comprehensive infrastructure audit across IaC, CI/CD, and cloud resources. Cover security, cost, and operational excellence, classify findings by severity, and produce an actionable report.

<required-skills>
- `tsh-optimizing-cloud-cost` - cost and rightsizing analysis.
- `tsh-managing-secrets` - secrets and exposure assessment.
- `tsh-codebase-analysing` - IaC, pipeline, and documentation review.
</required-skills>

<workflow>
1. Determine provider/platform, focus, and compliance requirements.
2. Inspect scoped instructions, IaC, pipelines, and existing infrastructure patterns.
3. Assess security, cost, secrets, tagging, IaC coverage, and documentation.
4. Escalate architectural findings to `tsh-architect` when structural changes are required.
5. Return an Infrastructure Audit Summary with prioritized findings and remediation routes to `tsh-implement-terraform`, `tsh-deploy-kubernetes`, `tsh-implement-pipeline`, or `tsh-implement-observability`.
</workflow>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-audit-infrastructure:v1 -->
