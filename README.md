### SUMMARY:
Deploys and configures a secure DevSecOps architecture consisting of GitLab CE and AWS managed services. Primarily meant for small-scale use with the Docker executor. 

Loosely based on GitLab docs like the following, but modified to be more secure 

https://docs.gitlab.com/ee/install/aws/manual_install_aws.html 


### FEATURES:
- Creates and configures a Client VPN for secure access
- Architecture resides in an airgapped environment
- Automatically sideloads two Docker images for use as build images with the Docker runner executor 
- Runner autoscaling by harnessing ECS / Fargate
- Gitaly configured to store repo data on its own server 
- Current configuration is meant to be low-cost, but can easily be scaled up by changing parameters in the tfvars file


### PREREQUISITES:
- An AWS account with credentials configured
- A registered domain name in AWS
- An Iron Bank account for pulling secure Docker images
- Terraform and Ansible installed locally, plus the amazon.aws collection (https://docs.ansible.com/ansible/latest/collections/amazon/aws/aws_ssm_lookup.html)
- Arbitrary password / token values entered in Parameter Store with the following names:
  <br>/dev/gitaly/auth_token
  <br>/dev/gitaly/secret_token
  <br>/dev/rds/password

### TO RUN:
- Git clone the repo to your home directory (you will have to alter the ansible_role_dir var in dev.auto.tfvars if you clone it elsewhere) 
- Run the setup.sh script to generate an SSH key, download the necessary packages and container images, and set up the certs for VPN authentication 
  **Note: There are a number of prompts (including for your sudo password and Iron Bank credentials), so stay close
  **Note2: It will download about 2GB of GitLab and Docker packages to your machine
- Follow the instructions provided by the setup script to enter the necessary vars for your environment and run the Terraform 
- Connect to the VPN by following the instructions from the setup script. Then run the Ansible
- Once complete, log into the Rails server with the SSH key generated and set the root password with this command: <br>
```sudo gitlab-rake "gitlab:password:reset[root]"```
- Sign into the web interface, create a project, and grab the runner registration token from the Settings > CICD > Runners page
- Log into the runner server with the same SSH key and register runners with this command: <br>
```sudo gitlab-runner register --url DOMAIN --registration-token TOKEN --name NAME --docker-image IMAGE --tag-list TAG1,TAG2,ETC --executor docker --docker-allowed-pull-policies never --docker-pull-policy never -n && gitlab-runner verify```
- That's it! You now have a highly secure, fully functional GitLab setup hosted in AWS


### CONFIGURATION: 
- This will automatically provision two build containers, buildah:1.24:2 and ubi8-minimal:8.7. You will have to sideload any other container images or tools needed from a machine with internet access
- Having Gitaly serving git repo data from its own server is probably overkill for this scale of deployment (but it provides the option to move to a more highly available design in the future, with a stateless Rails ASG). This can be changed to run from the Rails server for a simpler design
- You can scale up the deployment by changing the default values in the /terraform/dev.auto.tfvars file (such as using larger instance classes)
- High availability options to be added in the future


### TO DO:
- Configure the Ansible to install Rootless Docker on the Runner Machine
- Provision custom build containers with more languages and tools for testing for better functionality 
- Add runner autoscaling via ECS / Fargate
- Add the option for high availability by making it possible to put Rails in an autoscaling group
- Provision a detachable EBS volume to hold Gitaly repo data, and set up automatic backups via DLM
- Clean up the setup script 
- Configure Grafana monitoring on the Rails server
