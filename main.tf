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

module "vpc_dst" {
  source = "./dst-project-modules/modules/vpc"
   environment = var.environment
  # aws_region          = var.aws_region
  cidr_vpc            = var.cidr_vpc

  cidr_public_subnet_a  = var.cidr_public_subnet_a
  cidr_public_subnet_b = var.cidr_public_subnet_b

  cidr_app_subnet_a = var.cidr_app_subnet_a
  cidr_app_subnet_b = var.cidr_app_subnet_b 


}
module "ec2_dst" {
  source     = "./dst-project-modules/modules/ec2"
  namespace  = var.namespace
  vpc        = module.vpc
  key_name   = "Datascientest"
  sg_pub_id  = module.networking.sg_pub_id
  sg_priv_id = module.networking.sg_priv_id
  
}

