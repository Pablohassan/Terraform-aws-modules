

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


# module "s3_dst" {
#   source      = "./dst-project-modules/modules/s3"
#   environment = "dev" // or any other environment
# }

module "networking" {
  source      = "./dst-project-modules/modules/networking"
  environment = var.environment
  # aws_region          = var.aws_region
  namespace            = var.namespace
  cidr_vpc             = var.cidr_vpc
  az_a                 = var.az_a
  az_b                 = var.az_b
  cidr_public_subnet_a = var.cidr_public_subnet_a
  cidr_public_subnet_b = var.cidr_public_subnet_b
  db_ec2_instance_ip   = var.db_ec2_instance_ip
  cidr_app_subnet_a    = var.cidr_app_subnet_a
  cidr_app_subnet_b    = var.cidr_app_subnet_b
  db_subnet_ids        = [var.cidr_app_subnet_a, var.cidr_app_subnet_b]

}
module "rusmir_compute" {
  source              = "./dst-project-modules/modules/compute"
  namespace           = var.namespace
  bastion_sg_22       = module.networking.bastion_sg_22[0]
  vpc                 = module.networking
  key_name            = "datascientest_keypair"
  rusmir_wordpress_lb = module.networking.rusmir_wordpress_lb
  sg_pub_id           = module.networking.sg_pub_id
  sg_priv_id          = module.networking.sg_priv_id
  public_subnet_ids   = module.networking.public_subnet_ids
  private_subnet_ids  = module.networking.app_subnet_ids
  vpc_id              = module.networking.vpc_id
  db_user             = var.db_user
  db_password         = var.db_password
  db_name             = var.db_name
  db_host             = module.rusmir_rds.db_instance_endpoint
}

module "rusmir_rds" {

  source               = "./dst-project-modules/modules/rds"
  db_user              = var.db_user
  db_name              = var.db_name
  db_password          = var.db_password
  db_sg_id             = module.networking.db_sg_id
  db_subnet_group_name = module.networking.db_subnet_group_name
}

