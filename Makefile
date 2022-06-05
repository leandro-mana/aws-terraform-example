# Globals
.PHONY: help cfn
.DEFAULT: help
.ONESHELL:
.SILENT:
SHELL=/bin/bash
.SHELLFLAGS = -ceo pipefail

# Supported Environments
ENVS = dev qa prod

# Colours for Help Message and INFO formatting
YELLOW := "\e[1;33m"
NC := "\e[0m"
INFO := @bash -c 'printf $(YELLOW); echo "=> $$0"; printf $(NC)'
export 

help:
	$(INFO) "Run: make <target>"
	$(INFO) "Supported Environments: $$ENVS"
	@echo -e "\n\tList of Supported Targets:"
	@echo
	@echo -e "\tcfn/<env>:\t Cloudformation Deploy"

cfn/%:
	ENV=$*
	./scripts/cfn_deploy.sh $$ENV
