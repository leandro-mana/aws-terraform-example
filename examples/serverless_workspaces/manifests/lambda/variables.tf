variable "artifact_source" {
  description = "The path for the Lambda artifact"
  type        = string
}

variable "artifact_bucket_id" {
  description = "The S3 bucket ID for Lambda artifacts"
  type        = string
}

variable "artifact_s3_key" {
  description = "The S3 bucket key for the Lambda artifact"
  type        = string
}

variable "iam_arn_policies" {
  description = "List of IAM policy ARNs to attach to the Lambda role"
  type        = list(any)
}

variable "log_retention_in_days" {
  description = "The log retention time in days"
  type        = number
}

variable "name" {
  description = "The Lambda function name"
  type        = string
}

variable "runtime" {
  description = "The Lambda runtime"
  type        = string
}

variable "handler" {
  description = "The Lambda handler"
  type        = string
}

variable "source_code_hash" {
  description = "The Lambda source code hash"
  type        = string
}

variable "layers" {
  description = "The Lambda layers ARNs"
  type        = list(string)
  default     = []
}

variable "environment_vars" {
  description = "The Lambda environment variables"
  type        = list(any)
  default     = []
}
