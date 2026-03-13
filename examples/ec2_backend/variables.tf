###########
# Globals #
###########
variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "project" {
  description = "The name of the project"
  type        = string
}

variable "owner" {
  description = "The owner of the project"
  type        = string
}

variable "aws_region" {
  description = "The AWS Region"
  type        = string
  default     = "ap-southeast-2"
}

###########
# Network #
###########
variable "vpc_cidr" {
  description = "VPC CIDR block, e.g. 10.0.0.0/16"
  type        = string
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

######
# EC2 #
######
variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
}

variable "instance_count" {
  description = "The number of EC2 instances to deploy"
  type        = number
}
