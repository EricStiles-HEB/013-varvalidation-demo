terraform {
  required_version = "~> 0.13.0"
  backend "remote" {
    organization = "TFTMM"
    workspaces { name = "varvalidation-demo" }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "2.70.0"
    }
  }
}

variable "aws_region" {
  validation {
    condition   = length(var.aws_region) == 9 && substr(var.aws_region, 0, 2) == "us-"
    error_message = "The aws_region value must be a valid US-based region code, starting with \"us-\"."
  }
}

provider "aws" {
  region = var.aws_region
  alias  = "hashi"
}

module "s3-module" {
  source = "app.terraform.io/TFTMM/s3-module/aws"
  providers = {
    aws = aws.hashi
  }
}
