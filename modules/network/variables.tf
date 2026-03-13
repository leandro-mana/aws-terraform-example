################################
# Network Variables Definition #
################################
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

variable "vpc_cidr" {
  description = "VPC CIDR block, e.g. 10.0.0.0/16"
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

variable "private_subnet_cidrs" {
  description = "List of private CIDRs, one per availability zone"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of public CIDRs, one per availability zone"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "destination_cidr_block" {
  description = "CIDR block for routing all traffic through IGW/NAT"
  type        = string
  default     = "0.0.0.0/0"
}
