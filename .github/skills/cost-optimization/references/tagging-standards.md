# Cloud Resource Tagging Standards

## 1. Governance & Automation Strategy
* **Enforcement**: Tags are enforced via "Tag Policies" in AWS Organizations.
* **Case Sensitivity**: All Keys must use `PascalCase`; Values must use `lowercase-with-hyphens`.
* **IaC Requirement**: All Terraform/CDK modules must inject `Mandatory Tags` automatically.

## 2. Mandatory Tags (The "Core 5")
Resources without these tags will be flagged for **termination in 24 hours**.

| Tag Key | Example Value | Description | FOCUS Mapping |
| :--- | :--- | :--- | :--- |
| `CostCenter` | `cc-102` | Billing code for chargeback. | `Cost Center` |
| `Environment` | `dev`, `staging`, `prod` | Deployment stage. | `Environment` |
| `Service` | `auth-api`, `data-lake` | Name of the specific workload. | `Service Name` |
| `Owner` | `platform-team` | Team responsible for the resource. | `Resource Owner` |
| `DataClass` | `public`, `confidential`, `pii` | Security classification level. | N/A |

## 3. Workload-Specific Tags (Contextual)

### A. AI & ML Workloads (Critical for 2026)
* `ModelID`: (e.g., `llama-3-70b`, `gpt-4-finetune`) - Tracks spend per model.
* `TrainingJobId`: Links cost to specific training runs.
* `InferenceType`: `realtime` or `batch`.

### B. Automation & Lifecycle
* `Schedule`: `business-hours-only` (Used by Instance Scheduler to stop instances at night).
* `Temporary`: `true` (Must include `TTL` tag).
* `TTL`: `2026-12-31` (Date resource must be destroyed).

## 4. Compliance Rules
* **Untagged Resources**: Auto-quarantined by Lambda `finops-tag-remediation`.
* **Dev Limits**: `Environment:dev` cannot use instance families larger than `2xlarge` without `ExceptionID` tag.