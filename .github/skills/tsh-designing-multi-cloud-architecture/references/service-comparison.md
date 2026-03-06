# Cloud Service Comparison

Complete mapping of equivalent services across AWS, Azure, and GCP.

---

## Compute

| Category | AWS | Azure | GCP |
|---|---|---|---|
| Virtual Machines | EC2 | Virtual Machines | Compute Engine |
| Managed Kubernetes | EKS | AKS | GKE |
| Managed Containers (serverless) | Fargate | Container Apps | Cloud Run |
| Container Registry | ECR | Container Registry | Artifact Registry |
| Serverless Functions | Lambda | Azure Functions | Cloud Functions |
| Batch Processing | AWS Batch | Azure Batch | Cloud Batch |
| HPC | ParallelCluster | CycleCloud | HPC Toolkit |
| VM Image Building | EC2 Image Builder | Azure Image Builder | Packer (open source) |

---

## Storage

| Category | AWS | Azure | GCP |
|---|---|---|---|
| Object Storage | S3 | Blob Storage | Cloud Storage |
| Block Storage | EBS | Managed Disks | Persistent Disk |
| Shared File Storage | EFS | Azure Files | Filestore |
| Cold / Archive | S3 Glacier | Archive Storage | Archive Storage |
| Transfer Acceleration | S3 Transfer Acceleration | Azure CDN (Blob) | Storage Transfer Service |
| Hybrid Storage Gateway | Storage Gateway | StorSimple | Transfer Appliance |

---

## Database

| Category | AWS | Azure | GCP |
|---|---|---|---|
| Managed Relational (MySQL / PostgreSQL) | RDS | Azure Database for MySQL / PostgreSQL | Cloud SQL |
| High-performance Relational | Aurora | Hyperscale (Citus) | Cloud Spanner |
| NoSQL Document | DynamoDB | Cosmos DB (Core) | Firestore |
| Wide-column NoSQL | DynamoDB | Cosmos DB (Cassandra API) | Bigtable |
| In-memory Cache | ElastiCache (Redis / Memcached) | Azure Cache for Redis | Memorystore |
| Time-series | Timestream | Azure Data Explorer | Cloud Bigtable |
| Graph | Neptune | Cosmos DB (Gremlin) | — |
| Search | OpenSearch Service | Azure Cognitive Search | Vertex AI Search |
| Data Warehouse | Redshift | Synapse Analytics | BigQuery |

---

## Networking

| Category | AWS | Azure | GCP |
|---|---|---|---|
| Virtual Network | VPC | Virtual Network (VNet) | VPC |
| Load Balancer (L7) | Application Load Balancer (ALB) | Application Gateway | Cloud Load Balancing (HTTP(S)) |
| Load Balancer (L4) | Network Load Balancer (NLB) | Azure Load Balancer | Cloud Load Balancing (TCP/UDP) |
| CDN | CloudFront | Azure CDN / Front Door | Cloud CDN |
| DNS | Route 53 | Azure DNS | Cloud DNS |
| Global Traffic Manager | Route 53 (Latency/Geo) | Azure Traffic Manager | Cloud DNS + GLB |
| Dedicated Interconnect | Direct Connect | ExpressRoute | Cloud Interconnect |
| VPN Gateway | AWS VPN | Azure VPN Gateway | Cloud VPN |
| Private Endpoint | PrivateLink | Private Link / Private Endpoint | Private Service Connect |
| API Gateway | API Gateway | API Management (APIM) | API Gateway |
| Service Mesh | App Mesh | — | Traffic Director |

---

## Security & Identity

| Category | AWS | Azure | GCP |
|---|---|---|---|
| IAM | IAM | Azure AD / Entra ID | Cloud IAM |
| Secrets Manager | Secrets Manager / Parameter Store | Key Vault | Secret Manager |
| Key Management | KMS | Key Vault | Cloud KMS |
| Certificate Manager | ACM | App Service Certificates / Key Vault | Certificate Manager |
| Firewall | AWS Network Firewall | Azure Firewall | Cloud Armor |
| WAF | AWS WAF | Front Door WAF / App Gateway WAF | Cloud Armor |
| DDoS Protection | AWS Shield | Azure DDoS Protection | Cloud Armor |
| CSPM / Security Posture | Security Hub | Microsoft Defender for Cloud | Security Command Center |
| Threat Detection | GuardDuty | Microsoft Sentinel | Security Command Center |
| Compliance / Audit | AWS Config + CloudTrail | Azure Policy + Monitor | Cloud Asset Inventory + Audit Logs |
| Vulnerability Scanning | Amazon Inspector | Microsoft Defender for Containers | Artifact Analysis |

---

## Messaging & Integration

| Category | AWS | Azure | GCP |
|---|---|---|---|
| Message Queue | SQS | Azure Queue Storage / Service Bus | Cloud Tasks / Cloud Pub/Sub |
| Pub/Sub Messaging | SNS | Event Grid / Service Bus Topics | Cloud Pub/Sub |
| Managed Kafka | MSK | Event Hubs (Kafka protocol) | Confluent Cloud (partner) |
| Event Streaming | Kinesis | Event Hubs | Pub/Sub + Dataflow |
| Workflow Orchestration | Step Functions | Logic Apps / Durable Functions | Workflows |
| API Integration | EventBridge | Event Grid | Eventarc |

---

## Developer Tools & CI/CD

| Category | AWS | Azure | GCP |
|---|---|---|---|
| Source Control | CodeCommit | Azure Repos (DevOps) | Cloud Source Repositories |
| CI/CD Pipelines | CodePipeline + CodeBuild | Azure Pipelines | Cloud Build |
| Artifact Repository | CodeArtifact | Azure Artifacts | Artifact Registry |
| Infrastructure as Code | CloudFormation / CDK | Bicep / ARM Templates | Deployment Manager |
| IDE / Cloud Shell | Cloud9 / CloudShell | Azure Cloud Shell | Cloud Shell |

---

## AI & Machine Learning

| Category | AWS | Azure | GCP |
|---|---|---|---|
| ML Platform | SageMaker | Azure Machine Learning | Vertex AI |
| Pre-built AI APIs | Rekognition, Comprehend, Transcribe, … | Cognitive Services | Cloud AI APIs (Vision, Speech, NLP, …) |
| Large Language Models | Amazon Bedrock | Azure OpenAI Service | Vertex AI (Gemini) |
| Data Labelling | SageMaker Ground Truth | Azure ML Data Labelling | Vertex AI Data Labeling |
| ML Notebooks | SageMaker Studio | Azure ML Notebooks | Vertex AI Workbench |
| TPU / GPU Acceleration | Trainium / Inferentia (EC2) | NDsv5 (H100) | Cloud TPU |

---

## Analytics & Big Data

| Category | AWS | Azure | GCP |
|---|---|---|---|
| Data Warehouse | Redshift | Synapse Analytics | BigQuery |
| Managed Spark / Hadoop | EMR | HDInsight / Databricks | Dataproc |
| Data Factory / ETL | Glue | Azure Data Factory | Dataflow |
| Real-time Analytics | Kinesis Data Analytics | Stream Analytics | Dataflow |
| BI / Dashboards | QuickSight | Power BI | Looker / Looker Studio |
| Data Catalog | AWS Glue Data Catalog | Microsoft Purview | Dataplex |
| Lake Formation | AWS Lake Formation | Azure Synapse Analytics | BigLake |

---

## Monitoring & Observability

| Category | AWS | Azure | GCP |
|---|---|---|---|
| Cloud-native Monitoring | CloudWatch | Azure Monitor | Cloud Monitoring |
| Distributed Tracing | X-Ray | Application Insights | Cloud Trace |
| Log Management | CloudWatch Logs | Log Analytics (Monitor) | Cloud Logging |
| Infrastructure Dashboards | CloudWatch Dashboards | Azure Dashboards | Cloud Monitoring Dashboards |
| Alerting | CloudWatch Alarms | Azure Alerts | Cloud Alerting |
| Status Page | AWS Health Dashboard | Azure Service Health | Google Cloud Status |

---

## Pricing Models Comparison

| Pricing Model | AWS | Azure | GCP |
|---|---|---|---|
| On-demand / Pay-as-you-go | ✓ | ✓ | ✓ |
| 1-year reserved / committed | Reserved Instances (1yr) | Reserved VM Instances (1yr) | Committed Use Discounts (1yr) |
| 3-year reserved / committed | Reserved Instances (3yr) | Reserved VM Instances (3yr) | Committed Use Discounts (3yr) |
| Spot / Preemptible | Spot Instances | Spot VMs | Spot VMs (Preemptible) |
| Flexible savings plan | Compute Savings Plans | — | — |
| Sustained use discount | — | — | Automatic (up to 30%) |
| Free tier | AWS Free Tier | Azure Free Account | Google Cloud Free Tier |

---

## Related References

- [Multi-Cloud Patterns](./multi-cloud-patterns.md)
- [Terraform Module Library Skill](../../terraform-module-library/SKILL.md)
- [Cost Optimization Skill](../../cost-optimization/SKILL.md)
