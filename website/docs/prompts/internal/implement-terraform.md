---
sidebar_position: 13
title: /tsh-implement-terraform
---

# /tsh-implement-terraform

:::info
Not invoked directly by users. To trigger Terraform implementation, use [`/tsh-implement`](../public/implement) — the [Engineering Manager](../../agents/engineering-manager) will automatically delegate to the [DevOps Engineer](../../agents/devops-engineer).
:::

**Agent:** DevOps Engineer
**File:** `.github/internal-prompts/tsh-implement-terraform.prompt.md`

Creates Terraform modules and provisions cloud infrastructure safely following established IaC patterns and safety guardrails.

## How It’s Triggered

```text
/tsh-implement <describe what infrastructure to provision or modify>
```

The Engineering Manager identifies Terraform tasks in the plan and delegates them to the DevOps Engineer automatically.

## What It Does

### 1. Context Discovery

- Identifies existing Terraform modules, state backends, and provider configurations.
- Checks for naming conventions, tagging policies, and module structure.
- Discovers existing patterns for resource configuration and variable management.

### 2. Implementation

- Creates reusable Terraform modules with proper input/output variables.
- Applies consistent naming, tagging, and resource configuration.
- Configures state management and backend settings.
- Generates cost estimates for proposed changes.

### 3. Safety Checks

- Runs `terraform validate` and `terraform plan` before any changes.
- Never runs `terraform apply` without explicit user authorization.
- Includes rollback considerations and state management safeguards.

## Skills Loaded

- `tsh-implementing-terraform-modules` — Reusable Terraform modules for AWS, Azure, and GCP.
- `tsh-optimizing-cloud-cost` — Cost estimation and optimization.
- `tsh-technical-context-discovering` — Project conventions and existing patterns.
