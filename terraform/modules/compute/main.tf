resource "aws_key_pair" "this" {
  key_name   = "${var.name}-${var.env}-key"
  public_key = file(var.ssh_public_key_path)

  tags = merge(var.tags, {
    Name = "${var.name}-${var.env}-key"
  })
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    encrypted   = var.root_volume_encrypted
  }

  user_data = file("${path.module}/bootstrap.sh")

  tags = merge(var.tags, {
    Name = "${var.name}-${var.env}-ec2"
    Role = "app"
    Env  = var.env
  })
}
