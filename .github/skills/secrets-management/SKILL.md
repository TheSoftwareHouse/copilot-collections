---
name: secrets-management
description: 'Secrets management patterns for cloud and Kubernetes environments. Use when implementing secure credential storage, rotation, or CI/CD authentication.'
---

# Secrets Management

## When to Use

- Storing application credentials securely
- Configuring CI/CD authentication
- Implementing secrets rotation
- Setting up GitOps-compatible secret management

## Solution Decision Matrix

| Scenario | Recommended Solution |
|----------|---------------------|
| Single cloud, simple apps | Cloud-native (AWS Secrets Manager, Azure Key Vault, GCP Secret Manager) |
| Multi-cloud / hybrid | HashiCorp Vault |
| GitOps with Kubernetes | Sealed Secrets or External Secrets Operator |
| Local dev / small teams | SOPS with age/GPG |
| CI/CD → Cloud | OIDC federation (no long-lived keys) |

## Cloud-Native Detection

Check which cloud provider the project uses:
- `*.tf` with `provider "aws"` → AWS Secrets Manager
- `*.tf` with `provider "azurerm"` → Azure Key Vault
- `*.tf` with `provider "google"` → GCP Secret Manager

Use `context7` or cloud documentation MCP to look up provider-specific syntax.

## Kubernetes Secrets Detection

Check for existing patterns:
- `SealedSecret` resources → Bitnami Sealed Secrets
- `ExternalSecret` resources → External Secrets Operator
- `*.enc.yaml` files → SOPS encryption
- `vault-agent` sidecars → HashiCorp Vault

## CI/CD Credentials Decision

| CI Platform | Cloud | Approach |
|-------------|-------|----------|
| GitHub Actions | AWS | OIDC with `aws-actions/configure-aws-credentials` |
| GitHub Actions | Azure | OIDC with `azure/login` |
| GitHub Actions | GCP | OIDC with `google-github-actions/auth` |
| GitLab CI | AWS/GCP | OIDC with CI_JOB_JWT |
| Bitbucket | AWS | Repository variables + assume role |
| Any | Any | HashiCorp Vault with JWT/OIDC auth |

**Rule:** Always prefer OIDC federation over long-lived access keys.

## Process

1. **Discover context** → Check existing secret patterns in codebase
2. **Choose solution** → Use decision matrix based on scenario
3. **Look up implementation** → Use `context7` or cloud MCP for current syntax
4. **Implement rotation** → Set rotation policy (30-90 days for credentials)
5. **Enable auditing** → Configure access logging on secret store
6. **Document break-glass** → Define emergency access procedure

## Security Checklist

- [ ] No secrets in code, environment variables visible in UI, or logs
- [ ] Rotation policy defined (30-90 days for credentials)
- [ ] Least privilege access to secret stores
- [ ] Audit logging enabled on all secret access
- [ ] OIDC used for CI/CD (no long-lived access keys)
- [ ] Secrets encrypted at rest and in transit
- [ ] Break-glass procedure documented
- [ ] Secret scanning enabled in CI (gitleaks, trufflehog)

## Anti-Patterns

| ❌ Don't | ✅ Do |
|----------|-------|
| Hardcode secrets in code | Use secret references |
| Commit `.env` files | Use `.env.example` with placeholders |
| Share secrets via Slack/email | Use secret manager with access control |
| Same secret across environments | Separate secrets per environment |
| Long-lived CI/CD credentials | OIDC federation with short-lived tokens |
| Secrets in ConfigMaps | Use Kubernetes Secrets (encrypted at rest) |

## Related Skills

- `ci-cd-patterns` - For pipeline credential setup
- `terraform-module-library` - For IaC secret resource patterns
- `cost-optimization` - Secret manager pricing considerations
