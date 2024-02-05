
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.myec2key.key_name
  subnet_id                   = var.pub_sub1
  vpc_security_group_ids      = [var.bastion_sg_22]


  tags = {
    "Name" = "${var.namespace}-${var.environment}-BastionHost"
  }
}
resource "aws_launch_configuration" "webserver_launch_config" {
  name_prefix     = "webserver-launch-config"
  image_id        = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.myec2key.key_name
  security_groups = [var.webserver_sg]

  root_block_device {
    volume_type = "gp2"
    volume_size = 10
    encrypted   = true
  }
  lifecycle {
    create_before_destroy = true
  }
  user_data = filebase64("${path.module}/../install_wordpress.sh")
}

resource "aws_key_pair" "myec2key" {
  key_name   = "datascientest_keypair"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "datascientest-wordpress_instance" {
  name                 = "datascientest-wordpress-instance"
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  force_delete         = true
  depends_on           = [var.wordpress_alb_arn]
  target_group_arns    = [aws_lb_target_group.wordpress_instance_gr.arn]
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.webserver_launch_config.name
  vpc_zone_identifier  = concat([var.prv_sub1], [var.prv_sub2])

  tag {
    key                 = "Name"
    value               = "${var.namespace}-${var.environment}-wordpress-instance"
    propagate_at_launch = true
  }
}

# Create Target group

resource "aws_lb_target_group" "wordpress_instance_gr" {
  name       = "datascientest-wordpress-instance"
  depends_on = [var.rusmir_vpc] # peut eutre avec []
  port       = 80
  protocol   = "HTTP"
  vpc_id     = var.rusmir_vpc
  health_check {
    interval            = 30
    path                = "/"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}
