#VPC Configuration:
resource "aws_vpc" "rusmir_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "rusmir-vpc"
  }
}

# Subnets Public
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.rusmir_vpc.id
  cidr_block              = var.cidr_public_subnet_a
  map_public_ip_on_launch = true
  availability_zone       = var.az_a

  tags = {
    Name        = "public-a"
    Environment = var.environment
  }

  depends_on = [aws_vpc.rusmir_vpc]
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.rusmir_vpc.id
  cidr_block              = var.cidr_public_subnet_b
  map_public_ip_on_launch = true
  availability_zone       = var.az_b

  tags = {
    Name        = "public-b"
    Environment = "${var.environment}"
  }
  depends_on = [aws_vpc.rusmir_vpc]

}

## >>>  Private subnets  <<<   for wordpress
resource "aws_subnet" "app_subnet_a" {

  vpc_id                  = aws_vpc.rusmir_vpc.id
  cidr_block              = var.cidr_app_subnet_a
  availability_zone       = var.az_a
  tags = {
    Name        = "app-a"
    Environment = var.environment
  }
  depends_on = [aws_vpc.rusmir_vpc]
}


resource "aws_subnet" "app_subnet_b" {

  vpc_id            = aws_vpc.rusmir_vpc.id
  cidr_block        = var.cidr_app_subnet_b
  availability_zone = var.az_b

  tags = {
    Name        = "app-b"
    Environment = var.environment
  }
  depends_on = [aws_vpc.rusmir_vpc]
}

# >>>  Database Subnet Group  <<<

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "rusmir-db-subnet-group"
  subnet_ids = [aws_subnet.app_subnet_a.id, aws_subnet.app_subnet_b.id]

  tags = {
    Name = "${var.namespace}-db-subnet-group"
  }
}


resource "aws_internet_gateway" "rusmir_wp_igateway" {
  vpc_id = aws_vpc.rusmir_vpc.id

  tags = {
    Name = "rusmir-igateway"
  }

  depends_on = [aws_vpc.rusmir_vpc]
}

## Créer une passerelle nat pourle sous-réseau public a et une ip élastique
resource "aws_eip" "eip_public_a" {
  domain = "vpc"
}
resource "aws_nat_gateway" "gw_public_a" {
  allocation_id = aws_eip.eip_public_a.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "datascientest-nat-public-a"
  }
}
##################################################### FIN

resource "aws_eip" "eip_public_b" {
  domain = "vpc"
}
resource "aws_nat_gateway" "gw_public_b" {
  allocation_id = aws_eip.eip_public_b.id
  subnet_id     = aws_subnet.public_subnet_b.id

  tags = {
    Name = "datascientest-nat-public-b"
  }
}

resource "aws_route_table" "rtb_public" {

  vpc_id = aws_vpc.rusmir_vpc.id
  tags = {
    Name = "datascientest-public-routetable"
  }

  depends_on = [aws_vpc.rusmir_vpc]
}

# Créez une route dans la table de routage, pour accéder au public via une passerelle Internet
resource "aws_route" "route_igw" {
  route_table_id         = aws_route_table.rtb_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.rusmir_wp_igateway.id

  depends_on = [aws_internet_gateway.rusmir_wp_igateway]

  
}

# Ajouter un sous-réseau public-a à la table de routage
resource "aws_route_table_association" "rta_subnet_association_puba" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.rtb_public.id

  depends_on = [aws_route_table.rtb_public]

  
}

# Ajouter un sous-réseau public-b à la table de routage
resource "aws_route_table_association" "rta_subnet_association_pubb" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.rtb_public.id

  depends_on = [aws_route_table.rtb_public]
}

# Créer une table de routage pour app un sous-réseau
resource "aws_route_table" "rtb_appa" {

  vpc_id = aws_vpc.rusmir_vpc.id
  tags = {
    Name = "${var.namespace}-appa-routetable"
  }

}
##################################################### FIN

## Créer une table de routage pour app un sous-réseau
resource "aws_route_table" "rtb_appb" {

  vpc_id = aws_vpc.rusmir_vpc.id
  tags = {
    Name = "${var.namespace}-appb-routetable"
  }

}
##################################################### FIN

#créer une route vers la passerelle nat
resource "aws_route" "route_appa_nat" {
  route_table_id         = aws_route_table.rtb_appa.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw_public_a.id

  
}


resource "aws_route_table_association" "rta_subnet_association_appa" {
  subnet_id      = aws_subnet.app_subnet_a.id
  route_table_id = aws_route_table.rtb_appa.id
}

##################################################### FIN

#créer une route vers la passerelle nat
resource "aws_route" "route_appb_nat" {
  route_table_id         = aws_route_table.rtb_appb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw_public_b.id
}


resource "aws_route_table_association" "rtb_subnet_association_appb" {
  subnet_id      = aws_subnet.app_subnet_b.id
  route_table_id = aws_route_table.rtb_appb.id

  
}

# SG pour autoriser les connexions SSH depuis n'importe quel hôte

#Security  Group
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Database security group"
  vpc_id      = aws_vpc.rusmir_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups =[aws_security_group.allow_private.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}


resource "aws_security_group" "bastion_sg_22" {

  name   = "sg_22"
  vpc_id = aws_vpc.rusmir_vpc.id

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
    Name = "sg-22"
  }
}

resource "aws_security_group" "allow_public" {
  name        = "${var.namespace}-allow_http_pub"
  description = "Autoriser le trafic entrant  HTTP"
  vpc_id      = aws_vpc.rusmir_vpc.id

dynamic "ingress" { # nous créons un bloc dynamique pour toutes les ingress (règles entrantes) du groupe de sécurité
    for_each = var.allow_public_sg_ports_ingress # utilisation de la boucle for_reach sur les valeurs de la variables datascientest_sg_ports_ingress
    iterator = port # variable temporaire
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress"  {    # nous créons un bloc dynamique pour toutes les egress (règles entrantes) du groupe de sécurité

    for_each = var.allow_public_sg_ports_egress
    iterator = egress # variable temporaire
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    Name = "${var.namespace}-allow_pubic"
  }
}

resource "aws_security_group" "rusmir_wordpress_lb" {
  name = "rusmir-wordpress-sg-lb"
  vpc_id = aws_vpc.rusmir_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPs uniquement a partir de clients VPC internes"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.namespace}-wordpress-lb-sg"
  }
}

#SG pour autoriser uniquement les connexions SSH à partir de sous-réseaux publics VPC
resource "aws_security_group" "allow_private" {
  name        = "${var.namespace}-allow_ssh_priv"
  description = "Autoriser le trafic entrant SSH"
  vpc_id      = aws_vpc.rusmir_vpc.id

 dynamic "ingress" { # nous créons un bloc dynamique pour toutes les ingress (règles entrantes) du groupe de sécurité
    for_each = var.allow_private_sg_ports_ingress # utilisation de la boucle for_reach sur les valeurs de la variables datascientest_sg_ports_ingress
    iterator = port # variable temporaire
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  }

  dynamic "egress"  {    # nous créons un bloc dynamique pour toutes les egress (règles entrantes) du groupe de sécurité

    for_each = var.allow_private_sg_ports_egress
    iterator = egress # variable temporaire
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    Name = "${var.namespace}-allow_private"
  }
}


resource "aws_key_pair" "datascientest_keypair" {
  key_name   = "datascientest_keypair"
  public_key = file("~/.ssh/id_rsa.pub")
}
