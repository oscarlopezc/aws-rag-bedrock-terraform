############################################
# Lambda Function
############################################

resource "aws_lambda_function" "api" {

  function_name = local.lambda_name

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.13"

  handler = "lambda_function.lambda_handler"

  timeout = 30

  memory_size = 512

  filename = "lambda.zip"

  source_code_hash = filebase64sha256("lambda.zip")

  environment {

    variables = {

      CONTEXT           = var.context
      #KNOWLEDGE_BASE_ID = ""
      KNOWLEDGE_BASE_ID = awscc_bedrock_knowledge_base.knowledge_base.id
      MODEL_ID          = var.model_id
      TEMPERATURE       = var.temperature

    }

  }

  tags = local.common_tags

}

