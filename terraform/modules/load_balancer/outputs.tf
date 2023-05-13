
output "target_group_arn" {
  value = aws_lb_target_group.gitlab_target_group.arn
}

output "lb_dns_name" {
  value = aws_lb.gitlab_lb.dns_name
}