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
  vpc_cidr_block = "172.17.0.0/16"
  az_count       = 2
}

module "alb" {
  source                        = "../../modules/alb"
  alb_name                      = "cb-load-balancer"
  subnets                       = ["subnet-12345678", "subnet-23456789"]
  security_groups               = ["sg-12345678"]
  target_group_name             = "cb-target-group"
  target_group_port             = 80
  target_group_protocol         = "HTTP"
  vpc_id                        = "vpc-12345678"
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
  lb_sg_name                 = "cb-load-balancer-security-group"
  vpc_id                     = "vpc-12345678"
  app_port                   = 80
  lb_sg_ingress_cidr_blocks  = ["0.0.0.0/0"]
  lb_sg_egress_cidr_blocks   = ["0.0.0.0/0"]
  ecs_tasks_sg_name          = "cb-ecs-tasks-security-group"
  ecs_tasks_sg_egress_cidr_blocks = ["0.0.0.0/0"]
}

module "ecs" {
  source                  = "../../modules/ecs"
  ecs_cluster_name        = "cb-cluster"
  template_file_path      = "../../templates/ecs/cb_app.json.tpl"
  app_image               = "${aws_ecr_repository.my-app.repository_url}:latest"
  app_port                = 80
  fargate_cpu             = "256"
  fargate_memory          = "512"
  ecr_repository_name     = "my-app"
  ecs_task_family         = "cb-app-task"
  execution_role_arn      = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
  ecs_service_name        = "cb-service"
  app_count               = 2
  ecs_security_groups     = [module.security_groups.ecs_tasks_sg_id]
  ecs_subnets             = ["subnet-12345678", "subnet-23456789"]
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
  min_capacity            = 3
  max_capacity            = 6
}

module "logging" {
  source             = "../../modules/logging"
  log_group_name     = "/ecs/cb-app"
  retention_in_days  = 30
  log_stream_name    = "cb-log-stream"
  tags               = {
    Name = "cb-log-group"
  }
}