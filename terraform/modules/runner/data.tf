# data "aws_ami" "redhat_8_latest" {
#   most_recent = true
#   owners      = ["309956199498"]
#   filter {
#     name   = "name"
#     values = ["RHEL-8.*"]
#   }
# }

data "aws_ami" "ubuntu_latest" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}