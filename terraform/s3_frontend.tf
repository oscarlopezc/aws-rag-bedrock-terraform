############################################
# S3 Bucket - Frontend
############################################

resource "aws_s3_bucket" "frontend" {

  bucket = local.frontend_bucket_name

  tags = local.common_tags

}

############################################
# Bucket Versioning
############################################

resource "aws_s3_bucket_versioning" "frontend" {

  bucket = aws_s3_bucket.frontend.id

  versioning_configuration {

    status = "Enabled"

  }

}

############################################
# Bucket Encryption
############################################

resource "aws_s3_bucket_server_side_encryption_configuration" "frontend" {

  bucket = aws_s3_bucket.frontend.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"

    }

  }

}

############################################
# Bucket Policy
############################################

data "aws_iam_policy_document" "frontend_bucket_policy" {

  statement {

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.frontend.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.frontend.arn
      ]
    }

  }

}

resource "aws_s3_bucket_policy" "frontend" {

  bucket = aws_s3_bucket.frontend.id

  policy = data.aws_iam_policy_document.frontend_bucket_policy.json

}