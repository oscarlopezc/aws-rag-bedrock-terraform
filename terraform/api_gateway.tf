############################################
# API Gateway REST API
############################################

resource "aws_api_gateway_rest_api" "rag_api" {

  name = local.api_gateway_name

  description = "REST API for AWS RAG Bedrock"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = local.common_tags
}

############################################
# API Resource
############################################

resource "aws_api_gateway_resource" "chat" {

  rest_api_id = aws_api_gateway_rest_api.rag_api.id

  parent_id = aws_api_gateway_rest_api.rag_api.root_resource_id

  path_part = "chat"

}

############################################
# POST Method
############################################

resource "aws_api_gateway_method" "post_chat" {

  rest_api_id = aws_api_gateway_rest_api.rag_api.id

  resource_id = aws_api_gateway_resource.chat.id

  http_method = "POST"

  authorization = "NONE"

}
############################################
# Lambda Integration
############################################

resource "aws_api_gateway_integration" "lambda" {

  rest_api_id = aws_api_gateway_rest_api.rag_api.id

  resource_id = aws_api_gateway_resource.chat.id

  http_method = aws_api_gateway_method.post_chat.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"

  uri = aws_lambda_function.api.invoke_arn

}

############################################
# Lambda Permission
############################################

resource "aws_lambda_permission" "apigateway" {

  statement_id = "AllowExecutionFromAPIGateway"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.api.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.rag_api.execution_arn}/*/*"

}

############################################
# API Deployment
############################################

resource "aws_api_gateway_deployment" "deployment" {

  rest_api_id = aws_api_gateway_rest_api.rag_api.id

  depends_on = [

    aws_api_gateway_integration.lambda

  ]

}

############################################
# API Stage
############################################

resource "aws_api_gateway_stage" "dev" {

  deployment_id = aws_api_gateway_deployment.deployment.id

  rest_api_id = aws_api_gateway_rest_api.rag_api.id

  stage_name = var.environment

  tags = local.common_tags

}