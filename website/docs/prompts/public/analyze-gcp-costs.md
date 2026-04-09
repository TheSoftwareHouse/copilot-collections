---
sidebar_position: 18
title: /tsh-analyze-gcp-costs
---

# /tsh-analyze-gcp-costs

**Agent:** DevOps Engineer
**File:** `.github/prompts/tsh-analyze-gcp-costs.prompt.md`

Performs a comprehensive GCP cost optimization and labeling compliance audit using a hybrid approach — analyzes IaC code first, then validates against live GCP infrastructure via API.

## Usage

```text
/tsh-analyze-gcp-costs <GCP Project ID, Region, or 'all'> <focus: specific service or 'everything'>
```

## What It Does

### 1. IaC Analysis

- Scans Terraform templates for GCP resource configurations.
- Identifies over-provisioned instances, missing committed use discounts, and inefficient storage classes.
- Checks labeling compliance against organizational policies.

### 2. Live Infrastructure Validation

- Queries GCP infrastructure via GCP Gcloud MCP to validate actual resource usage.
- Identifies orphaned resources, unused persistent disks, and idle load balancers.
- Checks for committed use discount coverage gaps.

### 3. Cost Report

- Produces a detailed cost optimization report with estimated savings.
- Prioritizes findings by potential monthly cost reduction.
- Includes specific gcloud CLI or Terraform changes for each recommendation.

## Skills Loaded

- `tsh-optimizing-cloud-cost` — Cloud cost optimization strategies and labeling policies.
- `tsh-technical-context-discovering` — Project conventions and existing patterns.
