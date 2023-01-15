#!/bin/bash
# initialize a docker swarm on host machine

USER="${1:-hadoop}"

MASTER_IP=$(hostname -I | awk '{print $1}')
echo "MASTER_IP=$MASTER_IP"

sudo -H -u $USER docker swarm init --advertise-addr $MASTER_IP
# Set control-tower node labels - current settings: amd64/linux, has NVIDIA GPUs driver installed w/ cuda11.7
sudo -H -u $USER docker node update --label-add arch=amd64 --label-add os=linux --label-add gpu=gtx-1080-g1 --label-add cuda=11.7  $(hostname)
# Inspect control-tower
sudo -H -u $USER docker node inspect self --pretty


