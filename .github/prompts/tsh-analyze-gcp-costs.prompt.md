---
agent: "tsh-devops-engineer"
model: "Claude Opus 4.6"
description: "Perform a comprehensive GCP cost optimization and labeling compliance audit — checks IaC code first, then validates everything against live infrastructure via API."
argument-hint: "[GCP Project ID, Region, or 'all'] [focus: specific service or 'everything']"
---

Perform an exhaustive, evidence-based GCP cost optimization and labeling compliance audit. Use a **hybrid approach**: analyze Terraform/IaC code first (if available), then **always** validate against live GCP infrastructure via API. The goal is to inspect every nook and cranny — every service, every resource, every configuration — for optimization opportunities, waste, misconfigurations, and labeling gaps.

When the user does not specify a narrow scope, **default to auditing everything** in the given project and region.

## Required Skills
Before starting, load and follow these skills (in this order):
- `tsh-technical-context-discovering` — identify existing IaC patterns, labeling conventions, and project context
- `tsh-codebase-analysing` — IaC structure analysis, module relationships, and dead code detection; apply Steps 7, 2, 12 when IaC files are found
- `tsh-optimizing-cloud-cost` — cost analysis framework: Pricing Model Decision table, Storage Tiering Decision, labeling standards, rightsizing process, and anti-patterns
- `tsh-designing-multi-cloud-architecture` (conditional) — GCP service selection reference, multi-cloud decision framework; load when evaluating service alternatives or migration options
- `tsh-implementing-terraform-modules` (conditional) — Terraform module structure, best practices, and GCP module reference; load when Terraform files are found
- `tsh-managing-secrets` (conditional) — secrets management audit criteria, security checklist, and exposure risk assessment; load when security findings are in scope

## Workflow

1. **Scope validation**:
   - User should specify **GCP Project ID** and **Region** (or "all regions").
   - If missing, ask the user to clarify before proceeding.
   - If the user specifies a focus (e.g., "Compute Engine only"), respect that scope. Otherwise, **audit all services** — compute, storage, databases, networking, serverless, containers, AI/ML, security, and any other active resources.

2. **Load required skills** (MUST complete before any analysis):
   - **Always load** the `tsh-technical-context-discovering` skill (`read_file` on `.github/skills/tsh-technical-context-discovering/SKILL.md`) — follow its process to identify existing IaC patterns, labeling conventions, and project context.
   - **Always load** the `tsh-codebase-analysing` skill (`read_file` on `.github/skills/tsh-codebase-analysing/SKILL.md`) — even if no IaC files are found initially, this skill's Step 7 (infrastructure code) helps identify IaC in unexpected locations, and Step 2 (dependencies) reveals infrastructure-related dependencies in any project.
   - **Always load** the `tsh-optimizing-cloud-cost` skill (`read_file` on `.github/skills/tsh-optimizing-cloud-cost/SKILL.md` and `references/tagging-standards.md`) — use its GCP columns in the Pricing Model Decision table, Storage Tiering Decision table, Process steps, Checklist, and Anti-Patterns. Adapt the "Core 5" Mandatory Tags for GCP as **labels**: `cost_center`, `environment`, `service`, `owner`, `data_class` (lowercase with underscores — GCP label format). If the skill file cannot be found, use the following hardcoded defaults for the Core 5 Mandatory Labels: `cost_center`, `environment`, `service`, `owner`, `data_class`.
   - **Conditionally load** the `tsh-designing-multi-cloud-architecture` skill (`read_file` on `.github/skills/tsh-designing-multi-cloud-architecture/SKILL.md`) — load when evaluating GCP service alternatives or comparing GCP services against each other. Use its GCP service comparison tables for compute, storage, database, and networking decisions.
   - **Conditionally load** the `tsh-implementing-terraform-modules` skill (`read_file` on `.github/skills/tsh-implementing-terraform-modules/SKILL.md` and `references/gcp-modules.md`) — load when Terraform files (`*.tf`, `*.tfvars`, `terragrunt.hcl`) are found. Use it as the reference standard for module structure, naming conventions, provider pinning, and GCP-specific module patterns when evaluating IaC quality and generating Terraform code.
   - **Conditionally load** the `tsh-managing-secrets` skill (`read_file` on `.github/skills/tsh-managing-secrets/SKILL.md`) — load when the audit scope includes security (which is always for a full audit). Use its Security Checklist, Anti-Patterns, and Cloud-Native Detection patterns when evaluating secrets management, Cloud KMS keys, and credential handling.
   - **Fallback**: If any skill file cannot be loaded, log the failure, note the skill gap in the final report's Executive Summary, and proceed with available skills.
   - Do **not** proceed to step 3 until all applicable skills have been read and their processes initiated.

3. **IaC-first discovery** (hybrid approach — IaC then API):
   - Apply the `tsh-technical-context-discovering` skill process loaded in step 2.
   - **Phase A — Terraform/IaC analysis** (if available):
     - Search the current workspace for Terraform files (`*.tf`, `*.tfvars`, `terragrunt.hcl`) and Deployment Manager templates (`*.yaml`, `*.jinja` with GCP resource types).
     - If found:
       - Apply the `tsh-codebase-analysing` skill (loaded in step 2) — specifically run its infrastructure code analysis (Step 7), dependency check (Step 2), and dead code/duplication check (Step 12) against the IaC codebase.
       - Apply the `tsh-implementing-terraform-modules` skill (loaded in step 2) to evaluate module structure quality: check for standard file layout (`main.tf`/`variables.tf`/`outputs.tf`/`versions.tf`), provider version pinning, variable validation blocks, and adherence to GCP module best practices.
       - Parse IaC files to extract provisioned resource types, machine types, disk configurations, networking rules, and any hardcoded values that affect cost (e.g., `machine_type`, `disk_size_gb`, `disk_type`, `num_instances`, `tier`, `availability_type`).
       - Identify IaC anti-patterns: hardcoded machine types instead of variables, missing lifecycle policies, over-provisioned defaults, unused module outputs.
     - If **not found**: note this and proceed to Phase B. The user may provide a Terraform directory later in step 7.
   - **Phase B — Live GCP API validation** (MANDATORY — always execute):
     - Use `gcp-gcloud/*` MCP tools (read-only: `list`, `describe`, `get` operations only) to inventory **all** active resources in the specified scope via `gcloud` CLI commands (e.g., `gcloud compute instances list`, `gcloud sql instances list`, `gcloud container clusters list`, etc.).
     - Use `gcp-storage/*` MCP tools for Cloud Storage bucket auditing.
     - Use `gcp-observability/*` MCP tools for monitoring and logging configuration analysis.
     - Cross-reference live resources with IaC-defined resources (if Phase A ran) to detect **drift**: resources in code but not in GCP, resources in GCP but not in code, and configuration differences between code and live state.
     - Discover **shadow resources** — resources created manually or by other tools that have no IaC representation.
     - **Fallback**: If GCP MCP tools are unavailable or unresponsive, use `context7` for GCP service documentation and pricing reference data. Clearly inform the user that the audit is based on documentation rather than live data and recommend re-running with MCP API access for accurate results.

4. **Comprehensive resource audit** (check EVERYTHING):
   Apply the `tsh-optimizing-cloud-cost` skill's Process step 3 (Identify waste) and Checklist to systematically check each resource category below. Apply the `tsh-managing-secrets` skill's Security Checklist when auditing the Security & Compliance category.
   - **Compute**: Compute Engine instances (machine type, generation, sustained use / committed use discounts), Managed Instance Groups (min/max/target size), Cloud Functions (memory, timeout, concurrency), Cloud Run services (CPU/memory, min/max instances, concurrency), GKE node pools (machine type, autoscaling, Spot VMs).
   - **Storage**: Persistent Disks (type — pd-standard/pd-balanced/pd-ssd/pd-extreme, size, attachment status, snapshots), Cloud Storage buckets (lifecycle policies, storage class — Standard/Nearline/Coldline/Archive, versioning, access patterns, retention policies), Filestore instances (tier, capacity).
   - **Databases**: Cloud SQL instances (tier, machine type, high availability, storage type, disk autoresize), AlloyDB clusters (instance count, machine type), Firestore (provisioned vs. on-demand mode), Bigtable clusters (node count, storage type — SSD/HDD), Memorystore instances (tier, memory size, Redis/Memcached).
   - **Networking**: Cloud NAT gateways (data processing costs), Private Service Connect / Private Google Access (vs. NAT savings), Static External IPs (unattached, reserved), Cloud Load Balancers (idle or underutilized — HTTP(S)/TCP/UDP/Internal), Cloud CDN (cache hit ratio, origin traffic), Cloud DNS managed zones, Cloud Interconnect / VPN (utilization).
   - **Containers & Orchestration**: GKE clusters (Autopilot vs. Standard, node pool sizing, Spot/preemptible nodes), Cloud Run (CPU allocation — always-on vs. request-based, idle instances), Artifact Registry repositories (cleanup policies, image count).
   - **Serverless**: Cloud Functions (invocation count, duration, provisioned concurrency), API Gateway / Apigee (tier, traffic), Workflows (execution count).
   - **AI/ML**: Vertex AI endpoints (machine type, autoscaling), Vertex AI training jobs, GPU instances (type — T4/L4/A100/H100, utilization), TPU usage.
   - **Security & Compliance**: VPC Firewall Rules (overly permissive rules — 0.0.0.0/0 ingress), Cloud KMS keys (unused, rotation policy), Cloud Armor policies (WAF rules), Certificate Manager certificates.
   - **Other**: Cloud Logging (log retention settings, log exclusions, log routing sinks), Pub/Sub (unused topics/subscriptions, message retention), Secret Manager (unused secrets), Data Transfer costs (cross-region, internet egress, inter-zone).

5. **Labeling & governance audit**:
   Apply the `tsh-optimizing-cloud-cost` skill's Required Tags table (adapted for GCP labels) and `references/tagging-standards.md` for the complete labeling framework.
   - Use `gcp-gcloud/*` MCP tools to read resource labels for all discovered resources.
   - Check every resource against the **"Core 5" Mandatory Labels** (`cost_center`, `environment`, `service`, `owner`, `data_class`) — GCP labels use lowercase with underscores.
   - **AI/ML checks**: If the resource is a GPU instance or Vertex AI endpoint, verify `model_id` and `training_job_id` labels exist.
   - **Security check**: Verify `data_class` label exists on all storage and database resources.
   - **Lifecycle check**: Flag resources with `environment:dev` running 24/7 that are missing the `schedule` label.

6. **Cost & performance analysis**:
   - Use `gcp-gcloud/*` MCP tools with Cloud Billing APIs (`gcloud billing budgets list`, BigQuery billing export tables) for actual cost data. If unavailable, estimate based on machine type and runtime hours.
   - Apply the `tsh-optimizing-cloud-cost` skill's **Pricing Model Decision** table (GCP column) to match each resource's workload type (steady-state, variable, fault-tolerant, serverless) to the optimal pricing model (sustained use discounts, committed use discounts, Spot VMs, per-second billing). Apply the **Storage Tiering Decision** table for all storage resources. Reference the skill's **Anti-Patterns** table to flag common cost mistakes.
   - Apply the `tsh-designing-multi-cloud-architecture` skill's GCP service comparison tables when evaluating service alternatives or considering migrations between GCP service tiers (e.g., Cloud SQL vs. AlloyDB, GKE Standard vs. Autopilot, Compute Engine vs. Cloud Run).
   - Use `context7` to cross-reference GCP documentation for the latest machine types, pricing tiers, and service availability in the target region before recommending any changes. This step is **mandatory** — do not recommend machine types or configurations without checking current GCP documentation first.
   - Use `context7` to cross-reference Terraform provider documentation for any IaC-related recommendations.
   - Use `sequential-thinking` MCP tool to evaluate trade-offs when comparing optimization options across multiple resources. This step is **mandatory** — do not skip it.
   - For each resource, produce 3 optimization paths per the DevOps agent's Output Strategy:
     - **Golden Path**: Balanced, standard recommendation.
     - **Cost-Optimized Path**: Maximum savings (Spot VMs, scale-to-zero, serverless migration, committed use discounts).
     - **Velocity Path**: Fastest performance, higher cost.

7. **Generate and save the analysis report**:

    > **IMPORTANT**: Save the report file **before** presenting results to the user. Do not ask for confirmation. Always use this filename pattern: `gcp-cost-audit-<project>-<region>-YYYY-MM-DD.md` (e.g. `gcp-cost-audit-my-project-us-central1-2026-03-05.md`). After saving, tell the user the full file path on one line, then present the formatted summary below.

    The saved Markdown file must be **polished and presentation-ready**. Follow every formatting rule below exactly — do not improvise:

    ---

    **Exact report structure and formatting rules:**

    ```
    # GCP Cost Optimization Audit
    **Project:** `<project-id>`   **Region:** `<region>`   **Date:** YYYY-MM-DD
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
    | 1 | `instance-prod-01` | `e2-standard-4` | `e2-standard-8` | Config drift |
    | 2 | `fw-allow-ssh` | Not in IaC | Active | Shadow resource |

    *(If no IaC found or no drift detected, state that clearly.)*

    ---

    ## 💰 Optimization Opportunities

    | # | Resource ID | Type | Current Config | Current Cost ($/mo) | Recommended Config | Est. New Cost ($/mo) | Savings ($/mo) | Path |
    |---|---|---|---|---|---|---|---|---|
    | 1 | `instance-prod-01` | Compute Engine | `e2-standard-4` | $140 | `e2-standard-2` | $70 | **$70** | 🟢 Golden |
    | 2 | `db-prod-01` | Cloud SQL | `db-custom-8-32768, 500 GB pd-ssd` | $820 | `db-custom-4-16384, 500 GB pd-balanced` | $510 | **$310** | 🔵 Cost-Opt |

    > Path legend: 🟢 Golden Path · 🔵 Cost-Optimized · 🚀 Velocity

    ---

    ## 🏷️ Label Compliance

    | # | Resource ID | Type | Missing Labels | Status |
    |---|---|---|---|---|
    | 1 | `instance-prod-01` | Compute Engine | `owner`, `data_class` | ❌ FAIL |
    | 2 | `my-bucket` | Cloud Storage | — | ✅ PASS |

    ---

    ## 🔒 Critical Security Findings

    | # | Resource ID | Type | Finding | Severity |
    |---|---|---|---|---|
    | 1 | `fw-allow-ssh` | Firewall Rule | Port 22 open to 0.0.0.0/0 | 🔴 HIGH |

    *(If none found, write: "No critical security findings detected.")*

    ---

    ## 📊 Summary

    | Metric | Value |
    |---|---|
    | Total current monthly spend | $X,XXX |
    | Total estimated optimized spend | $X,XXX |
    | **Total estimated savings** | **$X,XXX/mo (XX%)** |
    | Label compliance | XX% (X of Y resources fully labeled) |
    | IaC coverage | XX% (X of Y resources managed by IaC) |
    | Drift detected | X resources with configuration drift |
    | Data sources used | GCP API / Terraform code / Both |

    ---

    ## ✅ Recommended Action Order

    1. Apply optimization #X — highest savings, lowest risk
    2. ...
    ```

    Formatting constraints:
    - Use `---` horizontal rules between every major section.
    - Use emoji section icons exactly as shown (📋 🔍 💰 🏷️ 🔒 📊 ✅).
    - Use `❌ FAIL` / `✅ PASS` in label compliance status column — no bold-only text.
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
         1. **Load skills for the new directory**: Read the `tsh-codebase-analysing` skill (if not already loaded), the `tsh-technical-context-discovering` skill, and the `tsh-implementing-terraform-modules` skill. Apply them to the provided Terraform directory — specifically run `tsh-codebase-analysing` Step 7 (infrastructure code), Step 2 (dependencies), and Step 12 (dead code) against the Terraform codebase, follow `tsh-technical-context-discovering` to understand existing patterns, and use `tsh-implementing-terraform-modules` for module structure reference (including `references/gcp-modules.md`) before making changes.
         2. Ask which opportunity numbers to apply.
         3. Only then proceed with code generation, following patterns discovered by the skills.

    Do **not** proceed with any code generation or file modification until the user explicitly confirms which items to implement.

## Prompt-Specific Guardrails

All standard DevOps agent guardrails (Mutation Lock, Zero-Deletion Policy, FinOps Alerts) apply automatically. Additionally:
- This prompt is **analysis-only** by default — do not generate or modify code unless the user explicitly requests it in the next steps.
- Always warn before suggesting modifications to resources labeled `environment:prod`.
- All remediation output (gcloud CLI scripts, Terraform code) is for user review and manual execution only — never execute directly.
- When modifying existing Terraform code, show a diff preview of proposed changes before writing to files.
