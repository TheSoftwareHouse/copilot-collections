# GCP Terraform Module Patterns

## VPC Module

- Custom-mode VPC (avoid auto-mode)
- Subnets with secondary IP ranges for GKE pods/services
- Cloud Router and Cloud NAT for private subnet egress
- Firewall rules (ingress/egress)
- VPC peering / Shared VPC support
- Private Google Access per subnet

## GKE Module

- GKE standard or autopilot cluster
- Private cluster with authorised networks
- Workload Identity (`workload_identity_config { workload_pool = "PROJECT_ID.svc.id.goog" }`)
- Node pools with autoscaling
- Binary Authorization
- Shielded nodes
- Dataplane V2 / ADVANCED_DATAPATH (`datapath_provider = "ADVANCED_DATAPATH"`)
- Cilium cluster-wide network policy (`enable_cilium_clusterwide_network_policy = true`, requires ADVANCED_DATAPATH)
- In-transit encryption (`in_transit_encryption_config = "IN_TRANSIT_ENCRYPTION_INTER_NODE_TRANSPARENT"`)
- Cloud Monitoring and Logging integration

## Cloud SQL Module

- PostgreSQL or MySQL instance
- High availability (regional) configuration
- Automated backups and PITR
- Private IP (VPC peering with `servicenetworking.googleapis.com`)
- SSL enforcement
- Database flags
- Read replicas
- Maintenance window

## Cloud Storage Module

- Bucket with chosen storage class (STANDARD/NEARLINE/COLDLINE/ARCHIVE)
- Uniform bucket-level access (disable ACLs)
- Versioning
- Lifecycle rules
- Retention policy
- CMEK with Cloud KMS
- Pub/Sub notifications
- Logging to separate audit bucket

## Cloud Run Module

- Cloud Run service or job
- Direct VPC egress for private access (VPC Connector is legacy — prefer Direct VPC egress)
- IAM invoker bindings
- Environment variable and secret injection (Secret Manager)
- Concurrency and resource limits
- Traffic splitting (canary / blue-green)

## Pub/Sub Module

- Topic with CMEK
- Subscription (push or pull)
- Dead-letter topic
- Message retention and acknowledgement deadline
- IAM bindings (publisher / subscriber roles)

## Secret Manager Module

- Secret resource with automatic replication or user-managed replication
- Secret versions
- IAM bindings (accessor roles)
- Rotation schedule / Pub/Sub notification

## Cloud Armor Module

- Security policy (global or regional)
- IP allowlist/denylist rules
- WAF preconfigured rules (OWASP CRS)
- Rate-based limiting
- Threat intelligence integration

## Best Practices

1. Use `google` provider version `~> 5.0`
2. Enable `google_project_service` for required APIs
3. Use Workload Identity — avoid service account keys
4. Apply organisation policies via Terraform (`google_org_policy_policy`)
5. Tag resources with labels (env, team, cost-centre, managed-by)
6. Use private IPs for all data services
7. Enable VPC Service Controls for sensitive projects
8. Enforce uniform bucket-level access on all Cloud Storage buckets
9. Use Customer-Managed Encryption Keys (CMEK) for sensitive workloads
10. Follow Google Cloud Architecture Framework pillars
