# --------------------------------------------
# AMI LOOKUP (Ubuntu 24.04 via SSM)
# --------------------------------------------
data "aws_ssm_parameter" "ubuntu_2404" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}
