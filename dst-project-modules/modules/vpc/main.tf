resource "aws_vpc" "rusmir_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "rusmir-vpc"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.rusmir_vpc.id
  cidr_block              = var.cidr_public_subnet_a
  map_public_ip_on_launch = "true"
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
  map_public_ip_on_launch = "true"
  availability_zone       = var.az_b

  tags = {
    Name        = "public-b"
    Environment = "${var.environment}"
  }
  depends_on = [aws_vpc.rusmir_vpc]

}

## Creation des 2 sous-réseaux privées pour les serveurs datascientest
resource "aws_subnet" "app_subnet_a" {

  vpc_id                  = aws_vpc.rusmir_vpc.id
  cidr_block              = var.cidr_app_subnet_a
  map_public_ip_on_launch = "true"
  availability_zone       = var.az_a
  tags = {
    Name        = "app-a"
    Environment = var.environment
  }
  depends_on = [aws_vpc.rusmir_vpc]
}


resource "aws_subnet" "app_subnet_b" {

  vpc_id                  = aws_vpc.rusmir_vpc.id
  cidr_block              = var.cidr_app_subnet_b
  availability_zone       = var.az_b

  tags = {
    Name        = "app-b"
    Environment = var.environment
  }
  depends_on = [aws_vpc.rusmir_vpc]
}

resource "aws_internet_gateway" "datascientest_igateway" {
  vpc_id = aws_vpc.rusmir_vpc.id

  tags = {
    Name = "datascientest-igateway"
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
  gateway_id             = aws_internet_gateway.datascientest_igateway.id

  depends_on = [aws_internet_gateway.datascientest_igateway]
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
    Name = "datascientest-appa-routetable"
  }

}
##################################################### FIN

## Créer une table de routage pour app un sous-réseau
resource "aws_route_table" "rtb_appb" {

  vpc_id = aws_vpc.rusmir_vpc.id
  tags = {
    Name = "datascientest-appb-routetable"
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
