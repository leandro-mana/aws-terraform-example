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

##############
# PowerTools #
##############
variable "aws_powertools_layer_version" {
  description = "AWS Lambda Powertools layer version"
  type        = string
  default     = "51"
}

##############
# CloudWatch #
##############
variable "log_retention_in_days" {
  description = "The log retention time in days"
  type        = number
}

##############
# Movies App #
##############
variable "movies_app_ddb_table" {
  description = "The DynamoDB table name"
  type        = string
}

variable "movies_app_ddb_billing_mode" {
  description = "The billing mode for the DynamoDB table"
  type        = string
  default     = "PROVISIONED"
}

variable "movies_app_ddb_read_capacity" {
  description = "The DynamoDB read capacity"
  type        = number
}

variable "movies_app_ddb_write_capacity" {
  description = "The DynamoDB write capacity"
  type        = number
}

variable "movies_app_ddb_hash_key" {
  description = "The DynamoDB hash key"
  type        = string
}

variable "movies_app_ddb_range_key" {
  description = "The DynamoDB range key"
  type        = string
}
