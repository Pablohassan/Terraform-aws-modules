output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.rusmir_vpc.id
}

output "sg_pub_id" {
  value = aws_security_group.allow_ssh_pub.id
}

output "sg_priv_id" {
  value = aws_security_group.allow_ssh_priv.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.app_subnet_a.id, aws_subnet.app_subnet_b.id]
}