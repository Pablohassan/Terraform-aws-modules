
variable "namespace" {
  description = "L'espace de noms de projet à utiliser pour la dénomination "
  default     = "rusmir"
  type        = string
}

variable "aws_region" {
  description = "AWS région"
  default     = "eu-west-3"
  type        = string
}

variable "environment" {
  description = "epace de travail dans le namespace"
  default     = "dev"
  type        = string

}

variable "cidr_vpc" {
  type        = string
  description = "The CIDR block for the VPC."
  default     = "10.1.0.0/16"

  validation {
    condition     = can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", var.cidr_vpc))
    error_message = "The CIDR block for the VPC is invalid. Expected format: x.x.x.x/x."
  }
}

variable "cidr_public_subnet_a" {
  type        = string
  description = "CIDR for public subnet a"
  default     = "10.1.1.0/24"

  validation {
    condition     = can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", var.cidr_public_subnet_a))
    error_message = "The CIDR block for public subnet a is invalid. Expected format: x.x.x.x/x."
  }
}

variable "cidr_public_subnet_b" {
  type        = string
  description = "CIDR for public subnet b"
  default     = "10.1.2.0/24"

  validation {
    condition     = can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", var.cidr_public_subnet_b))
    error_message = "The CIDR block for public subnet b is invalid. Expected format: x.x.x.x/x."
  }
}

variable "cidr_private_subnet_a" {
  type        = string
  description = "CIDR for private subnet a"
  default     = "10.1.3.0/24"

  validation {
    condition     = can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", var.cidr_private_subnet_a))
    error_message = "The CIDR block for private subnet a is invalid. Expected format: x.x.x.x/x."
  }
}

variable "cidr_private_subnet_b" {
  type        = string
  description = "CIDR for private subnet b"
  default     = "10.1.4.0/24"

  validation {
    condition     = can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", var.cidr_private_subnet_b))
    error_message = "The CIDR block for private subnet b is invalid. Expected format: x.x.x.x/x."
  }
}

variable "az_a" {
  type        = string
  description = "zone de disponibilité a"
  default     = "eu-west-3a"
}


variable "az_b" {
  type        = string
  description = "zone de disponibilité b"
  default     = "eu-west-3b"

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

