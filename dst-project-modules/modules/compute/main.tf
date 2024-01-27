data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

#Configurer l'instance EC2 dans un sous-réseau public
resource "aws_instance" "ec2_public" {
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
#   key_name                    = var.key_name
  subnet_id                   = var.public_subnets[0]
  vpc_security_group_ids      = [var.sg_pub_id]
  user_data                   = file("install_wordpress.sh")

  tags = {
    "Name" = "${var.namespace}-EC2-PUBLIC"
  }
}
# Configurer l'instance EC2 dans un sous-réseau privé
resource "aws_instance" "ec2_private" {
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = false
  instance_type               = "t2.micro"
#   key_name                    = var.key_name
  subnet_id                   = var.private_subnet_ids[1]
  vpc_security_group_ids      = [var.sg_priv_id]

  tags = {
    "Name" = "${var.namespace}-EC2-PRIVATE"
  }
}

resource "aws_lb_target_group" "rusmir_ec2_compute" {
  name     = "rusmir_autoscaling_group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.networking.rusmir_vpc.vpc_id
}

resource "aws_launch_configuration" "rusmir_compute_asg" {
  name_prefix     = "rusmir_terraform-aws-asg-"
  image_id        = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.micro"
  user_data       = file("user-data.sh")
  security_groups = [aws_security_group.allow_http_ssh_pub.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "rusmir_compute_asg" {
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.allow_http_ssh_pub.name
  vpc_zone_identifier  = module.networking.public_subnets
}