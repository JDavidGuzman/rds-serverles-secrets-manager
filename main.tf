terraform {
  required_providers {
    aws = {
      version = ">= 3.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  prefix = "${var.project}-${terraform.workspace}"
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Repository  = var.repo
    Owner       = "David Guzmán"
    ManagedBy   = "Terraform"
  }
}

data "aws_region" "current" {}