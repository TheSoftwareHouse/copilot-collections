# Terraform Implementation Workflow

This prompt creates or modifies Terraform modules and provisions cloud infrastructure following established IaC patterns and safety guardrails. It ensures consistent resource configuration with proper naming, tagging, state management, and cost estimation before any infrastructure changes are applied.

The workflow respects existing project conventions, validates all changes through `terraform plan`, and automatically escalates architectural decisions (VPC design, service selection, multi-region) to the architect agent. Every implementation includes cost impact analysis and step-by-step apply instructions.

## Required Skills
Before starting, load and follow these skills:
- `tsh-implementing-terraform-modules` - for module patterns, state management, and safe infrastructure changes
- `tsh-technical-context-discovering` - to establish project conventions and existing Terraform patterns

---

## 1. Context

Follow the `tsh-technical-context-discovering` skill to identify existing Terraform setup.

Additionally, always:
- **Read the delegated task block first** — Read the delegated task block in the plan and only the files/resources named in its `Read First` list. Use that task block as the primary source of truth for module names, state backend notes, provider versions, apply preconditions, and other infrastructure-specific facts. Do not rely on global plan sections or broader execution-support packages.
- Check `*.instructions.md` only for aspects **not covered** by the task block or its named reading
- Analyze existing Terraform modules and state configuration
- Discover environment organization (workspaces, Terragrunt)

Treat labeled pseudocode, tables, diagrams, and contracts in the task block as illustrative guidance only. They are not production Terraform configuration to copy verbatim.

---

## 2. Implementation

Follow the `tsh-implementing-terraform-modules` skill for:
- Module structure and interfaces
- Resource configurations with proper naming and tagging
- Variable definitions with validation
- State backend configuration

**Guardrails:**
- Always run `terraform plan` before any apply
- Never suggest `terraform apply -auto-approve` for production
- Ensure remote state is configured before applying
- Flag resources with significant cost impact (>10% increase)

---

## 3. Architect Consultation

Spawn `tsh-architect` sub-agent when:
- Designing new VPC/network topology
- Selecting between competing cloud services (ECS vs EKS, RDS vs Aurora)
- Implementing multi-region or disaster recovery architecture
- Making decisions with significant cost impact (>10% increase)

Skip for: adding resources to existing modules, updating versions, fixing bugs, adding tags.

---

## 4. Summary (required output)

```markdown
## Terraform Implementation Summary

### Current State
- [existing IaC configuration]

### Proposed Configuration
- Provider: [AWS / Azure / GCP]
- Resources: [list of resources to create/modify]

### Variables
| Variable | Type | Required | Description |
|----------|------|----------|-------------|

### State Backend
- [remote state configuration]

### Cost Estimate
- [approximate monthly cost for new resources]

### Apply Instructions
1. `terraform init`
2. `terraform plan -out=tfplan`
3. Review plan output
4. `terraform apply tfplan`

### Files
- NEW/MODIFIED: [list of files created or modified]
```

---

## Scope

**Does NOT handle** (redirect to):
- CI/CD pipelines for Terraform → `/tsh-implement-pipeline`
- Kubernetes workload configuration → `/tsh-deploy-kubernetes`
- Monitoring infrastructure → `/tsh-implement-observability`

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-implement-terraform:v2 -->
