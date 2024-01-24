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
  subnet_id                   = var.private_subnets[1]
  vpc_security_group_ids      = [var.sg_priv_id]

  tags = {
    "Name" = "${var.namespace}-EC2-PRIVATE"
  }
}