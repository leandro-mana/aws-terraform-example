variable "aws_region" {
  description = "The AWS Region"
  type        = string
  default     = "ap-southeast-2"
}

variable "log_retention_in_days" {
  description = "The log retention time in days"
  type        = number
}

variable "artifact_bucket_id" {
  description = "The S3 bucket ID for Lambda artifacts"
  type        = string
}

variable "api_gateway_execution_arn" {
  description = "The API Gateway execution ARN"
  type        = string
}

variable "api_gw_id" {
  description = "The API Gateway ID"
  type        = string
}

variable "api_gw_log_group_arn" {
  description = "The API Gateway CloudWatch log group ARN"
  type        = string
}

variable "movies_app_ddb_table" {
  description = "The DynamoDB table name"
  type        = string
}

variable "movies_app_ddb_billing_mode" {
  description = "The billing mode for the DynamoDB table"
  type        = string
}

variable "movies_app_ddb_read_capacity" {
  description = "The DynamoDB read capacity"
  type        = number
}

variable "movies_app_ddb_write_capacity" {
  description = "The DynamoDB write capacity"
  type        = number
}

variable "movies_app_ddb_hash_key" {
  description = "The DynamoDB hash key"
  type        = string
}

variable "movies_app_ddb_range_key" {
  description = "The DynamoDB range key"
  type        = string
}

variable "layers" {
  description = "The Lambda layers ARNs"
  type        = list(string)
}
