module "vpc_subnets" {
  source         = "./modules/vpc_subnets"
  vpc_cidr       = var.vpc_cidr
  subnet_cidr_1a = var.subnet_cidr_1a
  subnet_cidr_1b = var.subnet_cidr_1b
}

module "vpn" {
  source            = "./modules/vpn"
  vpc_id            = module.vpc_subnets.vpc_id
  subnet_assoc_1a   = module.vpc_subnets.subnet_1a_id
  target_net_cidr   = var.vpc_cidr
  client_cidr_block = var.client_cidr_block
  client_cert       = var.client_cert
  server_cert       = var.server_cert
  subnet_assoc_id   = var.subnet_cidr_1a
  target_subnet_id  = var.subnet_cidr_1a
}

module "route53_dns" {
  source        = "./modules/route53_dns"
  zone_vpc      = module.vpc_subnets.vpc_id
  lb_record     = [module.alb.lb_dns_name]
  rails_domain  = var.rails_domain
  gitaly_record = [module.gitaly.private_dns]
  gitaly_domain = var.gitaly_domain
  rds_record    = [module.rds.rds_dns_name]
  rds_domain    = var.rds_domain
}

module "iam" {
  source = "./modules/iam/"
}

module "key" {
  source        = "./modules/key"
  key_pair_name = var.key_pair_name
}

module "sec_groups" {
  source          = "./modules/security_groups"
  whitelisted_ips = var.vpc_cidr
  vpc_id          = module.vpc_subnets.vpc_id
}

module "rails" {
  source                 = "./modules/rails/"
  rails_subnet           = module.vpc_subnets.subnet_1a_id
  rails_inst_type        = var.rails_inst_type
  rails_sec_group        = module.sec_groups.frontend_sec_group_id
  rails_key_pair         = module.key.gitlab_key_id
  target_group_arn       = module.alb.target_group_arn
  rails_instance_profile = module.iam.rails_profile
}

module "gitaly" {
  source           = "./modules/gitaly/"
  gitaly_subnet    = module.vpc_subnets.subnet_1a_id
  gitaly_inst_type = var.gitaly_inst_type
  gitaly_sec_group = module.sec_groups.gitaly_sec_group_id
  gitaly_key_pair  = module.key.gitlab_key_id
}

module "runner" {
  source           = "./modules/runner/"
  runner_subnet    = module.vpc_subnets.subnet_1a_id
  runner_inst_type = var.runner_inst_type
  runner_sec_group = module.sec_groups.runner_sec_group_id
  runner_key_pair  = module.key.gitlab_key_id
}

module "alb" {
  source       = "./modules/load_balancer"
  lb_subnets   = [module.vpc_subnets.subnet_1a_id, module.vpc_subnets.subnet_1b_id]
  lb_sec_group = module.sec_groups.frontend_sec_group_id
  lb_vpc_id    = module.vpc_subnets.vpc_id
  cert_arn     = var.cert_arn
}

module "rds" {
  source = "./modules/database"

  rds_engine_version = var.rds_engine_version
  rds_inst_class     = var.rds_inst_class
  rds_sec_group      = module.sec_groups.rds_sec_group_id
  rds_subnets        = [module.vpc_subnets.subnet_1a_id, module.vpc_subnets.subnet_1b_id]
}

module "s3_object_storage" {
  source = "./modules/s3_object_storage"
}

resource "local_file" "ansible_var_file" {
  filename = "../ansible/playbooks/variables.yml"
  content  = <<-DOC
  rails_ip: ${module.rails.rails_ip}
  gitaly_ip: ${module.gitaly.gitaly_ip}
  runner_ip: ${module.runner.runner_ip}
  rails_domain: ${var.rails_domain}
  gitaly_domain: ${var.gitaly_domain}
  rds_domain: ${var.rds_domain}
  role_dir: ${var.ansible_role_dir}
  DOC
}