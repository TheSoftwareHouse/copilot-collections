# AWS Terraform Module Patterns

## VPC Module

- VPC with public/private subnets
- Internet Gateway and NAT Gateways
- Route tables and associations
- Network ACLs
- VPC Flow Logs

## EKS Module

- EKS cluster with managed node groups
- EKS Pod Identity (preferred, 2023+) or IRSA (IAM Roles for Service Accounts) for workload IAM
- Node group AMI: use `amazon-linux-2023`; pin release version via SSM parameter `/aws/service/eks/optimized-ami/{version}/amazon-linux-2023/x86_64/standard/recommended/release_version`
- Cluster autoscaler
- VPC CNI configuration
- Cluster logging

## RDS Module

- RDS instance or cluster
- Automated backups
- Read replicas
- Parameter groups
- Subnet groups
- Security groups

## S3 Module

- S3 bucket with versioning
- Encryption at rest
- Bucket policies
- Lifecycle rules
- Replication configuration

## ALB Module

- Application Load Balancer
- Target groups
- Listener rules
- SSL/TLS certificates
- Access logs

## Lambda Module

- Lambda function
- IAM execution role
- CloudWatch Logs
- Environment variables
- VPC configuration (optional)

## Security Group Module

- Reusable security group rules
- Ingress/egress rules
- Dynamic rule creation
- Rule descriptions

## Best Practices

1. Use AWS provider version ~> 6.0
2. Enable encryption by default
3. Use least-privilege IAM
4. Tag all resources consistently
5. Enable logging and monitoring
6. Use KMS for encryption
7. Implement backup strategies
8. Use PrivateLink when possible
9. Enable GuardDuty/SecurityHub
10. Follow AWS Well-Architected Framework
