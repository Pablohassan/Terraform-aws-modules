output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.rusmir_vpc.id
}

output "sg_pub_id" {
  value = aws_security_group.allow_http_ssh_pub.id
}

output "sg_priv_id" {
  value = aws_security_group.allow_ssh_priv.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
}

output "bastion_sg_22" {

value =  [aws_security_group.bastion_sg_22.id]
}

output "app_subnet_ids" {
  value = [aws_subnet.app_subnet_a.id, aws_subnet.app_subnet_b.id]
}

output "vpc_security_group_id" {
  value = [aws_security_group.db_sg.id]
  
}

output "db_subnet_group_name" {
value = aws_db_subnet_group.db_subnet_group.name
}

output "db_sg_id" {
    value = [aws_security_group.db_sg.id]
}

