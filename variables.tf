variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (Ubuntu 20.04 LTS)"
  type        = string
  default     = "ami-0261755bbcb8c4a84"  # Ubuntu 20.04 LTS en us-east-1, actualizar según región
}

variable "key_name" {
  description = "Name of the SSH key pair to use for the EC2 instance"
  type        = string
  # No default - debe ser proporcionado por el usuario
}

variable "ssh_key_path" {
  description = "Path to the SSH private key file"
  type        = string
  default     = "keys"  # Directorio relativo al proyecto donde se almacenan las claves SSH
} 