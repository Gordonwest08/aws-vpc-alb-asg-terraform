############################
# ALB (Application Load Balancer) - public
############################

# Security group for ALB - allow HTTP from anywhere
resource "aws_security_group" "alb_sg" {
  name        = format("%s-alb-sg", var.environment)
  description = "ALB security group - allow HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = format("%s-alb-sg", var.environment) })
}

# ALB
resource "aws_lb" "app_alb" {
  name               = format("%s-app-alb", var.environment)
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.alb_sg.id]

  tags = merge(local.common_tags, { Name = format("%s-app-alb", var.environment) })
}

# Target Group (instances)
resource "aws_lb_target_group" "app_tg" {
  name     = format("%s-app-tg", var.environment)
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/" # user-data installs a web service on '/'
    matcher             = "200"
  }

  tags = merge(local.common_tags, { Name = format("%s-app-tg", var.environment) })
}

# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
