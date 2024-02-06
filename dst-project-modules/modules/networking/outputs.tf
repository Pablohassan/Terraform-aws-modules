output "rusmir_vpc" {
  description = "The ID of the VPC"
  value       = aws_vpc.rusmir_vpc.id
}


output "wordpress_alb_arn" {
  description = "The ARN of the WordPress Application Load Balancer"
  value       = aws_lb.wordpress_alb.arn
}


output "prv_sub1" {
  value = aws_subnet.private["a"]
}
output "prv_sub2" {
  value = aws_subnet.private["b"]
}

output "pub_sub1" {
  value = aws_subnet.public["a"]
}


output "rusmir_db_subnet_group" {
  value = aws_db_subnet_group.rusmir_db_subnet_group.name

}






