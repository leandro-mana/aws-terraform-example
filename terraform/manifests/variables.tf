###########
# Globals #
###########
variable "environment"  {
  type = string
}

variable "project"  {
  type = string
}

variable "owner"  {
  type = string
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

############
# frontend #
############
variable instance_type {
  type = string
}

variable instance_count {
  type = number
}

output "instance-ip" {
  value = module.ec2.public_ip
}