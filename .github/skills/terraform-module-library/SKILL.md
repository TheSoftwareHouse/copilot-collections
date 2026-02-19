---
name: terraform-module-library
description: Build reusable Terraform modules for AWS, Azure, and GCP infrastructure following infrastructure-as-code best practices. Use when creating infrastructure modules, standardizing cloud provisioning, or implementing reusable IaC components.
---

# Terraform Module Library

Production-ready Terraform module patterns for AWS, Azure, and GCP infrastructure.

## Purpose

Create reusable, well-tested Terraform modules for common cloud infrastructure patterns across multiple cloud providers.

## When to Use

- Build reusable infrastructure components
- Standardize cloud resource provisioning
- Implement infrastructure as code best practices
- Create multi-cloud compatible modules
- Establish organizational Terraform standards

## Module Structure

```
terraform-modules/
├── aws/
│   ├── vpc/
│   ├── eks/
│   ├── rds/
│   └── s3/
├── azure/
│   ├── vnet/
│   ├── aks/
│   └── storage/
└── gcp/
    ├── vpc/
    ├── gke/
    └── cloud-sql/
```

## Standard Module Pattern

```
module-name/
├── main.tf          # Main resources
├── variables.tf     # Input variables
├── outputs.tf       # Output values
├── versions.tf      # Provider versions
├── README.md        # Documentation
├── examples/        # Usage examples
│   └── complete/
│       ├── main.tf
│       └── variables.tf
└── tests/           # Terratest files
    └── module_test.go
```

## AWS VPC Module Example

**main.tf:**

```hcl
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name = "${var.name}-private-${count.index + 1}"
      Tier = "private"
    },
    var.tags
  )
}

resource "aws_internet_gateway" "main" {
  count  = var.create_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.name}-igw"
    },
    var.tags
  )
}
```

**variables.tf:**

```hcl
variable "name" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "CIDR block must be valid IPv4 CIDR notation."
  }
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = []
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in VPC"
  type        = bool
  default     = true
}

variable "create_internet_gateway" {
  description = "Whether to create an Internet Gateway"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
```

**outputs.tf:**

```hcl
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "vpc_cidr_block" {
  description = "CIDR block of VPC"
  value       = aws_vpc.main.cidr_block
}
```

## Best Practices

1. **Use semantic versioning** for modules
2. **Pin provider versions** in versions.tf — use `aws ~> 6.0`, `azurerm ~> 4.0`, `google ~> 5.0`
3. **Document all variables** with descriptions
4. **Provide examples** in examples/ directory
5. **Use validation blocks** for input validation
6. **Output important attributes** for module composition
7. **Use locals** for computed values
8. **Implement conditional resources** with count/for_each
9. **Test modules** with Terratest
10. **Tag all resources** consistently

## Reference Files

- `references/aws-modules.md` - AWS module patterns
- `references/azure-modules.md` - Azure module patterns
- `references/gcp-modules.md` - GCP module patterns

## Testing

Use **Terratest** (Go) to test Terraform modules. Every module must include:

- `examples/complete/` — a root module that calls the module under test with realistic values and re-exports its outputs
- `tests/module_test.go` — Go test file that runs `InitAndApply`, reads outputs, asserts expected values, and always defers `Destroy`

Apply the following rules when writing tests:
- Always call `t.Parallel()`
- Always wrap options with `terraform.WithDefaultRetryableErrors`
- Always use `runtime.Caller(0)` to resolve `examples/complete/` path relative to the test file — never use hardcoded relative paths
- Always use `single_nat_gateway = true` (or equivalent cost-reducing flags) in test examples
- Provide a **plan-only** variant of each test (using `InitAndPlanAndShowWithStruct`) for fast PR validation that requires no AWS credentials
- Use a dedicated AWS test account — never run against production
- Set `-timeout 30m` in CI to avoid hanging runs

## Related Skills

- `multi-cloud-architecture` - For architectural decisions
- `cost-optimization` - For cost-effective designs
