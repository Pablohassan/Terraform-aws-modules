




resource "aws_vpc" "rusmir_vpc" {
  cidr_block = var.cidr_vpc

  tags = {
   
    Name    = "Datascientest-rusmir-VPC"
  }
}




resource "aws_lb" "wordpress_alb" {
  name               = "datascientest-wordpress--alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = [aws_subnet.pub_sub1.id, aws_subnet.pub_sub2.id]

  tags = {
    name    = "datascientest-wordpress-LoadBalancer"
  }
}

# Create ALB Listener 

resource "aws_lb_listener" "datascientest_worpress" {
  
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = var.lb_target_group_arn
  }
}

resource "aws_route_table" "prv_sub1_rt" {
  count  = "1"
  vpc_id = aws_vpc.rusmir_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_1[count.index].id
  }
  tags = {
    Name    = "private-subnet1-route"
  }
}

# Create route table association betn prv sub1 & NAT GW1

resource "aws_route_table_association" "pri_sub1_to_natgw1" {
  count          = "1"
  route_table_id = aws_route_table.prv_sub1_rt[count.index].id
  subnet_id      = aws_subnet.prv_sub1.id
}

# Create private route table for prv sub2

resource "aws_route_table" "prv_sub2_rt" {
  count  = "1"
  vpc_id = aws_vpc.rusmir_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_2[count.index].id
  }
  tags = {
    Project = "demo-app"
    Name    = "private-subnet2-route"
  }
}


resource "aws_eip" "eip_natgw1" {
  count = "1"
}

# Create NAT gateway1

resource "aws_nat_gateway" "natgateway_1" {
  count         = "1"
  allocation_id = aws_eip.eip_natgw1[count.index].id
  subnet_id     = aws_subnet.pub_sub1.id
}

# Create EIP for NAT GW2

resource "aws_eip" "eip_natgw2" {
  count = "1"
}

# Create NAT gateway2

resource "aws_nat_gateway" "natgateway_2" {
  count         = "1"
  allocation_id = aws_eip.eip_natgw2[count.index].id
  subnet_id     = aws_subnet.pub_sub2.id
}
# Create route table association betn prv sub2 & NAT GW2

resource "aws_route_table_association" "pri_sub2_to_natgw1" {
  count          = "1"
  route_table_id = aws_route_table.prv_sub2_rt[count.index].id
  subnet_id      = aws_subnet.prv_sub2.id
}

resource "aws_route_table" "pub_sub1_rt" {
  vpc_id = aws_vpc.rusmir_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {

    Name    = "public-subnet-route"
  }
}

# Create route table association of public subnet1

resource "aws_route_table_association" "internet_for_pub_sub1" {
  route_table_id = aws_route_table.pub_sub1_rt.id
  subnet_id      = aws_subnet.pub_sub1.id
}
# Create route table association of public subnet2

resource "aws_route_table_association" "internet_for_pub_sub2" {
  route_table_id = aws_route_table.pub_sub1_rt.id
  subnet_id      = aws_subnet.pub_sub2.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.rusmir_vpc.id

  tags = {
    Name    = "internet-gateway"
  }
}

resource "aws_subnet" "pub_sub1" {
  vpc_id                  = aws_vpc.rusmir_vpc.id
  cidr_block              = var.cidr_public_subnet_a
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true
  tags = {
    Name    = "public-subnet1"

  }
}

# Create Public Subnet2

resource "aws_subnet" "pub_sub2" {
  vpc_id                  = aws_vpc.rusmir_vpc.id
  cidr_block              = var.cidr_public_subnet_b
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = true
  tags = {
    Name    = "public-subnet2"
  }
}

# Create Private Subnet1
resource "aws_subnet" "prv_sub1" {
  vpc_id                  = aws_vpc.rusmir_vpc.id
  cidr_block              = var.cidr_private_subnet_a
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = false

  tags = {
    Name    = "private-subnet1"
  }
}

# Create Private Subnet2
resource "aws_subnet" "prv_sub2" {
  vpc_id                  = aws_vpc.rusmir_vpc.id
  cidr_block              = var.cidr_private_subnet_b
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = false

  tags = {
    Name    = "private-subnet2"
  }
}


resource "aws_security_group" "elb_sg" {
  name        = "elastic-load-balancer-security-group"
  vpc_id      = aws_vpc.rusmir_vpc.id

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
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "sg-elastic-load-balancer"
  
  }
}

# Create security group for webserver

resource "aws_security_group" "webserver_sg" {
  name        = "webserver-private-sg"
  description = "security group pritave web server"
  vpc_id      = aws_vpc.rusmir_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "sg-webserver"
    
  }
}
