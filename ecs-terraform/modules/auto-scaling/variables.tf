variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "ecs_service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "auto_scale_role_arn" {
  description = "The ARN of the IAM role that allows ECS auto scaling"
  type        = string
}

variable "min_capacity" {
  description = "The minimum capacity for the auto scaling group"
  type        = number
}

variable "max_capacity" {
  description = "The maximum capacity for the auto scaling group"
  type        = number
}