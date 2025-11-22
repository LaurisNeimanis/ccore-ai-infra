variable "name" {
  description = "Base name for networking resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet"
  type        = string
  default     = "10.10.1.0/24"
}

variable "az" {
  description = "Availability zone for subnet"
  type        = string
  default     = "eu-central-1a"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH (demo default is open; tighten later)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "env" {
  description = "Environment name (dev/prod)"
  type        = string
  default     = "dev"
}
