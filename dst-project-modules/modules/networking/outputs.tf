output "rusmir_vpc" {
  description = "The ID of the VPC"
  value       = aws_vpc.rusmir_vpc.id
}


output "wordpress_alb_arn" {
  description = "The ARN of the WordPress Application Load Balancer"
  value       = aws_lb.wordpress_alb.arn
}



# output "alb_dns_name" {
#   description = "The DNS name of the WordPress Application Load Balancer"
#   value       = aws_lb.wordpress_alb.dns_name
# }
output "prv_sub1" {
  value = aws_subnet.prv_sub1
}
output "prv_sub2" {
  value = aws_subnet.prv_sub2
}

output "pub_sub1" {
  value = aws_subnet.pub_sub1.id
}
output "pub_sub2" {
  value = aws_subnet.pub_sub2.id
}

output "webserver_sg" {
  value = aws_security_group.webserver_sg.id
  
}

output "security_group_elb_sg" {
  value = aws_security_group.elb_sg.id
  
}

# output "sg_pub_id" {
#   value = aws_security_group.allow_public.id
# }

# output "sg_priv_id" {
#   value = aws_security_group.allow_private.id
# }

# output "public_subnet_ids" {
#   value = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
# }

# output "bastion_sg_22" {

# value =  [aws_security_group.bastion_sg_22.id]
# }



# output "rusmir_wordpress_lb" {
# value = aws_security_group.rusmir_wordpress_lb.id

# }

# output "app_subnet_ids" {
#   value = [aws_subnet.app_subnet_a.id, aws_subnet.app_subnet_b.id]
# }



# output "db_subnet_group_name" {
# value = aws_db_subnet_group.db_subnet_group.name
# }

# output "db_sg_id" {
#     value = [aws_security_group.db_sg.id]
# }

# output "sg_datascientest" {
#   value = aws_security_group.sg_datascientest.id
  
# }

# output "app_subnet_a" {
#   value = aws_subnet.app_subnet_a.id
  
# }
# output "app_subnet_b" {
#   value = aws_subnet.app_subnet_b.id
  
# }

# output "public_subnet_a" {
#   value = aws_subnet.public_subnet_a.id
  
# }
# output "public_subnet_b" {
#   value = aws_subnet.public_subnet_b.id
  
# }
# output "sg_22" {
#   value = aws_security_group.sg_22
  
# }