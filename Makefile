# Globals
.PHONY: help prereqs cicd_local_env fmt validate clean cfn/% tf/%
.DEFAULT: help
.ONESHELL:
.SILENT:
SHELL=/bin/bash
.SHELLFLAGS = -ceo pipefail

# Supported Environments
ENVS = dev qa prod

# Colours
YELLOW := "\e[1;33m"
NC := "\e[0m"
INFO := @bash -c 'printf $(YELLOW); echo "=> $$0"; printf $(NC)'
export

help:
	$(INFO) "Run: make <target>"
	$(INFO) "Supported Environments: $(ENVS)"
	$(INFO) "List of Supported Targets:"
	@echo ""
	@echo "  Setup:"
	@echo "    cicd_local_env         Run CICD Docker Image"
	@echo "    prereqs                Check prerequisites"
	@echo ""
	@echo "  Code Quality:"
	@echo "    fmt                    Terraform recursive format"
	@echo "    validate               Terraform validate all examples"
	@echo ""
	@echo "  Deploy:"
	@echo "    cfn/deploy/<env>       Deploy CloudFormation base infra"
	@echo "    tf/plan/<env>          Terraform plan"
	@echo "    tf/deploy/<env>        Terraform apply"
	@echo "    tf/destroy/<env>       Terraform destroy"
	@echo "    tf/output/<env>        Terraform output"
	@echo ""
	@echo "  Utilities:"
	@echo "    clean                  Remove build artifacts"
	@echo ""

prereqs:
	$(INFO) "Checking prerequisites"
	@command -v terraform >/dev/null 2>&1 || { echo "terraform not found"; exit 1; }
	@command -v aws >/dev/null 2>&1 || { echo "aws-cli not found"; exit 1; }
	@echo "All prerequisites met"

cicd_local_env:
	$(INFO) "Run CICD Docker Image"
	source scripts/docker_run.sh

fmt:
	$(INFO) "Terraform Recursive Format"
	terraform fmt -recursive .

validate:
	$(INFO) "Terraform Validate"
	@for example in examples/*/; do \
		echo "Validating: $$example"; \
		cd "$$example" && terraform init -backend=false > /dev/null 2>&1 && terraform validate && cd ../..; \
	done

clean:
	$(INFO) "Cleaning build artifacts"
	rm -rf build/
	find . -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true
	find . -name ".terraform.lock.hcl" -delete 2>/dev/null || true
	find . -name "plan.out" -delete 2>/dev/null || true

cfn/deploy/% tf/plan/% tf/deploy/% tf/destroy/% tf/output/%:
	TARGET=$@
	$(INFO) "Deploy Target - $$TARGET"
	./scripts/deploy.sh $$TARGET
