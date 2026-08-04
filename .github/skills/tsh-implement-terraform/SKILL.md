---
name: tsh-implement-terraform
description: "Create or modify Terraform modules and cloud infrastructure following established IaC patterns, safety guardrails, and cost analysis."
user-invocable: false
---
<routing>Designated agent: `tsh-devops-engineer`; private workflow skill: `tsh-implement-terraform`.</routing>

Create or modify Terraform using existing module, provider, state, naming, tagging, and validation conventions. Run `terraform plan` before any apply, never recommend production auto-approve, and escalate topology, service-selection, multi-region, or material-cost decisions to `tsh-architect`.

<required-skills>`tsh-implementing-terraform-modules`, `tsh-technical-context-discovering`</required-skills>
<workflow>Discover Terraform setup; design module interfaces and resources; validate state and cost impact; return current state, proposed configuration, variables, backend, estimate, apply instructions, and files.</workflow>

<!-- TSH_COPILOT_COLLECTIONS:skill:tsh-implement-terraform:v1 -->
