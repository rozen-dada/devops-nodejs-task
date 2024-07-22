variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "template_file_path" {
  description = "The path to the ECS task definition template file"
  type        = string
}

variable "app_image" {
  description = "The Docker image for the application"
  type        = string
}

variable "app_port" {
  description = "The port the application listens on"
  type        = number
}

variable "fargate_cpu" {
  description = "The number of CPU units used by the Fargate task"
  type        = string
}

variable "fargate_memory" {
  description = "The amount of memory used by the Fargate task"
  type        = string
}

variable "ecr_repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "ecs_task_family" {
  description = "The family of the ECS task definition"
  type        = string
}

variable "execution_role_arn" {
  description = "The ARN of the IAM role that allows ECS tasks to make AWS API calls"
  type        = string
}

variable "ecs_service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "app_count" {
  description = "The desired number of ECS tasks"
  type        = number
}

variable "ecs_security_groups" {
  description = "The security groups to assign to the ECS tasks"
  type        = list(string)
}

variable "ecs_subnets" {
  description = "The subnets to assign to the ECS tasks"
  type        = list(string)
}

variable "target_group_arn" {
  description = "The ARN of the target group to associate with the ECS service"
  type        = string
}

variable "ecs_service_dependencies" {
  description = "The dependencies for the ECS service"
  type        = list(string)
}