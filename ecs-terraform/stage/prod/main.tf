terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "network" {
  source         = "../../modules/network"
  vpc_cidr_block = "10.0.0.0/16"  # Example CIDR block for production
  az_count       = 3               # Example for more availability zones in production
}

module "alb" {
  source                        = "../../modules/alb"
  alb_name                      = "prod-load-balancer"
  subnets                       = module.network.public_subnet_ids  # Updated to use output from network module
  security_groups               = [module.security_groups.lb_sg_id]  # Updated to use output from security_groups module
  target_group_name             = "prod-target-group"
  target_group_port             = 80
  target_group_protocol         = "HTTP"
  vpc_id                        = module.network.vpc_id
  target_group_target_type      = "ip"
  health_check_healthy_threshold = 3
  health_check_interval         = 30
  health_check_protocol         = "HTTP"
  health_check_matcher          = "200"
  health_check_timeout          = 3
  health_check_path             = "/health"
  health_check_unhealthy_threshold = 2
  listener_port                 = 80
  listener_protocol             = "HTTP"
}

module "security_groups" {
  source                     = "../../modules/security_groups"
  lb_sg_name                 = "prod-load-balancer-security-group"
  vpc_id                     = module.network.vpc_id
  app_port                   = 80
  lb_sg_ingress_cidr_blocks  = ["0.0.0.0/0"]
  lb_sg_egress_cidr_blocks   = ["0.0.0.0/0"]
  ecs_tasks_sg_name          = "prod-ecs-tasks-security-group"
  ecs_tasks_sg_egress_cidr_blocks = ["0.0.0.0/0"]
}

module "ecs" {
  source                  = "../../modules/ecs"
  ecs_cluster_name        = "prod-cluster"
  template_file_path      = "../../templates/ecs/prod_app.json.tpl"  # Update to use production template
  app_image               = "${aws_ecr_repository.my-app.repository_url}:latest"
  app_port                = 80
  fargate_cpu             = "512"  # Example for more resources in production
  fargate_memory          = "1024" # Example for more resources in production
  ecr_repository_name     = "my-app"
  ecs_task_family         = "prod-app-task"
  execution_role_arn      = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
  ecs_service_name        = "prod-service"
  app_count               = 4  # Example for more instances in production
  ecs_security_groups     = [module.security_groups.ecs_tasks_sg_id]
  ecs_subnets             = module.network.private_subnet_ids  # Updated to use output from network module
  target_group_arn        = module.alb.alb_target_group_arn
  ecs_service_dependencies = [
    aws_alb_listener.front_end.id,
    aws_iam_role_policy_attachment.ecs_task_execution_role_policy_attachment.id
  ]
}

module "auto_scaling" {
  source                  = "../../modules/auto_scaling"
  ecs_cluster_name        = module.ecs.ecs_cluster_id
  ecs_service_name        = module.ecs.ecs_service_id
  auto_scale_role_arn     = "arn:aws:iam::123456789012:role/ecsAutoScalingRole"
  min_capacity            = 5  # Example for more instances in production
  max_capacity            = 10 # Example for more instances in production
}

module "logging" {
  source             = "../../modules/logging"
  log_group_name     = "/ecs/prod-app"
  retention_in_days  = 30
  log_stream_name    = "prod-log-stream"
  tags               = {
    Name = "prod-log-group"
  }
}
