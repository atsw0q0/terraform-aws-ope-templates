output "cwl_arn" {
  value = aws_cloudwatch_log_group.rds_stop.arn
}

output "lambda_arn" {
  value = aws_lambda_function.rds_stop.arn
}

output "lambda_code_sha256" {
  value = aws_lambda_function.rds_stop.code_sha256
}

output "events_id" {
  value = aws_cloudwatch_event_rule.schedule.id
}
