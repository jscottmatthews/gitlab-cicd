# Enter the name of your registered domain in AWS below and the ARN of your ACM cert
rails_domain  = "gitlab.ENTER_DOMAIN_NAME"
gitaly_domain = "gitaly.ENTER_DOMAIN_NAME"
rds_domain    = "rds.ENTER_DOMAIN_NAME"
cert_arn      = "ENTER_CERT_ARN"

# Edit this if you cloned the project somewhere other than your home directory
# Also edit the file functions in /iam/main.tf and /key/main.tf
ansible_role_dir = "~/gitlab-cicd/ansible/playbooks"


# Edit the following values according to the setup script's instructions
server_cert = "ENTER_VALUE_FROM_SETUP_SCRIPT"
client_cert = "ENTER_VALUE_FROM_SETUP_SCRIPT"

######################################
# The following values are fine as is, but can be customized if desired

rails_inst_type    = "t3.medium"
gitaly_inst_type   = "t3.medium"
runner_inst_type   = "t3.medium"
rds_engine_version = "14.5"
rds_inst_class     = "db.t3.micro"
client_cidr_block  = "100.0.0.0/22"
vpc_cidr           = "10.0.0.0/23"
subnet_cidr_1a     = "10.0.0.0/24"
subnet_cidr_1b     = "10.0.1.0/24"
key_pair_name      = "gitlab-key"

