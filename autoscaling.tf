############################
# Launch Template (used by ASG)
############################
resource "aws_launch_template" "app_lt" {
  name_prefix   = format("%s-app-lt-", var.environment)
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    # Security groups for instances (allow only from ALB)
    security_groups = [aws_security_group.asg_sg.id]
  }

  key_name = var.key_pair_name != "" ? var.key_pair_name : null

  user_data = filebase64("${path.module}/user-data-asg.sh")

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = format("%s-asg-instance", var.environment)
    })
  }
}

############################
# Security Group for ASG instances (private)
############################
resource "aws_security_group" "asg_sg" {
  name        = format("%s-asg-sg", var.environment)
  description = "ASG instances SG - allow HTTP only from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = format("%s-asg-sg", var.environment) })
}

############################
# AutoScaling Group (attached to target group)
############################
resource "aws_autoscaling_group" "app_asg" {
  name                = format("%s-app-asg", var.environment)
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size
  desired_capacity    = var.asg_desired_capacity
  vpc_zone_identifier = aws_subnet.private[*].id

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 60
  force_delete              = true

  tag {
    key                 = "Name"
    value               = format("%s-asg-instance", var.environment)
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

