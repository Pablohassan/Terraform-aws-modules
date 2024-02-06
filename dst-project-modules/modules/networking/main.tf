
resource "aws_vpc" "rusmir_vpc" {
  cidr_block = var.cidr_vpc
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "${var.namespace}-${var.environment}-VPC"
  }
}

# Application Load Balancer
resource "aws_lb" "wordpress_alb" {
  name               = "datascientest-wordpress--alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.elb_sg_id]
  subnets            = [for key, subnet in aws_subnet.public : subnet.id]

  tags = {
    Name = "${var.namespace}-${var.environment}-alb-wordpress-LoadBalancer"
  }
}

# ALB Listener 

resource "aws_lb_listener" "datascientest_worpress" {

  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = var.lb_target_group_arn
  }

  tags = {
    Name = "${var.namespace}-${var.environment}-alb-listener-wordpress-instance"
  }
}

## SUBNETS 

# Pub subnets

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.rusmir_vpc.id
  cidr_block              = each.value
  availability_zone       = "eu-west-3${each.key}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.namespace}-${var.environment}-public-subnet-${each.key}"
  }
}

#Priv Subnets
resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id                  = aws_vpc.rusmir_vpc.id
  cidr_block              = each.value
  availability_zone       = "eu-west-3${each.key}"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.namespace}-${var.environment}-app-subnet-${each.key}"
  }
}



# DB subnet group
resource "aws_db_subnet_group" "rusmir_db_subnet_group" {
  name       = "rusmir-db-subnet-group"
  subnet_ids = [for key, subnet in aws_subnet.private : subnet.id]

  tags = {
    Name = "${var.namespace}-${var.environment}-rusmir-db-subnet-group"
  }
}
# Routes Tables 

# public route table
resource "aws_route_table" "pub_sub_rt" {
  vpc_id = aws_vpc.rusmir_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.namespace}-${var.environment}-public-subnet-route"
  }
}
# private route table for prv sub1
resource "aws_route_table" "prv_sub1_rt" {

  vpc_id = aws_vpc.rusmir_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_1.id
  }
  tags = {
    Name = "${var.namespace}-${var.environment}-priv-subnet1-route"
  }
}
# private route table for prv sub2
resource "aws_route_table" "prv_sub2_rt" {

  vpc_id = aws_vpc.rusmir_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_2.id
  }
  tags = {
    Name = "${var.namespace}-${var.environment}-priv-subnet2-route"
  }
}
# route table association prv sub1 & NAT GW1

resource "aws_route_table_association" "priv_sub1" {
  route_table_id = aws_route_table.prv_sub1_rt.id
  subnet_id      = aws_subnet.private["a"].id
}

# Create private route table for prv sub2
resource "aws_route_table_association" "priv_sub2" {

  route_table_id = aws_route_table.prv_sub2_rt.id
  subnet_id      = aws_subnet.private["b"].id
}
# route table association of public subnet1
resource "aws_route_table_association" "pub_sub1" {
  route_table_id = aws_route_table.pub_sub_rt.id
  subnet_id      = aws_subnet.public["a"].id
}
#  route table association of public subnet2

resource "aws_route_table_association" "pub_sub2" {
  route_table_id = aws_route_table.pub_sub_rt.id
  subnet_id      = aws_subnet.public["b"].id
}

#EIP for NAT gateway 1
resource "aws_eip" "eip_natgw1" {
  tags = {
    Name = "${var.namespace}-${var.environment}-elastic-ip-natgw1"
  }
}
#EIP for NAT gateway 2

resource "aws_eip" "eip_natgw2" {
  tags = {

    Name = "${var.namespace}-${var.environment}-elastic-ip-natgw2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.rusmir_vpc.id

  tags = {

    Name = "${var.namespace}-${var.environment}-internet-gatway-pub-subnet2"
  }

}

#  NAT gateway1
resource "aws_nat_gateway" "natgateway_1" {

  allocation_id = aws_eip.eip_natgw1.id
  subnet_id     = aws_subnet.public["a"].id

  tags = {

    Name = "${var.namespace}-${var.environment}-nat-gateway1-pub-subnet1"
  }
}
# NAT gateway2

resource "aws_nat_gateway" "natgateway_2" {
  allocation_id = aws_eip.eip_natgw2.id
  subnet_id     = aws_subnet.public["b"].id

  tags = {

    Name = "${var.namespace}-${var.environment}-nat-gateway2-pub-subnet2"
  }
}





