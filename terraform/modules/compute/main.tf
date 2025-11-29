# --------------------------------------------
# AMI LOOKUP (Ubuntu 24.04 LTS)
# --------------------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# --------------------------------------------
# SSH KEYPAIR
# --------------------------------------------
resource "aws_key_pair" "this" {
  key_name   = "${var.name}-${var.env}-key"
  public_key = file(var.ssh_public_key_path)

  tags = merge(
    {
      Name = "${var.name}-${var.env}-key"
    },
    var.tags
  )
}

# --------------------------------------------
# EC2 INSTANCE
# --------------------------------------------
resource "aws_instance" "this" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = aws_key_pair.this.key_name

  # Assign public IPv4 ONLY to this instance
  associate_public_ip_address = true

  # Cloud-init bootstrap
  user_data = file("${path.module}/bootstrap.sh")

  # Root volume configuration
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    encrypted   = var.root_volume_encrypted
  }

  # --------------------------------------------
  # IMDSv2 — AWS security best practice
  # --------------------------------------------
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"   # IMDSv2 only
    http_put_response_hop_limit = 2
  }

  tags = merge(
    {
      Name = "${var.name}-${var.env}-ec2"
    },
    var.tags
  )
}
