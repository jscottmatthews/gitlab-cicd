resource "aws_vpc" "gitlab_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
}

resource "aws_subnet" "gitlab_subnet_1a" {
  vpc_id            = aws_vpc.gitlab_vpc.id
  cidr_block        = var.subnet_cidr_1a
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "gitlab_subnet_1b" {
  vpc_id            = aws_vpc.gitlab_vpc.id
  cidr_block        = var.subnet_cidr_1b
  availability_zone = "us-east-1b"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = aws_vpc.gitlab_vpc.id
  service_name    = "com.amazonaws.us-east-1.s3"
  route_table_ids = [aws_vpc.gitlab_vpc.main_route_table_id]
}

