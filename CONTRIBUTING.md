# Contributing

Thank you for your interest in contributing to this project.

## Requirements

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- [pre-commit](https://pre-commit.com/)
- [GNU Make](https://www.gnu.org/software/make/) >= 4.3

## Getting Started

```bash
# Clone the repository
git clone https://github.com/leandro-mana/aws-terraform-example.git
cd aws-terraform-example

# Install pre-commit hooks
pre-commit install
```

## Branch Strategy

- `main` - Production-ready code
- `feature/<description>` - New features or examples
- `bugfix/<description>` - Bug fixes
- `docs/<description>` - Documentation updates

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(serverless): add secret_app service with Secrets Manager integration
fix(network): correct NAT gateway route table association
docs(readme): update project structure tree
refactor(modules): extract secrets_manager into reusable module
```

## Code Quality

### Terraform

- Run `terraform fmt -recursive` before committing
- Run `terraform validate` in each example directory
- Use consistent variable naming: `snake_case`
- Include `description` and `type` for all variables
- Include `description` for all outputs

### Python

- Follow PEP 8 conventions
- Use type hints for function signatures
- Keep Lambda handlers focused and concise
- Use `logging` module (not `print`)

## Pull Requests

1. Create a feature branch from `main`
2. Make your changes with clear, focused commits
3. Ensure pre-commit hooks pass
4. Open a PR with a clear title and description
5. Include what was changed and why

## Project Conventions

- **Modules** (`modules/`): Reusable, generic Terraform modules
- **Manifests** (`examples/*/manifests/`): Small, single-resource modules
- **Services** (`serverless_workspaces/services/`): Domain-specific compositions
- **Config** (`examples/*/config/`): Environment-specific `.tfvars` files
- **Source** (`src/`): Lambda function code, shared across examples
