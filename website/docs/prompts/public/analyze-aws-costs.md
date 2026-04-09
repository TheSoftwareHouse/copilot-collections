---
sidebar_position: 17
title: /tsh-analyze-aws-costs
---

# /tsh-analyze-aws-costs

**Agent:** DevOps Engineer
**File:** `.github/prompts/tsh-analyze-aws-costs.prompt.md`

Performs a comprehensive AWS cost optimization and tagging compliance audit using a hybrid approach — analyzes IaC code first, then validates against live AWS infrastructure via API.

## Usage

```text
/tsh-analyze-aws-costs <AWS Account/Profile, Region, or 'all'> <focus: specific service or 'everything'>
```

## What It Does

### 1. IaC Analysis

- Scans Terraform and CloudFormation templates for resource configurations.
- Identifies over-provisioned instances, missing reserved instance opportunities, and inefficient storage tiers.
- Checks tagging compliance against organizational policies.

### 2. Live Infrastructure Validation

- Queries AWS API MCP to validate actual resource usage against IaC definitions.
- Identifies orphaned resources, unused EBS volumes, idle load balancers.
- Checks for savings plan and reserved instance coverage gaps.

### 3. Cost Report

- Produces a detailed cost optimization report with estimated savings.
- Prioritizes findings by potential monthly cost reduction.
- Includes specific AWS CLI or Terraform changes for each recommendation.

## Skills Loaded

- `tsh-optimizing-cloud-cost` — Cloud cost optimization strategies and tagging policies.
- `tsh-technical-context-discovering` — Project conventions and existing patterns.
