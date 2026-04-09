---
sidebar_position: 15
title: /tsh-implement-observability
---

# /tsh-implement-observability

:::info
Not invoked directly by users. To trigger observability implementation, use [`/tsh-implement`](../public/implement) — the [Engineering Manager](../../agents/engineering-manager) will automatically delegate to the [DevOps Engineer](../../agents/devops-engineer).
:::

**Agent:** DevOps Engineer
**File:** `.github/internal-prompts/tsh-implement-observability.prompt.md`

Implements comprehensive observability solutions covering metrics, logs, traces, and alerting.

## How It’s Triggered

```text
/tsh-implement <describe what to monitor or observe>
```

The Engineering Manager identifies observability tasks in the plan and delegates them to the DevOps Engineer automatically.

## What It Does

### 1. Context Discovery

- Identifies existing monitoring stack (Prometheus, Grafana, Datadog, CloudWatch, etc.).
- Checks for existing dashboards, alert rules, and log aggregation patterns.
- Discovers service level objectives (SLOs) and key performance indicators (KPIs).

### 2. Implementation

- Sets up metrics collection with appropriate instrumentation.
- Configures log aggregation with structured logging patterns.
- Implements distributed tracing across services.
- Creates alerting rules with appropriate thresholds and escalation paths.
- Builds dashboards for system health visibility.

### 3. Verification

- Validates that metrics are being collected correctly.
- Ensures alert rules fire as expected with test scenarios.
- Verifies trace propagation across service boundaries.

## Skills Loaded

- `tsh-implementing-observability` — Observability patterns for logging, monitoring, alerting, tracing.
- `tsh-technical-context-discovering` — Project conventions and existing patterns.
