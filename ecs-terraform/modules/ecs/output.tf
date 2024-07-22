output "ecs_cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.app.arn
}

output "ecs_service_id" {
  value = aws_ecs_service.main.id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.my_app.repository_url
}