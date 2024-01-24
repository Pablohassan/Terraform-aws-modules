resource "aws_s3_bucket" "rusmir_datascientest_bucket" {
  bucket = "rusmir-datascientest-${var.environment}"
  acl    = "private"  // or any other configuration you need

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_policy" "rusmir_datascientest_s3_policy" {
  name   = "rusmir_datascientest_s3_policy_for_${var.environment}"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::rusmir_datascientest-${var.environment}/*"
      }
    ]
  })
}