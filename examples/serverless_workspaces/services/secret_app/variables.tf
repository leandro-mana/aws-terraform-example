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

variable "secret_value" {
  description = "The secret value as a map"
  type        = map(any)
  sensitive   = true
  nullable    = false
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

variable "layers" {
  description = "The Lambda layers ARNs"
  type        = list(string)
}
