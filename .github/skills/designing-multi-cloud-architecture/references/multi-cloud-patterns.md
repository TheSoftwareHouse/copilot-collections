# Multi-Cloud Architecture Patterns

Detailed reference for multi-cloud design patterns, integration strategies, and implementation guidance.

---

## Pattern 1: Single Provider with Disaster Recovery (DR)

### Overview

Run all production workloads in a primary cloud provider while maintaining a warm or cold standby in a secondary provider for failover.

### Architecture

```
                    ┌─────────────────────────────────────────┐
                    │            Global DNS / GTM              │
                    └────────────┬──────────────────┬──────────┘
                                 │ (primary)        │ (failover)
                    ┌────────────▼──────────┐  ┌────▼─────────────────┐
                    │   Cloud A (AWS)        │  │  Cloud B (Azure/GCP) │
                    │  ─────────────────     │  │  ─────────────────── │
                    │  App Servers (active)  │  │  App Servers (warm)  │
                    │  Database (primary)    │  │  Database (replica)  │
                    │  Object Storage        │  │  Object Storage sync │
                    └───────────────────────┘  └──────────────────────┘
                                      ↑ DB replication ↑
```

### When to Use

- Compliance requires geographic or provider separation
- SLA requires RPO < 1h and RTO < 4h
- Budget does not justify active-active

### Implementation Steps

1. Deploy full application stack in primary cloud (AWS/Azure/GCP)
2. Set up cross-cloud database replication (e.g., PostgreSQL streaming replication or AWS DMS)
3. Synchronise object storage using rclone, AWS DataSync, or Azure Data Factory
4. Configure health-check-based DNS failover (Route 53, Azure Traffic Manager, Cloud DNS)
5. Automate failover with runbooks and test quarterly

### Tool Recommendations

| Concern | Tool |
|---|---|
| IaC | Terraform (multi-provider) |
| DNS / GTM | CloudFlare / Route 53 / Azure Traffic Manager |
| DB replication | PostgreSQL streaming, AWS DMS, Google Datastream |
| Storage sync | rclone, AWS DataSync |
| Failover automation | AWS Systems Manager, Azure Automation |

---

## Pattern 2: Best-of-Breed (Polycloud)

### Overview

Select the best service from each cloud provider for different parts of the architecture. Route workloads to the provider that offers the best capability, price, or compliance fit.

### Architecture

```
                Application Plane
                ┌──────────────────────────────────────────────────────────┐
                │  API Gateway (Kong / AWS API GW / Azure APIM)            │
                └───────┬───────────────────┬──────────────────────────────┘
                        │                   │
           ┌────────────▼───────┐  ┌────────▼──────────────────┐
           │  AWS                │  │  GCP                      │
           │  ─────────────────  │  │  ───────────────────────  │
           │  General Compute    │  │  AI / ML Workloads        │
           │  S3 Object Storage  │  │  BigQuery Analytics       │
           │  SQS / SNS          │  │  Vertex AI                │
           └────────────────────┘  └───────────────────────────┘
                        │
           ┌────────────▼────────────────────┐
           │  Azure                           │
           │  ──────────────────────────────  │
           │  Active Directory / AAD          │
           │  Microsoft 365 Integration       │
           │  Hybrid enterprise connectivity  │
           └─────────────────────────────────┘
```

### Typical Service Allocation

| Domain | Recommended Provider | Rationale |
|---|---|---|
| Enterprise IAM | Microsoft Entra ID (formerly Azure AD) | Deep M365 / Windows integration |
| AI / ML training | GCP (Vertex AI, TPUs) | Best price/performance for ML |
| General compute | AWS EC2 / EKS | Broadest service catalog |
| Object storage | AWS S3 | De-facto standard API |
| Data warehousing | GCP BigQuery | Serverless, near-unlimited scale |
| Networking / CDN | CloudFlare + AWS CloudFront | Performance + security |

### Integration Patterns

- **Service mesh** (Istio with multi-cluster) for cross-cloud service discovery
- **Event bridge** (EventBridge + Azure Event Grid + GCP Pub/Sub) with a CloudEvents envelope
- **Unified secrets** via HashiCorp Vault or external-secrets operator
- **Centralised observability** via Grafana Cloud or Datadog

---

## Pattern 3: Geographic Distribution

### Overview

Deploy application stacks in cloud regions that are closest to user populations. Use global load balancing to route requests by latency or data-sovereignty rules.

### Architecture

```
              Users (global)
                    │
         ┌──────────▼──────────┐
         │  Global Load Balancer│  (CloudFlare / GCP GLB / AWS Global Accelerator)
         └──┬──────────────┬───┘
            │              │
  ┌─────────▼────┐  ┌───────▼──────────┐
  │ AWS us-east-1│  │ Azure europewest  │
  │ App + DB     │  │ App + DB         │
  └──────────────┘  └──────────────────┘
            │              │
  ┌─────────▼────────────────────────┐
  │  GCP asia-southeast1             │
  │  App + DB                        │
  └──────────────────────────────────┘
```

### Data Sovereign Awareness

- Define per-region data classification tags in Terraform
- Enforce data residency with OPA / AWS SCP / Azure Policy / GCP Organisation Policy
- Replicate only non-PII data cross-region

### Implementation Checklist

- [ ] Map user populations to cloud regions
- [ ] Identify data-residency requirements per country / regulation
- [ ] Choose global traffic manager (latency-based vs geo-routing)
- [ ] Deploy independent stacks per region using Terraform workspaces or Terragrunt
- [ ] Configure cross-region health checks and automated failover
- [ ] Test with synthetic probes from each region

---

## Pattern 4: Cloud-Agnostic Abstraction

### Overview

Build on open-source or standardised primitives that run identically across providers. Maximise portability; minimise proprietary lock-in.

### Abstraction Stack

```
  ┌─────────────────────────────────────────────┐
  │  Application (containers / microservices)    │
  ├─────────────────────────────────────────────┤
  │  Platform Abstractions                        │
  │  • Kubernetes (EKS / AKS / GKE)             │
  │  • PostgreSQL (RDS / Azure DB / Cloud SQL)   │
  │  • Redis (ElastiCache / Azure Cache / MS)   │
  │  • Kafka (MSK / Event Hubs / Confluent)      │
  │  • S3-compatible storage (MinIO)             │
  ├─────────────────────────────────────────────┤
  │  Infrastructure as Code (Terraform / OpenTofu)│
  ├─────────────────────────────────────────────┤
  │  Cloud Provider APIs (AWS / Azure / GCP)     │
  └─────────────────────────────────────────────┘
```

### Key Tooling

| Layer | Tool | Notes |
|---|---|---|
| Containers | Kubernetes | Use Helm charts for portability |
| IaC | Terraform / OpenTofu | Multi-provider state |
| Service mesh | Istio | Unified mTLS + observability |
| Secrets | HashiCorp Vault | Works on all clouds |
| CI/CD | GitHub Actions / GitLab CI | Cloud-agnostic pipelines |
| Observability | Prometheus + Grafana | Open standards |
| Object storage | MinIO (S3 API) | Cloud-portable |
| Policy | OPA / Gatekeeper | Consistent guardrails |

### Trade-offs

| Benefit | Cost |
|---|---|
| Maximum portability | Forfeits managed-service convenience |
| No vendor lock-in | Higher operational overhead |
| Consistent tooling | Possibly higher infrastructure cost |
| Team skill portability | Slower to adopt cloud-native features |

---

## Pattern 5: Cloud Bursting

### Overview

Run baseline workloads on-premises or in a primary cloud; burst overflow capacity to a secondary cloud during peak demand.

### Architecture

```
  ┌────────────────────────┐       ┌─────────────────────────────┐
  │  Primary Cloud / On-Prem│       │  Burst Cloud (any provider)  │
  │  (baseline capacity)    │──────▶│  (scale-out capacity)        │
  └────────────────────────┘       └─────────────────────────────┘
           ▲ autoscaler triggers burst when CPU/queue threshold exceeded
```

### When to Use

- Batch / HPC workloads with infrequent but large spikes
- Existing on-premises investment that cannot be fully migrated yet
- Cost-sensitive: 80% baseline on reserved, 20% burst on spot

### Implementation Notes

- Use Kubernetes Cluster API or Karpenter for dynamic node provisioning across clouds
- Leverage spot/preemptible VMs in burst cloud for maximum savings
- Ensure burst cloud has access to shared data layer (NFS, object storage) before scaling

---

## Pattern 6: Data Mesh / Analytics on Best Provider

### Overview

Centralise analytics on the cloud with the best data warehouse offering (typically GCP BigQuery) while keeping operational databases on the primary cloud.

### Flow

```
  Operational DBs (AWS RDS / Aurora)
          │
          │  Change Data Capture (Debezium / DMS / Datastream)
          ▼
  Streaming Layer (Kafka / Pub/Sub / Kinesis)
          │
          ▼
  Data Warehouse (GCP BigQuery / Snowflake)
          │
          ▼
  BI / Analytics (Looker / Tableau / Power BI)
```

---

## Decision Framework

Use the following decision tree to select the appropriate pattern:

```
Is DR / HA across providers required?
  └─ Yes → Pattern 1 (Single Provider + DR) or Pattern 3 (Geo Distribution)

Is the primary goal to use best cloud services per domain?
  └─ Yes → Pattern 2 (Best-of-Breed)

Is vendor lock-in the primary concern?
  └─ Yes → Pattern 4 (Cloud-Agnostic Abstraction)

Is workload bursty with on-prem baseline?
  └─ Yes → Pattern 5 (Cloud Bursting)

Is analytics / BI the primary cross-cloud integration point?
  └─ Yes → Pattern 6 (Data Mesh)
```

---

## Cross-Cutting Concerns

### Identity & Access Management

- Use federated identity (OIDC / SAML) across providers
- Centralise in Microsoft Entra ID (formerly Azure AD) or Okta when enterprise M365 is in use
- Apply least-privilege on all cloud accounts via IaC

### Networking

- Use private connectivity (AWS PrivateLink, Azure Private Link, GCP Private Service Connect) between clouds where possible
- VPN or dedicated interconnects (AWS Direct Connect + Azure ExpressRoute) for high-throughput or low-latency paths
- Zero-trust networking model: no implicit trust between cloud segments

### Observability

- Collect metrics, logs, and traces using OpenTelemetry
- Ship to a neutral SIEM / APM (Datadog, Grafana Cloud, Elastic)
- Avoid cloud-native logging silos (CloudWatch, Azure Monitor, Cloud Logging) as the *only* sink

### Security & Compliance

- Centralised CSPM (Wiz, Prisma Cloud, Lacework) across all cloud accounts
- Unified policy engine (OPA) deployed via CI/CD
- Automated compliance scanning in all pipelines
- Shared responsibility model documented per provider

### Cost Management

- Tag all resources with `environment`, `team`, `cost-centre`, and `project`
- Use a cross-cloud FinOps platform (CloudHealth, Apptio Cloudability, FOCUS standard)
- Set budget alerts in each cloud; roll up to a central dashboard
- Review reserved/committed usage quarterly

---

## Related References

- [Service Comparison](./service-comparison.md)
- [Terraform Module Library Skill](../../terraform-module-library/SKILL.md)
- [Cost Optimization Skill](../../cost-optimization/SKILL.md)
