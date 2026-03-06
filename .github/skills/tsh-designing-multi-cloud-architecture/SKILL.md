---
name: tsh-designing-multi-cloud-architecture
description: Design multi-cloud architectures using a decision framework to select and integrate services across AWS, Azure, and GCP. Use when building multi-cloud systems, avoiding vendor lock-in, or leveraging best-of-breed services from multiple providers.
---

# Multi-Cloud Architecture

Decision framework and patterns for architecting applications across AWS, Azure, and GCP.

## Purpose

Design cloud-agnostic architectures and make informed decisions about service selection across cloud providers.

## When to Use

- Design multi-cloud strategies
- Migrate between cloud providers
- Select cloud services for specific workloads
- Implement cloud-agnostic architectures
- Optimize costs across providers

## Cloud Service Comparison

### Compute Services

| AWS     | Azure               | GCP             | Use Case           |
| ------- | ------------------- | --------------- | ------------------ |
| EC2     | Virtual Machines    | Compute Engine  | IaaS VMs           |
| ECS     | Container Instances | Cloud Run       | Containers         |
| EKS     | AKS                 | GKE             | Kubernetes         |
| Lambda  | Functions           | Cloud Functions | Serverless         |
| Fargate | Container Apps      | Cloud Run       | Managed containers |

### Storage Services

| AWS     | Azure           | GCP             | Use Case       |
| ------- | --------------- | --------------- | -------------- |
| S3      | Blob Storage    | Cloud Storage   | Object storage |
| EBS     | Managed Disks   | Persistent Disk | Block storage  |
| EFS     | Azure Files     | Filestore       | File storage   |
| Glacier | Archive Storage | Archive Storage | Cold storage   |

### Database Services

| AWS         | Azure            | GCP           | Use Case        |
| ----------- | ---------------- | ------------- | --------------- |
| RDS         | SQL Database     | Cloud SQL     | Managed SQL     |
| DynamoDB    | Cosmos DB        | Firestore     | NoSQL           |
| Aurora      | PostgreSQL/MySQL | Cloud Spanner | Distributed SQL |
| ElastiCache | Cache for Redis  | Memorystore   | Caching         |

**Reference:** See `references/service-comparison.md` for complete comparison

## Multi-Cloud Patterns

### Pattern 1: Single Provider with DR

- Primary workload in one cloud
- Disaster recovery in another
- Database replication across clouds
- Automated failover

### Pattern 2: Best-of-Breed

- Use best service from each provider
- AI/ML on GCP
- Enterprise apps on Azure
- General compute on AWS

### Pattern 3: Geographic Distribution

- Serve users from nearest cloud region
- Data sovereignty compliance
- Global load balancing
- Regional failover

### Pattern 4: Cloud-Agnostic Abstraction

- Kubernetes for compute
- PostgreSQL for database
- S3-compatible storage (MinIO)
- Open source tools

## Cloud-Agnostic Architecture

### Use Cloud-Native Alternatives

- **Compute:** Kubernetes (EKS/AKS/GKE)
- **Database:** PostgreSQL/MySQL (RDS/SQL Database/Cloud SQL)
- **Message Queue:** Apache Kafka (MSK/Event Hubs/Confluent)
- **Cache:** Redis (ElastiCache/Azure Cache/Memorystore)
- **Object Storage:** S3-compatible API
- **Monitoring:** Prometheus/Grafana
- **Service Mesh:** Istio/Linkerd

### Abstraction Layers

```
Application Layer
    ↓
Infrastructure Abstraction (Terraform)
    ↓
Cloud Provider APIs
    ↓
AWS / Azure / GCP
```

## Cost Comparison

### Compute Pricing Factors

- **AWS:** On-demand, Reserved, Spot, Savings Plans
- **Azure:** Pay-as-you-go, Reserved, Spot
- **GCP:** On-demand, Committed use, Preemptible

### Cost Optimization Strategies

1. Use reserved/committed capacity (30-70% savings)
2. Leverage spot/preemptible instances
3. Right-size resources
4. Use serverless for variable workloads
5. Optimize data transfer costs
6. Implement lifecycle policies
7. Use cost allocation tags
8. Monitor with cloud cost tools

**Reference:** See `references/multi-cloud-patterns.md`

## Migration Strategy

### Phase 1: Assessment

- Inventory current infrastructure
- Identify dependencies
- Assess cloud compatibility
- Estimate costs

### Phase 2: Pilot

- Select pilot workload
- Implement in target cloud
- Test thoroughly
- Document learnings

### Phase 3: Migration

- Migrate workloads incrementally
- Maintain dual-run period
- Monitor performance
- Validate functionality

### Phase 4: Optimization

- Right-size resources
- Implement cloud-native services
- Optimize costs
- Enhance security

## Process

1. **Assess requirements** → Identify drivers (DR, compliance, best-of-breed, cost)
2. **Choose pattern** → Select from patterns above based on requirements
3. **Map services** → Use service comparison tables to select equivalents
4. **Design abstraction** → Use Kubernetes + Terraform for portability
5. **Plan networking** → Design cross-cloud connectivity (VPN, interconnect)
6. **Implement IaC** → Use `tsh-implementing-terraform-modules` skill
7. **Set up observability** → Unified monitoring across clouds
8. **Document runbooks** → Cloud-specific operational procedures

## Checklist

- [ ] Multi-cloud drivers documented (DR, compliance, vendor diversification)
- [ ] Service equivalents mapped across target clouds
- [ ] Abstraction layer chosen (Kubernetes, Terraform, or both)
- [ ] Cross-cloud networking designed and secured
- [ ] Identity federation configured (single IAM source of truth)
- [ ] Unified monitoring and logging implemented
- [ ] Cost allocation and tracking across clouds
- [ ] DR/failover procedures tested
- [ ] Team trained on all target cloud platforms

## Anti-Patterns

| ❌ Don't | ✅ Do |
|----------|-------|
| Use proprietary services for portability needs | Choose cloud-agnostic alternatives (K8s, PostgreSQL) |
| Duplicate everything across clouds | Be intentional about what runs where |
| Manage each cloud differently | Use unified IaC and observability |
| Ignore data transfer costs | Design to minimize cross-cloud traffic |

## Reference Files

- `references/service-comparison.md` - Complete service comparison
- `references/multi-cloud-patterns.md` - Architecture patterns

## Related Skills

- `tsh-implementing-terraform-modules` - For IaC implementation
- `tsh-optimizing-cloud-cost` - For cost management
