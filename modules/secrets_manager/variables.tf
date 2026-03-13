variable "secret_name" {
  description = "The name of the secret"
  type        = string
}

variable "recovery_window_in_days" {
  description = "Number of days before the secret can be deleted"
  type        = number
  default     = 0
}

variable "secret_value" {
  description = "The secret value as a map"
  type        = map(any)
  sensitive   = true
  nullable    = false
}
