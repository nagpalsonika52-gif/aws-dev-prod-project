
# Connect Terraform to AWS

provider "aws" {
  region = "ap-south-1"
}

# Find Amazon Linux image

data "aws_ami" "linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Create Development EC2

resource "aws_instance" "dev_server" {
  ami           = data.aws_ami.linux.id
  instance_type = "t3.micro"

  tags = {
    Name = "Development-Server"
  }
}

# Create Production EC2

resource "aws_instance" "prod_server" {
  ami           = data.aws_ami.linux.id
  instance_type = "t3.micro"

  tags = {
    Name = "Production-Server"
  }
}

# Display public IP addresses

output "dev_public_ip" {
  value = aws_instance.dev_server.public_ip
}

output "prod_public_ip" {
  value = aws_instance.prod_server.public_ip
}

# RDS Database Configuration

resource "aws_db_instance" "my_rds" {

  identifier = "my-project-rds"

  allocated_storage = 20

  storage_type = "gp3"

  engine = "mysql"

  engine_version = "8.0"

  instance_class = "db.t3.micro"

  db_name = "mydatabase"

  username = "admin"

  password = var.db_password

  publicly_accessible = false

  skip_final_snapshot = true

  tags = {
    Name = "My-RDS-Database"
  }
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}

$env:TF_VAR_db_password="YourStrongPassword123!"

