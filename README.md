# AWS Terraform Examples

![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5-7B42BC?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Provider%20~%3E%205.0-FF9900?logo=amazonaws)
![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python)
![License](https://img.shields.io/badge/License-MIT-green)

A consolidated collection of AWS infrastructure-as-code examples using [Terraform](https://www.terraform.io/), demonstrating a modular approach to provisioning AWS resources with reusable modules, remote state management, and progressive complexity from EC2 to serverless architectures.

This repository consolidates what were previously separate repositories into a single, cohesive reference, showing how to structure Terraform projects professionally for real-world AWS deployments.

## Requirements

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) v2
- [Docker](https://docs.docker.com/get-docker/) (optional, for CICD local environment)
- [GNU Make](https://www.gnu.org/software/make/) >= 4.3
- [Python](https://www.python.org/) >= 3.12 (for serverless examples)
- [pre-commit](https://pre-commit.com/) (for development)

## Quick Start

```bash
# Clone the repository
git clone https://github.com/leandro-mana/aws-terraform-example.git
cd aws-terraform-example

# Set AWS credentials
export AWS_ACCOUNT_ID=<...>
export AWS_DEFAULT_REGION=<...>
export AWS_ACCESS_KEY_ID=<...>
export AWS_SECRET_ACCESS_KEY=<...>

# Show available targets
make help

# Deploy CloudFormation base infrastructure (S3 + DynamoDB for TF state)
make cfn/deploy/dev

# Run Terraform plan for a specific example
make tf/plan/dev
```

## Project Structure

```
aws-terraform-examples/
├── modules/                          # Reusable Terraform modules
│   ├── network/                      # Standard AWS VPC network setup
│   │   ├── main.tf                   #   VPC, subnets, NAT, routing
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── manifests/
│   │       ├── vpc/                  #   VPC + Internet Gateway
│   │       ├── subnet/               #   Public/private subnets + route tables
│   │       └── nat_gateway/          #   NAT Gateway + Elastic IPs
│   └── secrets_manager/              # Secrets Manager + IAM policy
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── examples/
│   ├── ec2_backend/                  # EC2 + VPC with S3 remote state
│   │   ├── main.tf                   #   Uses modules/network
│   │   ├── config/dev.tfvars
│   │   └── manifests/ec2_backend/
│   ├── serverless/                   # API Gateway + Lambda + DynamoDB
│   │   ├── main.tf                   #   Modular serverless infrastructure
│   │   ├── config/dev.tfvars
│   │   └── manifests/                #   s3, api_gw, lambda, ddb modules
│   └── serverless_workspaces/        # Advanced: services + feature flags
│       ├── main.tf                   #   Conditional deployment per service
│       ├── manifests/                #   Shared building blocks
│       └── services/                 #   hello_app, movies_app, secret_app
├── src/                              # Python Lambda source code
│   ├── hello_app/                    #   Simple greeting API
│   ├── movies_app/                   #   DynamoDB CRUD API
│   ├── secret_app/                   #   Secrets Manager retrieval API
│   └── lambda_layers/                #   Shared utils (secrets_manager)
├── cloudformation/                   # TF remote state bootstrap
│   ├── template.yaml                 #   S3 bucket + DynamoDB lock table
│   └── config/dev.json
├── scripts/                          # Deployment and Docker helpers
├── tests/                            # Python unit tests
├── Makefile                          # Single interface for all operations
├── .pre-commit-config.yaml
├── CONTRIBUTING.md
└── LICENSE
```

## Examples Overview

| Example | Description | AWS Resources | Key Patterns |
|---------|-------------|---------------|--------------|
| [ec2_backend](examples/ec2_backend/) | VPC + EC2 instances | VPC, subnets, NAT, EC2, security groups | Module reuse, S3 remote state |
| [serverless](examples/serverless/) | Serverless REST API | API Gateway v2, Lambda, DynamoDB, S3 | Modular manifests, archive artifacts |
| [serverless_workspaces](examples/serverless_workspaces/) | Advanced serverless | All above + Secrets Manager, Lambda layers | Services pattern, feature flags, workspaces |

### Progression of Complexity

1. **EC2 Backend** - Start here. Consumes the `network` module to create a VPC with public/private subnets, NAT gateways, and deploys EC2 instances. Demonstrates remote state with S3 + DynamoDB locking via CloudFormation bootstrap.

2. **Serverless** - Builds a complete REST API with API Gateway v2, Lambda functions (Python), and DynamoDB. Shows modular manifest pattern where each AWS resource type is its own reusable module.

3. **Serverless Workspaces** - The most advanced pattern. Introduces a **services layer** on top of manifests, **feature flags** for conditional deployment (`deploy_hello_app = true`), **Lambda layers** for shared code, and **Secrets Manager** integration with fine-grained IAM policies.

## Reusable Modules

### Network Module

Standard AWS network setup: VPC, public/private subnets, Internet Gateway, NAT Gateway, route tables. Multi-AZ by configuration.

```hcl
module "network" {
  source               = "../../modules/network"
  environment          = "dev"
  project              = "my-project"
  tags                 = local.common_tags
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.50.0/24", "10.0.51.0/24"]
  availability_zones   = ["ap-southeast-2a", "ap-southeast-2b"]
}
```

### Secrets Manager Module

Creates an AWS secret and generates a fine-grained IAM policy to restrict access to that specific secret. The policy ARN can be attached to service roles.

```hcl
module "secrets_manager" {
  source       = "../../modules/secrets_manager"
  secret_name  = "my-secret"
  secret_value = var.secret_value
}

# Attach the generated policy to a Lambda role
resource "aws_iam_role_policy_attachment" "secret_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = module.secrets_manager.secret_iam_policy_arn
}
```

## Key Concepts

| Concept | Where | Description |
|---------|-------|-------------|
| Remote State | `cloudformation/` | S3 + DynamoDB for state locking, bootstrapped via CloudFormation |
| Module Composition | `modules/` | Reusable modules consumed across examples |
| Manifest Pattern | `examples/*/manifests/` | Small, focused modules per AWS resource type |
| Services Pattern | `serverless_workspaces/services/` | Domain-specific compositions of manifests |
| Feature Flags | `serverless_workspaces/main.tf` | Conditional deployment via `count` + boolean variables |
| Lambda Layers | `src/lambda_layers/` | Shared Python utilities across Lambda functions |
| Default Tags | `serverless_workspaces/` | Provider-level `default_tags` for automatic tagging |

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines, branching strategy, and commit message conventions.

```bash
# Install pre-commit hooks
pre-commit install

# Format Terraform files
make fmt

# Validate Terraform configuration
make validate
```

## References

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Remote State](https://developer.hashicorp.com/terraform/language/state/remote)
- [AWS Lambda Powertools](https://docs.powertools.aws.dev/lambda/python/latest/)
- [AWS API Gateway v2](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api.html)
- [Docker CICD Image](https://github.com/leandro-mana/docker-cicd-image)

## Related Repositories

| Repository | Description |
|------------|-------------|
| [python-for-data-science-notes](https://github.com/leandro-mana/python-for-data-science-notes) | Python for Data Science study notes |
| [python-for-time-series-notes](https://github.com/leandro-mana/python-for-time-series-notes) | Python for Time Series study notes |
| [analytics-engineering-sql-dbt](https://github.com/leandro-mana/analytics-engineering-sql-dbt) | Analytics Engineering with SQL and dbt |
| [felix-cloud-project](https://github.com/leandro-mana/felix-cloud-project) | Cloud-native platform with Python + AWS CDK |

## Author

[Leandro Mana](https://www.linkedin.com/in/leandro-mana-2854553b/)

## License

This project is licensed under the [MIT License](LICENSE).
