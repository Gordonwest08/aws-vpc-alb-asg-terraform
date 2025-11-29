############################
# IAM Role for EC2 (to allow SSM & future permissions)
############################
resource "aws_iam_role" "ec2_role" {
  name = format("%s-ec2-role", var.environment)

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = format("%s-ec2-profile", var.environment)
  role = aws_iam_role.ec2_role.name
}
