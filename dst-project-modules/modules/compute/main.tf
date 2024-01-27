data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

#Configurer l'instance EC2 dans un sous-réseau public pour le serveur bastion 
resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = var.public_subnets[0]
  vpc_security_group_ids      = var.bastion_sg_22.id
  

  tags = {
    "Name" = "${var.namespace}-BastionHost"
  }
}
# # Configurer l'instance EC2 dans un sous-réseau privé
# resource "aws_instance" "ec2_private" {
#   ami                         = data.aws_ami.amazon-linux-2.id
#   associate_public_ip_address = false
#   instance_type               = "t2.micro"
# #   key_name                    = var.key_name
#   subnet_id                   = var.private_subnet_ids[1]
#   vpc_security_group_ids      = [var.sg_priv_id]

#   tags = {
#     "Name" = "${var.namespace}-EC2-PRIVATE"
#   }
# }



resource "aws_launch_configuration" "rusmir_wordpress" {
  name_prefix     = "rusmir_wordpress-config-"
  image_id        = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.micro"
  user_data       = file("user-data.sh")
  security_groups = [aws_security_group.allow_http_ssh_pub.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "rusmir_wordpress" {
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.rusmir_wordpress_launch_config.name
  vpc_zone_identifier  = concat(module.networking.public_subnet_ids, module.networking.app_subnet_ids)
  target_group_arns    = [aws_lb_target_group.rusmir_wordpress.arn]
}

resource "aws_lb" "rusmir_wordpress" {
  name               = "rusmir_wordpress-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.rusmir_wordpress_lb.id]
  subnets            = module.vpc.public_subnet_ids
}

#specifies how to handle any HTTP requests to port 80

resource "aws_lb_listener" "rusmir_wordpress" {
  load_balancer_arn = aws_lb.rusmir_wordpress.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rusmir_wordpress.arn
  }
}

resource "aws_lb_target_group" "rusmir_wordpress" {
  name     = "rusmir_autoscaling_group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.networking.rusmir_vpc.vpc_id


health_check {
    enabled             = true
    interval            = 30  
    path                = "/" 
    protocol            = "HTTP"
    timeout             = 10   
    healthy_threshold   = 2  
    unhealthy_threshold = 2   
    matcher             = "200" 
  }


}

resource "aws_autoscaling_attachment" "rusmir_wordpress" {
  autoscaling_group_name = aws_autoscaling_group.rusmir_wordpress.id
  
}

#Automatically adjust the number of instances in the group in response to varying load

resource "aws_autoscaling_policy" "rusmir_wordpress_cpu_tracking" {
  name                   = "rusmir_wordpress_cpu_tracking"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.rusmir_wordpress.id

  policy_type            = "TargetTrackingScaling"
  estimated_instance_warmup = 300

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}