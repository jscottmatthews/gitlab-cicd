output "rds_dns_name" {
  value = aws_db_instance.gitlab_db.address
}