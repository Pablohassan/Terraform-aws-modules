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
  type = any
}
# id du groupe de sécurité privée
variable "sg_priv_id" {
  type = any
}
variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}
