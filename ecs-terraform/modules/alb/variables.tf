variable "alb_name" {
  description = "The name of the ALB"
  type        = string
}

variable "subnets" {
  description = "A list of subnet IDs for the ALB"
  type        = list(string)
}

variable "security_groups" {
  description = "A list of security group IDs to associate with the ALB"
  type        = list(string)
}

variable "target_group_name" {
  description = "The name of the target group"
  type        = string
}

variable "target_group_port" {
  description = "The port for the target group"
  type        = number
}

variable "target_group_protocol" {
  description = "The protocol for the target group"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID for the target group"
  type        = string
}

variable "target_group_target_type" {
  description = "The target type for the target group"
  type        = string
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
  type        = number
}

variable "health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target"
  type        = number
}

variable "health_check_protocol" {
  description = "The protocol to use to connect with the target"
  type        = string
}

variable "health_check_matcher" {
  description = "The HTTP codes to use when checking for a successful response from a target"
  type        = string
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check"
  type        = number
}

variable "health_check_path" {
  description = "The destination for the health check request"
  type        = string
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive health check failures required before considering the target unhealthy"
  type        = number
}

variable "listener_port" {
  description = "The port on which the load balancer is listening"
  type        = number
}

variable "listener_protocol" {
  description = "The protocol for connections from clients to the load balancer"
  type        = string
}