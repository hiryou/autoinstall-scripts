#!/bin/bash
# docs https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
# following guide https://gist.github.com/trongnghia203/9cc8157acb1a9faad2de95c3175aa875
# later step https://ericsysmin.com/2024/01/11/how-to-install-pyenv-on-ubuntu-22-04/

USER="${1:-hadoop}"
BRC_PATCH="${2:-/tmp/bashrc.pyenv}"
PIP_REQS="${3:-/tmp/requirements.txt}"

dpkg --configure -a

apt-get update
apt install -y curl git-core gcc make zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libssl-dev liblzma-dev libffi-dev
echo '----------------------------------------------------------------------------'

curl https://pyenv.run | bash
mv /root/.pyenv/ /home/$USER/
chown -R $USER:$USER /home/$USER/.pyenv
echo '----------------------------------------------------------------------------'

# python 3.12 here we go
sudo -H -u $USER /home/$USER/.pyenv/bin/pyenv install 3.12.4
sudo -H -u $USER /home/$USER/.pyenv/bin/pyenv versions
sudo -H -u $USER /home/$USER/.pyenv/bin/pyenv global 3.12.4
# in bashrc file
sudo -H -u $USER cat $BRC_PATCH >> /home/$USER/.bashrc
echo '----------------------------------------------------------------------------'

# basic pip pkgs
sudo -H -u $USER /home/$USER/.pyenv/shims/python -m pip install -r $PIP_REQS
echo '----------------------------------------------------------------------------'

