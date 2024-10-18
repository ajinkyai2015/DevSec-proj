resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  versioning {
    enabled = true
  }
  tags = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.bucket
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = ["s3:GetObject", "s3:PutObject"]
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.this.arn}/*"
        Principal = "*"
      }
    ]
  })
}
