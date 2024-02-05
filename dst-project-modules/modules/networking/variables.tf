variable "namespace" {
    type = string
}


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
# variable "wordpress_target_arn" {
#   type= list(string)
  
# }

variable "lb_target_group_arn" {
  type= string
  
}

variable "db_sg_id" {
  type = string
  
}

variable "elb_sg_id" {
  type = string
  
}



# variable "db_subnet_ids" {
#   description = "A list of VPC subnet IDs for the database"
#   type        = list(string)
# }


variable "az_a" {
 type = string
}


variable "az_b" {
 type = string

}

variable "cidr_private_subnet_a" {
 type = string
}

variable "cidr_private_subnet_b" {
   type = string

}



# variable "allow_public_sg_ports_ingress" {
#   type        = list(number)
#   description = "list of ingress ports"
#   default     = [80, 443]
# }
# variable "allow_public_sg_ports_egress" {
# type       = list(number)
# description = "list of ingress ports"
# default     = [0]
# }

# variable "allow_private_sg_ports_ingress" {
#   type        = list(number)
#   description = "list of ingress ports"
#   default     = [80, 443, 22]
# }
# variable "allow_private_sg_ports_egress" {
# type       = list(number)
# description = "list of ingress ports"
# default     = [0]
# }