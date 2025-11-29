resource "aws_security_group" "ec2_public_sg" {
  name        = format("%s-public-ec2-sg", var.environment)
  description = "Allow HTTP and SSH (optional) to public EC2 instances"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP from anywhere (for demo portfolios)
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # OPTIONAL: SSH access (you can restrict this to your IP in terraform.tfvars for security)
  ingress {
    description = "SSH (optional)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = format("%s-public-ec2-sg", var.environment)
  })
}

#############################
# SG for private EC2
#############################
resource "aws_security_group" "private_ec2_sg" {
  name        = format("%s-private-ec2-sg", var.environment)
  description = "Allow only internal traffic for private EC2"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP only from public subnets or ALB (optional)
  ingress {
    description = "HTTP from inside VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr] # allow only internal VPC
  }

  # Outbound allowed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = format("%s-private-ec2-sg", var.environment)
  })
}
