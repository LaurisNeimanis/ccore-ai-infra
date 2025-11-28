# --------------------------------------------
# VPC
# --------------------------------------------
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = merge(
    {
      Name = "${var.name}-${var.env}-vpc"
    },
    var.tags
  )
}

# --------------------------------------------
# PUBLIC SUBNET
# --------------------------------------------
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.az

  tags = merge(
    {
      Name = "${var.name}-${var.env}-public-subnet"
    },
    var.tags
  )
}

# --------------------------------------------
# INTERNET GATEWAY
# --------------------------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "${var.name}-${var.env}-igw"
    },
    var.tags
  )
}

# --------------------------------------------
# ROUTE TABLE + DEFAULT ROUTE
# --------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "${var.name}-${var.env}-rt"
    },
    var.tags
  )
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# --------------------------------------------
# SECURITY GROUP
# --------------------------------------------
resource "aws_security_group" "this" {
  name        = "${var.name}-${var.env}-sg"
  description = "Security group for public EC2 instance"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "${var.name}-${var.env}-sg"
    },
    var.tags
  )
}
