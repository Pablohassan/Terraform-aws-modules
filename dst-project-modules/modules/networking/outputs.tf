output "rusmir_vpc" {
  description = "The ID of the VPC"
  value       = aws_vpc.rusmir_vpc.id
}


output "wordpress_alb_arn" {
  description = "The ARN of the WordPress Application Load Balancer"
  value       = aws_lb.wordpress_alb.arn
}


output "prv_sub1" {
  value = aws_subnet.prv_sub1
}
output "prv_sub2" {
  value = aws_subnet.prv_sub2
}

output "pub_sub1" {
  value = aws_subnet.pub_sub1
}


output "webserver_sg" {
  value = aws_security_group.webserver_sg.id

}

output "security_group_elb_sg" {
  value = aws_security_group.elb_sg.id

}

output "rusmir_db_subnet_group" {
  value = aws_db_subnet_group.rusmir_db_subnet_group.name

}

output "db_security_group" {
  value = aws_security_group.db_sg.id

}


output "bastion_sg_22" {

  value = aws_security_group.bastion_sg_22.id
}

