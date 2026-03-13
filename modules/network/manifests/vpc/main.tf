############################################################
# VPC Module, defining the VPC itself and Internet Gateway #
############################################################
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    var.tags,
    { Name = "${var.environment}-${var.project}-vpc" }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = var.tags
}
