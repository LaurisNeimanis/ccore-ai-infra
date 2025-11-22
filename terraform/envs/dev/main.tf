terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  common_tags = {
    Project = var.project_name
    Env     = var.env
    Owner   = "Lauris Neimanis"
  }
}

module "network" {
  source             = "../../modules/network"
  name               = var.project_name
  env                = var.env
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  az                 = var.az
  allowed_ssh_cidr   = var.allowed_ssh_cidr
  tags               = local.common_tags
}

module "compute" {
  source              = "../../modules/compute"
  name                = var.project_name
  env                 = var.env
  vpc_id              = module.network.vpc_id
  subnet_id           = module.network.public_subnet_id
  instance_type       = var.instance_type
  ssh_public_key_path = var.ssh_public_key_path
  tags                = local.common_tags

  root_volume_size      = var.root_volume_size
  root_volume_type      = var.root_volume_type
  root_volume_encrypted = var.root_volume_encrypted

  security_group_ids = [module.network.security_group_id]
}
