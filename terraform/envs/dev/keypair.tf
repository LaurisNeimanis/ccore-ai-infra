# --------------------------------------------
# SSH KEYPAIR
# --------------------------------------------
resource "aws_key_pair" "this" {
  key_name   = "${var.project_name}-${var.env}-key"
  public_key = file(var.ssh_public_key_path)

  tags = merge(
    { Name = "${var.project_name}-${var.env}-key" },
    local.common_tags
  )
}
