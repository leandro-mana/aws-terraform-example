variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "project" {
  description = "The name of the project"
  type        = string
}

variable "tags" {
  description = "The tags for the resource"
  type        = map(string)
}

variable "cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "enable_dns_support" {
  description = "Enable/disable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable/disable DNS hostnames in the VPC"
  type        = bool
  default     = true
}
