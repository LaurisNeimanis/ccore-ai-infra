# --------------------------------------------
# COMPUTE OUTPUTS
# --------------------------------------------

output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IPv4 address of the EC2 instance."
  value       = aws_instance.this.public_ip
}

output "ami_id" {
  description = "AMI ID used for launching the instance."
  value       = data.aws_ami.ubuntu.id
}
