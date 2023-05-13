resource "aws_key_pair" "generated_key" {
  key_name   = var.key_pair_name
  public_key = file("~/gitlab-cicd/setup/gitlab-key.pub")
}
