# --------------------------------------------
# TERRAFORM SETTINGS
# --------------------------------------------
terraform {
  required_version = "~> 1.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

# --------------------------------------------
# PROVIDER
# --------------------------------------------
provider "aws" {
  region = var.region
}

# --------------------------------------------
# VPC
# --------------------------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "${var.project_name}-${var.env}-vpc"
  cidr = var.vpc_cidr

  azs            = [var.az]
  public_subnets = [var.public_subnet_cidr]

  enable_ipv6 = true

  public_subnet_ipv6_prefixes                   = [0]
  public_subnet_assign_ipv6_address_on_creation = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  manage_default_security_group = false
  manage_default_route_table    = false
  manage_default_network_acl    = false

  tags = local.common_tags
}


# --------------------------------------------
# SECURITY GROUP
# --------------------------------------------
module "sg_instance" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name            = "${var.project_name}-${var.env}-sg"
  use_name_prefix = false
  vpc_id          = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = var.allowed_ssh_cidr
    },
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  ingress_with_ipv6_cidr_blocks = [
    {
      rule             = "http-80-tcp"
      ipv6_cidr_blocks = "::/0"
    },
    {
      rule             = "https-443-tcp"
      ipv6_cidr_blocks = "::/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  # IPv6 egress is NOT defined here because the ec2-instance module
  # automatically creates an IPv6 "::/0" egress rule when ipv6_address_count = 1.
  # Defining it in this SG would cause a duplicate rule error.
  #egress_with_ipv6_cidr_blocks = [
  #  {
  #    rule             = "all-all"
  #    ipv6_cidr_blocks = "::/0"
  #  }
  #]

  tags = local.common_tags
}

# --------------------------------------------
# EC2 INSTANCE
# --------------------------------------------
module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name = "${var.project_name}-${var.env}-instance"

  create_security_group = false

  ami           = data.aws_ssm_parameter.ubuntu_2404.value
  instance_type = var.instance_type

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.sg_instance.security_group_id]

  ipv6_address_count = 1

  key_name = aws_key_pair.this.key_name

  associate_public_ip_address = true
  user_data                   = file("${path.module}/bootstrap/bootstrap.yaml")

  root_block_device = {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    encrypted   = var.root_volume_encrypted
  }

  metadata_options = {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
  }

  tags = local.common_tags
}
