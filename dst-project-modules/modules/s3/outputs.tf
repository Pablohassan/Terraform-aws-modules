output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.rusmir_datascientest_bucket.bucket
}

output "iam_policy_arn" {
  description = "The ARN of the IAM policy"
  value       = aws_iam_policy.rusmir_datascientest_s3_policy.arn
}