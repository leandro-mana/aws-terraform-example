###########################################
# Module to setup AWS NAT Gateway service #
###########################################
resource "aws_eip" "nat" {
  vpc   = true
  count = var.subnet_count
  tags  = merge(
    var.tags,
    {Name="${var.environment}-${var.project}-eip"}    
  )
}

resource "aws_nat_gateway" "nat" {
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(var.subnet_ids, count.index)
  count         = var.subnet_count
  tags  = merge(
    var.tags,
    {Name="${var.environment}-${var.project}-nat"}    
  )  
}
