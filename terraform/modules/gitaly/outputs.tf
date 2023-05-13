output "private_dns" {
  value = aws_instance.gitaly_server.private_dns
}

output "gitaly_ip" {
  value = aws_instance.gitaly_server.private_ip
}