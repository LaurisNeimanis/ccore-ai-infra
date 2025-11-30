output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID used by the EC2 instance."
  value       = module.vpc.public_subnets[0]
}

output "security_group_id" {
  description = "Security group ID attached to the EC2 instance."
  value       = module.sg_instance.security_group_id
}

output "ec2_instance_id" {
  description = "The EC2 instance ID."
  value       = module.ec2.id
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance."
  value       = module.ec2.public_ip
}

output "ssh_connection" {
  description = "Convenient SSH command to access the EC2 instance."
  value       = "ssh -i ~/.ssh/id_ed25519 ubuntu@${module.ec2.public_ip}"
}
