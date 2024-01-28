variable "db_user" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
}

variable "db_name" {
  description = "host database name "
  type = string
}

variable "db_sg_id" {
  description = "List of security group for the RDS instances"
  type        = list(string)
}
variable "db_subnet_group_name" {

  type = string
}
