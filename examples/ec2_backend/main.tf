###################################################
# EC2 Backend Example                             #
# VPC + EC2 instances with S3 remote state        #
# Demonstrates: network module, EC2, remote state #
###################################################
terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5"
}

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Environment = var.environment
    Owner       = var.owner
    Project     = var.project
  }
}

module "network" {
  source               = "../../modules/network"
  environment          = var.environment
  project              = var.project
  tags                 = local.common_tags
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "ec2_backend" {
  source            = "./manifests/ec2_backend"
  environment       = var.environment
  project           = var.project
  tags              = local.common_tags
  vpc_id            = module.network.vpc_id
  instance_type     = var.instance_type
  instance_count    = var.instance_count
  private_subnet_id = module.network.private_subnet_ids[1]
}
