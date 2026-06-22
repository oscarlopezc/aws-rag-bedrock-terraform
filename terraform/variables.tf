variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "aws-rag-bedrock-terraform"
}

variable "lambda_function_name" {
  description = "AWS Lambda function name"
  type        = string
  default     = "Lambda_API"
}

variable "context" {
  description = "Prompt prefix sent to the model"
  type        = string
}


variable "model_arn" {
  type = string
}

variable "temperature" {
  description = "Model temperature"
  type        = string
  default     = "0.5"
}
variable "pinecone_api_key" {
  description = "Pinecone API Key"
  type        = string
  sensitive   = true
}
variable "pinecone_host" {
  type = string
}

variable "knowledge_base_name" {
  type    = string
  default = "rag-knowledge-base"
}

variable "knowledge_base_description" {
  type    = string
  default = "Knowledge Base para RAG"
}

