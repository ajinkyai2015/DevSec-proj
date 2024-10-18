resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.this.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "s3:*",
        Effect    = "Allow",
        Resource  = "${aws_s3_bucket.this.arn}/*",
        Principal = {
          "AWS": "arn:aws:iam::339146967744:root"  # Replace ACCOUNT_ID with your actual AWS account ID
        }
      }
    ]
  })
}

