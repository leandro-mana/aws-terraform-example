variable "tags" {
  description = "The tags for the resource"
  type        = map(string)
}

variable "name" {
  description = "The API Gateway stage name"
  type        = string
}

variable "api_gw_id" {
  description = "The API Gateway ID"
  type        = string
}

variable "auto_deploy" {
  description = "Whether updates automatically trigger a new deployment"
  type        = bool
  default     = true
}

variable "cw_log_group_arn" {
  description = "The CloudWatch log group ARN"
  type        = string
}
