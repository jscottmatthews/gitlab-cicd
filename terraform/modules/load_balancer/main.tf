resource "aws_lb" "gitlab_lb" {
  name               = "GitLab-ALB"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.lb_sec_group]
  subnets            = var.lb_subnets

  #  enable_deletion_protection = true

  tags = {
    Name = "GitLab-ALB"
  }
}

resource "aws_lb_target_group" "gitlab_target_group" {
  name     = "GitLab-Target-Group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.lb_vpc_id
  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299"
    path                = "/explore"
    protocol            = "HTTP"
    timeout             = 5
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.gitlab_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gitlab_target_group.arn
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.gitlab_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gitlab_target_group.arn
  }
}