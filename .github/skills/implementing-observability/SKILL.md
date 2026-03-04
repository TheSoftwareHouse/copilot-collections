---
name: implementing-observability
description: 'Observability patterns for logging, monitoring, alerting, and distributed tracing. Use when implementing metrics collection, log aggregation, alerting rules, or distributed tracing across services.'
---

# Observability Patterns

## When to Use

- Setting up monitoring and alerting for applications
- Implementing centralized logging
- Adding distributed tracing to microservices
- Designing SLOs/SLIs and error budgets
- Creating dashboards and runbooks

## Three Pillars of Observability

| Pillar | Purpose | Tools |
|--------|---------|-------|
| **Metrics** | Quantitative measurements over time | Prometheus, CloudWatch, Datadog, Grafana |
| **Logs** | Discrete events with context | ELK, Loki, CloudWatch Logs, Splunk |
| **Traces** | Request flow across services | Jaeger, Zipkin, X-Ray, Tempo |

## Stack Detection

Check which observability stack the project uses:
- `prometheus.yml` or `ServiceMonitor` → Prometheus
- `fluent-bit.conf` or `fluentd.conf` → Fluent Bit/Fluentd
- `otel-collector-config.yaml` → OpenTelemetry
- AWS with `aws_cloudwatch_*` resources → CloudWatch
- `datadog-agent` or `DD_*` env vars → Datadog

Use `context7` to look up stack-specific configuration syntax.

## Solution Decision Matrix

### Metrics Stack

| Scenario | Recommended Solution |
|----------|---------------------|
| Kubernetes-native, cost-sensitive | Prometheus + Grafana |
| AWS-native, simple setup | CloudWatch Metrics |
| Multi-cloud, enterprise | Datadog or New Relic |
| OpenTelemetry-first | Prometheus with OTLP receiver |

### Logging Stack

| Scenario | Recommended Solution |
|----------|---------------------|
| Kubernetes, cost-sensitive | Loki + Grafana |
| AWS-native | CloudWatch Logs |
| High volume, complex queries | Elasticsearch (ELK) |
| Multi-cloud, managed | Datadog Logs or Splunk |

### Tracing Stack

| Scenario | Recommended Solution |
|----------|---------------------|
| Kubernetes, open-source | Jaeger or Tempo |
| AWS-native | X-Ray |
| Multi-cloud, correlated | Datadog APM |
| Vendor-agnostic | OpenTelemetry → any backend |

## Kubernetes Observability Pattern

```
┌─────────────────────────────────────────────────────┐
│                   Applications                       │
│  (instrumented with OpenTelemetry SDK or auto-inst) │
└──────────────────────┬──────────────────────────────┘
                       │ OTLP
                       ▼
┌─────────────────────────────────────────────────────┐
│            OpenTelemetry Collector                   │
│  (receives, processes, exports telemetry)           │
└───────┬─────────────────┬─────────────────┬─────────┘
        │                 │                 │
        ▼                 ▼                 ▼
   Prometheus          Loki             Tempo/Jaeger
   (metrics)          (logs)            (traces)
        │                 │                 │
        └────────────────┬┴─────────────────┘
                         ▼
                      Grafana
                   (visualization)
```

## SLO/SLI Framework

### Key Metrics (RED Method for Services)

| Metric | Description | Example SLI |
|--------|-------------|-------------|
| **R**ate | Requests per second | `rate(http_requests_total[5m])` |
| **E**rrors | Failed requests | `rate(http_requests_total{status=~"5.."}[5m])` |
| **D**uration | Latency distribution | `histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))` |

### Key Metrics (USE Method for Resources)

| Metric | Description | Example |
|--------|-------------|---------|
| **U**tilization | % time resource is busy | CPU usage, memory usage |
| **S**aturation | Queue depth, waiting | Pod pending, connection pool |
| **E**rrors | Error count | OOM kills, disk errors |

### SLO Definition Template

```yaml
# Example: API availability SLO
slo:
  name: api-availability
  description: "API returns successful responses"
  sli:
    metric: |
      sum(rate(http_requests_total{status!~"5.."}[5m]))
      /
      sum(rate(http_requests_total[5m]))
  target: 99.9%
  window: 30d
  error_budget: 0.1%  # ~43 minutes/month downtime allowed
```

## Alerting Strategy

### Alert Severity Levels

| Severity | Response | Example |
|----------|----------|---------|
| **Critical** | Page on-call immediately | Service down, data loss risk |
| **Warning** | Investigate within hours | Error rate elevated, disk 80% |
| **Info** | Review during business hours | Deployment completed, scaling event |

### Alert Quality Rules

- **Actionable**: Every alert must have a clear response action
- **Relevant**: Alert on symptoms (user impact), not causes
- **Unique**: Avoid duplicate alerts for same incident
- **Timely**: Alert early enough to prevent impact

### Alert Template (Prometheus)

```yaml
groups:
  - name: api-alerts
    rules:
      - alert: HighErrorRate
        expr: |
          sum(rate(http_requests_total{status=~"5.."}[5m]))
          /
          sum(rate(http_requests_total[5m])) > 0.01
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value | humanizePercentage }} (threshold: 1%)"
          runbook_url: "https://runbooks.example.com/high-error-rate"
```

## Structured Logging

### Log Format (JSON)

```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "level": "error",
  "message": "Payment processing failed",
  "service": "payment-api",
  "trace_id": "abc123",
  "span_id": "def456",
  "user_id": "user-789",
  "error": {
    "type": "PaymentGatewayError",
    "message": "Connection timeout"
  },
  "context": {
    "payment_id": "pay-123",
    "amount": 99.99
  }
}
```

### Required Log Fields

| Field | Purpose | Correlation |
|-------|---------|-------------|
| `timestamp` | When event occurred | Time-based queries |
| `level` | Severity (debug/info/warn/error) | Filtering |
| `service` | Source service name | Service filtering |
| `trace_id` | Distributed trace identifier | Cross-service correlation |
| `message` | Human-readable description | Search |

## Process

1. **Discover context** → Check existing observability setup (Prometheus, CloudWatch, etc.)
2. **Choose stack** → Use decision matrix based on environment and requirements
3. **Instrument apps** → Add OpenTelemetry SDK or auto-instrumentation
4. **Configure collection** → Set up collectors, exporters, and storage
5. **Define SLOs** → Establish SLIs, targets, and error budgets
6. **Create alerts** → Implement actionable alerts with runbooks
7. **Build dashboards** → Create service and infrastructure dashboards
8. **Document runbooks** → Write response procedures for each alert

## Checklist

- [ ] All services emit metrics, logs, and traces
- [ ] Trace IDs propagated across service boundaries
- [ ] Structured logging with consistent format (JSON)
- [ ] SLOs defined with error budgets
- [ ] Alerts are actionable with runbook links
- [ ] Dashboards show service health at a glance
- [ ] Log retention policy configured
- [ ] PII/sensitive data excluded from logs
- [ ] On-call rotation defined for critical alerts

## Anti-Patterns

| Don't | Do |
|-------|-----|
| Alert on every metric threshold | Alert on user-impacting symptoms |
| Log everything at DEBUG in production | Use appropriate log levels |
| Unstructured log messages | Structured JSON logging |
| Missing trace context | Propagate trace IDs across services |
| Dashboards with 50+ panels | Focused dashboards per service/domain |
| Alerts without runbooks | Every alert links to response procedure |
| Store logs indefinitely | Define retention based on compliance needs |

## Related Skills

- `implementing-kubernetes` - For K8s-native observability setup
- `implementing-ci-cd` - For pipeline observability integration
- `managing-secrets` - For secure credential storage for observability tools
