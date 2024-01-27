output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.rusmir_datascientest_bucket.bucket
}

output "s3_bucket_arn" {
  description = "The ARN of the IAM policy"
  value       = aws_s3_bucket.rusmir_datascientest_bucket.arn
}

output "aws_s3_bucket_policy" {
  value = aws_s3_bucket_policy.rusmir_datascientest_bucket_policy.id
  
}