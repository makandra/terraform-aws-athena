variable "query_bucket_name" {
  description = "The name of the bucket to save the query into."
  type        = string
}

variable "cloudfront" {
  description = "The name of the s3 bucket containing the cloudfront logs. Creates a db and saved cloudfront queries if set."
  type        = string
  default     = null
}

variable "cloudtrail" {
  description = "Configuration for cloudtrail. Creates a db and saved cloudfront queries if bucket_name is set. Only set prefix if you configured one in your cloudtrail"
  type = object({
    bucket_name = optional(string)
    prefix      = optional(string)
  })
  default = {}
}

variable "ses" {
  description = "The name of the s3 bucket containing the ses logs. Creates a db and saved ses queries if set"
  type        = string
  default     = null
}
