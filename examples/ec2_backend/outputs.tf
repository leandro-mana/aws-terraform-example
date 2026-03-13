output "vpc_id" {
  description = "The VPC ID"
  value       = module.network.vpc_id
}

output "private_subnet_ids" {
  description = "The private subnet IDs"
  value       = module.network.private_subnet_ids
}

output "public_subnet_ids" {
  description = "The public subnet IDs"
  value       = module.network.public_subnet_ids
}
