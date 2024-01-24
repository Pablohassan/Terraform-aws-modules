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