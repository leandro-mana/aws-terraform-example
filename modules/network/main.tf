########################################
# AWS Standard Network Module          #
# VPC, Subnets, NAT Gateway, Routing  #
########################################
module "vpc" {
  source               = "./manifests/vpc"
  environment          = var.environment
  project              = var.project
  tags                 = var.tags
  cidr                 = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
}

module "private_subnet" {
  source             = "./manifests/subnet"
  environment        = var.environment
  project            = var.project
  tags               = var.tags
  type               = "private"
  vpc_id             = module.vpc.id
  cidrs              = var.private_subnet_cidrs
  availability_zones = var.availability_zones
}

module "public_subnet" {
  source             = "./manifests/subnet"
  environment        = var.environment
  project            = var.project
  tags               = var.tags
  type               = "public"
  vpc_id             = module.vpc.id
  cidrs              = var.public_subnet_cidrs
  availability_zones = var.availability_zones
}

module "nat" {
  source       = "./manifests/nat_gateway"
  environment  = var.environment
  project      = var.project
  tags         = var.tags
  subnet_ids   = module.public_subnet.ids
  subnet_count = length(var.public_subnet_cidrs)
}

resource "aws_route" "public_igw_route" {
  count                  = length(var.public_subnet_cidrs)
  route_table_id         = element(module.public_subnet.route_table_ids, count.index)
  gateway_id             = module.vpc.igw
  destination_cidr_block = var.destination_cidr_block
}

resource "aws_route" "private_nat_route" {
  count                  = length(var.private_subnet_cidrs)
  route_table_id         = element(module.private_subnet.route_table_ids, count.index)
  nat_gateway_id         = element(module.nat.ids, count.index)
  destination_cidr_block = var.destination_cidr_block
}
