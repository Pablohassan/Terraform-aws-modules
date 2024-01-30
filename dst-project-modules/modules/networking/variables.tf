variable "namespace" {
    type = string
}

# variable "vpc_id" {
#   description = "The VPC ID where the database should be created"
#   type        = string
# }

variable "cidr_vpc" {
 type = string

}
variable "environment" {
type = string  
}

variable "cidr_public_subnet_a" {
  type = string
}

variable "cidr_public_subnet_b" {
  type = string
}

variable "db_subnet_ids" {
  description = "A list of VPC subnet IDs for the database"
  type        = list(string)
}


variable "az_a" {
 type = string
}


variable "az_b" {
 type = string

}

variable "cidr_app_subnet_a" {
 type = string
}

variable "cidr_app_subnet_b" {
   type = string

}

# variable "db_ec2_instance_ip" {
#   description = "The IP address range to allow connection to the RDS instance"
#   type        = string
# }



variable "allow_public_sg_ports_ingress" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [80, 443]
}
variable "allow_public_sg_ports_egress" {
type       = list(number)
description = "list of ingress ports"
default     = [0]
}

variable "allow_private_sg_ports_ingress" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [80, 443, 22]
}
variable "allow_private_sg_ports_egress" {
type       = list(number)
description = "list of ingress ports"
default     = [0]
}