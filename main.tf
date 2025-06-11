provider "aws" {
  profile = "noit"
  region  = var.region
}

# S3 bucket for businesses
resource "aws_s3_bucket" "noit_businesses" {
  bucket = "noit-businesses"
  
  tags = {
    Name = "noit-businesses"
  }
}

# Grupo de seguridad
resource "aws_security_group" "noit_sg" {
  name        = "noit-sg"
  description = "Security group for noit application"
  vpc_id      = aws_default_vpc.default.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # PostgreSQL
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Application port 3000
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Application port 8080
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Salida
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "noit-sg"
  }
}

# Use default VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# EC2 Instance
resource "aws_instance" "noit_server" {
  ami                    = var.ami_id
  instance_type          = "t3a.large"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.noit_sg.id]
  
  credit_specification {
    cpu_credits = "unlimited"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 50
  }

  tags = {
    Name = "noit-server"
  }

  # Esto es importante para que Ansible pueda conectarse sin problemas
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${var.ssh_key_path}/${var.key_name}.pem")
    host        = self.public_ip
  }

  # Esperamos a que la instancia esté completamente disponible
  provisioner "remote-exec" {
    inline = ["echo 'Server is ready!'"]
  }
}

# EBS volumen para datos de Docker (incluyendo PostgreSQL)
resource "aws_ebs_volume" "postgres_data" {
  availability_zone = aws_instance.noit_server.availability_zone
  size              = 50
  type              = "gp3"
  iops              = 3000
  throughput        = 125
  
  tags = {
    Name = "docker-data"
  }
}

resource "aws_volume_attachment" "postgres_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.postgres_data.id
  instance_id = aws_instance.noit_server.id
}

# Creamos un inventario de Ansible local
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl",
    {
      server_ip = aws_instance.noit_server.public_ip
      ssh_keyfile = "${abspath(path.root)}/${var.ssh_key_path}/${var.key_name}.pem"
    }
  )
  filename = "${path.module}/ansible/inventory.ini"
}

# Ejecutamos Ansible para configurar la instancia
resource "null_resource" "ansible_provisioner" {
  depends_on = [
    aws_instance.noit_server,
    aws_volume_attachment.postgres_attachment,
    local_file.ansible_inventory
  ]

  provisioner "local-exec" {
    command = "sleep 30 && cd ${path.module}/ansible && ansible-playbook -i inventory.ini docker-setup.yml && ansible-playbook -i inventory.ini deploy-app.yml"
  }

  triggers = {
    instance_id = aws_instance.noit_server.id
  }
} 