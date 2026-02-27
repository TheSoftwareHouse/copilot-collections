---
name: ci-cd-patterns
description: 'CI/CD pipeline design patterns and deployment strategies. Use when designing pipelines, implementing deployment strategies, or setting up automated delivery.'
---

# CI/CD Pipeline Patterns

## When to Use

- Designing new CI/CD pipelines
- Implementing deployment strategies (rolling, blue-green, canary)
- Setting up GitOps workflows
- Configuring secure CI/CD credentials

## Platform Detection

Check which CI/CD platform the project uses:
- `.github/workflows/*.yml` → GitHub Actions
- `bitbucket-pipelines.yml` → Bitbucket Pipelines
- `.gitlab-ci.yml` → GitLab CI
- `azure-pipelines.yml` → Azure Pipelines
- `Jenkinsfile` → Jenkins

Use `context7` to look up platform-specific syntax for the detected platform.

## Pipeline Structure

```
Lint → Test → Build → Deploy (staging) → Deploy (production)
         ↓
    Artifacts & Caching
```

**Rule:** Each stage should be independent and cacheable.

## Deployment Strategy Decision

| Strategy | Use When | Rollback | Risk |
|----------|----------|----------|------|
| **Rolling** | Stateless apps, can tolerate mixed versions | Slow | Low |
| **Blue-Green** | Need instant rollback, DB migrations | Instant | Low |
| **Canary** | High traffic, want gradual validation | Instant | Very Low |
| **Recreate** | Dev/test, breaking changes only | Slow | High |

## Credentials Strategy Decision

| Scenario | Approach |
|----------|----------|
| AWS from GitHub/GitLab | OIDC federation (no long-lived keys) |
| AWS from Bitbucket | Repository variables + IAM role |
| Multi-cloud | HashiCorp Vault with CI/CD auth |
| Simple/small team | Platform native secrets |

**Rule:** Prefer OIDC federation over long-lived access keys. Use `secrets-management` skill for implementation details.

## Monorepo Strategy

| Tool | Detection | Approach |
|------|-----------|----------|
| Nx | `nx.json` | `nx affected --target=build` |
| Turborepo | `turbo.json` | `turbo run build --filter=...[origin/main]` |
| None | - | Path filtering in CI config |

## Process

1. **Discover context** → Use `technical-context-discovery` to find existing CI patterns
2. **Detect platform** → Check for CI config files listed above
3. **Look up syntax** → Use `context7` for platform-specific YAML syntax
4. **Choose deployment strategy** → Use decision table above
5. **Configure credentials** → Use `secrets-management` skill
6. **Validate** → Run pipeline in dry-run/plan mode first

## Checklist

- [ ] Secrets stored in platform secret manager (not in code)
- [ ] Caching configured for dependencies
- [ ] Branch protection enabled on main/master
- [ ] Environment approvals required for production
- [ ] Rollback procedure documented
- [ ] Pipeline uses pinned versions (not `@latest`)

## Anti-Patterns

- Storing secrets in code or logs
- Skipping tests for "quick fixes"
- Using `latest` tags in production images
- Deploying without artifact verification
- Direct pushes to main/master

---

## Infrastructure as Code Pipelines

### Terraform/Terragrunt Pipeline Structure

```
Lint (fmt) → Validate → Security Scan → Plan → [Manual Approval] → Apply
                                          ↓
                                    Save Plan Artifact
                                          ↓
                                    PR Comment with Diff
```

**Rule:** Never use local state in CI/CD. Always configure remote backend before pipeline runs.

### Required Elements

| Element | Implementation | Why |
|---------|---------------|-----|
| AWS Credentials | `aws-actions/configure-aws-credentials@v4` with OIDC | No long-lived secrets |
| State Backend | S3 + DynamoDB locking | Persistent state, concurrent access protection |
| Plan Artifact | `terraform plan -out=tfplan` + upload artifact | Ensure apply matches reviewed plan |
| PR Comment | `actions/github-script` or `terraform-pr-commenter` | Reviewers see changes before merge |
| Security Scan | `aquasecurity/tfsec-action` or `bridgecrewio/checkov-action` | Catch misconfigurations early |
| Production Guard | `environment: production` with required reviewers | Human approval before infra changes |
| Cache | `actions/cache` for `.terraform` directory | Faster init, reduced API calls |

### GitHub Actions OIDC for AWS

```yaml
permissions:
  id-token: write
  contents: read

steps:
  - uses: aws-actions/configure-aws-credentials@v4
    with:
      role-to-arn: ${{ secrets.AWS_ROLE_ARN }}
      aws-region: ${{ vars.AWS_REGION }}
```

**Rule:** Always use OIDC federation. Never store AWS access keys as secrets.

### Environment Protection

```yaml
apply:
  runs-on: ubuntu-latest
  needs: plan
  environment: production  # Requires manual approval
  if: github.ref == 'refs/heads/main' && github.event_name == 'push'
```

Configure in GitHub: Settings → Environments → production → Required reviewers.

### Plan Artifact Pattern

```yaml
plan:
  steps:
    - run: terraform plan -out=tfplan
    - uses: actions/upload-artifact@v4
      with:
        name: tfplan
        path: tfplan

apply:
  steps:
    - uses: actions/download-artifact@v4
      with:
        name: tfplan
    - run: terraform apply tfplan
```

**Rule:** Apply must use the exact plan that was reviewed, not regenerate it.

### IaC Anti-Patterns

- `apply -auto-approve` without environment protection gates
- Repeating `terraform init` in every job without cache
- Missing remote state backend configuration
- No plan artifact between plan and apply jobs
- Skipping security scanning (tfsec, checkov, trivy)
- Using `latest` provider versions instead of pinned versions
- Not posting plan output to PR for review

### IaC Checklist

- [ ] Remote state backend configured (S3/GCS/Azure Blob)
- [ ] State locking enabled (DynamoDB/native)
- [ ] OIDC federation for cloud credentials
- [ ] Security scanning in pipeline (tfsec/checkov)
- [ ] Plan artifact saved and reused in apply
- [ ] Plan diff posted as PR comment
- [ ] Environment protection on production
- [ ] Provider versions pinned in `versions.tf`
- [ ] `.terraform` directory cached between runs

---

## Related Skills

- `secrets-management` - For credential configuration
- `technical-context-discovery` - For finding existing patterns
