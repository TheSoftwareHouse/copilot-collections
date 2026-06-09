# Observability Implementation Workflow

This prompt implements comprehensive observability solutions covering metrics, logs, traces, and alerting. It establishes monitoring infrastructure that enables teams to understand system behavior, detect issues proactively, and maintain service level objectives through well-designed dashboards and alert rules.

The workflow follows RED/USE methodology for metrics collection, configures appropriate SLOs/SLIs with error budgets, and creates actionable alerts linked to runbooks. Decisions about new observability stacks, cross-service tracing architecture, or compliance-sensitive logging are escalated to the architect agent.

## Required Skills
Before starting, load and follow these skills:
- `tsh-implementing-observability` - for metrics, logs, traces, alerting patterns, SLO definitions, and dashboard design
- `tsh-technical-context-discovering` - to establish project conventions and existing monitoring patterns

---

## 1. Context

Follow the `tsh-technical-context-discovering` skill to identify existing observability setup.

Additionally, always:
- **Read the delegated task block first** — Read the delegated task block in the plan and only the files/resources named in its `Read First` list. Use that task block as the primary source of truth for metric names, log fields, trace spans, alert thresholds, and any rollout or verification notes. Do not rely on global plan sections or broader execution-support packages.
- Check `*.instructions.md` only for aspects **not covered** by the task block or its named reading
- Analyze existing monitoring configurations (Prometheus, Grafana, CloudWatch, etc.)
- Discover existing alerting rules and dashboards

Treat labeled pseudocode, tables, diagrams, and contracts in the task block as illustrative guidance only. They are not production configuration to copy verbatim.

---

## 2. Implementation

Follow the `tsh-implementing-observability` skill for:
- Metrics collection configuration
- Log aggregation setup
- Distributed tracing instrumentation
- SLO/SLI definitions with error budgets
- Alert rules with runbooks
- Dashboard design

---

## 3. Architect Consultation

Spawn `tsh-architect` sub-agent when:
- Selecting observability stack for greenfield projects
- Designing cross-service tracing architecture
- Implementing centralized logging with compliance requirements

Skip for: adding alerts, creating dashboards, configuring log retention, adding metrics to existing stack.

---

## 4. Summary (required output)

```markdown
## Observability Implementation Summary

### Current State
- [existing observability infrastructure]

### Proposed Stack
- Metrics: [tool and configuration]
- Logs: [tool and configuration]
- Traces: [tool and configuration]

### SLO Definitions
| Service | SLI | Target | Error Budget |
|---------|-----|--------|--------------|

### Alert Rules
| Alert | Condition | Severity | Runbook |
|-------|-----------|----------|---------|

### Dashboards
- [list of dashboard definitions]

### Instrumentation Guide
- [what application teams need to add, if any]

### Files
- NEW/MODIFIED: [list of files created or modified]
```

---

## Scope

**Does NOT handle** (redirect to):
- Application code instrumentation → coordinate with software engineer
- Infrastructure provisioning → `/tsh-implement-terraform`
- CI/CD pipelines → `/tsh-implement-pipeline`

<!-- TSH_COPILOT_COLLECTIONS:prompt:tsh-implement-observability:v2 -->
