############################################
# IAM Role for Lambda
############################################

resource "aws_iam_role" "lambda_role" {

  name = "${local.lambda_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {

  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}

############################################
# Amazon Bedrock Policy
############################################

resource "aws_iam_policy" "lambda_bedrock_policy" {

  name        = "${local.lambda_name}-bedrock-policy"

  description = "Allow Lambda to query Amazon Bedrock Knowledge Bases"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "bedrock:Retrieve",
          "bedrock:RetrieveAndGenerate",
          "bedrock:InvokeModel",
          "bedrock:GetInferenceProfile"
        ]

        Resource = "*"

      }

    ]

  })
}

############################################
# Attach Bedrock Policy
############################################

resource "aws_iam_role_policy_attachment" "lambda_bedrock_attach" {

  role = aws_iam_role.lambda_role.name

  policy_arn = aws_iam_policy.lambda_bedrock_policy.arn

}
