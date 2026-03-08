---
sidebar_position: 8
title: DevOps Engineer
---

# DevOps Engineer Agent

**File:** `.github/agents/tsh-devops-engineer.agent.md`

The DevOps Engineer agent is a Senior DevOps Engineer and Consultant that propagates DevOps culture, builds "Golden Path" templates, and manages cloud infrastructure, CI/CD pipelines, observability, and cost optimization.

## Responsibilities

- Infrastructure automation with Terraform and Kubernetes.
- CI/CD pipeline design and implementation.
- Cloud cost optimization and tagging compliance audits.
- Observability and monitoring setup (logging, metrics, traces, alerting).
- Secrets management and security hardening.
- Multi-cloud architecture guidance (AWS, Azure, GCP).

## Key Behaviors

- **Non-interactive** — Makes reasonable decisions autonomously and documents assumptions.
- **Delegates architecture decisions** — Spawns `tsh-architect` as a sub-agent for infrastructure design, multi-region topology, or new feature architecture.
- **Safety-first** — Prefers `--dry-run`, `plan`, or `validate` before destructive operations. Never runs `apply`, `delete`, or `destroy` without explicit user authorization.
- **IaC-only** — Never makes manual cloud console changes or ad-hoc CLI mutations outside of code.
- **Cost-aware** — Every infrastructure proposal includes cost impact. Flags proposals exceeding 10% spend increase.

## Tool Access

| Tool                      | Usage                                                                        |
| ------------------------- | ---------------------------------------------------------------------------- |
| **Context7**              | Search cloud provider documentation, Terraform registry, Kubernetes API docs |
| **Sequential Thinking**   | Analyze complex infrastructure decisions, debug deployment issues            |
| **AWS API**               | Query live AWS infrastructure, validate resources, check configurations      |
| **AWS Documentation**     | Reference AWS service documentation and best practices                       |
| **GCP Gcloud**            | Google Cloud operations and resource management                              |
| **GCP Observability**     | Google Cloud monitoring and observability integration                        |
| **GCP Storage**           | Google Cloud Storage resource management                                     |
| **Terminal**              | Run Terraform, kubectl, Helm, and other CLI tools                            |
| **File Read/Edit/Search** | Read, modify, and search workspace files                                     |
| **Sub-agents**            | Delegate to `tsh-architect` for architectural decisions                      |

## Skills Loaded

- `tsh-technical-context-discovering` — Project conventions and infrastructure patterns.
- `tsh-codebase-analysing` — Understand existing Terraform, Helm, K8s manifests, and infrastructure codebase.
- `tsh-implementing-ci-cd` — CI/CD pipeline design patterns and deployment strategies.
- `tsh-implementing-kubernetes` — Kubernetes deployment patterns, Helm charts, cluster management.
- `tsh-implementing-terraform-modules` — Reusable Terraform modules for AWS, Azure, and GCP.
- `tsh-implementing-observability` — Observability patterns for logging, monitoring, alerting, tracing.
- `tsh-managing-secrets` — Secrets management for cloud and Kubernetes environments.
- `tsh-optimizing-cloud-cost` — Cloud cost optimization through rightsizing and tagging.
- `tsh-designing-multi-cloud-architecture` — Multi-cloud architecture design across providers.

## Context Discovery

Before implementing, the agent discovers context in this order:

1. **Project instructions** — `.devops/instructions.md`, `infrastructure/README.md`, `*.instructions.md`.
2. **CI/CD platform** — GitHub Actions, Bitbucket Pipelines, GitLab CI, Jenkins.
3. **IaC patterns** — Terraform, Terragrunt, Kubernetes, Helm, Kustomize, CloudFormation, CDK.
4. **Policy & secrets** — `.rego`, `.sops.yaml`, `sealed-secrets/`, `vault-config/`.
5. **Greenfield** — If no patterns exist, gathers requirements and delegates to Architect.

## Handoffs

After completing infrastructure work, the DevOps Engineer can hand off to:

- **Code Reviewer** → `/tsh-review` (review IaC and pipeline changes)
