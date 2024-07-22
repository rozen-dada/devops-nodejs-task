variable "lb_sg_name" {
  description = "The name of the ALB security group"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the security groups will be created"
  type        = string
}

variable "app_port" {
  description = "The port the application listens on"
  type        = number
}

variable "lb_sg_ingress_cidr_blocks" {
  description = "The CIDR blocks for ingress traffic to the ALB security group"
  type        = list(string)
}

variable "lb_sg_egress_cidr_blocks" {
  description = "The CIDR blocks for egress traffic from the ALB security group"
  type        = list(string)
}

variable "ecs_tasks_sg_name" {
  description = "The name of the ECS tasks security group"
  type        = string
}

variable "ecs_tasks_sg_egress_cidr_blocks" {
  description = "The CIDR blocks for egress traffic from the ECS tasks security group"
  type        = list(string)
}