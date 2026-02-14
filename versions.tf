terraform {
  required_version = ">= 1.3.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.32.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.88.0"
    }
  }
}