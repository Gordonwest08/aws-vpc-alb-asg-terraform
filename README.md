AWS VPC Infrastructure With ALB, Auto Scaling Group & EC2 (Terraform Project)

A complete production-grade AWS infrastructure deployed using Terraform, including a custom VPC, public/private subnets, NAT Gateway, Internet Gateway, Application Load Balancer, Auto Scaling Group, Launch Template, IAM roles, and bootstrap user-data scripts.

This project demonstrates real-world cloud engineering, DevOps, infrastructure automation, and scalable architecture on AWS.

 Project Features
🔹 Infrastructure as Code (Terraform)

Modular, reusable Terraform configuration

Remote provisioning of all networking, compute and security resources

Automated user-data scripts for EC2 and ASG instances

🔹 Production-Grade AWS Architecture

Custom VPC (CIDR: 10.0.0.0/16)

Public & private subnets across 2 AZs

Internet Gateway + NAT Gateway

Route tables + associations

Security groups with least-privilege

Application Load Balancer (ALB)

Auto Scaling Group (ASG) with Launch Template

IAM Roles + Instance Profiles

SSM (Session Manager) access (no SSH required)

🔹 Scalability & Resilience

Auto-scaling EC2 instances across multiple AZs

Health checks via ALB

Instance replacement and lifecycle automation

📂 Directory Structure
vpc-project/
│── main.tf
│── provider.tf
│── variables.tf
│── outputs.tf
│── vpc.tf
│── ec2.tf
│── autoscaling.tf
│── alb.tf
│── sg.tf
│── iam.tf
│── locals.tf
│── terraform.tfvars
│── user-data.sh
│── user-data-private.sh
│── user-data-asg.sh
│── README.md

🧩 Architecture Diagram
                    ┌──────────────────────────────┐
                    │        Application LB         │
                    │  (Public Subnets, Port 80)    │
                    └──────────────┬───────────────┘
                                   │
                     ALB Target Group (HTTP)
                                   │
                    ┌──────────────┴───────────────┐
                    │      Auto Scaling Group       │
                    │  (Private Subnets, EC2)       │
                    └──────────────┬───────────────┘
                                   │
                           NAT Gateway
                                   │
Internet ─── IGW ─── Public Subnets│
                                   │
                         Private Subnets
                                   │
                           EC2 Instances

🛠️ How to Deploy
1️ Initialize Terraform
terraform init

2️ Validate
terraform validate

3️ Preview changes
terraform plan

4️ Deploy
terraform apply

 Accessing the Application

After deployment:

terraform output alb_dns_name


Paste the DNS name into your browser.

You should see:

Welcome to ASG instance — deployed via Terraform

🧹 Cleanup
terraform destroy