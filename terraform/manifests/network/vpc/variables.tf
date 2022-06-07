############################
# VPC Variables Definition #
############################
variable "cidr" {
  description = "VPC cidr block. Example: 10.0.0.0/16"
  type        = string
}

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
