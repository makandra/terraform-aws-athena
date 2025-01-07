terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      version = ">= 4.55.0"
      source  = "hashicorp/aws"
    }
  }
}
