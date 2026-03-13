variable "log_retention_in_days" {
  description = "The log retention time in days"
  type        = number
}

variable "name" {
  description = "The API Gateway name"
  type        = string
}

variable "protocol_type" {
  description = "The API Gateway protocol type"
  type        = string
}
