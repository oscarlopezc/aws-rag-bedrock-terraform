locals {

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  frontend_bucket_name = "${var.project_name}-${var.environment}-frontend"

  datasource_bucket_name = "${var.project_name}-${var.environment}-datasource"

  lambda_name = "${var.project_name}-${var.environment}-lambda"

  api_gateway_name = "${var.project_name}-${var.environment}-api"

  cloudfront_comment = "${var.project_name}-${var.environment}"

}