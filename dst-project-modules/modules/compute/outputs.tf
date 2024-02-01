

# output "wordpress_target_group_arn" {
#   value = aws_lb_target_group.wordpress_instance_gr.arn
# }

output "lb_target_group_arn" {
  value = aws_lb_target_group.wordpress_instance_gr.arn # averifier name ou arn
  
}

# output "wordpress_alb_arn" {
#   description = "The ARN of the WordPress Application Load Balancer"
#   value       = aws_lb.wordpress_alb.arn
# }