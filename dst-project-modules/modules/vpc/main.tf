resource "aws_vpc" "rusmir_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "rusmir-vpc"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.datascientest_vpc.id
  cidr_block              = var.cidr_public_subnet_a
  map_public_ip_on_launch = "true"
  availability_zone       = var.az_a

  tags = {
    Name        = "public-a"
    Environment = var.environment
  }

  depends_on = [aws_vpc.datascientest_vpc]
}
resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.datascientest_vpc.id
  cidr_block              = var.cidr_public_subnet_b
  map_public_ip_on_launch = "true"
  availability_zone       = var.az_b

  tags = {
    Name        = "public-b"
    Environment = "${var.environment}"
  }
  depends_on = [aws_vpc.datascientest_vpc]

}

## Creation des 2 sous-réseaux privées pour les serveurs datascientest
resource "aws_subnet" "app_subnet_a" {

  vpc_id                  = aws_vpc.datascientest_vpc.id
  cidr_block              = var.cidr_app_subnet_a
  map_public_ip_on_launch = "true"
  availability_zone       = var.az_b
  tags = {
    Name        = "app-a"
    Environment = var.environment
  }
  depends_on = [aws_vpc.datascientest_vpc]
}


resource "aws_subnet" "app_subnet_b" {

  vpc_id                  = aws_vpc.datascientest_vpc.id
  cidr_block              = var.cidr_app_subnet_b
  availability_zone       = var.az_b

  tags = {
    Name        = "app-b"
    Environment = var.environment
  }
  depends_on = [aws_vpc.datascientest_vpc]
}

resource "aws_internet_gateway" "datascientest_igateway" {
  vpc_id = aws_vpc.datascientest_vpc.id

  tags = {
    Name = "datascientest-igateway"
  }

  depends_on = [aws_vpc.datascientest_vpc]
}