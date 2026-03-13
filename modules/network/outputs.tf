output "vpc_id" {
  description = "The VPC ID"
  value       = module.vpc.id
}

output "vpc_cidr" {
  description = "The VPC CIDR block"
  value       = module.vpc.cidr_block
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.private_subnet.ids
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.public_subnet.ids
}
