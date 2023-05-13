output "vpc_id" {
  value = aws_vpc.gitlab_vpc.id
}

output "subnet_1a_id" {
  value = aws_subnet.gitlab_subnet_1a.id
}

output "subnet_1b_id" {
  value = aws_subnet.gitlab_subnet_1b.id
}