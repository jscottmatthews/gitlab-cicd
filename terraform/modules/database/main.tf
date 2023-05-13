resource "aws_db_instance" "gitlab_db" {
  allocated_storage       = 10
  vpc_security_group_ids  = [var.rds_sec_group]
  db_subnet_group_name    = aws_db_subnet_group.gitlab_db_subnet.id
  db_name                 = "gitlab"
  username                = "gitlab"
  engine                  = "postgres"
  password                = data.aws_ssm_parameter.rds_password.value
  engine_version          = var.rds_engine_version
  instance_class          = var.rds_inst_class
  backup_retention_period = 3
  skip_final_snapshot     = true
  storage_encrypted       = true
}

resource "aws_db_subnet_group" "gitlab_db_subnet" {
  name       = "main"
  subnet_ids = var.rds_subnets

  tags = {
    Name = "GitLab-DB-Subnet-Group"
  }
}