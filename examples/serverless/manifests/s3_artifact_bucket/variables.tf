variable "tags" {
  description = "The tags for the resource"
  type        = map(string)
}

variable "bucket_name" {
  description = "The S3 artifact bucket name"
  type        = string
}

variable "force_destroy" {
  description = "Whether the bucket can be destroyed when not empty"
  type        = bool
  default     = true
}
