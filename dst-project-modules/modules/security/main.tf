
# Create security groups

# elastic load balancer security group
resource "aws_security_group" "elb_sg" {
  name   = "elastic-load-balancer-security-group"
  vpc_id = var.rusmir_vpc

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.namespace}-${var.environment}-security-group-elastic-load-balancer"
  }
}

# security group for webserver instance
resource "aws_security_group" "webserver_sg" {
  name        = "webserver-private-sg"
  description = "security group pritave web server"
  vpc_id      = var.rusmir_vpc

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    description     = "HTTP from alb "
    security_groups = [aws_security_group.elb_sg.id]

  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    description     = "HTTP"
    security_groups = [aws_security_group.bastion_sg_22.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.namespace}-${var.environment}-sg-webserver"

  }
}
#  security group for bastion host
resource "aws_security_group" "bastion_sg_22" {

  name   = "sg_22"
  vpc_id = var.rusmir_vpc

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.namespace}-${var.environment}-sg-22"
  }
}

# security group for database
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Database security group"
  vpc_id      = var.rusmir_vpc

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.namespace}-${var.environment}-db-sg"
  }
}

