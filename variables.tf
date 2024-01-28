
variable "namespace" {
  description = "L'espace de noms de projet à utiliser pour la dénomination unique des ressources"
  default     = "Datascientest"
  type        = string
}

variable "aws_region" {
  description = "AWS région"
  default     = "eu-west-3"
  type        = string
}

variable "environment" {
  description = "epace de travail dans le namespace"
  default = "dev"
  type = string
  
}


variable "cidr_vpc" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "cidr_public_subnet_a" {
  description = "CIDR du Sous-réseau  public a"
  default     = "10.0.0.0/24"

}

variable "cidr_public_subnet_b" {
  description = "CIDR du Sous-réseau  public b"
  default     = "10.0.1.0/24"

}

# on déclare l'étendue de la plage ip du reseau privé a
variable "cidr_app_subnet_a" {
  description = "CIDR du Sous-réseau privé a"
  default     = "10.0.2.0/24"

}

variable "cidr_app_subnet_b" {
  description = "CIDR du Sous-réseau privé b"
  default     = "10.0.3.0/24"

}

variable "az_a" {
  description = "zone de disponibilité a"
  default     = "eu-west-3a"
}


variable "az_b" {
  description = "zone de disponibilité b"
  default     = "eu-west-3b"

}

variable "db_ec2_instance_ip" { 
description = "CIDR du dubent bdd"

default = "10.0.4.0/24"

}

variable "db_username" {
  description = "Database username"
  type        = string
  
}

variable "db_password" {
  
  description = "Database password"
  type        = string
}

variable "key_name" {

  description = "keyname bastion host ssh 22"
  type = string
  
}