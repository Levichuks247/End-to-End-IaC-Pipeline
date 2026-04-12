terraform {
  backend "s3" {
    bucket  = "levichuks-terraform-state-v11"
    key     = "terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region

  # TPO FEATURE: Automated Cost Tracking & Compliance Tags
  default_tags {
    tags = {
      ProductLine = "B2B-SaaS-Infrastructure"
      ManagedBy   = "Terraform"
      Compliance  = "DORA-2026-Ready"
      CostCenter  = "IE-Research-Unit"
      Environment = "Production"
    }
  }
}