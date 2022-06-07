#############################################################
# VPC Module, defining the vpc it self and internet gateway #
#############################################################
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  tags                 = merge(
    var.tags, 
    {Name="${var.environment}-${var.project}-vpc"}
  )
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = aws_vpc.vpc.id
  tags   = var.tags
}
