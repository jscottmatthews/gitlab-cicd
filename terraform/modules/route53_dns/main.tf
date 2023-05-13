resource "aws_route53_zone" "hosted_zone" {
  name = "devops-testenv.com"
  vpc {
    vpc_id = var.zone_vpc
  }
}

resource "aws_route53_record" "lb_record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = var.rails_domain
  type    = "CNAME"
  ttl     = 60
  records = var.lb_record
}

resource "aws_route53_record" "gitaly_record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = var.gitaly_domain
  type    = "CNAME"
  ttl     = 60
  records = var.gitaly_record
}

resource "aws_route53_record" "rds_record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = var.rds_domain
  type    = "CNAME"
  ttl     = 60
  records = var.rds_record
}