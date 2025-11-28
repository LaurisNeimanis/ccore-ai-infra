variable "project_name" {
  type        = string
  description = "Project name used for tagging and resource naming."
  default     = "ccore-ai"
}

variable "env" {
  type        = string
  description = "Environment identifier (e.g., dev, stage, prod)."
  default     = "dev"
}

variable "region" {
  type        = string
  description = "AWS region where resources will be deployed."
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet."
  default     = "10.10.1.0/24"
}

variable "az" {
  type        = string
  description = "Availability Zone for compute resources."
  default     = "eu-central-1a"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type to deploy."
  default     = "t3.micro"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Local path to the SSH public key used for EC2 access."
  default     = "~/.ssh/id_ed25519.pub"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "Allowed CIDR block for incoming SSH access."
  default     = "0.0.0.0/0"
}

variable "root_volume_size" {
  type        = number
  description = "EBS root volume size in GB."
  default     = 20
}

variable "root_volume_type" {
  type        = string
  description = "EBS root volume type (gp3, io1, etc.)."
  default     = "gp3"
}

variable "root_volume_encrypted" {
  type        = bool
  description = "Whether the EBS root volume should be encrypted."
  default     = true
}
