

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}
# la région aws ou nous voulons déployer nos différentes ressources
provider "aws" {
  region = "eu-west-3"
}


module "s3_dst" {
  source      = "./dst-project-modules/modules/s3"
  environment = "dev" // or any other environment
}

module "rusmir_vpc" {
  source      = "./dst-project-modules/modules/vpc"
  environment = var.environment
  # aws_region          = var.aws_region
  namespace            = var.namespace
  cidr_vpc             = var.cidr_vpc
  az_a                 = var.az_a
  az_b                 = var.az_b
  cidr_public_subnet_a = var.cidr_public_subnet_a
  cidr_public_subnet_b = var.cidr_public_subnet_b
  db_ec2_instance_ip  = var.db_ec2_instance_ip
  cidr_app_subnet_a = var.cidr_app_subnet_a
  cidr_app_subnet_b = var.cidr_app_subnet_b
  vpc_id = var.cidr_vpc
  db_subnet_ids = [var.cidr_app_subnet_a, var.cidr_app_subnet_b]

}
module "ec2_dst" {
  source     = "./dst-project-modules/modules/ec2"
  namespace  = var.namespace
  vpc        = module.rusmir_vpc
  key_name   = "Datascientest"
  sg_pub_id  = module.rusmir_vpc.sg_pub_id
  sg_priv_id = module.rusmir_vpc.sg_priv_id
  public_subnets  = module.rusmir_vpc.public_subnet_ids
  private_subnets = module.rusmir_vpc.private_subnet_ids
  vpc_id = var.cidr_vpc
}

module "rusmir_rds" {
  
source = "./dst-project-modules/modules/rds"
db_username = var.db_username
db_password = var.db_password
vpc_security_group_id = module.rusmir_vpc.vpc_security_group_id
db_subnet_group_name = module.rusmir_vpc.db_subnet_group_name
}


