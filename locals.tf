locals {
  common_tags = {
    Project     = "vpc-project"
    Environment = "var.environment"
    ManagedBy   = "Terraform"
  }
}