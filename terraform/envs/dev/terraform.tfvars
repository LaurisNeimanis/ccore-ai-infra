# Core project settings
project_name = "ccore-ai"     # Name prefix for all resources
env          = "dev"          # Environment identifier
region       = "eu-central-1" # AWS region

# Networking
vpc_cidr           = "10.10.0.0/16"  # VPC CIDR block
public_subnet_cidr = "10.10.1.0/24"  # Public subnet for the EC2 instance
az                 = "eu-central-1a" # Availability zone

# Access control
allowed_ssh_cidr = "0.0.0.0/0" # SSH access range (tighten later for security)

# Compute configuration
instance_type       = "t3.micro"              # EC2 instance size
ssh_public_key_path = "~/.ssh/id_ed25519.pub" # SSH public key for access

# Root volume configuration
root_volume_size = 20    # Size in GiB
root_volume_type = "gp3" # Default EBS volume type
