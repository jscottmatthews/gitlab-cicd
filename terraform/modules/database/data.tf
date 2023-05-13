data "aws_ssm_parameter" "rds_password" {
  name = "/dev/rds/password"
}

