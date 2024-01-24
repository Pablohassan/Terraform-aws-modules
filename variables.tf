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
  default     = "10.1.0.0/24"

}

variable "cidr_public_subnet_b" {
  description = "CIDR du Sous-réseau  public b"
  default     = "10.1.1.0/24"

}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet."
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "The availability zone to deploy into."
  default     = "eu-west-3a"  # Adjust this based on your region
}
