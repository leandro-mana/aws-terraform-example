###################################################
# Serverless Workspaces Example                   #
# Services architecture with feature flags        #
# Demonstrates: TF workspaces, conditional deploy #
###################################################
terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }

  required_version = ">= 1.5"
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = local.common_tags
  }
}

locals {
  common_tags = {
    Environment = var.environment
    Owner       = var.owner
    Project     = var.project
    Provider    = "Terraform"
  }
  aws_lambda_powertools_layer = "arn:aws:lambda:${var.aws_region}:017000801446:layer:AWSLambdaPowertoolsPythonV2:${var.aws_powertools_layer_version}"
}

######################
# S3 Artifact Bucket #
######################
module "s3_artifact_bucket" {
  count       = var.deploy_s3_artifact_bucket ? 1 : 0
  source      = "./manifests/s3_artifact_bucket"
  bucket_name = "${var.environment}-${var.project}-${var.aws_region}-artifacts"
}

###############
# API Gateway #
###############
module "api_gateway" {
  count                 = var.deploy_api_gw ? 1 : 0
  source                = "./manifests/api_gateway"
  name                  = "hello_app"
  protocol_type         = "HTTP"
  log_retention_in_days = var.log_retention_in_days
}

########################
# Utils Lambda Layer   #
########################
module "utils_lambda_layer" {
  count              = var.deploy_utils_lambda_layer ? 1 : 0
  source             = "./manifests/lambda_layer"
  source_dir         = "${path.module}/../../src/lambda_layers/"
  output_path        = "${path.module}/../../build/utils.zip"
  artifact_bucket_id = module.s3_artifact_bucket[0].id
  artifact_s3_key    = "lambda_layers/utils.zip"
  layer_name         = "utils"
  skip_destroy       = false
  compatible_runtimes = [
    "python3.10",
    "python3.11",
    "python3.12",
  ]
}

#############
# Hello App #
#############
module "hello_app" {
  count                     = var.deploy_hello_app ? 1 : 0
  source                    = "./services/hello_app"
  aws_region                = var.aws_region
  log_retention_in_days     = var.log_retention_in_days
  artifact_bucket_id        = module.s3_artifact_bucket[0].id
  api_gateway_execution_arn = module.api_gateway[0].execution_arn
  api_gw_id                 = module.api_gateway[0].id
  api_gw_log_group_arn      = module.api_gateway[0].cw_log_group_arn
  layers = [
    local.aws_lambda_powertools_layer,
  ]
}

##############
# Movies App #
##############
module "movies_app" {
  count                         = var.deploy_movies_app ? 1 : 0
  source                        = "./services/movies_app"
  aws_region                    = var.aws_region
  log_retention_in_days         = var.log_retention_in_days
  artifact_bucket_id            = module.s3_artifact_bucket[0].id
  api_gateway_execution_arn     = module.api_gateway[0].execution_arn
  api_gw_id                     = module.api_gateway[0].id
  api_gw_log_group_arn          = module.api_gateway[0].cw_log_group_arn
  movies_app_ddb_table          = var.movies_app_ddb_table
  movies_app_ddb_billing_mode   = var.movies_app_ddb_billing_mode
  movies_app_ddb_read_capacity  = var.movies_app_ddb_read_capacity
  movies_app_ddb_write_capacity = var.movies_app_ddb_write_capacity
  movies_app_ddb_hash_key       = var.movies_app_ddb_hash_key
  movies_app_ddb_range_key      = var.movies_app_ddb_range_key
  layers = [
    local.aws_lambda_powertools_layer,
  ]
}

##############
# Secret App #
##############
module "secret_app" {
  count                     = var.deploy_secret_app ? 1 : 0
  source                    = "./services/secret_app"
  secret_value              = var.secret_app_secret_value
  aws_region                = var.aws_region
  log_retention_in_days     = var.log_retention_in_days
  artifact_bucket_id        = module.s3_artifact_bucket[0].id
  api_gateway_execution_arn = module.api_gateway[0].execution_arn
  api_gw_id                 = module.api_gateway[0].id
  api_gw_log_group_arn      = module.api_gateway[0].cw_log_group_arn
  layers = [
    local.aws_lambda_powertools_layer,
    module.utils_lambda_layer[0].lambda_layer_arn,
  ]
}
