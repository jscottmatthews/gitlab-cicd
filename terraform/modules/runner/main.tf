
resource "aws_instance" "runner_server" {
  subnet_id              = var.runner_subnet
  ami                    = data.aws_ami.ubuntu_latest.id
  instance_type          = var.runner_inst_type
  vpc_security_group_ids = [var.runner_sec_group]
  key_name               = var.runner_key_pair

  tags = {
    Name = "Runner-Server"
  }
}

