variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group for the RDS instances"
  type        = list(string)
}
variable "db_subnet_group_name" {

  type = string
}
