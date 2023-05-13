resource "aws_instance" "rails_server" {
  subnet_id              = var.rails_subnet
  ami                    = data.aws_ami.ubuntu_latest.id
  instance_type          = var.rails_inst_type
  vpc_security_group_ids = [var.rails_sec_group]
  key_name               = var.rails_key_pair
  iam_instance_profile   = var.rails_instance_profile
  tags = {
    Name = "Rails-Server"
  }
}

resource "aws_lb_target_group_attachment" "gitlab_target_group" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.rails_server.id
  port             = 80
}