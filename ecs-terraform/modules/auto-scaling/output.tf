output "autoscaling_target_id" {
  value = aws_appautoscaling_target.target.id
}

output "scale_up_policy_id" {
  value = aws_appautoscaling_policy.up.id
}

output "scale_down_policy_id" {
  value = aws_appautoscaling_policy.down.id
}

output "cpu_high_alarm_id" {
  value = aws_cloudwatch_metric_alarm.service_cpu_high.id
}

output "cpu_low_alarm_id" {
  value = aws_cloudwatch_metric_alarm.service_cpu_low.id
}