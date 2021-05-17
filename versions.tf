terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.13"
    }
  }
  required_version = ">= 0.14"
}
