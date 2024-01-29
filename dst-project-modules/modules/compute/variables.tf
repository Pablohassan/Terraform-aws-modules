variable "namespace" {
    type = string
  
}
variable "vpc" {
  type = any
}
# paire de clé utilisée
variable key_name {
  type = string
}
# id du groupe de sécurité public
variable "sg_pub_id" {
  type = string
}
# id du groupe de sécurité privée
variable "sg_priv_id" {
  type = string
}
variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}




variable "private_subnet_ids" {
  description = "List of subnet IDs for the application"
  type        = list(string)
}
variable "vpc_id" {
  description = "The ID of the VPC where the RDS instance will be created"
  type        = string
}

variable "bastion_sg_22" { 
  description = "the vpc security groupe for bastion instance "
  type = string

}
# variable "allow_ssh_priv" {

# description = "security group for private subnet"
# type = string

# }

variable "rusmir_wordpress_lb" {
  description = "security group for load balancer"
  type = string
  
}

variable "db_name" {
  description = "Database name"
  type        = string
  
}

variable "db_user" {
  description = "database username"
  type = string
}

variable "db_host" {
description = "database host"
type = string
}

variable "db_password" {
  
  description = "Database password"
  type        = string
}