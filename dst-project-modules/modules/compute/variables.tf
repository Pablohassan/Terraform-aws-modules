variable "rusmir_vpc" {
type = string  
}



variable "prv_sub1" {
 type= string
  
}

variable "prv_sub2" {
type= string
}
variable "webserver_sg" {
  type = string
}
variable "wordpress_alb_arn" {
  description = "The ARN of the WordPress Application Load Balancer"
  type        = string
}

variable "security_group_elb_sg" {
  type = string
}