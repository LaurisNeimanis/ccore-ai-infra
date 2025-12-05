variable "name" {
  type        = string
  description = "EC2 instance logical name used for naming and tagging."
}

variable "ami" {
  type        = string
  description = "AMI ID used to launch the EC2 instance."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type (e.g., t3.micro, m6i.large)."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where the EC2 instance will be deployed."
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "List of security group IDs associated with the instance."
}

variable "key_name" {
  type        = string
  description = "SSH key pair name for EC2 instance access."
}

variable "associate_public_ip_address" {
  type        = bool
  default     = true
  description = "Whether to assign a public IPv4 address to the instance."
}

variable "ipv6_address_count" {
  type        = number
  default     = 0
  description = "Number of automatically assigned IPv6 addresses."
}

variable "user_data" {
  type        = string
  default     = null
  description = "Optional user-data script executed on first boot."
}

variable "root_volume_size" {
  type        = number
  description = "Root EBS volume size in GiB."
}

variable "root_volume_type" {
  type        = string
  default     = "gp3"
  description = "Root EBS volume type (gp3, gp2, io1, etc.)."
}

variable "root_volume_encrypted" {
  type        = bool
  default     = true
  description = "Whether the root EBS volume should be encrypted."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags applied to the EC2 instance and resources."
}
