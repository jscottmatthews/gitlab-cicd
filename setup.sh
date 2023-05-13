#!/bin/bash

mkdir setup/
cd setup/

#Generate SSH key
ssh-keygen -t rsa -b 4096 -f gitlab-key -N ''

#Download GitLab and Runner packages
curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
curl -s "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
curl -LJO "https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb" 
wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/jammy/gitlab-ce_15.9.7-ce.0_amd64.deb/download.deb -O gitlab.deb

#Download Docker packages
mkdir docker
cd docker
curl -Lo containerd.deb https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/amd64/containerd.io_1.6.9-1_amd64.deb
curl -Lo docker-ce.deb https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/amd64/docker-ce_23.0.6-1~ubuntu.22.04~jammy_amd64.deb
curl -Lo docker-ce-cli.deb https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/amd64/docker-ce-cli_20.10.24~3-0~ubuntu-jammy_amd64.deb
curl -Lo docker-buildx-plugin.deb https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/amd64/docker-buildx-plugin_0.10.4-1~ubuntu.22.04~jammy_amd64.deb
curl -Lo docker-compose-plugin.deb https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/amd64/docker-compose-plugin_2.17.3-1~ubuntu.22.04~jammy_amd64.deb

#Prompt for Iron Bank login, then pull, rename, and package container images
echo ""
echo "You will need your username and CLI secret from your Iron Bank profile"
echo "found here https://registry1.dso.mil/harbor/projects for the next step"
read -e -p "Enter your username: " USERNAME 
read -e -p "Enter your CLI secret: " SECRET 
docker login registry1.dso.mil -u $USERNAME -p $SECRET

docker pull registry1.dso.mil/ironbank/opensource/containers/buildah:1.24.2
docker tag registry1.dso.mil/ironbank/opensource/containers/buildah:1.24.2 buildah:1.24.2
docker save buildah:1.24.2 -o buildah.tar

docker pull registry1.dso.mil/ironbank/redhat/ubi/ubi8-minimal:8.7
docker tag registry1.dso.mil/ironbank/redhat/ubi/ubi8-minimal:8.7 ubi8-min:8.7
docker save ubi8-min:8.7 -o ubi8-min.tar

Set up the client / server certs to authenticate with the VPN
cd ../
git clone https://github.com/OpenVPN/easy-rsa.git
./easy-rsa/easyrsa3/easyrsa init-pki
./easy-rsa/easyrsa3/easyrsa build-ca nopass
./easy-rsa/easyrsa3/easyrsa build-server-full server nopass
./easy-rsa/easyrsa3/easyrsa build-client-full client1.domain.tld nopass
mkdir certs/
cp pki/ca.crt certs/
cp pki/issued/server.crt certs/
cp pki/private/server.key certs/
cp pki/issued/client1.domain.tld.crt certs/
cp pki/private/client1.domain.tld.key certs/
cd certs/
echo ""
echo "               ***IMPORTANT***"
echo "FOLLOW THE INSTRUCTIONS BELOW TO CONNECT TO THE VPN"
echo "         AND COMPLETE THE INSTALLATION!"
echo ""
echo "Take the Server Cert ARN below and enter it in the 'server_cert' var in /terraform/dev.auto.tfvars"
aws acm import-certificate --certificate fileb://server.crt --private-key fileb://server.key --certificate-chain fileb://ca.crt
echo "Take the Client Cert ARN below and enter it in the 'client_cert' var in /terraform/dev.auto.tfvars"
aws acm import-certificate --certificate fileb://client1.domain.tld.crt --private-key fileb://client1.domain.tld.key --certificate-chain fileb://ca.crt
KEY_VALUE="$(cat client1.domain.tld.key)"
CERT_VALUE="$(cat client1.domain.tld.crt)"
cat <<EOF >> ../vpn-config
<key>
$KEY_VALUE
</key>
<cert>
$CERT_VALUE
</cert>
EOF
echo "Once you've added the above values to /terraform/dev.auto.tfvars, run terraform plan | apply"
echo "When finished, navigate in AWS console to:"
echo "VPC > Client VPN endpoints > Download client configuration (button at top)"
echo "Copy the contents of the vpn-config file in the /setup folder and add it to this file"
echo "Then connect to the VPN with this command: sudo openvpn --config <config_file>"
echo "Navigate to /ansible/playbooks and run: ansible-playbook -i hosts.yml full-stack.yml --key-file=../../setup/gitlab-key"
