
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
  region = var.aws_region

}

module "compute" {
  source                = "./dst-project-modules/modules/compute"
  rusmir_vpc            = module.networking.rusmir_vpc
  webserver_sg          = module.security.webserver_sg
  prv_sub1              = module.networking.prv_sub1.id
  prv_sub2              = module.networking.prv_sub2.id
  pub_sub1              = module.networking.pub_sub1.id
  wordpress_alb_arn     = module.networking.wordpress_alb_arn
  security_group_elb_sg = module.security.security_group_elb_sg
  bastion_sg_22         = module.security.bastion_sg_22
  namespace             = var.namespace
  environment           = var.environment
}

module "networking" {
  source                = "./dst-project-modules/modules/networking"
  environment           = var.environment
  db_sg_id              = module.security.db_sg_id
  elb_sg_id             = module.security.elb_sg_id
  namespace             = var.namespace
  cidr_vpc              = var.cidr_vpc
  az_a                  = var.az_a
  az_b                  = var.az_b
  cidr_public_subnet_a  = var.cidr_public_subnet_a
  cidr_public_subnet_b  = var.cidr_public_subnet_b
  cidr_private_subnet_a = var.cidr_app_subnet_a
  cidr_private_subnet_b = var.cidr_app_subnet_b
  lb_target_group_arn   = module.compute.lb_target_group_arn
  # db_subnet_ids        = [var.cidr_app_subnet_a, var.cidr_app_subnet_b]

}


module "rusmir_rds" {

  source                 = "./dst-project-modules/modules/rds"
  db_user                = var.db_user
  db_name                = var.db_name
  db_password            = var.db_password
  db_sg_id               = module.security.db_security_group
  rusmir_db_subnet_group = module.networking.rusmir_db_subnet_group
  namespace              = var.namespace
  environment            = var.environment
}

module "security" {
  source      = "./dst-project-modules/modules/security"
  rusmir_vpc  = module.networking.rusmir_vpc
  namespace   = var.namespace
  environment = var.environment



}