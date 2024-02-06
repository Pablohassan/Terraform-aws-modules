variable "namespace" {
  description = "value of the namespace"
    type = string
}


variable "cidr_vpc" {
description = "value of the cidr block for the vpc"
 type = string

}
variable "environment" {
description = "value of the environment"  
type = string  
}

variable "cidr_public_subnet_a" {
description = "value of the cidr block for the public subnet a"
  type = string
}

variable "cidr_public_subnet_b" {
description = "value of the cidr block for the public subnet b"

  type = string
}

variable "lb_target_group_arn" {
  description = "value of the lb target group arn"
  type= string
  
}

variable "db_sg_id" {
  description = "value of the db security group id"
  type = string
  
}

variable "elb_sg_id" {
  description = "value of the elb security group id"
  type = string
  
}

variable "az_a" {
description = "value of the availability zone a"
 type = string
}


variable "az_b" {
 description = "value of the availability zone b"
 type = string

}

variable "cidr_private_subnet_a" {
 description = "value of the cidr block for the private subnet a"
 type = string
}

variable "cidr_private_subnet_b" {
   description = "value of the cidr block for the private subnet b" 
   type = string

}


locals {
  description = "regrouping values in locals to use for each"
  public_subnets = {
    "a" = var.cidr_public_subnet_a,
    "b" = var.cidr_public_subnet_b
  }

  private_subnets = {
    "a" = var.cidr_private_subnet_a,
    "b" = var.cidr_private_subnet_b
  }
}