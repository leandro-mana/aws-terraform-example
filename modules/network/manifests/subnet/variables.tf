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

variable "type" {
  description = "The type (private or public) of the subnet"
  type        = string
}

variable "cidrs" {
  description = "List of CIDRs, one per availability zone"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
