output "instance_ids" {
  description = "The EC2 instance IDs"
  value       = aws_instance.backend[*].id
}
