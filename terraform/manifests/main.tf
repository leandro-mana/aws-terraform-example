###################
# Setup Terraform #
###################
terraform {
  backend "s3" {}

}

#############
# Providers #
#############
provider "aws" {
  region     = var.aws_region

}

###############
# Common Tags #
###############
locals {
  common_tags = {
    Environment = var.environment      
    Owner       = var.owner
    Project     = var.project
  }

}

###########
# Modules #
###########
