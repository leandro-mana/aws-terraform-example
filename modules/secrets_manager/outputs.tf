output "secret_name" {
  description = "The secret name"
  value       = aws_secretsmanager_secret.secret.id
}

output "secret_iam_policy_arn" {
  description = "The ARN of the IAM policy restricting access to the secret"
  value       = aws_iam_policy.secret_policy.arn
}
