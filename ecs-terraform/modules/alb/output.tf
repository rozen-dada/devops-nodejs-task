output "alb_arn" {
  value = aws_alb.main.arn
}

output "alb_dns_name" {
  value = aws_alb.main.dns_name
}

output "alb_target_group_arn" {
  value = aws_alb_target_group.app.arn
}