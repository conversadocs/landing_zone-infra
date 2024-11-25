terraform {
  backend "s3" {
    bucket         = "conversadocs-terraform"
    key            = "state/prime/landing_zone.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
    profile        = "cd-prime"
  }

  required_version = "1.9.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Terraform = "true"
    }
  }
}
