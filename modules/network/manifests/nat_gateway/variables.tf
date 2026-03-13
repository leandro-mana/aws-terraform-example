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

variable "subnet_ids" {
  description = "List of subnets in which to place the NAT Gateway"
  type        = list(string)
}

variable "subnet_count" {
  description = "Number of subnets (determines NAT gateway count)"
  type        = number
}
