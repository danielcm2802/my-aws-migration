


# resource "aws_cloudwatch_log_group" "app_logs" {
#   name              = "/aws/ec2/${var.project_name}-microservices"
#   retention_in_days = 7

#   tags = {
#     Name        = "${var.project_name}-container-logs"
#     Environment = var.environment
#   }
# }


# lunch templates
# -----------------------
resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.project_name}-lt-app"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.ec2_instance_profile
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2.id] #create!!!!!!!!!!!!!!!!!!!!!!!!!!
  }

  monitoring {
    enabled = true
  }
 # create log group!!!!!!!!!!!!!!!!!!!
  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo dnf update -y
              sudo dnf install docker -y
              sudo systemctl start docker
              sudo systemctl enable docker

              sudo docker run -d \
                -p 8080:80 \
                --name web-app \
                --log-driver=awslogs \
                --log-opt awslogs-region=${var.aws_region} \
                --log-opt awslogs-group=${aws_cloudwatch_log_group.app_logs.name} \ 
                --log-opt awslogs-stream=app-stream \
                nginx:latest
              EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}



# autoscaling group EC2
# ----------------------
resource "aws_autoscaling_group" "app_asg" {
  name                      = "${var.project_name}-asg"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = var.private_app_subnet_ids
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app_lt.id 
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app.arn] # createee!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}



# application LB
# --------------------
resource "aws_lb" "app_lb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id] # createee!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  subnets            = var.public_subnet_ids

  enable_deletion_protection = true

  tags = {
    Name        = "${var.project_name}-alb"
    Environment = var.environment
  }
}



# target group
# --------------
resource "aws_lb_target_group" "app_tg" {
  name        = "${var.project_name}-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name        = "${var.project_name}-tg"
    Environment = var.environment
  }
}



# application LB listener
# ----------------------------
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
