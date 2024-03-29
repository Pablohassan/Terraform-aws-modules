variable "rusmir_vpc" {
  type = string
}

variable "bastion_sg_22" {
  description = "the vpc security groupe for bastion instance "
  type        = string

}
variable "prv_sub1" {
  type = string

}

variable "prv_sub2" {
  type = string
}


variable "pub_sub1" {
  type = string

}

variable "webserver_sg" {
  type = string
}
variable "wordpress_alb_arn" {
  description = "The ARN of the WordPress Application Load Balancer"
  type        = string
}

variable "security_group_elb_sg" {
  type = string
}

variable "namespace" {
  type = string
}

variable "environment" {
  type = string
}
variable "db_name" {
  description = "Database name"
  type        = string

}

variable "db_user" {
  description = "database username"
  type        = string
}

variable "db_password" {

  description = "Database password"
  type        = string
}

variable "db_host_instance" {
  description = "Database host instance"
  type        = string
}