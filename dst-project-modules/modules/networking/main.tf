
resource "aws_vpc" "rusmir_vpc" {
  cidr_block = var.cidr_vpc

  tags = {

    Name = "datascientest--VPC"
  }
}

# Application Load Balancer
resource "aws_lb" "wordpress_alb" {
  name               = "datascientest-wordpress--alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.elb_sg_id]
  subnets            = [aws_subnet.pub_sub1.id, aws_subnet.pub_sub2.id]

  tags = {
    name = "${var.namespace}-${var.environment}-alb-wordpress-LoadBalancer"
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

    name = "${var.namespace}-${var.environment}-alb-listener-wordpress-instance"
    
    }
}


## SUBNETS 

# Pub subnet1
resource "aws_subnet" "pub_sub1" {
  vpc_id                  = aws_vpc.rusmir_vpc.id
  cidr_block              = var.cidr_public_subnet_a
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.namespace}-${var.environment}-public-subnet1"

  }
}
# Pub subnet2
resource "aws_subnet" "pub_sub2" {
  vpc_id                  = aws_vpc.rusmir_vpc.id
  cidr_block              = var.cidr_public_subnet_b
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.namespace}-${var.environment}-public-subnet2"
  }
}

#  Priv Subnet1
resource "aws_subnet" "prv_sub1" {
  vpc_id                  = aws_vpc.rusmir_vpc.id
  cidr_block              = var.cidr_private_subnet_a
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.namespace}-${var.environment}-private-subnet1"
  }
}

# Create Priv Subnet2
resource "aws_subnet" "prv_sub2" {
  vpc_id                  = aws_vpc.rusmir_vpc.id
  cidr_block              = var.cidr_private_subnet_b
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.namespace}-${var.environment}-private-subnet2"
  }
}
# DB subnet group
resource "aws_db_subnet_group" "rusmir_db_subnet_group" {
  name       = "rusmir-db-subnet-group"
  subnet_ids = [aws_subnet.prv_sub1.id, aws_subnet.prv_sub2.id]

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
  count  = "1"
  vpc_id = aws_vpc.rusmir_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_1[count.index].id
  }
  tags = {
    Name = "${var.namespace}-${var.environment}-priv-subnet1-route"
  }
}
# private route table for prv sub2
resource "aws_route_table" "prv_sub2_rt" {
  count  = "1"
  vpc_id = aws_vpc.rusmir_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_2[count.index].id
  }
  tags = {
    Name    = "${var.namespace}-${var.environment}-priv-subnet2-route"
  }
}

# route table association prv sub1 & NAT GW1

resource "aws_route_table_association" "priv_sub1_to_natgw1" {
  count          = "1"
  route_table_id = aws_route_table.prv_sub1_rt[count.index].id
  subnet_id      = aws_subnet.prv_sub1.id
}

# Create private route table for prv sub2
resource "aws_route_table_association" "priv_sub2_to_natgw1" {
  count          = "1"
  route_table_id = aws_route_table.prv_sub2_rt[count.index].id
  subnet_id      = aws_subnet.prv_sub2.id
}
# route table association of public subnet1
resource "aws_route_table_association" "internet_for_pub_sub1" {
  route_table_id = aws_route_table.pub_sub_rt.id
  subnet_id      = aws_subnet.pub_sub1.id
}
#  route table association of public subnet2

resource "aws_route_table_association" "internet_for_pub_sub2" {
  route_table_id = aws_route_table.pub_sub_rt.id
  subnet_id      = aws_subnet.pub_sub2.id
}

#EIP for NAT gateway 1
resource "aws_eip" "eip_natgw1" {
  count = "1"
  tags = {
    Name = "${var.namespace}-${var.environment}-elastic-ip-natgw1"
  }
}
#EIP for NAT gateway 2

resource "aws_eip" "eip_natgw2" {
  count = "1"
  tags = {

    Name = "${var.namespace}-${var.environment}-elastic-ip-natgw1"
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
  count         = "1"
  allocation_id = aws_eip.eip_natgw1[count.index].id
  subnet_id     = aws_subnet.pub_sub1.id

 tags = {

    Name = "${var.namespace}-${var.environment}-nat-gateway1-pub-subnet1"
  }
}

# NAT gateway2

resource "aws_nat_gateway" "natgateway_2" {
  count         = "1"
  allocation_id = aws_eip.eip_natgw2[count.index].id
  subnet_id     = aws_subnet.pub_sub2.id

  tags = {

    Name = "${var.namespace}-${var.environment}-nat-gateway2-pub-subnet2"
  }
}





