############################################
# Secrets Manager - Pinecone API Key
############################################

resource "aws_secretsmanager_secret" "pinecone_api_key" {

  name = "${var.project_name}-${var.environment}-pinecone-api-key"

  description = "Pinecone API Key for Amazon Bedrock Knowledge Base"

  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "pinecone_api_key" {

  secret_id = aws_secretsmanager_secret.pinecone_api_key.id

  secret_string = var.pinecone_api_key

}
