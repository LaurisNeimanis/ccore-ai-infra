output "ec2_public_ip" {
  value = module.compute.public_ip
}

output "ec2_instance_id" {
  value = module.compute.instance_id
}

output "vpc_id" {
  value = module.network.vpc_id
}
