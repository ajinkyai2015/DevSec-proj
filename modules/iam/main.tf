resource "aws_iam_policy" "terraform_backend_policy" {
  name        = "TerraformBackendS3Policy"
  description = "Policy for accessing the S3 bucket for Terraform state"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = [
          "arn:aws:s3:::cicd-statefile",
          "arn:aws:s3:::cicd-statefile/*"
        ]
      }
    ]
  })
}
