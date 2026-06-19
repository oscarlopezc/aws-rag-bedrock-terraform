terraform {

  required_version = ">= 1.11.0"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.96"
    }

    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 1.30"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }

  }

}
