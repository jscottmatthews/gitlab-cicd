resource "aws_ec2_client_vpn_endpoint" "client_vpn_endpoint" {
  description            = "client VPN endpoint"
  vpc_id                 = var.vpc_id
  server_certificate_arn = var.server_cert
  client_cidr_block      = var.client_cidr_block
  split_tunnel           = true
  security_group_ids     = [aws_security_group.vpn_access_sec_group.id]
  dns_servers            = ["10.0.0.2"]
  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.client_cert
  }

  connection_log_options {
    enabled = false
  }

  tags = {
    Name = "GitLab-Client-VPN-Endpoint"
  }
}

resource "aws_security_group" "vpn_access_sec_group" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    protocol    = "UDP"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "Incoming VPN connection"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Client-VPN-Endpoint-Sec-Group"
  }
}

resource "aws_ec2_client_vpn_network_association" "vpn_subnet_assoc_1a" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_endpoint.id
  subnet_id              = var.subnet_assoc_1a
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_endpoint.id
  target_network_cidr    = var.target_net_cidr
  authorize_all_groups   = true
}