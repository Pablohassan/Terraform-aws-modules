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
  db_subnet_group_name   = var.db_subnet_group.name
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  tags = {
    Name = "wordpress-rds-instance"
  }
}