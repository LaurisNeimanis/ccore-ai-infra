# --------------------------------------------
# TERRAFORM SETTINGS
# --------------------------------------------
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# --------------------------------------------
# PROVIDER CONFIGURATION
# --------------------------------------------
provider "aws" {
  region = var.region
}

# --------------------------------------------
# COMMON TAGS
# --------------------------------------------
locals {
  common_tags = {
    Project = var.project_name
    Env     = var.env
    Owner   = "Lauris Neimanis"
  }
}

# --------------------------------------------
# NETWORK MODULE
# --------------------------------------------
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

# --------------------------------------------
# COMPUTE MODULE
# --------------------------------------------
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

# --------------------------------------------
# INSTANCE MAP (FOR ANSIBLE INVENTORY)
# --------------------------------------------
locals {
  instance_map = {
    app = {
      public_ip = module.compute.public_ip
    }
  }
}

# --------------------------------------------
# AUTO-GENERATED ANSIBLE INVENTORY (YAML)
# --------------------------------------------
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../ansible/inventory/hosts.yaml"

  content = templatefile("${path.module}/../../templates/inventory.tmpl", {
    hosts = local.instance_map
  })

  file_permission      = "0644"
  directory_permission = "0755"
}
