resource "aws_instance" "gitaly_server" {
  subnet_id              = var.gitaly_subnet
  ami                    = data.aws_ami.ubuntu_latest.id
  instance_type          = var.gitaly_inst_type
  vpc_security_group_ids = [var.gitaly_sec_group]
  key_name               = var.gitaly_key_pair
  root_block_device {
    encrypted   = true
    volume_size = 50
  }

  tags = {
    Name = "Gitaly-Server"
  }
}

# resource "aws_ebs_volume" "gitaly_ebs_volume" {
#   availability_zone = "us-east-1a"
#   size              = 50
#   encrypted         = true
#   tags = {
#     Name = "gitaly-ebs-volume"
#   }
# }

# resource "aws_volume_attachment" "gitaly_ebs_attachment" {
#   device_name = "/dev/sdh"
#   volume_id   = aws_ebs_volume.gitaly_ebs_volume.id
#   instance_id = aws_instance.gitaly_server.id
# }