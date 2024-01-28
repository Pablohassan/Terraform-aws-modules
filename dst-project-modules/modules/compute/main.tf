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
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = [var.bastion_sg_22]
  

  tags = {
    "Name" = "${var.namespace}-BastionHost"
  }
}



# resource "aws_launch_configuration" "rusmir_wordpress" {
#   name_prefix     = "rusmir_wordpress-config-"
#   image_id        = data.aws_ami.amazon-linux-2.id
#   instance_type   = "t2.micro"
#   user_data       = "${file("install_wordpress.sh")}"
#   security_groups = [var.allow_http_ssh_pub]

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_autoscaling_group" "rusmir_wordpress" {
#   name                 = "rusmir-wordpress"
#   min_size             = 1
#   max_size             = 2
#   desired_capacity     = 1
#   launch_configuration = aws_launch_configuration.rusmir_wordpress.name
#   vpc_zone_identifier  = concat(var.public_subnet_ids, var.private_subnet_ids)
#   target_group_arns    = [aws_lb_target_group.rusmir_wordpress.arn]
# }

resource "aws_launch_template" "rusmir_wordpress" {
  name_prefix   = "rusmir_wordpress-template-"
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  user_data = base64encode(<<-EOF
                #!/bin/bash
                export DB_NAME=${var.db_name}
                export DB_USER=${var.db_user}
                export DB_PASSWORD=${var.db_password}
                export DB_HOST=${var.db_host}

                $(cat install_wordpress.sh)
                EOF
    )

  vpc_security_group_ids = [var.allow_http_ssh_pub]

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    "Name" = "${var.namespace}-wordpress-instance"
  }
}

resource "aws_autoscaling_group" "rusmir_wordpress" {
  name                 = "rusmir-wordpress"
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  launch_template {
    id      = aws_launch_template.rusmir_wordpress.id
    version = "$Latest"
  }
  vpc_zone_identifier  = concat(var.public_subnet_ids, var.private_subnet_ids)
  target_group_arns    = [aws_lb_target_group.rusmir_wordpress.arn]

  
}





resource "aws_lb" "rusmir_wordpress" {
  name               = "rusmir-wordpress-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.rusmir_wordpress_lb]
  subnets            = var.public_subnet_ids

  tags = {
    "Name" = "${var.namespace}-wordpress-lb"
  }
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
  name     = "rusmir-autoscaling-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id


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

tags = {
    "Name" = "${var.namespace}-wordpress-asg"
  }
}


#Automatically adjust the number of instances in the group in response to varying load

resource "aws_autoscaling_policy" "rusmir_wordpress_cpu_tracking" {
  name                   = "rusmir_wordpress_cpu_tracking"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.rusmir_wordpress.id
  policy_type            = "SimpleScaling"
  cooldown               = 300
}