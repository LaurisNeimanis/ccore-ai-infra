# --------------------------------------------
# COMPUTE MODULE VARIABLES
# --------------------------------------------

variable "name" {
  description = "Base name for compute resources."
  type        = string
}

variable "env" {
  description = "Environment name (dev/stage/prod)."
  type        = string
  default     = "dev"
}

# --------------------------------------------
# NETWORK REFERENCES (NO DEFAULTS)
# These must come from the environment (envs/dev)
# --------------------------------------------
variable "vpc_id" {
  description = "VPC ID where the instance will be deployed."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2 placement."
  type        = string
}

variable "security_group_ids" {
  description = "List of security groups attached to the EC2 instance."
  type        = list(string)
}

# --------------------------------------------
# EC2 CONFIGURATION
# --------------------------------------------
variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "ssh_public_key_path" {
  description = "Path to the local SSH public key."
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

# --------------------------------------------
# ROOT VOLUME SETTINGS
# --------------------------------------------
variable "root_volume_size" {
  description = "Root EBS volume size in GB."
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Root EBS volume type."
  type        = string
  default     = "gp3"
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root volume."
  type        = bool
  default     = true
}

# --------------------------------------------
# TAGS
# --------------------------------------------
variable "tags" {
  description = "Common tags applied to all compute resources."
  type        = map(string)
  default     = {}
}
