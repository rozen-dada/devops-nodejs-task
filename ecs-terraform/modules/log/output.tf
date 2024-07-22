output "log_group_name" {
  value = aws_cloudwatch_log_group.cb_log_group.name
}

output "log_stream_name" {
  value = aws_cloudwatch_log_stream.cb_log_stream.name
}