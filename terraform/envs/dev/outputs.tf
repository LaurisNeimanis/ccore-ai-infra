# --------------------------------------------
# ENVIRONMENT OUTPUTS
# --------------------------------------------

output "public_ip" {
  description = "Public IPv4 address of the EC2 instance."
  value       = module.compute.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance."
  value       = module.compute.instance_id
}

output "vpc_id" {
  description = "ID of the VPC created for this environment."
  value       = module.network.vpc_id
}

output "subnet_id" {
  description = "ID of the public subnet for this environment."
  value       = module.network.public_subnet_id
}

output "security_group_id" {
  description = "ID of the security group applied to the EC2 instance."
  value       = module.network.security_group_id
}
