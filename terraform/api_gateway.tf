############################################
# API Gateway REST API
############################################

resource "aws_api_gateway_rest_api" "rag_api" {

  name        = local.api_gateway_name
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
  parent_id   = aws_api_gateway_rest_api.rag_api.root_resource_id
  path_part   = "chat"

}

############################################
# POST Method
############################################

resource "aws_api_gateway_method" "post_chat" {

  rest_api_id   = aws_api_gateway_rest_api.rag_api.id
  resource_id   = aws_api_gateway_resource.chat.id
  http_method   = "POST"
  authorization = "NONE"

}

############################################
# Lambda Integration
############################################

resource "aws_api_gateway_integration" "lambda" {

  rest_api_id             = aws_api_gateway_rest_api.rag_api.id
  resource_id             = aws_api_gateway_resource.chat.id
  http_method             = aws_api_gateway_method.post_chat.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"

  uri = aws_lambda_function.api.invoke_arn

}

############################################
# OPTIONS Method (CORS)
############################################

resource "aws_api_gateway_method" "options_chat" {

  rest_api_id   = aws_api_gateway_rest_api.rag_api.id
  resource_id   = aws_api_gateway_resource.chat.id
  http_method   = "OPTIONS"
  authorization = "NONE"

}

############################################
# OPTIONS Integration
############################################

resource "aws_api_gateway_integration" "options_chat" {

  rest_api_id = aws_api_gateway_rest_api.rag_api.id
  resource_id = aws_api_gateway_resource.chat.id
  http_method = aws_api_gateway_method.options_chat.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\":200}"
  }

}

############################################
# OPTIONS Method Response
############################################

resource "aws_api_gateway_method_response" "options_chat" {

  rest_api_id = aws_api_gateway_rest_api.rag_api.id
  resource_id = aws_api_gateway_resource.chat.id
  http_method = aws_api_gateway_method.options_chat.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }

}

############################################
# OPTIONS Integration Response
############################################

resource "aws_api_gateway_integration_response" "options_chat" {

  rest_api_id = aws_api_gateway_rest_api.rag_api.id
  resource_id = aws_api_gateway_resource.chat.id
  http_method = aws_api_gateway_method.options_chat.http_method
  status_code = aws_api_gateway_method_response.options_chat.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }

}

############################################
# Lambda Permission
############################################

resource "aws_lambda_permission" "apigateway" {

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.rag_api.execution_arn}/*/*"

}

############################################
# API Deployment
############################################

resource "aws_api_gateway_deployment" "deployment" {

  rest_api_id = aws_api_gateway_rest_api.rag_api.id

  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.options_chat,
    aws_api_gateway_integration_response.options_chat
  ]

}

############################################
# API Stage
############################################

resource "aws_api_gateway_stage" "dev" {

  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rag_api.id
  stage_name    = var.environment

  tags = local.common_tags

}