output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_lb.dns_name
}

output "alb_arn_suffix" {
  description = "ARN suffix of the ALB"
  value       = aws_lb.app_lb.arn_suffix
}

output "alb_arn" {
  description = "Full ARN of the ALB"
  value       = aws_lb.app_lb.arn
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.app_tg.arn
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.app_asg.name
}

output "launch_template_id" {
  description = "ID of the EC2 Launch Template"
  value       = aws_launch_template.app_lt.id
}

output "lb_dns_name" {
  description = "DNS name of ALB"
  value       = aws_lb.app_lb.dns_name
}

output "lb_zone_id" {
  description = "zone ID of ALB"
  value       = aws_lb.app_lb.zone_id
}