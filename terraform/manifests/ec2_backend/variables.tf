############################
# EC2 Variables definition #
############################
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

variable "vpc_id" {
  description = "The VPC Id"
  type        = string
}

variable instance_type {
  description = "The EC2 Instance Type"
  type        = string
}

variable instance_count {
  description = "The amount of EC2 instances to deploy"
  type        = number
}

variable private_subnet_id {
  description = "The private subnet id to deploy the instances"
  type        = string
}
