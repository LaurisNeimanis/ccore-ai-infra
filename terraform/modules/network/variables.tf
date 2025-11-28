variable "name" {
  type        = string
  description = "Base name used for tagging and resource naming."
}

variable "env" {
  type        = string
  description = "Environment identifier (e.g., dev, stage, prod)."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block of the public subnet."
}

variable "az" {
  type        = string
  description = "AWS Availability Zone for subnet placement."
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed to access SSH port."
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to all resources."
  default     = {}
}
