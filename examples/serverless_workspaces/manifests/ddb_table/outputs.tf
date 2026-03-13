output "id" {
  description = "The DynamoDB table name"
  value       = aws_dynamodb_table.ddb_table.id
}
