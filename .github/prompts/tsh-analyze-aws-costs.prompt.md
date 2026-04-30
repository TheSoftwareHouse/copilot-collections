---
agent: "tsh-devops-engineer"
model: "Claude Opus 4.6"
description: "Perform a comprehensive AWS cost optimization and tagging compliance audit — checks IaC code first, then validates everything against live infrastructure via API."
argument-hint: "[AWS Account/Profile, Region, or 'all'] [focus: specific service or 'everything']"
---

Perform an exhaustive, evidence-based AWS cost optimization and tagging compliance audit. Use a **hybrid approach**: analyze Terraform/IaC code first (if available), then **always** validate against live AWS infrastructure via API. The goal is to inspect every nook and cranny — every service, every resource, every configuration — for optimization opportunities, waste, misconfigurations, and tagging gaps.

When the user does not specify a narrow scope, **default to auditing everything** in the given account and region.

## Required Skills
Before starting, load and follow these skills (in this order):
- `tsh-technical-context-discovering` — identify existing IaC patterns, tagging conventions, and project context
- `tsh-codebase-analysing` — IaC structure analysis, module relationships, and dead code detection; apply Steps 7, 2, 12 when IaC files are found
- `tsh-optimizing-cloud-cost` — cost analysis framework: Pricing Model Decision table, Storage Tiering Decision, tagging standards, rightsizing process, and anti-patterns
- `tsh-implementing-terraform-modules` (conditional) — Terraform module structure, best practices, and AWS module reference; load when Terraform files are found
- `tsh-managing-secrets` (conditional) — secrets management audit criteria, security checklist, and exposure risk assessment; load when security findings are in scope

## Workflow

1. **Scope validation**:
   - User should specify **AWS Account/Profile** and **Region** (or "all regions").
   - If missing, ask the user to clarify before proceeding.
   - If the user specifies a focus (e.g., "EC2 only"), respect that scope. Otherwise, **audit all services** — compute, storage, databases, networking, serverless, containers, AI/ML, security, and any other active resources.

2. **Load required skills** (MUST complete before any analysis):
   - **Always load** the `tsh-technical-context-discovering` skill (`read_file` on `.github/skills/tsh-technical-context-discovering/SKILL.md`) — follow its process to identify existing IaC patterns, tagging conventions, and project context.
   - **Always load** the `tsh-codebase-analysing` skill (`read_file` on `.github/skills/tsh-codebase-analysing/SKILL.md`) — even if no IaC files are found initially, this skill's Step 7 (infrastructure code) helps identify IaC in unexpected locations, and Step 2 (dependencies) reveals infrastructure-related dependencies in any project.
   - **Always load** the `tsh-optimizing-cloud-cost` skill (`read_file` on `.github/skills/tsh-optimizing-cloud-cost/SKILL.md` and `references/tagging-standards.md`) — use it to establish the "Core 5" Mandatory Tags, Pricing Model Decision table, Storage Tiering Decision table, Process steps, Checklist, and Anti-Patterns. If the skill file cannot be found, use the following hardcoded defaults for the Core 5 Mandatory Tags: `CostCenter`, `Environment`, `Service`, `Owner`, `DataClass`.
   - **Conditionally load** the `tsh-implementing-terraform-modules` skill (`read_file` on `.github/skills/tsh-implementing-terraform-modules/SKILL.md`) — load when Terraform files (`*.tf`, `*.tfvars`, `terragrunt.hcl`) are found. Use it as the reference standard for module structure, naming conventions, provider pinning, and AWS-specific module patterns when evaluating IaC quality and generating Terraform code.
   - **Conditionally load** the `tsh-managing-secrets` skill (`read_file` on `.github/skills/tsh-managing-secrets/SKILL.md`) — load when the audit scope includes security (which is always for a full audit). Use its Security Checklist, Anti-Patterns, and Cloud-Native Detection patterns when evaluating secrets management, KMS keys, and credential handling.
   - **Fallback**: If any skill file cannot be loaded, log the failure, note the skill gap in the final report's Executive Summary, and proceed with available skills.
   - Do **not** proceed to step 3 until all applicable skills have been read and their processes initiated.

3. **IaC-first discovery** (hybrid approach — IaC then API):
   - Apply the `tsh-technical-context-discovering` skill process loaded in step 2.
   - **Phase A — Terraform/IaC analysis** (if available):
     - Search the current workspace for Terraform files (`*.tf`, `*.tfvars`, `terragrunt.hcl`) and CloudFormation templates (`*.yaml`, `*.json` with `AWSTemplateFormatVersion`).
     - If found:
       - Apply the `tsh-codebase-analysing` skill (loaded in step 2) — specifically run its infrastructure code analysis (Step 7), dependency check (Step 2), and dead code/duplication check (Step 12) against the IaC codebase.
       - Apply the `tsh-implementing-terraform-modules` skill (loaded in step 2) to evaluate module structure quality: check for standard file layout (`main.tf`/`variables.tf`/`outputs.tf`/`versions.tf`), provider version pinning, variable validation blocks, and adherence to AWS module best practices.
       - Parse IaC files to extract provisioned resource types, instance sizes, storage configurations, networking rules, and any hardcoded values that affect cost (e.g., `instance_type`, `allocated_storage`, `desired_count`, `volume_size`, `engine`, `multi_az`).
       - Identify IaC anti-patterns: hardcoded instance types instead of variables, missing lifecycle policies, over-provisioned defaults, unused module outputs.
     - If **not found**: note this and proceed to Phase B. The user may provide a Terraform directory later in step 7.
   - **Phase B — Live AWS API validation** (MANDATORY — always execute):
     - Use `awslabs.aws-api-mcp-server` (read-only: `describe`, `list`, `get` operations only) to inventory **all** active resources in the specified scope.
     - Cross-reference live resources with IaC-defined resources (if Phase A ran) to detect **drift**: resources in code but not in AWS, resources in AWS but not in code, and configuration differences between code and live state.
     - Discover **shadow resources** — resources created manually or by other tools that have no IaC representation.
     - **Fallback**: If `awslabs.aws-api-mcp-server` is unavailable or unresponsive, use `awslabs.aws-documentation-mcp-server` for service documentation and `context7` for pricing/resource reference data. Clearly inform the user that the audit is based on documentation rather than live data and recommend re-running with MCP API access for accurate results.

4. **Comprehensive resource audit** (check EVERYTHING):
   Apply the `tsh-optimizing-cloud-cost` skill's Process step 3 (Identify waste) and Checklist to systematically check each resource category below. Apply the `tsh-managing-secrets` skill's Security Checklist when auditing the Security & Compliance category.
   - **Compute**: EC2 instances (sizing, generation, purchase type), Auto Scaling groups (min/max/desired), Lambda functions (memory, timeout, concurrency), ECS/EKS tasks and services, Batch compute environments.
   - **Storage**: EBS volumes (type, size, IOPS, attachment status), S3 buckets (lifecycle policies, storage class, versioning, access patterns), EFS file systems (throughput mode, storage class).
   - **Databases**: RDS instances (engine, class, Multi-AZ, storage type), Aurora clusters (instance count, serverless v2 scaling), DynamoDB tables (capacity mode, provisioned throughput vs on-demand), ElastiCache clusters (node type, cluster mode).
   - **Networking**: NAT Gateways (data transfer costs), VPC endpoints (vs NAT Gateway savings), Elastic IPs (unattached), Load Balancers (idle or underutilized), CloudFront distributions (price class, caching efficiency), Route 53 hosted zones.
   - **Containers & Orchestration**: ECS Fargate tasks (CPU/memory allocation), EKS node groups (instance types, scaling), ECR repositories (lifecycle policies, image count).
   - **Serverless**: Lambda (invocation count, duration, provisioned concurrency), API Gateway (endpoint type, caching), Step Functions (execution count, express vs standard).
   - **AI/ML**: SageMaker endpoints (instance type, auto-scaling), Bedrock usage, GPU instances.
   - **Security & Compliance**: Security Groups (overly permissive rules), KMS keys (unused), WAF rules, Certificate Manager certificates.
   - **Other**: CloudWatch Logs (retention policies), SNS/SQS (unused topics/queues), Secrets Manager (unused secrets), Data Transfer costs (cross-AZ, cross-region, internet egress).

5. **Tagging & governance audit**:
   Apply the `tsh-optimizing-cloud-cost` skill's Required Tags table and `references/tagging-standards.md` for the complete tagging framework.
   - Use `awslabs.aws-api-mcp-server` to read resource tags for all discovered resources.
   - Check every resource against the **"Core 5" Mandatory Tags** (`CostCenter`, `Environment`, `Service`, `Owner`, `DataClass`) as defined in `tagging-standards.md`.
   - **AI/ML checks**: If the resource is a GPU instance or SageMaker endpoint, verify `ModelID` and `TrainingJobId` tags exist.
   - **Security check**: Verify `DataClass` tag exists on all storage and database resources.
   - **Lifecycle check**: Flag resources with `Environment:dev` running 24/7 that are missing the `Schedule` tag.

6. **Cost & performance analysis**:
   - Use `awslabs.aws-api-mcp-server` with Cost Explorer APIs (`ce:GetCostAndUsage`) for actual cost data. If unavailable, estimate based on instance type and runtime hours.
   - Apply the `tsh-optimizing-cloud-cost` skill's **Pricing Model Decision** table to match each resource's workload type (steady-state, variable, fault-tolerant, serverless) to the optimal pricing model. Apply the **Storage Tiering Decision** table for all storage resources. Reference the skill's **Anti-Patterns** table to flag common cost mistakes.
   - Use `awslabs.aws-documentation-mcp-server` to verify the latest instance families, pricing tiers, and service availability in the target region before recommending any changes. This step is **mandatory** — do not recommend instance types or configurations without checking current AWS documentation first.
   - Use `context7` to cross-reference Terraform provider documentation for any IaC-related recommendations.
   - Use `sequential-thinking` MCP tool to evaluate trade-offs when comparing optimization options across multiple resources. This step is **mandatory** — do not skip it.
   - For each resource, produce 3 optimization paths per the DevOps agent's Output Strategy:
     - **Golden Path**: Balanced, standard recommendation.
     - **Cost-Optimized Path**: Maximum savings (Spot, Scale-to-Zero, Serverless, Reserved/Savings Plans).
     - **Velocity Path**: Fastest performance, higher cost.

7. **Generate and save the analysis report**:

    > **IMPORTANT**: Save the report file **before** presenting results to the user. Do not ask for confirmation. Always use this filename pattern: `aws-cost-audit-<profile>-<region>-YYYY-MM-DD.md` (e.g. `aws-cost-audit-default-eu-north-1-2026-02-18.md`). After saving, tell the user the full file path on one line, then present the formatted summary below.

    The saved Markdown file must be **polished and presentation-ready**. Follow every formatting rule below exactly — do not improvise:

    ---

    **Exact report structure and formatting rules:**

    ```
    # AWS Cost Optimization Audit
    **Account / Profile:** `<profile>`   **Region:** `<region>`   **Date:** YYYY-MM-DD
    **Data Sources:** IaC (Terraform) / Live API / Both
    **Scope:** All services / <specific services>

    ---

    ## 📋 Executive Summary

    - <bullet 1>
    - <bullet 2>
    - ... (3–6 bullets max)

    ---

    ## 🔍 IaC vs Live Infrastructure Drift

    | # | Resource | IaC State | Live State | Drift Type |
    |---|----------|-----------|------------|------------|
    | 1 | `i-0abc123` | `m5.xlarge` | `m5.2xlarge` | Config drift |
    | 2 | `sg-0xyz` | Not in IaC | Active | Shadow resource |

    *(If no IaC found or no drift detected, state that clearly.)*

    ---

    ## 💰 Optimization Opportunities

    | # | Resource ID | Type | Current Config | Current Cost ($/mo) | Recommended Config | Est. New Cost ($/mo) | Savings ($/mo) | Path |
    |---|---|---|---|---|---|---|---|---|
    | 1 | `i-0abc123` | EC2 | `m5.xlarge` | $140 | `m7g.large` | $70 | **$70** | 🟢 Golden |
    | 2 | `db-prod-01` | RDS | `db.r5.2xl, 500 GB gp2` | $820 | `db.r7g.xl, 500 GB gp3` | $510 | **$310** | 🔵 Cost-Opt |

    > Path legend: 🟢 Golden Path · 🔵 Cost-Optimized · 🚀 Velocity

    ---

    ## 🏷️ Tag Compliance

    | # | Resource ID | Type | Missing Tags | Status |
    |---|---|---|---|---|
    | 1 | `i-0abc123` | EC2 | `Owner`, `DataClass` | ❌ FAIL |
    | 2 | `my-bucket` | S3 | — | ✅ PASS |

    ---

    ## 🔒 Critical Security Findings

    | # | Resource ID | Type | Finding | Severity |
    |---|---|---|---|---|
    | 1 | `sg-0xyz` | Security Group | Port 22 open to 0.0.0.0/0 | 🔴 HIGH |

    *(If none found, write: "No critical security findings detected.")*

    ---

    ## 📊 Summary

    | Metric | Value |
    |---|---|
    | Total current monthly spend | $X,XXX |
    | Total estimated optimized spend | $X,XXX |
    | **Total estimated savings** | **$X,XXX/mo (XX%)** |
    | Tag compliance | XX% (X of Y resources fully tagged) |
    | IaC coverage | XX% (X of Y resources managed by IaC) |
    | Drift detected | X resources with configuration drift |
    | Data sources used | AWS API / Terraform code / Both |

    ---

    ## ✅ Recommended Action Order

    1. Apply optimization #X — highest savings, lowest risk
    2. ...
    ```

    Formatting constraints:
    - Use `---` horizontal rules between every major section.
    - Use emoji section icons exactly as shown (📋 🔍 💰 🏷️ 🔒 📊 ✅).
    - Use `❌ FAIL` / `✅ PASS` in tag compliance status column — no bold-only text.
    - Use path emoji legend exactly as shown: 🟢 Golden · 🔵 Cost-Opt · 🚀 Velocity.
    - Resource IDs must always be wrapped in backticks.
    - All table columns must be left-aligned (use `|---|` separators, not `:---:`).
    - Do not add extra prose paragraphs between tables.

8. **Next steps** — After saving and presenting the analysis report, ask **only one question**:

    > _"Would you like me to generate Terraform code to implement these optimizations?"_

    - If **no**: end the workflow — the saved report stands on its own.

    - If **yes**:
       - **Terraform code found in workspace (step 3)**: List the optimization opportunity numbers and ask which ones to apply (e.g., `1, 3, 5` or `all`). Only modify the resources the user selects. Apply the `tsh-implementing-terraform-modules` skill's module structure patterns and best practices when generating or modifying Terraform code.
       - **No Terraform code found in workspace (step 3)**: Ask — _"No Terraform code was found in the current workspace. Please provide a local folder path or a Git repository URL where I should apply the optimizations."_ Once the user supplies the path/URL:
         1. **Load skills for the new directory**: Read the `tsh-codebase-analysing` skill (if not already loaded), the `tsh-technical-context-discovering` skill, and the `tsh-implementing-terraform-modules` skill. Apply them to the provided Terraform directory — specifically run `tsh-codebase-analysing` Step 7 (infrastructure code), Step 2 (dependencies), and Step 12 (dead code) against the Terraform codebase, follow `tsh-technical-context-discovering` to understand existing patterns, and use `tsh-implementing-terraform-modules` for module structure reference before making changes.
         2. Ask which opportunity numbers to apply.
         3. Only then proceed with code generation, following patterns discovered by the skills.

    Do **not** proceed with any code generation or file modification until the user explicitly confirms which items to implement.

## Prompt-Specific Guardrails

All standard DevOps agent guardrails (Mutation Lock, Zero-Deletion Policy, FinOps Alerts) apply automatically. Additionally:
- This prompt is **analysis-only** by default — do not generate or modify code unless the user explicitly requests it in the next steps.
- Always warn before suggesting modifications to resources tagged `Environment:prod`.
- All remediation output (CLI scripts, Terraform code) is for user review and manual execution only — never execute directly.
- When modifying existing Terraform code, show a diff preview of proposed changes before writing to files.

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-analyze-aws-costs:v1 -->
