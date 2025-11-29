output "vpc_id" {
  value       = try(aws_vpc.main.id, "")
  description = "ID of the created VPC"

}

output "public_subnet_ids" {
  value       = try(aws_subnet.public[*].id, [])
  description = "IDs of public subnets"

}

output "private_subnets_ids" {
  value       = try(aws_subnet.private[*].id, [])
  description = "IDs of private subnets"

}


output "web_instance_id" {
  value       = try(aws_instance.web_public.id, "")
  description = "ID of public web EC2 instance"
}

output "web_instance_public_ip" {
  value       = try(aws_instance.web_public.public_ip, "")
  description = "Public IP of web instance"
}

output "alb_dns_name" {
  value       = aws_lb.app_alb.dns_name
  description = "ALB DNS name"
}

output "asg_name" {
  value       = aws_autoscaling_group.app_asg.name
  description = "Auto Scaling Group name"
}
