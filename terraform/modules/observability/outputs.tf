output "log_groups_names" {
  value = aws_cloudwatch_log_group.microservice[*].name
}

output "sns_topic_arn" {
  description = "ARN of the SNS alarm topic"
  value       = aws_sns_topic.alarms.arn
}