#!/bin/bash
# docs https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

USER="${1:-hadoop}"

apt-get remove docker docker-engine docker.io containerd runc
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release
echo '----------------------------------------------------------------------------'

mkdir -p /etc/apt/keyrings
# overwrite /etc/apt/keyrings/docker.gpg if already existed
# https://stackoverflow.com/questions/7519375/how-to-automatically-overwrite-the-output-file-when-running-gpg-i-e-without
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
echo '----------------------------------------------------------------------------'

# simply install the latest version for now
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
echo '----------------------------------------------------------------------------'

# add user $USER to docker group to streamline usage
# https://docs.docker.com/engine/install/linux-postinstall/
groupadd docker
usermod -aG docker $USER

sudo -H -u hadoop docker run hello-world
echo '----------------------------------------------------------------------------'
