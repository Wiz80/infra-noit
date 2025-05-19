output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.noit_server.id
}

output "public_ip" {
  description = "IP pública de la instancia EC2"
  value       = aws_instance.noit_server.public_ip
}

output "public_dns" {
  description = "DNS público de la instancia EC2"
  value       = aws_instance.noit_server.public_dns
}

output "ssh_command" {
  description = "Comando para conectarse vía SSH a la instancia"
  value       = "ssh -i /path/to/${var.key_name}.pem ubuntu@${aws_instance.noit_server.public_dns}"
} 