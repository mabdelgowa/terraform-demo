output "public_ip_address" {
  value = aws_instance.nginx-server.public_ip
}