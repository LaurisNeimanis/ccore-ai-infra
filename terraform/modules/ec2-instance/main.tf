# --------------------------------------------
# EC2 INSTANCE
# --------------------------------------------
resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  user_data                   = var.user_data

  # --------------------------------------------
  # NETWORKING
  # --------------------------------------------
  ipv6_address_count          = var.ipv6_address_count
  associate_public_ip_address = var.associate_public_ip_address

  # Never use "security_groups" (for EC2-Classic)
  security_groups             = []
  vpc_security_group_ids      = var.security_group_ids

  # --------------------------------------------
  # ROOT BLOCK DEVICE
  # --------------------------------------------
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    encrypted   = var.root_volume_encrypted
  }

  # --------------------------------------------
  # METADATA OPTIONS (BEST PRACTICE)
  # --------------------------------------------
  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
  }

  tags = var.tags
}
