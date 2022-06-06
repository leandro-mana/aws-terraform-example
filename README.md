# AWS Terraform Example

The purpose of this repository is to provide an example of deploying `AWS` Infrastructure by using `Terraform`, with a remote state approach in AWS S3 and DynamoDB, at the same time a set of wrappers were added to make simpler the usage of the CLI via [Makefile](Makefile), as the single interface to interact with the build, test and deploy processes.

This repository is using the concepts shared in [docker-cicd-image](https://github.com/leandro-mana/docker-cicd-image) repository, where the local development environment is alligned with the CICD Pipeline by using the same Docker Image.

The used pattern for the `infrastructure as code` is the following:
- Cloudformation [template](template.yaml), only containing the minimum requirement of AWS Infrastrcture for Terraform [remote state](https://www.terraform.io/language/state/remote).
- Terraform code groupped into [manifests](terraform/manifests/) folder to simplify the variables declaration as well as common objects to be used along modules definition, so Cloudformation deploy is a requirement for any Terraform target.

### **Make**

- Requirements:
    - `GNU Make 4.3`
    - [docker](https://docs.docker.com/get-docker/)
    - [docker-cicd-image](https://github.com/leandro-mana/docker-cicd-image) built

- Environment Variables:
    - `AWS_ACCOUNT_ID`: The AWS Account Id to deploy the infra
    - `AWS_DEFAULT_REGION`: The AWS Account Default Region
    - `AWS_ACCESS_KEY_ID`: The AWS API Access Key ID  
    - `AWS_SECRET_ACCESS_KEY`: The AWS API Access Secret Key
```bash
# Export the minimum AWS Envrionment variables specified above
export AWS_ACCOUNT_ID=<...>
export AWS_DEFAULT_REGION=<...>
export AWS_ACCESS_KEY_ID=<...>  
export AWS_SECRET_ACCESS_KEY=<...>

# Help message
make [help]

# Mount the repository into CICD Docker Image
# it will add the AWS Context in it
make cicd_local_env

# Deploy Cloudformation in dev
make cfn/deploy/dev

# Terraform plan
make tf/plan/dev

# Terraform deploy
make tf/deploy/dev

# Terraform destroy
make tf/destroy/dev
```
**NOTE:** To destroy Cloudformation, do it via the AWS Web Console, as the infrastructure defined in there implies an S3 Bucket, that has a Retain policy, plus it needs to be empitied before deletion. This is done for security reasons to simulate a production environment in where the Terraform states needs to be preserved. Regarding the AWS Environmental variables, when used in CICD, like [Github Actions](https://docs.github.com/en/actions), should be an [environment secret](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment), to use the same names on different environments.

**Contact:** [Leandro Mana](https://www.linkedin.com/in/leandro-mana-2854553b/)
