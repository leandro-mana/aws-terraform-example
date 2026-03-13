variable "tags" {
  description = "The tags for the resource"
  type        = map(string)
}

variable "table_name" {
  description = "The DynamoDB table name"
  type        = string
}

variable "billing_mode" {
  description = "The billing mode for the DynamoDB table"
  type        = string
  default     = "PROVISIONED"
}

variable "read_capacity" {
  description = "The DynamoDB read capacity"
  type        = number
}

variable "write_capacity" {
  description = "The DynamoDB write capacity"
  type        = number
}

variable "hash_key" {
  description = "The DynamoDB hash key"
  type        = string
}

variable "range_key" {
  description = "The DynamoDB range key"
  type        = string
}

variable "attributes" {
  description = "List of attribute definitions"
  type        = list(map(string))
}
