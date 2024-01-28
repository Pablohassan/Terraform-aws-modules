resource "aws_db_instance" "rusmir_rds" {

  allocated_storage    = 10
  db_name              = "rusdb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  multi_az               = true
  db_subnet_group_name   = var.db_subnet_group_name
  skip_final_snapshot  = true
  vpc_security_group_ids = var.db_sg_id
  tags = {
    Name = "wordpress-rds-instance"
  }
}

# resource "aws_db_instance" "wordpress_read_replica" {
#   identifier           = "wordpress-read-replica"
#   replicate_source_db  = aws_db_instance.rusmir_rds.id
#   instance_class       = "db.t2.micro"
#   publicly_accessible  = false
#   vpc_security_group_ids = var.db_sg_id
#   db_subnet_group_name = var.db_subnet_group_name
  
#   depends_on =[aws_db_instance.rusmir_rds]
# }