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