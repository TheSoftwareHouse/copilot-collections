---
agent: "tsh-devops-engineer"
model: "Claude Opus 4.6"
description: "Create or modify CI/CD pipelines with deployment stages and environment protection."
argument-hint: "[describe the pipeline to create or modify]"
---

# CI/CD Pipeline Implementation Workflow

This prompt creates or modifies CI/CD pipelines with proper deployment stages, environment protection, and secure authentication. It implements pipelines that follow established patterns for the project's platform (GitHub Actions, GitLab CI, Bitbucket Pipelines) with optimized caching and parallelization.

The workflow configures OIDC authentication for cloud providers, sets up environment-specific secrets handling, and implements appropriate deployment strategies (rolling, blue-green, canary). Complex GitOps workflows and multi-environment promotion pipelines are escalated to the architect agent for design validation.

## Required Skills
Before starting, load and follow these skills:
- `tsh-implementing-ci-cd` - for pipeline patterns, deployment strategies, and GitOps workflows
- `tsh-managing-secrets` - for OIDC authentication setup and secrets handling
- `tsh-technical-context-discovering` - to establish project conventions and existing pipeline patterns

---

## 1. Context

Follow the `tsh-technical-context-discovering` skill to identify existing CI/CD setup.

Additionally, always:
- Check `*.instructions.md` → project-specific conventions
- Analyze existing pipeline configurations (GitHub Actions, GitLab CI, Bitbucket, etc.)
- Discover branching strategy and deployment targets

---

## 2. Implementation

Follow the `tsh-implementing-ci-cd` skill for:
- Pipeline stages (lint, test, build, deploy)
- Deployment strategies (rolling, blue-green, canary)
- Caching and optimization

Follow the `tsh-managing-secrets` skill for:
- OIDC authentication for cloud providers
- Secrets configuration in CI/CD platform
- Environment-specific variables

---

## 3. Architect Consultation

Spawn `tsh-architect` sub-agent when:
- Designing new deployment strategies (blue-green, canary)
- Setting up multi-environment promotion pipelines
- Implementing complex GitOps workflows

Skip for: adding test stages, fixing pipeline bugs, updating versions, adding caching.

---

## 4. Summary (required output)

```markdown
## CI/CD Pipeline Summary

### Current State
- [existing CI/CD configuration]

### Proposed Pipeline
- Platform: [GitHub Actions / GitLab CI / etc.]
- Stages: [list of stages]
- Deployment strategy: [rolling / blue-green / canary]

### Required Setup
| Secret/Variable | Description | Where to configure |
|-----------------|-------------|-------------------|

### Testing Instructions
- [how to validate the pipeline works]

### Files
- NEW/MODIFIED: [list of files created or modified]
```

---

## Scope

**Does NOT handle** (redirect to):
- Infrastructure provisioning → `/tsh-implement-terraform`
- Kubernetes deployment configuration → `/tsh-deploy-kubernetes`
- Monitoring and alerting → `/tsh-implement-observability`

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-implement-pipeline:v1 -->
