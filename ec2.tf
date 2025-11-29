###################
#Data source: latest amazon linux 2 AMI

data "aws_ami" "amazon_linux" {
  most_recent = true


  filter {

    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]

  }

  owners = ["137112412989"] #Amazon




}




###############
# Ec2 instance (public)
######################
resource "aws_instance" "web_public" {
  subnet_id                   = aws_subnet.public[0].id # <-- REQUIRED
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.ec2_public_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true




  #user data -bootstrap webserver
  user_data = file("${path.module}/user-data.sh")


  tags = merge(local.common_tags, {
    Name = format("%s-public-web-01", var.environment)

  })

}

#################################
# Private EC2 instance
#################################
resource "aws_instance" "app_private" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.private[0].id # ❗ goes into private subnet #1

  vpc_security_group_ids = [
    aws_security_group.private_ec2_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  associate_public_ip_address = false # ❗ PRIVATE

  user_data = file("${path.module}/user-data-private.sh")

  tags = merge(local.common_tags, {
    Name = format("%s-private-app-01", var.environment)
  })
}
