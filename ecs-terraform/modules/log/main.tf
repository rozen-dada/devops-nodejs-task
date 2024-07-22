resource "aws_cloudwatch_log_group" "cb_log_group" {
  name              = var.log_group_name
  retention_in_days = var.retention_in_days

  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "cb_log_stream" {
  name           = var.log_stream_name
  log_group_name = aws_cloudwatch_log_group.cb_log_group.name
}