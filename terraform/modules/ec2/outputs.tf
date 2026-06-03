output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_lb.dns_name
}

output "alb_arn_suffix" {
  description = "ARN suffix of the ALB (used in CloudWatch metrics)"
  value       = aws_lb.maiapp_lbn.arn_suffix
}

output "alb_arn" {
  description = "Full ARN of the ALB"
  value       = aws_lb.app_lb.arn
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.app_tg.arn
}

# output "ec2_security_group_id" {
#   description = "ID of the EC2 security group (used by RDS module to allow DB access)"
#   value       = aws_security_group.ec2.id
# }

# output "alb_security_group_id" {
#   description = "ID of the ALB security group"
#   value       = aws_security_group.alb.id
# }

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.app_asg.name
}

output "launch_template_id" {
  description = "ID of the EC2 Launch Template"
  value       = aws_launch_template.app_lt.id
}
