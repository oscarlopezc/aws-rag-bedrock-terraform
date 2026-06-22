############################################
# Lambda
############################################

output "lambda_name" {
  description = "Lambda Function Name"
  value       = aws_lambda_function.api.function_name
}

output "lambda_arn" {
  description = "Lambda Function ARN"
  value       = aws_lambda_function.api.arn
}

############################################
# API Gateway
############################################

output "api_gateway_id" {
  description = "API Gateway ID"
  value       = aws_api_gateway_rest_api.rag_api.id
}

output "api_gateway_url" {
  description = "Invoke URL"

  value = "${aws_api_gateway_stage.dev.invoke_url}/chat"
}

############################################
# CloudFront
############################################

output "cloudfront_domain" {
  description = "CloudFront Domain Name"
  value       = aws_cloudfront_distribution.frontend.domain_name
}

############################################
# S3
############################################

output "frontend_bucket" {
  description = "Frontend Bucket"
  value       = aws_s3_bucket.frontend.bucket
}

output "datasource_bucket" {
  description = "Knowledge Base Data Source Bucket"
  value       = aws_s3_bucket.datasource.bucket
}

############################################
# Bedrock Outputs
############################################

output "knowledge_base_id" {
  value = awscc_bedrock_knowledge_base.knowledge_base.id
}

output "knowledge_base_arn" {
  value = awscc_bedrock_knowledge_base.knowledge_base.knowledge_base_arn
}

output "bedrock_role_arn" {

  value = aws_iam_role.bedrock_role.arn

}


############################################
# CI/CD Outputs
############################################

output "cloudfront_distribution_id" {

  description = "CloudFront Distribution ID"

  value = aws_cloudfront_distribution.frontend.id

}