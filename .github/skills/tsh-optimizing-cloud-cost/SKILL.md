---
name: tsh-optimizing-cloud-cost
description: 'Optimize cloud costs through resource rightsizing, tagging strategies, reserved instances, and spending analysis. Use when reducing cloud expenses, analyzing infrastructure costs, or implementing cost governance policies.'
---

# Cloud Cost Optimization

## When to Use

- Reducing cloud spending or meeting budget constraints
- Right-sizing resources based on utilization
- Implementing cost governance and tagging
- Analyzing multi-cloud cost optimization opportunities

## Pricing Model Decision

| Workload Type | AWS | Azure | GCP | Savings |
|---------------|-----|-------|-----|---------|
| Steady-state (24/7) | Reserved Instances / Savings Plans | Reserved VMs | Committed Use | 30-72% |
| Variable / burst | On-Demand + Auto-scaling | Pay-as-you-go | On-Demand | Baseline |
| Fault-tolerant batch | Spot Instances | Spot VMs | Preemptible | Up to 90% |
| Serverless / event-driven | Lambda | Functions | Cloud Functions | Pay-per-use |

## Storage Tiering Decision

| Data Access Pattern | AWS | Azure | GCP |
|---------------------|-----|-------|-----|
| Frequent (hot) | S3 Standard | Hot | Standard |
| Infrequent (30+ days) | S3 Standard-IA | Cool | Nearline |
| Rare (90+ days) | S3 Glacier | Cold | Coldline |
| Archive (365+ days) | S3 Deep Archive | Archive | Archive |

**Rule:** Implement lifecycle policies to auto-transition data between tiers.

## Required Tags

| Tag | Purpose | Example |
|-----|---------|---------|
| `Environment` | Cost allocation by env | `production`, `staging` |
| `Project` | Cost allocation by project | `my-project` |
| `CostCenter` | Finance reporting | `engineering` |
| `Owner` | Contact for unused resources | `team@example.com` |
| `ManagedBy` | Track IaC vs manual | `terraform` |

**Reference:** See `references/tagging-standards.md` for full standards.

## Process

1. **Audit current spend** → Use Cost Explorer / Cost Management to identify top costs
2. **Tag all resources** → Apply required tags for cost allocation
3. **Identify waste** → Find unused EBS, EIPs, snapshots, idle instances
4. **Right-size resources** → Use Compute Optimizer / Advisor recommendations
5. **Apply pricing models** → Reserved/Committed for steady, Spot for batch
6. **Implement tiering** → Storage lifecycle policies, database right-sizing
7. **Set up alerts** → Budget alerts at 50%, 80%, 100% thresholds
8. **Schedule reviews** → Weekly cost review, monthly optimization

## Checklist

- [ ] Cost allocation tags applied to all resources
- [ ] Unused resources deleted (EBS, EIPs, snapshots, idle instances)
- [ ] Instances right-sized based on utilization metrics
- [ ] Reserved capacity purchased for steady workloads (>70% utilization)
- [ ] Spot/preemptible used for fault-tolerant workloads
- [ ] Storage lifecycle policies configured
- [ ] Budget alerts enabled (50%, 80%, 100%)
- [ ] Cost anomaly detection enabled
- [ ] Auto-scaling configured for variable workloads

## Anti-Patterns

| ❌ Don't | ✅ Do |
|----------|-------|
| Over-provision "just in case" | Right-size based on metrics, scale up if needed |
| Use On-Demand for steady workloads | Use Reserved/Committed for predictable usage |
| Store all data in hot tier | Implement lifecycle policies |
| Skip tagging | Tag everything for cost visibility |
| Review costs monthly | Review weekly, alert on anomalies |

## Tools

| Provider | Tools |
|----------|-------|
| AWS | Cost Explorer, Cost Anomaly Detection, Compute Optimizer |
| Azure | Cost Management, Advisor |
| GCP | Cost Management, Recommender |
| Multi-cloud | CloudHealth, Cloudability, Kubecost |

## Reference Files

- `references/tagging-standards.md` - Tagging conventions and enforcement

## Related Skills

- `tsh-implementing-terraform-modules` - For resource provisioning
- `tsh-designing-multi-cloud-architecture` - For cloud selection
