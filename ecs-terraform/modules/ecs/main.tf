resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster_name
}

data "template_file" "cb_app" {
  template = file(var.template_file_path)

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
  }
}

# Define the ECR repository
resource "aws_ecr_repository" "my_app" {
  name = var.ecr_repository_name
}

resource "aws_ecs_task_definition" "app" {
  family                   = var.ecs_task_family
  execution_role_arn       = var.execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.cb_app.rendered
}

resource "aws_ecs_service" "main" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = var.ecs_security_groups
    subnets          = var.ecs_subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "cb-app"
    container_port   = var.app_port
  }

  depends_on = var.ecs_service_dependencies
}