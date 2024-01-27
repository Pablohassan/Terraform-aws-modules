resource "aws_s3_bucket" "rusmir_datascientest_bucket" {
  bucket = "rusmir-datascientest-${var.environment}"
// or any other configuration you need

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_policy" "rusmir_datascientest_bucket_policy" {
 bucket = aws_s3_bucket.rusmir_datascientest_bucket.id
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::rusmir_datascientest-${var.environment}/*",
        Principal = "*" 
      }
    ]
  })
}