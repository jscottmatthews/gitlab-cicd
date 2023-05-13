output "frontend_sec_group_id" {
  value = aws_security_group.frontend_sec_group.id
}

output "gitaly_sec_group_id" {
  value = aws_security_group.gitaly_sec_group.id
}

output "rds_sec_group_id" {
  value = aws_security_group.rds_sec_group.id
}

output "runner_sec_group_id" {
  value = aws_security_group.runner_sec_group.id
}