############################################################
# Main Project Module, containing configuration and global #
# definitions, this module invokes the defined modules in  #
# the manitfests                                           #
############################################################

# Setup Terraform
terraform {
  backend "s3" {}
}

# Providers
provider "aws" {
  region = var.aws_region
}

# Common Tags
locals {
  common_tags = {
    Environment = var.environment      
    Owner       = var.owner
    Project     = var.project
  }
}

# Modules
module "network" {
  source               = "./network"
  environment          = var.environment
  project              = var.project
  tags                 = local.common_tags
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones  
}

module "ec2_backend" {
  source            = "./ec2_backend"
  environment       = var.environment
  project           = var.project
  tags              = local.common_tags
  vpc_id            = module.network.vpc_id
  instance_type     = var.instance_type
  instance_count    = var.instance_count
  private_subnet_id = module.network.private_subnet_ids[1]
}
