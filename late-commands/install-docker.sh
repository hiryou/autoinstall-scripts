#!/bin/bash
# docs https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

USER="${1:-hadoop}"
DATA_ROOT="${2:-/home/universal/docker/data-root}"

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

# set Docker data-root dir to a different path not affected by OS re-installation
# https://tienbm90.medium.com/how-to-change-docker-root-data-directory-89a39be1a70b
service docker stop
touch /etc/docker/daemon.json
cat > /etc/docker/daemon.json << 'EOF'
{
   "data-root": "data_root_value"
}
EOF
mkdir -p "$DATA_ROOT"
sed -i "s%data_root_value%$DATA_ROOT%g" /etc/docker/daemon.json
rsync -aP /var/lib/docker/ "$DATA_ROOT"
mv /var/lib/docker /var/lib/docker.old
service docker start
echo '----------------------------------------------------------------------------'

# add user $USER to docker group to streamline usage
# https://docs.docker.com/engine/install/linux-postinstall/
groupadd docker
usermod -aG docker $USER

sudo -H -u $USER docker run hello-world
echo '----------------------------------------------------------------------------'
