output "db_instance_endpoint" {
  value = aws_db_instance.rusmir_rds.endpoint
}


output "source_db_instance_id" {
  value = aws_db_instance.rusmir_rds.id
}