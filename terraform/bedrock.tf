############################################
# IAM Role - Amazon Bedrock Knowledge Base
############################################
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "bedrock_role" {

  name = "${var.project_name}-${var.environment}-bedrock-role"

  assume_role_policy = jsonencode({

  Version = "2012-10-17"

  Statement = [

    {

      Effect = "Allow"

      Principal = {

        Service = "bedrock.amazonaws.com"

      }

      Action = "sts:AssumeRole"

      Condition = {

        StringEquals = {

          "aws:SourceAccount" = data.aws_caller_identity.current.account_id

        }

        ArnLike = {

          "aws:SourceArn" = "arn:aws:bedrock:${var.aws_region}:${data.aws_caller_identity.current.account_id}:knowledge-base/*"

        }

      }

    }

  ]

})

  tags = local.common_tags

}
############################################
# IAM Policy
############################################

resource "aws_iam_policy" "bedrock_policy" {

  name = "${var.project_name}-${var.environment}-bedrock-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Sid    = "InvokeEmbeddingModel"

        Effect = "Allow"

        Action = [

          "bedrock:InvokeModel",
          "bedrock:ListFoundationModels",
          "bedrock:ListCustomModels"

        ]

        Resource = "*"

      },

      {
        Sid    = "ReadDatasource"

        Effect = "Allow"

        Action = [

          "s3:GetObject",
          "s3:ListBucket"

        ]

        Resource = [

          aws_s3_bucket.datasource.arn,
          "${aws_s3_bucket.datasource.arn}/*"

        ]

      },

      {
        Sid    = "ReadSecrets"

        Effect = "Allow"

        Action = [

          "secretsmanager:GetSecretValue"

        ]

        Resource = aws_secretsmanager_secret.pinecone_api_key.arn

      }

    ]

  })

}

############################################
# Attach Policy
############################################

resource "aws_iam_role_policy_attachment" "bedrock_policy_attach" {

  role       = aws_iam_role.bedrock_role.name

  policy_arn = aws_iam_policy.bedrock_policy.arn

}


############################################
# Wait for IAM Propagation
############################################

resource "time_sleep" "wait_for_iam" {

  depends_on = [
    aws_iam_role_policy_attachment.bedrock_policy_attach
  ]

  create_duration = "30s"

}

############################################
# Amazon Bedrock Knowledge Base
############################################

#resource "awscc_bedrock_knowledge_base" "knowledge_base" {

 # depends_on = [
  #  time_sleep.wait_for_iam,
  #  aws_secretsmanager_secret_version.pinecone_api_key

#  ]

  #name        = var.knowledge_base_name

  #description = var.knowledge_base_description

  #role_arn = aws_iam_role.bedrock_role.arn

  #knowledge_base_configuration = {

   # type = "VECTOR"

    #vector_knowledge_base_configuration = {

     # embedding_model_arn = "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v2:0"

    #}

  #}

  #storage_configuration = {

   # type = "PINECONE"

    #pinecone_configuration = {

     # connection_string = var.pinecone_host

      #credentials_secret_arn = aws_secretsmanager_secret.pinecone_api_key.arn

      #field_mapping = {

       #text_field     = "text"

      #metadata_field = "metadata"

      #}

    #}

  #}

  #tags = local.common_tags

#}

############################################
# Bedrock Data Source (S3)
############################################

#resource "awscc_bedrock_data_source" "datasource" {

#  knowledge_base_id = awscc_bedrock_knowledge_base.knowledge_base.id

 # name = "${var.project_name}-${var.environment}-datasource"

  #description = "S3 Data Source for RAG"

 # data_deletion_policy = "DELETE"

  #data_source_configuration = {

   # type = "S3"

    #s3_configuration = {

     # bucket_arn = aws_s3_bucket.datasource.arn

    #}
#  }
 # 
#}

############################################
# Amazon Bedrock Knowledge Base
############################################

resource "awscc_bedrock_knowledge_base" "knowledge_base" {

  depends_on = [
    time_sleep.wait_for_iam,
    aws_secretsmanager_secret_version.pinecone_api_key
  ]

  name        = var.knowledge_base_name

  description = var.knowledge_base_description

  role_arn = aws_iam_role.bedrock_role.arn

  knowledge_base_configuration = {

    type = "VECTOR"

    vector_knowledge_base_configuration = {

      embedding_model_arn = "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v2:0"

    }

  }

  storage_configuration = {

    type = "PINECONE"

    pinecone_configuration = {

      connection_string = var.pinecone_host

      credentials_secret_arn = aws_secretsmanager_secret.pinecone_api_key.arn

      field_mapping = {

        text_field     = "text"
        metadata_field = "metadata"

      }

    }

  }

 # tags = local.common_tags

}

############################################
# Bedrock Data Source (S3)
############################################

resource "awscc_bedrock_data_source" "datasource" {

  knowledge_base_id = awscc_bedrock_knowledge_base.knowledge_base.id

  name = "${var.project_name}-${var.environment}-datasource"

  description = "S3 Data Source for RAG"

  data_deletion_policy = "DELETE"

  data_source_configuration = {

    type = "S3"

    s3_configuration = {

      bucket_arn = aws_s3_bucket.datasource.arn
      inclusion_prefixes = [
       "/"
      ]

    }

  }

}