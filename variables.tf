variable "aws_region" {
  type    = string
  default = "us-east-1"

}

variable "environment" {
  type    = string
  default = "dev"

}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"

}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]


}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]

}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]

}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type for demo"
}

variable "ssh_allowed_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"] # WARNING: wide open; restrict this to your IP range for security
  description = "CIDR blocks allowed for SSH. Use your IP for production."
}

variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_desired_capacity" {
  type    = number
  default = 1
}

variable "asg_max_size" {
  type    = number
  default = 2
}

# Optional key pair for debugging (can be blank)
variable "key_pair_name" {
  type        = string
  default     = ""
  description = "Name of an existing EC2 key pair (optional). Leave empty to not assign a key"
}

