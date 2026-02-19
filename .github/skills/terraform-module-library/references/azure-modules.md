# Azure Terraform Module Patterns

## VNet Module

- Virtual Network with address space
- Public and private subnets (address prefixes)
- Network Security Groups (NSGs) per subnet
- Route tables
- DDoS protection plan (optional)
- VNet peering support

## AKS Module

- AKS cluster with system and user node pools
- Workload Identity (`workload_identity_enabled = true` — requires `oidc_issuer_enabled = true`; pod identity is deprecated — do not use)
- Azure CNI or kubenet networking
- Private cluster option
- RBAC and Microsoft Entra ID (formerly Azure AD) integration
- Cluster autoscaler
- Monitoring add-on (Azure Monitor for Containers)

## Azure Database for PostgreSQL / MySQL Module

- Flexible server deployment
- High availability (zone-redundant or same-zone)
- Automated backups with retention
- Private DNS zone and VNet integration
- Firewall rules
- Parameter configurations
- Read replicas

## Azure Blob Storage Module

- Storage account with chosen redundancy (LRS/ZRS/GRS/GZRS)
- Container creation
- Lifecycle management policies
- Soft delete and versioning
- Private endpoint integration
- Customer-managed keys (CMK)
- Static website hosting (optional)

## Azure Application Gateway / WAF Module

- Application Gateway v2
- WAF policy (OWASP ruleset)
- SSL/TLS termination with Key Vault certificates
- Backend pools and HTTP settings
- Health probes
- Autoscaling

## Azure Key Vault Module

- Key Vault with access policy or RBAC model
- Secrets, keys, and certificates management
- Private endpoint
- Soft delete and purge protection
- Diagnostic logging
- Network ACLs

## Azure Container Registry (ACR) Module

- ACR with configurable SKU (Basic/Standard/Premium)
- Geo-replication (Premium)
- Private endpoint
- Retention policy
- Webhook integrations

## Azure Service Bus Module

- Service Bus namespace (Standard/Premium)
- Queues with dead-letter settings
- Topics and subscriptions
- Message TTL and lock duration
- Private endpoint (Premium)

## Best Practices

1. Use `azurerm` provider version `~> 4.0`
2. Always enable resource locks on critical resources
3. Use Managed Identities — avoid service principal passwords
4. Enable diagnostic settings and route logs to Log Analytics
5. Apply Azure Policy via Terraform (`azurerm_policy_assignment`)
6. Tag resources consistently (environment, cost-centre, managed-by)
7. Use `azurerm_resource_group` per environment / module boundary
8. Enable soft-delete and purge protection on Key Vault
9. Prefer private endpoints over public access
10. Follow Azure Well-Architected Framework pillars
