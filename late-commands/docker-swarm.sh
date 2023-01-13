#!/bin/bash
# initialize a docker swarm on host machine

USER="${1:-hadoop}"

MASTER_IP=$(hostname -I | awk '{print $1}')
echo "MASTER_IP=$MASTER_IP"

sudo -H -u $USER docker swarm init --advertise-addr $MASTER_IP
sudo -H -u $USER docker node inspect self --pretty


