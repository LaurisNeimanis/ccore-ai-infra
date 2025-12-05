# --------------------------------------------
# EC2 INSTANCE OUTPUTS
# --------------------------------------------
output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IPv4 address of the instance."
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "Private IPv4 address of the instance."
  value       = aws_instance.this.private_ip
}

output "arn" {
  description = "ARN of the EC2 instance."
  value       = aws_instance.this.arn
}
