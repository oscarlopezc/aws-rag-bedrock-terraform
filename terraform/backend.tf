terraform {

  backend "s3" {
    bucket  = "aws-rag-bedrock-terraform-dev-tfstate"
    key     = "dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

}