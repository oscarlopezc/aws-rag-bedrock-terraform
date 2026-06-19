############################################
# S3 Bucket - Knowledge Base Data Source
############################################

resource "aws_s3_bucket" "datasource" {

  bucket = local.datasource_bucket_name

  tags = local.common_tags

}

############################################
# Bucket Versioning
############################################

resource "aws_s3_bucket_versioning" "datasource" {

  bucket = aws_s3_bucket.datasource.id

  versioning_configuration {
    status = "Enabled"
  }

}

############################################
# Bucket Encryption
############################################

resource "aws_s3_bucket_server_side_encryption_configuration" "datasource" {

  bucket = aws_s3_bucket.datasource.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}