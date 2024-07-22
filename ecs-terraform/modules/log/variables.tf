variable "log_group_name" {
  description = "The name of the CloudWatch log group"
  type        = string
}

variable "retention_in_days" {
  description = "The number of days to retain the logs"
  type        = number
  default     = 30
}

variable "log_stream_name" {
  description = "The name of the CloudWatch log stream"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {
    Name = "cb-log-group"
  }
}