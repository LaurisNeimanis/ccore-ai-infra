# --------------------------------------------
# COMMON LOCALS
# --------------------------------------------
locals {
  common_tags = {
    Project = var.project_name
    Env     = var.env
    Owner   = "Lauris Neimanis"
  }

  instance_map = {
    app = {
      public_ip = module.ec2.public_ip
    }
  }
}
